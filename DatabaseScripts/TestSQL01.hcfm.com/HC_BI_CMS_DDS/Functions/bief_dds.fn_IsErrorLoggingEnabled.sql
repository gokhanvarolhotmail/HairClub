/* CreateDate: 05/03/2010 12:17:24.243 , ModifyDate: 09/16/2019 09:33:49.907 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [bief_dds].[fn_IsErrorLoggingEnabled] ()
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
	FROM	[bief_dds].[_DBConfig]
	WHERE	[setting_name] = 'IsErrorLoggingEnabled'

	-- Return the result of the function
	RETURN @IsEnabled

END
GO
