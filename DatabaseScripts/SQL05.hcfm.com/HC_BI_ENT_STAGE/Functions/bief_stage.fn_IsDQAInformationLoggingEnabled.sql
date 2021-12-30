/* CreateDate: 05/03/2010 12:09:36.560 , ModifyDate: 05/03/2010 12:09:36.560 */
GO
CREATE FUNCTION [bief_stage].[fn_IsDQAInformationLoggingEnabled] ()
-----------------------------------------------------------------------
-- [fn_IsInformationLoggingEnabled] indicates whether Information Logging
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
	FROM	[bief_stage].[_DBConfig]
	WHERE	[setting_name] = 'IsDQAInformationLoggingEnabled'

	-- Return the result of the function
	RETURN @IsEnabled

END
GO
