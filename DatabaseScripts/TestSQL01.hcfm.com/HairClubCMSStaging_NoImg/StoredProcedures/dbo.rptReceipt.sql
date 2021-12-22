/* CreateDate: 02/13/2009 10:30:09.040 , ModifyDate: 02/27/2017 09:49:29.320 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				rptReceipt

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Shaun Hankermeyer

IMPLEMENTOR: 			Shaun Hankermeyer

DATE IMPLEMENTED: 		3/17/09

LAST REVISION DATE:
04/23/2009 - Andrew Schwalbe:  Change sales order type description short to return a full description
03/26/2009 - Andrew Schwalbe:  Change to Add 1 instead of Subtract 1 to UTC offset
06/16/2009 - Shaun Hankermeyer: Added Client Home Center
03/07/2014 - Rachelen Hut: Added CASE WHEN SalesCodeDescriptionShort = '100' THEN GenericSalesCodeDescription
02/08/2016 - Rachelen Hut: Added fields 'ProductReceipt' and 'DiscountPercent' for special wording on the report; removed all Franchise centers from the discount wording except for center 891
06/22/2016 - Rachelen Hut: Added Tax1, Tax2, TaxType1ID, TaxTypeDescriptionShort1, TaxType2ID and TaxTypeDescriptionShort2 for Canadian centers
09/27/2016 - Rachelen Hut: Added Siebel ID (#129345)

--------------------------------------------------------------------------------------------------------
NOTES: 	Retrieve data for Receipt report.
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

rptReceipt '82245AAE-7EFC-498F-80C7-770E7BA29925'  --Joy Salas in 292

rptReceipt '8B607305-16C6-4349-A000-15C1A503AC16'  --Ottawa

rptReceipt '2223E746-716E-4F61-A42B-05C7D7B5E84E'  --Siffert, Joseph (213690) with SiebelID


***********************************************************************/

CREATE PROCEDURE [dbo].[rptReceipt]
@SalesOrderGUID uniqueidentifier
AS
BEGIN

SET NOCOUNT ON;


DECLARE @TotalProducts INT

/**********  Create temp tables ****************************************/

CREATE TABLE #CentersToRemove --from 'IsProduct'
(CenterID INT)

CREATE TABLE #Receipt(ClientFullNameCalc NVARCHAR(127)
     , MembershipID INT
     , MembershipDescription NVARCHAR(50)
     , OrderDate DATETIME
     , InvoiceNumber NVARCHAR(50)
     , SalesCodeID INT
     , SalesCodeDescription NVARCHAR(50)
     , Quantity INT
     , Price MONEY
     , Discount MONEY
     , Tax1 MONEY
     , Tax2 MONEY
	 , TaxType1ID MONEY
	 , TaxType2ID MONEY
     , TotalTaxCalc MONEY
     , ExtendedPriceCalc MONEY
     , PriceTaxCalc MONEY
     , CenterDescriptionFullCalc  NVARCHAR(50)
     , CenterID INT
     , CountryID INT
     , ClientHomeCenter  NVARCHAR(50)
	 , AbbreviatedNameCalc  NVARCHAR(50)
     , IsRefundedFlag INT
     , IsVoidedFlag INT
     , SalesOrderTypeDescriptionShort  NVARCHAR(50)
     , SalesOrderTypeDescription  NVARCHAR(50)
     , ReportSubTitle  NVARCHAR(50)
     , SalesCodeDivisionID INT
     , SalesCodeDivisionDescription  NVARCHAR(50)
     , IsProduct INT
     , DiscountPercent NVARCHAR(10)
     , TaxTypeDescriptionShort1 NVARCHAR(50)
	 , TaxTypeDescriptionShort2 NVARCHAR(50)
	 , SiebelID  NVARCHAR(50)
	 )

INSERT INTO #CentersToRemove
SELECT CenterID FROM cfgCenter WHERE CenterID LIKE '[78]%'

--Keep CenterID 891 - Calgary - They are participating in the discount for memberships
DELETE FROM #CentersToRemove WHERE CenterID = 891

/*********  INSERT INTO #Receipt ******************************************************/

INSERT INTO #Receipt
SELECT c.ClientFullNameCalc,
gm.MembershipID,
gm.MembershipDescription,

dbo.GetLocalFromUTC(so.OrderDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) AS OrderDate,
--DATEADD(Hour, CASE WHEN tz.UsesDayLightSavingsFlag = 0 THEN (tz.UTCOffset) WHEN DATEPART(WK, so.OrderDate) <= 10 OR DATEPART(WK, so.OrderDate) >= 45 THEN (tz.UTCOffset) ELSE ((tz.UTCOffset) + 1) END, so.OrderDate) AS OrderDate,

