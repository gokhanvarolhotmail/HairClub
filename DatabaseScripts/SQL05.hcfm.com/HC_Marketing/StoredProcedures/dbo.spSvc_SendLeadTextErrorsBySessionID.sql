/* CreateDate: 10/19/2016 16:21:04.663 , ModifyDate: 10/19/2016 16:21:04.663 */
GO
/***********************************************************************
PROCEDURE:				spSvc_SendLeadTextErrorsBySessionID
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Marketing
RELATED APP:			Message Media Text Message SSIS
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		09/07/2016
------------------------------------------------------------------------
NOTES:

Checks for errors in the specified session and sends an alert.
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_SendLeadTextErrorsBySessionID '7A7FEAB9-159F-4C8A-BE53-1CDBED18005A'
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_SendLeadTextErrorsBySessionID]
(
	@SessionID NVARCHAR(100)
)
AS
BEGIN

IF EXISTS ( SELECT  LML.LeadMessageLogID
            FROM    datLeadMessageLog LML
            WHERE   LML.SessionGUID = @SessionID
					AND LML.TextMessageStatusID IN ( 3, 7 ) )
   BEGIN
         DECLARE @TodaysDate DATETIME;


		 SET @TodaysDate = (SELECT TOP 1 LML.CreateDate FROM datLeadMessageLog LML WHERE LML.SessionGUID = @SessionID);
		 SET @TodaysDate = DATEADD(HOUR, 0, DATEADD(HOUR, DATEDIFF(HOUR, 0, @TodaysDate), 0));


         DECLARE @Subject NVARCHAR(255) = 'Activity Reminders Error Report - ' + CONVERT(VARCHAR(50), @TodaysDate, 107) + ' ' + RIGHT(CONVERT(VARCHAR, @TodaysDate, 100), 7);
         DECLARE @Caption NVARCHAR(255) = 'Summary of Errors for the Batch';


         DECLARE @Header1 NVARCHAR(4000) = '<tr><th>ID</th><th>ActivityID</th><th>PhoneNumber</th></tr>';
         DECLARE @Data1 NVARCHAR(MAX) = '';


         DECLARE @ID INT;
         DECLARE @ActivityID NVARCHAR(10);
         DECLARE @PhoneNumber NVARCHAR(50);


         DECLARE db_cursor CURSOR
         FOR
         SELECT LML.LeadMessageLogID AS 'ID'
         ,      LML.ActivityID
         ,      LML.PhoneNumber
         FROM   datLeadMessageLog LML
         WHERE  LML.SessionGUID = @SessionID
				AND LML.TextMessageStatusID IN ( 3, 7 )
		 ORDER BY LML.LeadMessageLogID


         OPEN db_cursor
         FETCH NEXT FROM db_cursor INTO @ID, @ActivityID, @PhoneNumber;

         WHILE @@FETCH_STATUS = 0
               BEGIN
                     SET @ID = ISNULL(@ID, '');


					SET @Data1 = @Data1 +
					'<tr>' +
						'<td>' + CAST(@ID AS NVARCHAR) + '</td>' +
						'<td>' + @ActivityID + '</td>' +
						'<td>' + @PhoneNumber + '</td>' +
					'</tr>'

                     FETCH NEXT FROM db_cursor INTO @ID, @ActivityID, @PhoneNumber
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
         ,  @recipients = '_NCCProjectTeam@hcfm.com;DLeiba@hcfm.com'
         ,  @body_format = HTML
         ,  @subject = @Subject
         ,  @body = @MsgBody;

   END

END
GO
