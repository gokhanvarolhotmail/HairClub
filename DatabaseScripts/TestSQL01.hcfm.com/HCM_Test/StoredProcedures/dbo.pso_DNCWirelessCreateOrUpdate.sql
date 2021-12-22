/* CreateDate: 03/22/2016 11:02:44.617 , ModifyDate: 03/22/2016 11:02:44.617 */
GO
-- =============================================
-- Author:		MJW - Workwise, LLC
-- Create date: 2016-01-26
-- Description:	Create or update cstd_phone_dnc_wireless entry
-- =============================================
CREATE PROCEDURE [dbo].[pso_DNCWirelessCreateOrUpdate]
	@phonenumber nvarchar(30),
	@dnc_flag nchar(1),
	@user_code nchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @phonenumber IS NULL RETURN
	IF @dnc_flag IS NULL RETURN

	IF NOT EXISTS (SELECT 1 FROM cstd_phone_dnc_wireless WHERE phonenumber = @phonenumber)
		INSERT INTO cstd_phone_dnc_wireless (phone_dnc_wireless_id, phonenumber, creation_date, created_by_user_code, updated_date, updated_by_user_code)
			VALUES (NEWID(), @phonenumber, GETDATE(), @user_code, GETDATE(), @user_code)

	IF EXISTS (SELECT 1 FROM cstd_phone_dnc_wireless WHERE phonenumber = @phonenumber AND (dnc_flag IS NULL OR dnc_flag <> @dnc_flag))
		UPDATE cstd_phone_dnc_wireless SET
			dnc_flag = @dnc_flag,
			dnc_date = GETDATE(),
			dnc_flag_user_code = @user_code,
			updated_date = GETDATE(),
			updated_by_user_code = @user_code
		WHERE phonenumber = @phonenumber
END
GO
