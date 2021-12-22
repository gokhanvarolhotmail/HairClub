/* CreateDate: 06/27/2011 20:28:26.133 , ModifyDate: 10/11/2019 10:00:05.753 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
-- Procedure Name:			rptPricingSummary
-- Procedure Description:
--
-- Created By:				Mike Maass, Skyline Technologies, Inc
-- Implemented By:			Mike Maass, Skyline Technologies, Inc
-- Last Modified By:		Mike Maass, Skyline Technologies, Inc
--
-- Date Created:			6/19/2011
-- Date Implemented:		6/19/2011
-- Date Last Modified:		6/19/2011
--
-- Destination Server:		SQL01
-- Destination Database:	HairClubCMS
-- Related Application:		CMS

Sample Execution:

EXEC rptPricingSummary '6H'
EXEC rptPricingSummary 'All Factories'

--------------------------------------------------------------------------------------------------------
NOTES: 	Returns

		* 01/14/2011 - MLM	Add Handling for Corporate, Franchise, And Joint Venture Groups
		* 01/21/2011 - MLM  Changed the join on HairSystemOrder from CenterID to ClientHomeCenterID
		* 01/25/2011 - MLM: Changed the Stored Procedure to Pass in the EmployeeGUID instead of UserLogin
		* 02/11/2011 - MLM: Added IncAll Parameters to 'Hack' around the Select All
		* 02/25/2011 - MLM: Exclude Center 100 from corporate Centers Group
		* 03/01/2011 - MLM: Removed Measuredby and EnteredBy
		* 07/06/2011 - AMH: Added DateRange and Removed IsActiveContract Bit

--------------------------------------------------------------------------------------------------------
================================================================================================*/
CREATE PROCEDURE [dbo].[rptPricingSummary]
(
	@Factory VARCHAR(50),
	@StartDate datetime,
	@EndDate datetime
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


;WITH PRICE_CTE AS
(
	SELECT v.VendorID
	,v.VendorDescription
	,v.VendorDescriptionShort
	,hsvc.ContractBeginDate
	,hsvc.ContractEndDate
	,hsvc.ContractName
	,hs.HairSystemID
	,hs.HairSystemDescription
	,hs.HairSystemDescriptionShort
	,hsc.HairSystemCurlID
	,hsc.HairSystemCurlDescription
	,hsc.HairSystemCurlDescriptionShort
	,hshl.HairSystemHairLengthID
	,hshl.HairSystemHairLengthDescription
	,hshl.HairSystemHairLengthDescriptionShort
	,hshl.HairSystemHairLengthValue
	,hsvcp.HairSystemAreaRangeBegin
	,hsvcp.HairSystemAreaRangeEnd
	,hsvcp.HairSystemCost AS 'HairSystemPrice'
	,COUNT(*) OVER(PARTITION BY hsvc.HairSystemVendorContractId, hsc.HairSystemCurlID, hshl.HairSystemHairLengthId, hsvcp.HairSystemAreaRangeBegin) AS HairSystemCount
	,COUNT(*) OVER(PARTITION BY hsvc.HairSystemVendorContractId, hs.HairSystemID, hshl.HairSystemHairLengthId, hsvcp.HairSystemAreaRangeBegin) AS HairSystemCurlCount
	FROM [dbo].[cfgHairSystemVendorContract] hsvc
		INNER JOIN [dbo].[cfgVendor] v ON hsvc.VendorID = v.VendorID
		INNER JOIN [dbo].[cfgHairSystemVendorContractHairSystem] hsvchs  ON hsvc.HairSystemVendorContractID = hsvchs.HairSystemVendorContractID
		INNER JOIN [dbo].[cfgHairSystem] hs ON hsvchs.HairSystemID = hs.HairSystemID
		INNER JOIN [dbo].[cfgHairSystemVendorContractHairSystemCurl] hsvchsc ON hsvc.HairSystemVendorContractID = hsvchsc.HairSystemVendorContractID
		INNER JOIN [dbo].[lkpHairSystemCurl] hsc ON hsvchsc.HairSystemCurlID = hsc.HairSystemCurlID
		INNER JOIN [dbo].[cfgHairSystemVendorContractPricing] hsvcp ON hsvc.HairSystemVendorContractID = hsvcp.HairSystemVendorContractID
		INNER JOIN [dbo].[lkpHairSystemHairLength] hshl ON hsvcp.HairSystemHairLengthID = hshl.HairSystemHairLengthID
	WHERE ((hsvc.ContractBeginDate  IS NOT NULL AND hsvc.ContractBeginDate BETWEEN @StartDate AND @EndDate) OR
		   (hsvc.ContractEndDate IS NOT NULL AND hsvc.ContractEndDate  BETWEEN @StartDate AND @EndDate) OR
		   (@StartDate BETWEEN hsvc.ContractBeginDate AND hsvc.ContractEndDate) OR
		   (@EndDate BETWEEN hsvc.ContractBeginDate AND hsvc.ContractEndDate))
		AND ISNULL(v.VendorDescriptionShort, 'XX') LIKE CASE WHEN @Factory = 'All Factories' THEN '%' ELSE @Factory END
)
SELECT DISTINCT VendorID
	,VendorDescription
	,VendorDescriptionShort
	,ContractName
	,ContractBeginDate
	,ContractEndDate
	,HairSystemAreaRangeBegin
	,HairSystemAreaRangeEnd
	,CASE WHEN HairSystemCount <= 5 THEN
			STUFF
			(
				(
					SELECT ', ' + HairSystemDescriptionShort
					FROM PRICE_CTE cte2
					WHERE cte2.VendorID = PRICE_CTE.VendorID
						AND cte2.ContractName = PRICE_CTE.ContractName
						AND cte2.HairSystemAreaRangeBegin = PRICE_CTE.HairSystemAreaRangeBegin
						AND cte2.HairSystemHairLengthID = PRICE_CTE.HairSystemHairLengthID
						AND cte2.HairSystemPrice = PRICE_CTE.HairSystemPrice
						AND cte2.HairSystemCurlID = PRICE_CTE.HairSystemCurlID
					ORDER BY cte2.ContractName
					FOR XML PATH('')
				), 1, 1, ''
			)
		ELSE ''
	END as HairSystemDescriptionShort
	,CASE WHEN HairSystemCurlCount <= 5 THEN
			STUFF
			(
				(
					SELECT ', ' + HairSystemCurlDescriptionShort
					FROM PRICE_CTE cte2
					WHERE cte2.VendorID = PRICE_CTE.VendorID
						AND cte2.ContractName = PRICE_CTE.ContractName
						AND cte2.HairSystemAreaRangeBegin = PRICE_CTE.HairSystemAreaRangeBegin
						AND cte2.HairSystemHairLengthID = PRICE_CTE.HairSystemHairLengthID
						AND cte2.HairSystemPrice = PRICE_CTE.HairSystemPrice
						AND cte2.HairSystemID = PRICE_CTE.HairSystemID
					ORDER BY cte2.ContractName
					FOR XML PATH('')
				), 1, 1, ''
			)
		ELSE ''
	END as HairSystemCurlDescriptionShort
	,HairSystemHairLengthDescriptionShort
	,HairSystemHairLengthValue
	,HairSystemPrice
FROM Price_CTE
ORDER BY VendorDescriptionShort, ContractName, ContractBeginDate, HairSystemAreaRangeBegin, HairSystemHairLengthValue

END
GO
