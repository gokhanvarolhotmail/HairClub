/* CreateDate: 05/23/2016 10:57:00.420 , ModifyDate: 05/23/2016 10:57:00.420 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [SqlQueryNotificationStoredProcedure-91c80a9c-a915-4dd6-9bd0-b34c0f40a66a] AS BEGIN BEGIN TRANSACTION; RECEIVE TOP(0) conversation_handle FROM [SqlQueryNotificationService-91c80a9c-a915-4dd6-9bd0-b34c0f40a66a]; IF (SELECT COUNT(*) FROM [SqlQueryNotificationService-91c80a9c-a915-4dd6-9bd0-b34c0f40a66a] WHERE message_type_name = 'http://schemas.microsoft.com/SQL/ServiceBroker/DialogTimer') > 0 BEGIN if ((SELECT COUNT(*) FROM sys.services WHERE name = 'SqlQueryNotificationService-91c80a9c-a915-4dd6-9bd0-b34c0f40a66a') > 0)   DROP SERVICE [SqlQueryNotificationService-91c80a9c-a915-4dd6-9bd0-b34c0f40a66a]; if (OBJECT_ID('SqlQueryNotificationService-91c80a9c-a915-4dd6-9bd0-b34c0f40a66a', 'SQ') IS NOT NULL)   DROP QUEUE [SqlQueryNotificationService-91c80a9c-a915-4dd6-9bd0-b34c0f40a66a]; DROP PROCEDURE [SqlQueryNotificationStoredProcedure-91c80a9c-a915-4dd6-9bd0-b34c0f40a66a]; END COMMIT TRANSACTION; END
GO
