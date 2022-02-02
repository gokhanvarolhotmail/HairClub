USE [ReportServer] ;
GO
DECLARE
    @OldUserID UNIQUEIDENTIFIER
  , @NewUserID UNIQUEIDENTIFIER ;

SELECT @OldUserID = [UserID]
FROM [dbo].[Users]
WHERE [UserName] = 'HCFM\DPolania' ;

SELECT @NewUserID = [UserID]
FROM [dbo].[Users]
WHERE [UserName] = 'HCFM\BIIntegrations' ;

UPDATE [dbo].[Subscriptions]
SET [OwnerID] = @NewUserID
WHERE [OwnerID] = @OldUserID ;