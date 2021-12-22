-- =============================================
-- Author:		Edmund Poillion
-- Create date: 11/21/2014
-- Description:
-- =============================================
CREATE PROCEDURE [dbo].[dbaETSetClientAutoConfirmEmail]
	@ClientGUID uniqueidentifier,
	@IsAutoConfirmEmail bit
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [Utility].[dbo].[ET_Log] ([RunDate],[ProcName],[AppointmentGUID],[ClientGUID],[AppointmentDateTime],[IsEmailUndeliverable],[IsAutoConfirmEmail])
		VALUES (GETDATE(),'[dbo].[dbaETSetClientAutoConfirmEmail]',null,@ClientGUID,null,null,@IsAutoConfirmEmail);

	UPDATE
		[dbo].[datClient]
	SET
		IsAutoConfirmEmail = @IsAutoConfirmEmail
	WHERE
		ClientGUID = @ClientGUID;
END
