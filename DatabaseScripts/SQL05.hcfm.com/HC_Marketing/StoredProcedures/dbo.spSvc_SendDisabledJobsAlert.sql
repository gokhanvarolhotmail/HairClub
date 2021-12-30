/* CreateDate: 06/26/2019 08:32:28.250 , ModifyDate: 03/11/2021 08:50:20.157 */
GO
/***********************************************************************
PROCEDURE:				spSvc_SendDisabledJobsAlert
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Marketing
RELATED APP:			SQL Server Jobs
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		06/26/2019
------------------------------------------------------------------------
NOTES:

Checks for disabled SQL Server jobs and sends an alert.
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_SendDisabledJobsAlert
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_SendDisabledJobsAlert]
AS
BEGIN


CREATE TABLE #Job (
	ServerName NVARCHAR(50)
,	JobName NVARCHAR(255)
,	SortOrder INT
,	IsEnabled BIT
)


INSERT	INTO #Job
		SELECT	'SQL05' AS 'ServerName'
		,		name AS 'JobName'
		,		3 AS 'SortOrder'
		,		enabled
		FROM	SQL05.msdb.dbo.sysjobs
		UNION
		SELECT	'SQL06' AS 'ServerName'
		,		name AS 'JobName'
		,		4 AS 'SortOrder'
		,		enabled
		FROM	SQL06.msdb.dbo.sysjobs


IF EXISTS ( SELECT	j.JobName
			FROM	#Job j
			WHERE	LEFT(j.JobName, 3) <> 'xxx'
					AND j.JobName NOT IN ( 'SQL Sentry 2.0 Queue Monitor', 'H_0005_Monitor_tempdb' )
					AND j.IsEnabled = 0
			)
BEGIN
	DECLARE @TodaysDate NVARCHAR(50);


	SET @TodaysDate = CONVERT(VARCHAR, GETDATE(), 100)


	DECLARE @Subject NVARCHAR(255) = 'SQL Server Jobs Disabled - ' + @TodaysDate;
	DECLARE @Caption NVARCHAR(255) = 'Summary of disabled SQL Server Jobs';


	DECLARE @Header1 NVARCHAR(4000) = '<tr><th>Server</th><th>Job Name</th></tr>';
	DECLARE @Data1 NVARCHAR(MAX) = '';


	DECLARE @ServerName NVARCHAR(50);
	DECLARE @JobName NVARCHAR(255);


	DECLARE db_cursor CURSOR
	FOR
	SELECT	j.ServerName
	,		j.JobName
	FROM	#Job j
	WHERE	LEFT(j.JobName, 3) <> 'xxx'
			AND j.JobName NOT IN ( 'SQL Sentry 2.0 Queue Monitor', 'H_0005_Monitor_tempdb' )
			AND j.IsEnabled = 0
	ORDER BY j.SortOrder
	,		j.JobName


	OPEN db_cursor
	FETCH NEXT FROM db_cursor INTO @ServerName, @JobName;

	WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @Data1 = @Data1 +
			'<tr>' +
				'<td>' + @ServerName + '</td>' +
				'<td>' + @JobName + '</td>' +
			'</tr>'

			FETCH NEXT FROM db_cursor INTO @ServerName, @JobName
		END

	CLOSE db_cursor
	DEALLOCATE db_cursor


	DECLARE @MsgBody NVARCHAR(MAX);


	SET @MsgBody = '<html>';
	SET @MsgBody = @MsgBody + '<head><style>table, th, td { border: 1px solid black; border-collapse: collapse; } th, td { padding: 5px; text-align: left; }</style></head>';
	SET @MsgBody = @MsgBody + '<body>';
	SET @MsgBody = @MsgBody + '<table style="width:100%"><caption>' + @Caption + '</caption>';
	SET @MsgBody = @MsgBody + @Header1;
	SET @MsgBody = @MsgBody + @Data1;
	SET @MsgBody = @MsgBody + '</table>';
	SET @MsgBody = @MsgBody + '</body>';
	SET @MsgBody = @MsgBody + '</html>';


	EXEC msdb.dbo.sp_send_dbmail
	@profile_name = 'SQL05-Mail'
	,  @recipients = 'KMurdoch@hairclub.com;DLeiba@hairclub.com'
	,  @body_format = HTML
	,  @subject = @Subject
	,  @body = @MsgBody;

END

END
GO