so.InvoiceNumber,
sc.SalesCodeID,
CASE WHEN sc.SalesCodeDescriptionShort = '100' THEN ISNULL(GenericSalesCodeDescription,'Retail Product Generic') ELSE SalesCodeDescription END AS 'SalesCodeDescription',
sod.Quantity,
sod.Price,
sod.Discount,
sod.Tax1,
sod.Tax2,
sod.TaxType1ID,
sod.TaxType2ID,
sod.TotalTaxCalc,
sod.ExtendedPriceCalc,
sod.PriceTaxCalc,
ct.CenterDescriptionFullCalc,
ct.CenterID,
ct.CountryID,
cfgct.CenterDescriptionFullCalc AS 'ClientHomeCenter',
e.AbbreviatedNameCalc,
so.IsRefundedFlag,
so.IsVoidedFlag,
lt.SalesOrderTypeDescriptionShort,
CASE
	WHEN lt.SalesOrderTypeDescriptionShort = 'SO' THEN 'Sales Order'
	WHEN lt.SalesOrderTypeDescriptionShort = 'MO' THEN 'Membership Order'
	ELSE ''
END AS SalesOrderTypeDescription,
CASE
	WHEN so.IsRefundedFlag = 1 AND so.IsVoidedFlag =1 THEN 'Refund, Voided Order'
	WHEN so.IsRefundedFlag = 1 AND (so.IsVoidedFlag IS NULL OR so.IsVoidedFlag = 0) THEN 'Refund'
	WHEN so.IsVoidedFlag = 1 AND (so.IsRefundedFlag IS NULL OR so.IsRefundedFlag = 0) THEN 'Voided Order'
	ELSE ''
