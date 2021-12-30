/* CreateDate: 05/03/2010 12:26:22.663 , ModifyDate: 05/03/2010 12:26:22.663 */
GO
CREATE FUNCTION [bief_stage].[fn_GetBatchSize] ()
-----------------------------------------------------------------------
-- [fn_GetBatchSize] defines the size of the batches for INSERT,
-- UPDATE, DELETE
-----------------------------------------------------------------------
--         Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------
RETURNS INT AS
BEGIN
	DECLARE @BatchSize INT

	SET @BatchSize = 10000		-- 10000 is the default batch size

	-- Retrieve value from DBConfig table
	SELECT @BatchSize = [setting_value_int]
	FROM	[bief_stage].[_DBConfig]
	WHERE	[setting_name] = 'BatchSize'

	-- Return the result of the function
	RETURN @BatchSize

END
GO
