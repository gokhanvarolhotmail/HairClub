/* CreateDate: 06/28/2016 12:24:00.580 , ModifyDate: 11/09/2016 16:42:45.227 */
GO
/***********************************************************************

PROCEDURE:				rptReceiptSum

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

ORIGINAL AUTHOR: 		Rachelen Hut

IMPLEMENTOR: 			Rachelen Hut

DATE IMPLEMENTED: 		06/22/2016

LAST REVISION DATE:

--------------------------------------------------------------------------------------------------------
NOTES: 	Retrieve data for Receipt report.  This stored procedure find the totals for Canadian tax types.
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

[rptReceiptSum] '82245AAE-7EFC-498F-80C7-770E7BA29925'  --Joy Salas in 292

[rptReceiptSum] '1C9B9EA1-5463-4173-B844-3573E30BFECB'

[rptReceiptSum] 'D3023C91-5AEA-4813-A021-01F3BB8B590E'

[rptReceiptSum] '1BDA4C95-3510-460E-8192-9FA824831939'

[rptReceiptSum] '4262240D-D4C1-4ED1-ABB0-E307BAB1430D'


***********************************************************************/

CREATE PROCEDURE [dbo].[rptReceiptSum]
@SalesOrderGUID uniqueidentifier
AS
BEGIN

SET NOCOUNT ON;




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
	 , TaxIDNumber1  NVARCHAR(50)
	 , TaxIDNumber2  NVARCHAR(50)
	 )

INSERT INTO #CentersToRemove
SELECT CenterID FROM cfgCenter WHERE CenterID LIKE '[78]%'

--Keep CenterID 891 - Calgary - They are participating in the discount for memberships
DELETE FROM #CentersToRemove WHERE CenterID = 891


CREATE TABLE #CenterTaxTypes( CenterID INT
,	CountryID INT
,	TaxTypeID INT
,	TaxTypeDescriptionShort NVARCHAR(10)
,	Tax1 MONEY
,	Tax2 MONEY
,	TotalTax MONEY
,	TaxIDNumberString NVARCHAR(MAX)
)

CREATE TABLE #TaxTypeTotals(
	TaxType1ID INT
	,	TaxType2ID INT
	,	Tax1 MONEY
	,	Tax2 MONEY)




/*********  INSERT INTO #Receipt This is the same query as rptReceipt ******************************************************/

INSERT INTO #Receipt
SELECT c.ClientFullNameCalc,
gm.MembershipID,
gm.MembershipDescription,

dbo.GetLocalFromUTC(so.OrderDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) AS OrderDate,
--DATEADD(Hour, CASE WHEN tz.UsesDayLightSavingsFlag = 0 THEN (tz.UTCOffset) WHEN DATEPART(WK, so.OrderDate) <= 10 OR DATEPART(WK, so.OrderDate) >= 45 THEN (tz.UTCOffset) ELSE ((tz.UTCOffset) + 1) END, so.OrderDate) AS 'OrderDate',

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
,	TAX1.TaxIDNumber AS 'TaxIDNumber1'
,	TAX2.TaxIDNumber AS 'TaxIDNumber2'
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
LEFT JOIN dbo.cfgCenterTaxRate TAX1 	ON TAX1.CenterID = so.CenterID AND TAX1.TaxTypeID = sod.TaxType1ID
LEFT JOIN dbo.cfgCenterTaxRate TAX2 	ON TAX2.CenterID = so.CenterID AND TAX2.TaxTypeID = sod.TaxType2ID
WHERE so.SalesOrderGUID = @SalesOrderGUID
ORDER BY sc.SalesCodeSortOrder ASC

--SELECT * FROM #Receipt

INSERT INTO #CenterTaxTypes
        (CenterID
		,	CountryID
       , TaxTypeID
       , TaxTypeDescriptionShort
        )
SELECT CTR.CenterID
,	R.CountryID
,	CTR.TaxTypeID
,	TT.TaxTypeDescriptionShort
FROM #Receipt R
INNER JOIN dbo.cfgCenterTaxRate  CTR
	ON R.CenterID = CTR.CenterID
INNER JOIN dbo.lkpTaxType TT
	ON TT.TaxTypeID = CTR.TaxTypeID
WHERE CTR.IsActiveFlag = 1
AND TT.IsActiveFlag = 1
GROUP BY CTR.CenterID
		,	R.CountryID
       , CTR.TaxTypeID
       , TT.TaxTypeDescriptionShort


--SELECT * FROM #CenterTaxTypes

INSERT INTO #TaxTypeTotals
(TaxType1ID, Tax1)
SELECT TaxType1ID
, SUM(Tax1) AS 'Tax1'
FROM #Receipt
WHERE TaxType1ID IS NOT NULL AND Tax1 <> '0.00'
GROUP BY TaxType1ID

INSERT INTO #TaxTypeTotals
(TaxType2ID, Tax2)
SELECT TaxType2ID, SUM(Tax2) AS 'Tax2'
FROM #Receipt
WHERE TaxType2ID IS NOT NULL AND Tax2 <> '0.00'
GROUP BY TaxType2ID

--SELECT * FROM #TaxTypeTotals

--Find Tax1 per TaxTypeID
UPDATE CTT
SET CTT.Tax1 =TTT.Tax1
FROM #CenterTaxTypes CTT
INNER JOIN #TaxTypeTotals TTT
	ON CTT.TaxTypeID = TTT.TaxType1ID
WHERE TaxTypeID = TaxType1ID

--Find Tax2 per TaxTypeID
UPDATE CTT
SET CTT.Tax2 = TTT.Tax2
FROM #CenterTaxTypes CTT
INNER JOIN #TaxTypeTotals TTT
	ON CTT.TaxTypeID = TTT.TaxType2ID
WHERE CTT.TaxTypeID = TTT.TaxType2ID

--Add Tax1 and Tax2
UPDATE CTT
SET CTT.TotalTax = ISNULL(CTT.Tax1,0) + ISNULL(CTT.Tax2,0)
FROM #CenterTaxTypes CTT


--INSERT TaxIDNumberString
UPDATE #CenterTaxTypes
SET TaxIDNumberString = CASE WHEN TaxIDNumber2 IS NOT NULL THEN (ISNULL(TaxIDNumber1,'') + ', ' + ISNULL(TaxIDNumber2,'')) ELSE ISNULL(TaxIDNumber1,'') END
FROM #Receipt


SELECT CountryID
,	TaxTypeDescriptionShort
,	TotalTax
,	TaxIDNumberString
FROM #CenterTaxTypes
WHERE TotalTax <> '0.00'

END
GO
