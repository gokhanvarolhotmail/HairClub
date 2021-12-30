/* CreateDate: 01/03/2014 07:07:50.733 , ModifyDate: 01/03/2014 07:07:50.733 */
GO
CREATE PROCEDURE [snapshots].[rpt_query_plan_missing_indexes]
    @instance_name sysname,
    @plan_handle_str varchar(130),
    @statement_start_offset int,
    @statement_end_offset int
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @showplan nvarchar(max)
    DECLARE @plan_handle varbinary(64)
    DECLARE @element nvarchar(512), @element_start nvarchar(512), @element_end nvarchar(512)
    DECLARE @xml_fragment xml
    DECLARE @start_offset int

    -- We may be invoked with a NULL/empty string plan handle if the user has not yet drilled down into
    -- a specific query plan on the query_stats_detail report.
    IF ISNULL (@plan_handle_str, '') = ''
    BEGIN
        RETURN
    END

    SET @plan_handle = snapshots.fn_hexstrtovarbin (@plan_handle_str)

    SELECT TOP 1
        @showplan = CONVERT (nvarchar(max), qp.query_plan)
    FROM snapshots.notable_query_plan qp
    INNER JOIN core.snapshots snap ON snap.source_id = qp.source_id
    WHERE plan_handle = @plan_handle
        AND statement_start_offset = @statement_start_offset AND statement_end_offset = @statement_end_offset
        AND snap.instance_name = @instance_name
        -- Get sql_handle to enable a clustered index seek on notable_query_plans
        AND qp.sql_handle =
        (
            SELECT TOP 1 sql_handle
            FROM snapshots.notable_query_plan AS qp
            INNER JOIN core.snapshots snap ON snap.source_id = qp.source_id
            WHERE plan_handle = @plan_handle
                AND statement_start_offset = @statement_start_offset AND statement_end_offset = @statement_end_offset
                AND snap.instance_name = @instance_name
        );

    SET @element = 'MissingIndexes'
    -- Use non-XML methods to extract the <MissingIndexes> fragment.  Some query plans may be too complex
    -- to represent in the T-SQL xml data type, but the <MissingIndexes> node will always be simple enough.
    -- Doing this ensures that we will always be able to extract any missing index information from the
    -- plan even if the plan itself is too complex for the T-SQL xml type.
    SET @element_start = '<' + @element + '>'
    SET @element_end = '</' + @element + '>'
    SET @start_offset = ISNULL (PATINDEX ('%' + @element_start + '%', @showplan), 0)
    IF @start_offset > 0
    BEGIN
        SET @xml_fragment = SUBSTRING (@showplan, @start_offset, PATINDEX ('%' + @element_end + '%', @showplan) - @start_offset + LEN (@element_end));

        --  Sample <MissingIndexes> fragment from an XML query plan:
        --    <MissingIndexes>
        --      <MissingIndexGroup Impact="26.4126">
        --        <MissingIndex Database="[AdventureWorks]" Schema="[Sales]" Table="[CustomerAddress]">
        --          <ColumnGroup Usage="EQUALITY">
        --            <Column Name="[AddressTypeID]" ColumnId="3"/>
        --          </ColumnGroup>
        --          <ColumnGroup Usage="INCLUDE">
        --          <Column Name="[CustomerID]" ColumnId="1"/>
        --            <Column Name="[AddressID]" ColumnId="2"/>
        --          </ColumnGroup>
        --        </MissingIndex>
        --      </MissingIndexGroup>
        --    </MissingIndexes>
        SELECT
            'CREATE INDEX [ncidx_mdw_'
                + LEFT (target_object_name, 20)
                -- Random component to make name conflicts less likely
                + '_' + CONVERT (varchar(30), ABS (CONVERT (binary(6), NEWID()) % 1000))
                + '] ON ' + target_object_fullname
                + ' (' + ISNULL (equality_columns, '')
                + CASE WHEN ISNULL (equality_columns, '') != '' AND ISNULL (inequality_columns, '') != '' THEN ',' ELSE '' END + ISNULL (inequality_columns, '')
                + ')'
                + CASE WHEN ISNULL (included_columns, '') != '' THEN ' INCLUDE (' + included_columns + ')' ELSE '' END
                AS create_idx_statement,
            *
        FROM
        (
            SELECT
                index_node.value('(../@Impact)[1]', 'float') as index_impact,
                REPLACE (REPLACE (index_node.value('(./@Table)[1]', 'nvarchar(512)'), '[', ''), ']', '') AS target_object_name,
                CONVERT (nvarchar(1024), index_node.query('concat(
                        string((./@Database)[1]),
                        ".",
                        string((./@Schema)[1]),
                        ".",
                        string((./@Table)[1])
                    )')) AS target_object_fullname,
                REPLACE (CONVERT (nvarchar(max), index_node.query('for $colgroup in ./ColumnGroup,
                        $col in $colgroup/Column
                        where $colgroup/@Usage = "EQUALITY"
                        return string($col/@Name)')), '] [', '],[') AS equality_columns,
                REPLACE (CONVERT (nvarchar(max), index_node.query('for $colgroup in ./ColumnGroup,
                        $col in $colgroup/Column
                        where $colgroup/@Usage = "INEQUALITY"
                        return string($col/@Name)')), '] [', '],[') AS inequality_columns,
                REPLACE (CONVERT (nvarchar(max), index_node.query('for $colgroup in .//ColumnGroup,
                        $col in $colgroup/Column
                        where $colgroup/@Usage = "INCLUDE"
                        return string($col/@Name)')), '] [', '],[') AS included_columns
            FROM (SELECT @xml_fragment AS fragment) AS missing_indexes_fragment
            CROSS APPLY missing_indexes_fragment.fragment.nodes('/MissingIndexes/MissingIndexGroup/MissingIndex') AS missing_indexes (index_node)
        ) AS t
    END
END
GO
