/* CreateDate: 08/21/2012 10:17:49.420 , ModifyDate: 06/05/2015 12:22:20.100 */
GO
/***********************************************************************
PROCEDURE:				spRpt_FranchiseRoyalty
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Franchise Royalty Report
AUTHOR:					Marlon Burrell
IMPLEMENTOR:			Marlon Burrell
DATE IMPLEMENTED:		05/17/2013
------------------------------------------------------------------------
NOTES:
11/04/2013 - DL - (#93429) Separated Retail Data from the main query. Main query joined from FactSalesTransactions --> DimClientMembership --> DimCenter.
				  This was causing the retail amount to not match both the Recurring Business Flash & the Retail Flash amounts.
				  Separated Retail query and joined from FactSalesTransactions --> DimCenter which resolved the issue.
11/12/2013 - DL - (#93429) Added Join from DimSalesOrder.ClientHomeCenterKey --> DimCenter in order to filter results.
12/04/2013 - DL - (#94635) Fixed an issue where PCP Writeoffs done on a CANCEL membership were not being reflected under Recurring Business.
09/05/2014 - DL - (#104941) Added Client Name.
09/22/2014 - DL - (#106626) Excluded Intercompany Sales Order Types
06/05/2015 - RH - (115575) Find Last_Transact; NULL as CMSDate - since [HCSQL2\SQL2005] no longer valid
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_FranchiseRoyalty 896, 8, 2014
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_FranchiseRoyalty]
(
	@Center INT
,	@Month INT
,	@Year INT
)
AS
BEGIN

SET NOCOUNT ON;


DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME
DECLARE @RoyaltyPercentage NUMERIC(3,2)
DECLARE @LastTransfer DATETIME
DECLARE @CMSDate DATETIME


SELECT  @StartDate = CONVERT(DATETIME, CONVERT(VARCHAR, @Month) + '/1/' + CONVERT(VARCHAR, @Year))
,       @EndDate = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @StartDate))
,       @RoyaltyPercentage = 0.06
--Find Last_Transact
--,       @LastTransfer = ( SELECT    Last_Transact
--                          FROM      [HCSQL2\SQL2005].INFOSTORE.dbo.gmterr
--                          WHERE     Territory = @Center
--                        )
,       @LastTransfer = (SELECT  MAX(DD.FullDate)
                         FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
							INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
								ON FST.OrderDateKey = dd.DateKey
						 WHERE  FST.CenterKey IN (SELECT CTR.CenterKey
												  FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
												  INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
													 ON FST.CenterKey = CTR.CenterKey
												  WHERE CTR.CenterSSID = @Center)
                        )

--
--,       @CMSDate = ( SELECT CMS_DATE
--                     FROM   [HCSQL2\SQL2005].HCFMDirectory.dbo.tblCenter
--                     WHERE  Center_Num = @Center
--                   )


/********************************** Create temp table objects *************************************/
CREATE TABLE #Sales (
	CenterSSID INT
,	CenterName VARCHAR(50)
,	CMSDate DATETIME
,	InvoiceNumber VARCHAR(50)
,	SalesOrderDetailKey INT
,	TransactionDate DATETIME
,	ClientIdentifier INT
,	Code VARCHAR(15)
,	Description VARCHAR(50)
,	RevenueGroup VARCHAR(50)
,	Division VARCHAR(50)
,	Department VARCHAR(50)
,	Revenue MONEY
,	Tax MONEY
,	Net MONEY
,	Royalty MONEY
,	RoyaltyPercentage VARCHAR(50)
,	LastTransfer DATETIME
)

CREATE TABLE #RetailSales (
	CenterSSID INT
,	CenterName VARCHAR(50)
,	CMSDate DATETIME
,	InvoiceNumber VARCHAR(50)
,	SalesOrderDetailKey INT
,	TransactionDate DATETIME
,	ClientIdentifier INT
,	Code VARCHAR(15)
,	Description VARCHAR(50)
,	RevenueGroup VARCHAR(50)
,	Division VARCHAR(50)
,	Department VARCHAR(50)
,	Revenue MONEY
,	Tax MONEY
,	Net MONEY
,	Royalty MONEY
,	RoyaltyPercentage VARCHAR(50)
,	LastTransfer DATETIME
)

