/* CreateDate: 01/03/2014 07:07:50.760 , ModifyDate: 01/03/2014 07:07:50.760 */
GO
CREATE PROCEDURE [snapshots].rpt_query_plan_parameters
    @instance_name sysname,
    @plan_handle_str varchar(130),
    @statement_start_offset int,
    @statement_end_offset int
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @showplan xml
    DECLARE @plan_handle varbinary(64)

    -- We may be invoked with a NULL/empty string plan handle if the user has not yet drilled down into
    -- a specific query plan on the query_stats_detail report.
    IF ISNULL (@plan_handle_str, '') = ''
    BEGIN
        RETURN
    END

    SET @plan_handle = snapshots.fn_hexstrtovarbin (@plan_handle_str)

    BEGIN TRY
        SELECT TOP 1
            @showplan = CONVERT (xml, qp.query_plan)
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
    END TRY
    BEGIN CATCH
        -- It is expected that we may end up here even under normal circumstances.  Some plans are simply too
        -- complex to represent using T-SQL's xml datatype. Raise a low-severity message with the error details.
        DECLARE @ErrorMessage   NVARCHAR(4000);
        DECLARE @ErrorNumber    INT;
        DECLARE @ErrorLine      INT;
        SELECT @ErrorLine = ERROR_LINE(),
               @ErrorNumber = ERROR_NUMBER(),
               @ErrorMessage = ERROR_MESSAGE();
        -- "Unable to convert showplan to XML.  Error #%d on Line %d: %s"
        RAISERROR (14697, 0, 1, @ErrorNumber, @ErrorLine, @ErrorMessage);
    END CATCH;

    WITH XMLNAMESPACES ('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS sp)
    SELECT
        param_list.param_node.value('(./@Column)[1]', 'nvarchar(512)') AS param_name,
        param_list.param_node.value('(./@ParameterCompiledValue)[1]', 'nvarchar(max)') AS param_compiled_value
    FROM (SELECT @showplan AS query_plan) AS p
    CROSS APPLY p.query_plan.nodes ('/sp:ShowPlanXML/sp:BatchSequence/sp:Batch/sp:Statements/sp:StmtSimple/sp:QueryPlan[1]/sp:ParameterList[1]/sp:ColumnReference') as param_list (param_node)
END
GO
