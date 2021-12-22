/* CreateDate: 01/03/2013 10:22:39.160 , ModifyDate: 01/03/2013 10:22:39.160 */
GO
-- =============================================
-- Create date: 29 October 2012
-- Description:	Ensures the provided User exists within the User setup table.
-- =============================================
CREATE PROCEDURE [dbo].[psoEnsureUserExists]
	@UserCode NCHAR(20),	-- The User to validate exists.
	@DisplayName NCHAR(50)	-- The Display Name of the User.
AS
BEGIN
	IF (SELECT user_code FROM onca_user WHERE user_code = @UserCode) IS NULL
	BEGIN
		INSERT INTO onca_user (user_code, description, display_name, active) VALUES (@UserCode, @DisplayName, @DisplayName, 'N')
	END
END
GO