END AS 'ReportSubTitle'
,	scdept.SalesCodeDivisionID
,	scdiv.SalesCodeDivisionDescription
,	CASE WHEN scdept.SalesCodeDivisionID IN(30)
		AND gm.MembershipID IN(26,28,65,66,67,68)
		AND c.CenterID NOT IN(SELECT CenterID FROM #CentersToRemove)  --Do not include Franchises except 891
		THEN 1 ELSE 0 END AS 'IsProduct'
,	CASE WHEN gm.MembershipID IN(28,67,68) THEN '20%'
		WHEN gm.MembershipID IN (26,65,66) THEN '15%'
		ELSE '' END AS 'DiscountPercent'

/*28	Gold - 20%
67	Sapphire - 20%
68	Sapphire Plus - 20%
26	Silver - 15%
65	Emerald  - 15%
66	Emerald Plus - 15%
*/
,	TT1.TaxTypeDescriptionShort AS 'TaxTypeDescriptionShort1'
,	TT2.TaxTypeDescriptionShort AS 'TaxTypeDescriptionShort2'
,	c.SiebelID
FROM datSalesOrder so
LEFT JOIN datSalesOrderDetail sod ON so.SalesOrderGUID = sod.SalesOrderGUID
INNER JOIN cfgSalesCode sc ON sod.SalesCodeID = sc.SalesCodeID
INNER JOIN datClient c ON so.ClientGUID = c.ClientGUID
INNER JOIN cfgCenter ct ON so.CenterID = ct.CenterID
INNER JOIN cfgCenter cfgct ON so.ClientHomeCenterID = cfgct.CenterID
INNER JOIN lkpTimeZone tz ON ct.TimeZoneID = tz.TimeZoneID
INNER JOIN datEmployee e ON so.EmployeeGUID = e.EmployeeGUID
INNER JOIN datClientMembership cm ON so.ClientMembershipGUID = cm.ClientMembershipGUID
INNER JOIN cfgMembership gm ON cm.MembershipID = gm.MembershipID
LEFT JOIN lkpSalesOrderType lt ON so.SalesOrderTypeID = lt.SalesOrderTypeID
INNER JOIN dbo.lkpSalesCodeDepartment scdept ON sc.SalesCodeDepartmentID = scdept.SalesCodeDepartmentID
INNER JOIN dbo.lkpSalesCodeDivision scdiv ON scdept.SalesCodeDivisionID = scdiv.SalesCodeDivisionID
LEFT JOIN dbo.lkpTaxType TT1 ON TT1.TaxTypeID = sod.TaxType1ID
LEFT JOIN dbo.lkpTaxType TT2 ON TT2.TaxTypeID = sod.TaxType2ID
LEFT JOIN dbo.cfgCenterTaxRate TAX 	ON TAX.CenterID = ct.CenterID
WHERE so.SalesOrderGUID = @SalesOrderGUID
ORDER BY sc.SalesCodeSortOrder ASC


/******** Discover if there are any Products for the required MembershipIDs from #Receipt to show the special wording on the report *******************/

SET @TotalProducts = (SELECT SUM(IsProduct) FROM #Receipt)

IF @TotalProducts > 0
BEGIN
SELECT ClientFullNameCalc
     , MembershipID
     , MembershipDescription
     , OrderDate
     , InvoiceNumber
     , SalesCodeID
     , SalesCodeDescription
     , Quantity
     , Price
     , Discount
     , ISNULL(Tax1,0) AS 'Tax1'
     , ISNULL(Tax2,0) AS 'Tax2'
	 , TaxType1ID
	 , TaxType2ID
     , TotalTaxCalc
     , ExtendedPriceCalc
     , PriceTaxCalc
     , CenterDescriptionFullCalc
	 ,	CountryID
     , ClientHomeCenter
     , AbbreviatedNameCalc
     , IsRefundedFlag
     , IsVoidedFlag
     , SalesOrderTypeDescriptionShort
     , SalesOrderTypeDescription
     , ReportSubTitle
     , SalesCodeDivisionID
     , SalesCodeDivisionDescription
     , 1 AS 'ProductReceipt'
     , DiscountPercent
	 , CASE WHEN TaxTypeDescriptionShort1 = 'NONTAX' THEN NULL ELSE TaxTypeDescriptionShort1 END AS 'TaxTypeDescriptionShort1'
	 , CASE WHEN TaxTypeDescriptionShort2 = 'NONTAX' THEN NULL ELSE TaxTypeDescriptionShort2 END AS 'TaxTypeDescriptionShort2'
	 , SiebelID
FROM #Receipt
GROUP BY ClientFullNameCalc
     , MembershipID
     , MembershipDescription
     , OrderDate
     , InvoiceNumber
     , SalesCodeID
     , SalesCodeDescription
     , Quantity
     , Price
     , Discount
     , Tax1
     , Tax2
	 , TaxType1ID
	 , TaxType2ID
     , TotalTaxCalc
     , ExtendedPriceCalc
     , PriceTaxCalc
     , CenterDescriptionFullCalc
	 ,	CountryID
     , ClientHomeCenter
     , AbbreviatedNameCalc
     , IsRefundedFlag
     , IsVoidedFlag
     , SalesOrderTypeDescriptionShort
     , SalesOrderTypeDescription
     , ReportSubTitle
     , SalesCodeDivisionID
     , SalesCodeDivisionDescription
     , DiscountPercent
	 , TaxTypeDescriptionShort1
	 , TaxTypeDescriptionShort2
	 , SiebelID
END
ELSE
BEGIN
SELECT ClientFullNameCalc
     , MembershipID
     , MembershipDescription
     , OrderDate
     , InvoiceNumber
     , SalesCodeID
     , SalesCodeDescription
     , Quantity
     , Price
     , Discount
     , Tax1
     , Tax2
	 , TaxType1ID
	 , TaxType2ID
     , TotalTaxCalc
     , ExtendedPriceCalc
     , PriceTaxCalc
     , CenterDescriptionFullCalc
	 ,	CountryID
     , ClientHomeCenter
     , AbbreviatedNameCalc
     , IsRefundedFlag
     , IsVoidedFlag
     , SalesOrderTypeDescriptionShort
     , SalesOrderTypeDescription
     , ReportSubTitle
     , SalesCodeDivisionID
     , SalesCodeDivisionDescription
     , 0 AS 'ProductReceipt'
     , DiscountPercent
	 , CASE WHEN TaxTypeDescriptionShort1 = 'NONTAX' THEN NULL ELSE TaxTypeDescriptionShort1 END AS 'TaxTypeDescriptionShort1'
	 , CASE WHEN TaxTypeDescriptionShort2 = 'NONTAX' THEN NULL ELSE TaxTypeDescriptionShort2 END AS 'TaxTypeDescriptionShort2'
	 , SiebelID
FROM #Receipt
GROUP BY ClientFullNameCalc
     , MembershipID
     , MembershipDescription
     , OrderDate
     , InvoiceNumber
     , SalesCodeID
     , SalesCodeDescription
     , Quantity
     , Price
     , Discount
     , Tax1
     , Tax2
	 , TaxType1ID
	 , TaxType2ID
     , TotalTaxCalc
     , ExtendedPriceCalc
     , PriceTaxCalc
     , CenterDescriptionFullCalc
	 ,	CountryID
     , ClientHomeCenter
     , AbbreviatedNameCalc
     , IsRefundedFlag
     , IsVoidedFlag
     , SalesOrderTypeDescriptionShort
     , SalesOrderTypeDescription
     , ReportSubTitle
     , SalesCodeDivisionID
     , SalesCodeDivisionDescription
     , DiscountPercent
	 , TaxTypeDescriptionShort1
	 , TaxTypeDescriptionShort2
	 , SiebelID
END
END
GO
