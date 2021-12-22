/* CreateDate: 02/21/2013 11:15:12.533 , ModifyDate: 02/27/2020 07:44:09.590 */
GO
/***********************************************************************

FUNCTION:				CanadianConversion

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_DeferredRevenue

AUTHOR: 				Marlon Burrell

DATE IMPLEMENTED: 		02/21/2013
--------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

SELECT [dbo].[CanadianConversion] (229, 250, '1/01/2009')

***********************************************************************/
CREATE FUNCTION [dbo].[CanadianConversion] (
	@CenterSSID INT
,	@Price MONEY
,	@OrderDate DATETIME)

RETURNS MONEY AS
BEGIN
	DECLARE @NewPrice MONEY
	,	@Country CHAR(2)

	SELECT @Country = (
		SELECT CountryRegionDescriptionShort
		FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter
		WHERE CenterSSID = @CenterSSID
	)

	IF @Country = 'CA'
		BEGIN
			SET @NewPrice = (
				SELECT CONVERT(NUMERIC(10, 2), @Price * ExchangeRate)
				FROM lkpCanadianExchangeRates
				WHERE @OrderDate BETWEEN BeginDate AND EndDate
			)
		END
	ELSE
		BEGIN
			SET @NewPrice = @Price
		END

	RETURN @NewPrice
END
GO