CREATE TABLE #Final (
	CenterSSID INT
,	CenterName VARCHAR(50)
,	CMSDate DATETIME
,	InvoiceNumber VARCHAR(50)
,	SalesOrderDetailKey INT
,	TransactionDate DATETIME
,	ClientIdentifier INT
,	Code VARCHAR(15)
,	Description VARCHAR(50)
,	RevenueGroup VARCHAR(50)
,	Division VARCHAR(50)
,	Department VARCHAR(50)
,	Revenue MONEY
,	Tax MONEY
,	Net MONEY
,	Royalty MONEY
,	RoyaltyPercentage VARCHAR(50)
,	LastTransfer DATETIME
)


/****************************** GET SALES DATA **************************************/
INSERT	INTO #Sales
		SELECT  DC.CenterSSID AS 'center'
		,       DC.CenterDescription AS 'CenterName'
		,       NULL AS 'CMS_Date'
		,       SO.InvoiceNumber AS 'ticket_no'
		,       FST.SalesOrderDetailKey AS 'transact_no'
		,       DD.FullDate AS 'date'
		,       CLT.ClientIdentifier AS 'client_no'
		,       SC.SalesCodeDescriptionShort AS 'code'
		,       SC.SalesCodeDescription AS 'description'
		,       CASE WHEN M.MembershipSSID = 11
							AND SC.SalesCodeDescriptionShort = 'PCPREVWO' THEN 'Recurring Business'
						ELSE M.RevenueGroupDescription
				END AS 'RevenueGroupDescription'
		,       CASE WHEN M.MembershipSSID = 15 THEN 'Non Program'
						ELSE CASE WHEN M.MembershipSSID = 11
									AND SC.SalesCodeDescriptionShort = 'PCPREVWO' THEN 'Recurring Business'
								ELSE M.RevenueGroupDescription
							END
				END AS 'Division'
		,       SCDept.SalesCodeDepartmentDescription AS 'Department'
		,       FST.ExtendedPricePlusTax AS 'Revenue'
		,       FST.Tax1 AS 'Tax'
		,       FST.ExtendedPrice AS 'Net'
		,       CONVERT(MONEY, FST.ExtendedPrice * @RoyaltyPercentage) AS 'Royalty'
		,       CAST(CAST(@RoyaltyPercentage * 100 AS NUMERIC(10, 0)) AS VARCHAR(5)) + '%' AS 'RoyaltyPercentage'
		,       @LastTransfer AS 'Last_Transact'
		FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
					ON FST.OrderDateKey = dd.DateKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
					ON fst.SalesCodeKey = sc.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
					ON FST.ClientMembershipKey = cm.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
					ON cm.MembershipSSID = m.MembershipSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
					ON cm.CenterKey = c.CenterKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment SCDept
					ON SC.SalesCodeDepartmentKey = SCDept.SalesCodeDepartmentKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDivision SCDiv
					ON SCDept.SalesCodeDivisionKey = SCDiv.SalesCodeDivisionKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
					ON FST.SalesOrderKey = SO.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
					ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
					ON FST.ClientKey = CLT.ClientKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					ON SO.ClientHomeCenterKey = DC.CenterKey
		WHERE   DC.CenterSSID = @Center
				AND DD.FullDate BETWEEN @StartDate AND @EndDate
				AND SCDiv.SalesCodeDivisionSSID IN ( 20 )


