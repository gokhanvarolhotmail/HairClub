/* CreateDate: 05/02/2010 09:45:05.140 , ModifyDate: 05/02/2010 09:45:05.140 */
GO
CREATE FUNCTION [bief_config].[fn_IsErrorLoggingEnabled] ()
-----------------------------------------------------------------------
-- [fn_IsErrorLoggingEnabled] indicates whether Error Logging
-- should occur or not
-----------------------------------------------------------------------
--         Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--
-----------------------------------------------------------------------
RETURNS bit AS
BEGIN
	DECLARE @IsEnabled bit

	SET @IsEnabled = 1		-- 0 Not enabled or 1 Enabled

	-- Retrieve value from DBConfig table
	SELECT @IsEnabled = [setting_value_bit]
	FROM	[bief_config].[_DBConfig]
	WHERE	[setting_name] = 'IsErrorLoggingEnabled'

	-- Return the result of the function
	RETURN @IsEnabled

END
GO
