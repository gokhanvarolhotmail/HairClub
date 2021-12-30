/* CreateDate: 05/03/2010 12:17:24.210 , ModifyDate: 10/03/2019 22:52:21.947 */
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