/****************************** GET RETAIL DATA **************************************/
INSERT	INTO #RetailSales
		SELECT  C.CenterSSID AS 'center'
		,       C.CenterDescription AS 'CenterName'
		,       NULL AS 'CMS_Date'
		,       SO.InvoiceNumber AS 'ticket_no'
		,       FST.SalesOrderDetailKey AS 'transact_no'
		,       DD.FullDate AS 'date'
		,       CLT.ClientIdentifier AS 'client_no'
		,       SC.SalesCodeDescriptionShort AS 'code'
		,       SC.SalesCodeDescription AS 'description'
		,		M.RevenueGroupDescription
		,       SCDiv.SalesCodeDivisionDescription AS 'Division'
		,       SCDept.SalesCodeDepartmentDescription AS 'Department'
		,       FST.ExtendedPricePlusTax AS 'Revenue'
		,       FST.Tax1 AS 'Tax'
		,       FST.ExtendedPrice AS 'Net'
		,       CONVERT(MONEY, FST.ExtendedPrice * @RoyaltyPercentage) AS 'Royalty'
		,       CAST(CAST(@RoyaltyPercentage * 100 AS NUMERIC(10, 0)) AS VARCHAR(5)) + '%' AS 'RoyaltyPercentage'
		,       @LastTransfer AS 'Last_Transact'
		FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
					ON FST.OrderDateKey = dd.DateKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
					ON fst.SalesCodeKey = sc.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
					ON FST.ClientMembershipKey = cm.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
					ON cm.MembershipSSID = m.MembershipSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
					ON fst.CenterKey = c.CenterKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment SCDept
					ON SC.SalesCodeDepartmentKey = SCDept.SalesCodeDepartmentKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDivision SCDiv
					ON SCDept.SalesCodeDivisionKey = SCDiv.SalesCodeDivisionKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
					ON FST.SalesOrderKey = SO.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderType DSOT
					ON SO.SalesOrderTypeKey = DSOT.SalesOrderTypeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
					ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
					ON FST.ClientKey = CLT.ClientKey
		WHERE   C.CenterSSID = @Center
				AND DD.FullDate BETWEEN @StartDate AND @EndDate
				AND SCDiv.SalesCodeDivisionSSID IN ( 30, 50 )
				AND DSOT.SalesOrderTypeKey <> 7


/****************************** COMBINE DATA **************************************/
INSERT	INTO #Final
		SELECT  S.CenterSSID
		,       S.CenterName
		,       S.CMSDate
		,       S.InvoiceNumber
		,       S.SalesOrderDetailKey
		,       S.TransactionDate
		,       S.ClientIdentifier
		,       S.Code
		,       S.Description
        ,		S.RevenueGroup
		,       S.Division
		,       S.Department
		,       S.Revenue
		,       S.Tax
		,       S.Net
		,       S.Royalty
		,       S.RoyaltyPercentage
		,       S.LastTransfer
		FROM	#Sales S
		UNION
		SELECT  RS.CenterSSID
		,       RS.CenterName
		,       RS.CMSDate
		,       RS.InvoiceNumber
		,       RS.SalesOrderDetailKey
		,       RS.TransactionDate
		,       RS.ClientIdentifier
		,       RS.Code
		,       RS.Description
		,		RS.RevenueGroup
		,       RS.Division
		,       RS.Department
		,       RS.Revenue
		,       RS.Tax
		,       RS.Net
		,       RS.Royalty
		,       RS.RoyaltyPercentage
		,       RS.LastTransfer
		FROM	#RetailSales RS


/****************************** DISPLAY DATA **************************************/
SELECT  F.CenterSSID AS 'center'
,       F.CenterName
,       NULL AS 'CMS_Date'
,       F.InvoiceNumber AS 'ticket_no'
,       F.SalesOrderDetailKey AS 'transact_no'
,       F.TransactionDate AS 'date'
,		F.ClientIdentifier AS 'client_no'
,       CLT.ClientLastName + ', ' + CLT.ClientFirstName + ' (' + CONVERT(VARCHAR, F.ClientIdentifier) + ')' AS 'client_name'
,       F.Code
,       F.Description AS 'description'
,       F.Division
,       F.Department
,       F.Revenue
,       F.Tax
,       F.Net
,       F.Royalty
,       F.RoyaltyPercentage
,       F.LastTransfer AS 'Last_Transact'
FROM    #Final F
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON F.ClientIdentifier = CLT.ClientIdentifier
ORDER BY F.Division
,		F.RevenueGroup + ' ' + F.Department
,		F.InvoiceNumber

END
GO
