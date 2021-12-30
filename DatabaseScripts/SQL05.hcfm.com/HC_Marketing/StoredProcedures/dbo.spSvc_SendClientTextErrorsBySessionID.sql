/* CreateDate: 10/19/2016 16:20:12.237 , ModifyDate: 10/31/2016 13:38:26.037 */
GO
/***********************************************************************
PROCEDURE:				spSvc_SendClientTextErrorsBySessionID
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

EXEC spSvc_SendClientTextErrorsBySessionID '7A7FEAB9-159F-4C8A-BE53-1CDBED18005A'
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_SendClientTextErrorsBySessionID]
(
	@SessionID NVARCHAR(100)
)
AS
BEGIN

IF EXISTS ( SELECT  CML.ClientMessageLogID
            FROM    datClientMessageLog CML
            WHERE   CML.SessionGUID = @SessionID
					AND CML.TextMessageStatusID IN ( 3, 7 ) )
   BEGIN
         DECLARE @TodaysDate DATETIME;


		 SET @TodaysDate = (SELECT TOP 1 CML.CreateDate FROM datClientMessageLog CML WHERE CML.SessionGUID = @SessionID);
		 SET @TodaysDate = DATEADD(HOUR, 0, DATEADD(HOUR, DATEDIFF(HOUR, 0, @TodaysDate), 0));


         DECLARE @Subject NVARCHAR(255) = 'Appointment Reminders Error Report - ' + CONVERT(VARCHAR(50), @TodaysDate, 107) + ' ' + RIGHT(CONVERT(VARCHAR, @TodaysDate, 100), 7);
         DECLARE @Caption NVARCHAR(255) = 'Summary of Errors for the Batch';


         DECLARE @Header1 NVARCHAR(4000) = '<tr><th>ID</th><th>AppointmentGUID</th><th>PhoneNumber</th></tr>';
         DECLARE @Data1 NVARCHAR(MAX) = '';


         DECLARE @ID INT;
         DECLARE @AppointmentGUID NVARCHAR(100);
         DECLARE @PhoneNumber NVARCHAR(50);


         DECLARE db_cursor CURSOR
         FOR
         SELECT CML.ClientMessageLogID AS 'ID'
         ,      CML.AppointmentGUID
         ,      CML.ClientPhoneNumber
         FROM   datClientMessageLog CML
         WHERE  CML.SessionGUID = @SessionID
				AND CML.TextMessageStatusID IN ( 3, 7 )
		 ORDER BY CML.ClientMessageLogID


         OPEN db_cursor
         FETCH NEXT FROM db_cursor INTO @ID, @AppointmentGUID, @PhoneNumber;

         WHILE @@FETCH_STATUS = 0
               BEGIN
                     SET @ID = ISNULL(@ID, '');


					SET @Data1 = @Data1 +
					'<tr>' +
						'<td>' + CAST(@ID AS NVARCHAR) + '</td>' +
						'<td>' + @AppointmentGUID + '</td>' +
						'<td>' + @PhoneNumber + '</td>' +
					'</tr>'

                     FETCH NEXT FROM db_cursor INTO @ID, @AppointmentGUID, @PhoneNumber
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
         ,  @recipients = 'DLeiba@hcfm.com'
         ,  @body_format = HTML
         ,  @subject = @Subject
         ,  @body = @MsgBody;

   END

END
GO
