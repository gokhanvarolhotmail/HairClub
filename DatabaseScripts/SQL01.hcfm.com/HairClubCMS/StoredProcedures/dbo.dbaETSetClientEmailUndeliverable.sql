-- =============================================
-- Author:		Edmund Poillion
-- Create date: 11/21/2014
-- Description:
-- =============================================
CREATE PROCEDURE [dbo].[dbaETSetClientEmailUndeliverable]
	@ClientGUID uniqueidentifier,
	@IsEmailUndeliverable bit
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [Utility].[dbo].[ET_Log] ([RunDate],[ProcName],[AppointmentGUID],[ClientGUID],[AppointmentDateTime],[IsEmailUndeliverable],[IsAutoConfirmEmail])
		VALUES (GETDATE(),'[dbo].[dbaETSetClientEmailUndeliverable]',null,@ClientGUID,null,@IsEmailUndeliverable,null);

	UPDATE
		[dbo].[datClient]
	SET
		IsEmailUndeliverable = @IsEmailUndeliverable
	WHERE
		ClientGUID = @ClientGUID;
END
