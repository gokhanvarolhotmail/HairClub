/* CreateDate: 05/03/2010 12:22:43.860 , ModifyDate: 05/03/2010 12:22:43.860 */
GO
CREATE FUNCTION [bief_dq].[fn_IsErrorLoggingEnabled] ()
-----------------------------------------------------------------------
-- [fn_IsErrorLoggingEnabled] indicates whether Error Logging
-- should occur or not
-----------------------------------------------------------------------
--         Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------
RETURNS bit AS
BEGIN
	DECLARE @IsEnabled bit

	SET @IsEnabled = 1		-- 0 Not enabled or 1 Enabled

	-- Retrieve value from DBConfig table
	SELECT @IsEnabled = [setting_value_bit]
	FROM	[bief_dq].[_DBConfig]
	WHERE	[setting_name] = 'IsErrorLoggingEnabled'

	-- Return the result of the function
	RETURN @IsEnabled

END
GO
