/* CreateDate: 10/04/2010 12:09:07.897 , ModifyDate: 02/27/2017 09:49:24.213 */
GO
/*
==============================================================================
PROCEDURE:				[rptAnnualProductionByLengthSummary]

VERSION:				v1.0

DESTINATION SERVER:		HCSQL2

DESTINATION DATABASE: 	Production

RELATED APPLICATION:  	Production

AUTHOR: 				Marlon Burrell

IMPLEMENTOR: 			Marlon Burrell

DATE IMPLEMENTED: 		 4/22/2008

LAST REVISION DATE: 	 3/3/2010

==============================================================================
DESCRIPTION:	Annual Order Summary By Area Summary
==============================================================================
-- Notes:
	* 6/24/11 MVT - Fixed date ranges. Modified sort by hair length

==============================================================================
SAMPLE EXECUTION:
EXEC [rptAnnualProductionByLengthSummary] '1/1/08', '12/31/08'
==============================================================================
*/
CREATE PROCEDURE [dbo].[rptAnnualProductionByLengthSummary]
	@StartDate DATETIME
,	@EndDate DATETIME
AS
BEGIN

	SET NOCOUNT ON

	DECLARE @Total INT
	DECLARE @HairSystemDescription1 varchar(2)
	DECLARE @HairSystemDescription2 varchar(2)

	SET @EndDate = DATEADD(MILLISECOND, -2, DATEADD(dd, DATEDIFF(d, 0, @EndDate), 1))
	SET @HairSystemDescription1 = 'HA'
	SET @HairSystemDescription2 = 'SW'

	SELECT @Total = COUNT(*)
		FROM datHairSystemOrder [Orders]
			INNER JOIN cfgHairSystem [HairSystem] ON [Orders].HairSystemID = [HairSystem].HairSystemID
			INNER JOIN [datPurchaseOrderDetail] [PurchaseOrderDetail] ON [Orders].HairSystemOrderGUID = [PurchaseOrderDetail].HairSystemOrderGUID
			INNER JOIN [datPurchaseOrder] [PurchaseOrder] ON [PurchaseOrderDetail].PurchaseOrderGUID = [PurchaseOrder].PurchaseOrderGUID
		WHERE [Orders].HairSystemOrderDate BETWEEN @StartDate AND @EndDate
			AND [HairSystem].HairSystemDescriptionShort NOT IN (@HairSystemDescription1, @HairSystemDescription2)

	SELECT
		[HairLength].HairSystemHairLengthDescription AS 'hairldesc'
	,	COUNT(*) AS 'TotalCount'
	,   CASE WHEN @Total = 0 THEN 0
			 ELSE 1.0 * COUNT(*) / @Total
		END AS 'TotalPercentage'
	,   SUM(CASE WHEN [Orders].TemplateAreaActualCalc <= 80 THEN 1
				 ELSE 0
			END) AS 'LessThan80'
	,	CASE WHEN @Total = 0 THEN 0
			ELSE 1.0 * SUM(CASE WHEN [Orders].TemplateAreaActualCalc <= 80 THEN 1
			ELSE 0 END) / @Total
		END AS 'LessThan80Percentage'
	,   SUM(CASE WHEN [Orders].TemplateAreaActualCalc > 80 AND
							[Orders].TemplateAreaActualCalc <= 110 THEN 1
				 ELSE 0
			END) AS 'Between80And110'
	,   CASE WHEN @Total = 0 THEN 0
			 ELSE 1.0 * SUM(CASE WHEN [Orders].TemplateAreaActualCalc > 80 AND
							[Orders].TemplateAreaActualCalc <= 110 THEN 1
								 ELSE 0
							END) / @Total
		END AS 'Between80And110Percentage'
	,   SUM(CASE WHEN [Orders].TemplateAreaActualCalc > 110 THEN 1
				 ELSE 0
			END) AS 'GreaterThan110'
	,   CASE WHEN @Total = 0 THEN 0
			 ELSE 1.0 * SUM(CASE WHEN [Orders].TemplateAreaActualCalc > 110 THEN 1
								 ELSE 0
							END) / @Total
		END AS 'GreaterThan110Percentage'
	FROM datHairSystemOrder [Orders]
		INNER JOIN lkpHairSystemHairLength [HairLength] ON [Orders].HairSystemHairLengthID = [HairLength].HairSystemHairLengthID
		INNER JOIN cfgHairSystem [HairSystem] ON [Orders].HairSystemID = [HairSystem].HairSystemID
	WHERE [Orders].HairSystemOrderDate BETWEEN @StartDate AND @EndDate
		AND [HairSystem].HairSystemDescriptionShort NOT IN (@HairSystemDescription1, @HairSystemDescription2)
	GROUP BY [HairLength].HairSystemHairLengthDescriptionShort
	,	[HairLength].HairSystemHairLengthDescription
	,	[HairLength].HairSystemHairLengthValue
	ORDER BY [HairLength].HairSystemHairLengthValue

END
GO
