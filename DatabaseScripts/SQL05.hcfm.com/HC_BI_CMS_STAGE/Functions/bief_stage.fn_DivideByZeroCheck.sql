/* CreateDate: 05/24/2012 14:11:53.897 , ModifyDate: 05/24/2012 14:11:53.897 */
GO
CREATE FUNCTION [bief_stage].[fn_DivideByZeroCheck] (@numerator numeric, @denominator numeric)
-----------------------------------------------------------------------
-- [fn_DivideByZeroCheck] ensures safe division by zero
--
-----------------------------------------------------------------------
--         Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------
RETURNS float

AS

	BEGIN
		DECLARE @fProduct AS FLOAT

		IF  @denominator = 0
			SET @fProduct = 0
		ELSE
			SET @fProduct = (SUM(CONVERT(money, @numerator)) / SUM(CONVERT(money, @denominator)))

		RETURN @fProduct

	END
GO
