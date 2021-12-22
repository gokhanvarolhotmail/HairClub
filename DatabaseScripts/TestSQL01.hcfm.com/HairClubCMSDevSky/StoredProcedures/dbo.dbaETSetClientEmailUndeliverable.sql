/* CreateDate: 12/02/2014 12:27:12.063 , ModifyDate: 12/02/2014 12:27:12.063 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
