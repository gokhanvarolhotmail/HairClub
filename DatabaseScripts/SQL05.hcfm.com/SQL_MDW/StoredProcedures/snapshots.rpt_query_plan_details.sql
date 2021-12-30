/* CreateDate: 01/03/2014 07:07:50.783 , ModifyDate: 01/03/2014 07:07:50.783 */
GO
CREATE PROCEDURE [snapshots].rpt_query_plan_details
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
        FROM snapshots.notable_query_plan AS qp
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
        RETURN
    END CATCH;

    WITH XMLNAMESPACES ('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS sp)
    SELECT TOP 10
        CONVERT (bigint, stmt_simple.stmt_node.value('(./@StatementEstRows)[1]', 'decimal(28,10)')) AS stmt_est_rows,
        stmt_simple.stmt_node.value('(./@StatementOptmLevel)[1]', 'varchar(30)') AS stmt_optimization_level,
        stmt_simple.stmt_node.value('(./@StatementOptmEarlyAbortReason)[1]', 'varchar(30)') AS stmt_optimization_early_abort_reason,
        stmt_simple.stmt_node.value('(./@StatementSubTreeCost)[1]', 'float') AS stmt_est_subtree_cost,
        stmt_simple.stmt_node.value('(./@StatementText)[1]', 'nvarchar(max)') AS stmt_text,
        stmt_simple.stmt_node.value('(./@ParameterizedText)[1]', 'nvarchar(max)') AS stmt_parameterized_text,
        stmt_simple.stmt_node.value('(./@StatementType)[1]', 'varchar(30)') AS stmt_type,
        stmt_simple.stmt_node.value('(./@PlanGuideName)[1]', 'varchar(30)') AS plan_guide_name,
        stmt_simple.stmt_node.value('(./sp:QueryPlan/@CachedPlanSize)[1]', 'int') AS plan_size,
        stmt_simple.stmt_node.value('(./sp:QueryPlan/@CompileTime)[1]', 'bigint') AS plan_compile_time,
        stmt_simple.stmt_node.value('(./sp:QueryPlan/@CompileCPU)[1]', 'bigint') AS plan_compile_cpu,
        stmt_simple.stmt_node.value('(./sp:QueryPlan/@CompileMemory)[1]', 'int') AS plan_compile_memory
    FROM (SELECT @showplan AS query_plan) AS p
    CROSS APPLY p.query_plan.nodes ('/sp:ShowPlanXML/sp:BatchSequence/sp:Batch/sp:Statements/sp:StmtSimple') as stmt_simple (stmt_node)
END
GO
