/* CreateDate: 08/28/2017 09:48:49.130 , ModifyDate: 08/28/2017 09:48:49.130 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [SqlQueryNotificationStoredProcedure-f8474cca-9f45-4e01-9ed4-5260462b48de] AS BEGIN BEGIN TRANSACTION; RECEIVE TOP(0) conversation_handle FROM [SqlQueryNotificationService-f8474cca-9f45-4e01-9ed4-5260462b48de]; IF (SELECT COUNT(*) FROM [SqlQueryNotificationService-f8474cca-9f45-4e01-9ed4-5260462b48de] WHERE message_type_name = 'http://schemas.microsoft.com/SQL/ServiceBroker/DialogTimer') > 0 BEGIN if ((SELECT COUNT(*) FROM sys.services WHERE name = 'SqlQueryNotificationService-f8474cca-9f45-4e01-9ed4-5260462b48de') > 0)   DROP SERVICE [SqlQueryNotificationService-f8474cca-9f45-4e01-9ed4-5260462b48de]; if (OBJECT_ID('SqlQueryNotificationService-f8474cca-9f45-4e01-9ed4-5260462b48de', 'SQ') IS NOT NULL)   DROP QUEUE [SqlQueryNotificationService-f8474cca-9f45-4e01-9ed4-5260462b48de]; DROP PROCEDURE [SqlQueryNotificationStoredProcedure-f8474cca-9f45-4e01-9ed4-5260462b48de]; END COMMIT TRANSACTION; END
GO
