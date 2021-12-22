/*===============================================================================================
-- Procedure Name:			CanadianConversion
-- Procedure Description:
--
-- Created By:				Dominic Leiba
-- Implemented By:			Dominic Leiba
-- Last Modified By:		Dominic Leiba
--
-- Date Created:			4/3/2009
-- Date Implemented:		4/3/2009
-- Date Last Modified:		4/3/2009
--
-- Destination Server:		HCSQLBK
-- Destination Database:	HairClubCMS
-- Related Application:		CMS v3.0
--
-- ----------------------------------------------------------------------------------------------
-- Notes:
--	03/28/11	KRM	Changed derivation of Canadian exchange rate to be 1 to 1
-- ----------------------------------------------------------------------------------------------
--
Sample Execution:
--
SELECT [dbo].[CanadianConversion] (229, 250, '1/01/2009')
================================================================================================*/
CREATE FUNCTION [dbo].[CanadianConversion]
(
	@CenterNumber INT,
	@Price FLOAT,
	@Date DATETIME
)
RETURNS FLOAT AS
BEGIN
	DECLARE @ExchangeRate FLOAT
	DECLARE @NewPrice FLOAT

	--IF @CenterNumber IN ( 229, 329, 265, 365, 264, 364, 228, 328 )
	--  BEGIN
	--	SELECT  @ExchangeRate = ExchangeRate
	--	FROM    cfgCurrencyExchangeRate
	--	WHERE   @Date BETWEEN BeginDate AND ISNULL(EndDate, GETDATE())

	--	SET @NewPrice = @ExchangeRate * @Price
	--  END
	--ELSE
	--  BEGIN
	--	SET @NewPrice = @Price
	--  END
	SET @NewPrice = @Price
	RETURN @NewPrice
END
