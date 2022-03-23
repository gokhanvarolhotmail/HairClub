/* CreateDate: 03/17/2022 11:57:10.530 , ModifyDate: 03/17/2022 11:57:10.530 */
GO
CREATE  FUNCTION [bief_dds].[fn_DivideByZeroCheck] (@numerator numeric, @denominator numeric)
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
