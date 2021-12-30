/* CreateDate: 01/03/2014 07:07:47.903 , ModifyDate: 01/03/2014 07:07:47.903 */
GO
CREATE FUNCTION [snapshots].[fn_trace_gettable]
(
    @trace_info_id       int,
    @start_time          datetimeoffset(7) = NULL,
    @end_time            datetimeoffset(7) = NULL
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        TextData,
        BinaryData,
        DatabaseID,
        TransactionID,
        LineNumber,
        NTUserName,
        NTDomainName,
        HostName,
        ClientProcessID,
        ApplicationName,
        LoginName,
        SPID,
        Duration,
        StartTime,
        EndTime,
        Reads,
        Writes,
        CPU,
        Permissions,
        Severity,
        EventSubClass,
        ObjectID,
        Success,
        IndexID,
        IntegerData,
        ServerName,
        EventClass,
        ObjectType,
        NestLevel,
        State,
        Error,
        Mode,
        Handle,
        ObjectName,
        DatabaseName,
        FileName,
        OwnerName,
        RoleName,
        TargetUserName,
        DBUserName,
        LoginSid,
        TargetLoginName,
        TargetLoginSid,
        ColumnPermissions,
        LinkedServerName,
        ProviderName,
        MethodName,
        RowCounts,
        RequestID,
        XactSequence,
        EventSequence,
        BigintData1,
        BigintData2,
        GUID,
        IntegerData2,
        ObjectID2,
        Type,
        OwnerID,
        ParentName,
        IsSystem,
        Offset,
        SourceDatabaseID,
        SqlHandle,
        SessionLoginName,
        PlanHandle
    FROM snapshots.trace_data
    WHERE
        trace_info_id = @trace_info_id
        AND StartTime >= ISNULL(@start_time, '1753-01-01')
        AND StartTime <= ISNULL(@end_time, '9999-12-31')
)
GO
