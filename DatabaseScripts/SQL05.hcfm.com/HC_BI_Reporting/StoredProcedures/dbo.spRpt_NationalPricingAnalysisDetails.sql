/* CreateDate: 01/31/2014 14:50:38.790 , ModifyDate: 09/13/2019 09:23:34.850 */
GO
/***********************************************************************
PROCEDURE:				spRpt_NationalPricingAnalysisDetails
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			National Pricing Analysis Details
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		11/5/2013
------------------------------------------------------------------------
NOTES:

11/05/2013 - DL - Converted Stored procedure
11/25/2013 - DL - Changed formula used to calculate Difference to use DCM.ClientMembershipMonthlyFee (#94202)
12/10/2013 - DL - Rounded the CurrentRate value to 2 decimal places as it was being done in the Difference formula (#94888)
01/31/2014 - DL - Replaced @Membership parameter with @MembershipID parameter
11/15/2016 - RH - Changed DM.MembershipMonthlyFee to DCM.ClientMembershipMonthlyFee so the difference makes sense; Added TransactionDate (Monthly Fee Change Date) (#132172)
01/05/2017 - RH - Changed EmployeeKey to CenterManagementAreaSSID as AreaManagerID and CenterManagementAreaDescription as description (#132688)
07/18/2017 - RH - (#140979) Changed source of National Rates from HC_DeferredRevenue.dbo.DimMembershipRatesByCenter to SQL05.HairClubCMS.dbo.cfgCenterMembership
08/25/2017 - RH - (#142423) National Pricing should only include Recurring Business
04/16/2018 - RH - (#145957) Removed Regions/ Areas as they are not used in the detail report
02/12/2019 - DL - Changed the CASE statement for the NationalRate to use the NationalMonthlyFee value on the DimClientMembership table (if it exists) instead of the rate in the #NationalRates table
08/08/2019 - RH - (#12821) Added TotalContractPrice, TotalPayments, Difference2, DaysRemaining, ClientIdentifier, join on HC_Accounting.dbo.dbaClient; pull membership rates from HC_DeferredRevenue_DAILY.dbo.DimMembershipRatesByCenter
08/23/2019 - RH - (#12821) Removed @SpecifiyDate, @Month2, @Year2
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_NationalPricingAnalysisDetails 201, 0, 7, 2019, 65, 1

EXEC spRpt_NationalPricingAnalysisDetails 849, 1, 1, 2019, 24, 1
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_NationalPricingAnalysisDetails]
(
	@Center INT
,	@Filter INT
,	@Month INT
,	@Year INT
,	@MembershipID INT
,	@NationalRate INT
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


/*
@Filter
	0 - All Clients
	1 - Clients LESS THAN the national rate
	2 - Clients GREATER THAN the national rate

@NationalRate
	0 - Old National Rates
	1 - New National Rates
*/



DECLARE @MonthStart DATETIME
DECLARE @PreviousTwoMonthsStart DATETIME
DECLARE @EndOfLastMonth DATETIME
DECLARE @MemBeginDate DATETIME
DECLARE @MemEndDate DATETIME



		SET @MonthStart = CONVERT(DATETIME, CONVERT(VARCHAR, @Month) + '/1/' + CONVERT(VARCHAR, @Year))


IF @NationalRate = 0
	BEGIN
		SET @MemBeginDate = DATEADD(MONTH, -24, '3/31/11 23:59')
		SET @MemEndDate = '3/31/11 23:59'
	END
ELSE
	BEGIN
		SET @MemBeginDate = '4/1/11'
		SET @MemEndDate = GETDATE()
	END


SET @PreviousTwoMonthsStart = CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(DATEADD(MONTH, -2, GETDATE()))) + '/1/' + CONVERT(VARCHAR, YEAR(DATEADD(MONTH, -2, GETDATE()))))
SET @EndOfLastMonth = DATEADD(s, -1, DATEADD(mm, DATEDIFF(m, 0, DATEADD(MONTH, 1, @PreviousTwoMonthsStart)) + 1, 0))


/********************************** Create Temp Table Objects *************************************/


CREATE TABLE #Centers (
	CenterSSID INT
,	CenterDescriptionNumber VARCHAR(255)
,	CenterDescription VARCHAR(255)
,	CenterTypeDescriptionShort VARCHAR(10)
)



CREATE TABLE #Comparison (
	CenterSSID INT
,	CenterDescription VARCHAR(50)
,	CenterDescriptionNumber VARCHAR(255)
,	CenterTypeDescriptionShort VARCHAR(10)
,	ClientIdentifier INT
,	GenderSSID INT
,	Client VARCHAR(250)
,	ClientLastName VARCHAR(250)
,	ClientFirstName VARCHAR(250)
,	MembershipSSID INT
,	MembershipDescription VARCHAR(50)
,	ClientMembershipBeginDate DATETIME
,	ClientMembershipEndDate DATETIME
,	CurrentRate DECIMAL(18,2)
,	NationalRate DECIMAL(18,2)
,	AvgEFT DECIMAL(18,2)
,	DeferredBalance DECIMAL(18,2)
,	TransactionDate DATETIME
)


CREATE TABLE #ComparisonFinal (
	CenterSSID INT
,	CenterDescription VARCHAR(50)
,	CenterDescriptionNumber VARCHAR(255)
,	CenterTypeDescriptionShort VARCHAR(10)
,	ClientIdentifier INT
,	GenderSSID INT
,	Client VARCHAR(250)
,	ClientLastName VARCHAR(250)
,	ClientFirstName VARCHAR(250)
,	MembershipSSID INT
,	MembershipDescription VARCHAR(50)
,	ClientMembershipBeginDate DATETIME
,	ClientMembershipEndDate DATETIME
,	CurrentRate DECIMAL(18,2)
,	NationalRate DECIMAL(18,2)
,	[Difference] DECIMAL(18,2)
,	AvgEFT DECIMAL(18,2)
,	DeferredBalance DECIMAL(18,2)
,	TransactionDate DATETIME
)


CREATE TABLE #National (
	CenterSSID INT
,	CenterDescription VARCHAR(100)
,	Client VARCHAR(250)
,	ClientIdentifier INT
,	MembershipSSID INT
,	MembershipDescription VARCHAR(100)
,	ClientMembershipBeginDate DATETIME
,	ClientMembershipEndDate DATETIME
,	CurrentRate DECIMAL(18,2)
,	NationalRate DECIMAL(18,2)
,	[Difference] DECIMAL(18,2)
,	TransactionDate DATETIME
)


CREATE TABLE #Final(
	CenterSSID INT
,	CenterDescription VARCHAR(50)
,	Client VARCHAR(250)
,	ClientIdentifier INT
,	MembershipSSID INT
,	MembershipDescription VARCHAR(100)
,	ClientMembershipBeginDate DATETIME
,	ClientMembershipEndDate DATETIME
,	CurrentRate DECIMAL(18,2)
,	NationalRate DECIMAL(18,2)
,	[Difference] DECIMAL(18,2)
,	TransactionDate DATETIME
,	TotalContractPrice DECIMAL(18,2)
,	TotalPayments DECIMAL(18,2)
,	Difference2 DECIMAL(18,2)
,	DaysRemaining INT
)


/********************************** Get List of Centers *************************************/
INSERT  INTO #Centers
SELECT  DC.CenterSSID
,		DC.CenterDescriptionNumber
,		DC.CenterDescription
,		DCT.CenterTypeDescriptionShort
FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
			ON DC.CenterTypeKey = DCT.CenterTypeKey
WHERE   CONVERT(VARCHAR, DC.CenterSSID) = @Center
		AND DC.Active = 'Y'


/********************************** Get Report Data  ************************************************/
INSERT  INTO #Comparison
SELECT	C.CenterSSID
,		C.CenterDescription
,		C.CenterDescriptionNumber
,		C.CenterTypeDescriptionShort
,		CLT.ClientIdentifier
,		CLT.GenderSSID
,       CLT.ClientFullName + ' (' + CAST(CLT.ClientIdentifier  AS NVARCHAR) + ')' AS 'Client'
,		CLT.ClientLastName
,		CLT.ClientFirstName
,		DCM.MembershipSSID
,		DM.MembershipDescription
,		DCM.ClientMembershipBeginDate
,		DCM.ClientMembershipEndDate
,		ROUND(DCM.ClientMembershipMonthlyFee, 2) AS 'CurrentRate'
,		nrates.MembershipRate AS 'NationalRate'
,		0 AS 'AvgEFT'
,		ISNULL(FDRH.Deferred, 0) AS 'DeferredBalance'
,		CONVERT(VARCHAR(30),TransactionDate,101) AS 'TransactionDate'
FROM SQL05.HairClubCMS.dbo.datClientEFT DCE
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON DCE.ClientGUID = CLT.ClientSSID
		INNER JOIN #Centers C
			ON CLT.CenterSSID = C.CenterSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
			ON DCE.ClientMembershipGUID = DCM.ClientMembershipSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
			ON DCM.MembershipKey = DM.MembershipKey
		LEFT OUTER JOIN HC_DeferredRevenue_DAILY.dbo.FactDeferredRevenueHeader FDRH
			ON DCM.ClientMembershipKey = FDRH.ClientMembershipKey
		LEFT OUTER JOIN
						(SELECT NR.CenterSSID
							, NR.MembershipKey
							, NR.MembershipRate
							, ROW_NUMBER()OVER(PARTITION BY  NR.CenterSSID, NR.MembershipKey ORDER BY NR.MembershipRate DESC) AS 'Rank'
						FROM HC_DeferredRevenue_DAILY.dbo.DimMembershipRatesByCenter NR
						INNER JOIN #Centers C
							ON C.CenterSSID = NR.CenterSSID
						) nrates
					ON CLT.CenterSSID = nrates.CenterSSID AND nrates.MembershipKey = DM.MembershipKey AND nrates.[Rank] = 1
		LEFT OUTER JOIN
				(SELECT CT.ClientGUID
					, CT.TransactionDate
					, CT.MonthlyFeeAmount
					, ROW_NUMBER()OVER(PARTITION BY CT.ClientGUID ORDER BY CT.TransactionDate DESC) AS 'Ranking'
				FROM [dbo].[synHairclubCMS_datClientTransaction] CT
				WHERE CT.ClientProcessID = 8
					AND TransactionDate >= @MonthStart) trans
			ON DCE.ClientGUID = trans.ClientGUID AND trans.Ranking = 1
WHERE	DCM.ClientMembershipEndDate >= @MonthStart
		AND DCM.ClientMembershipBeginDate BETWEEN @MemBeginDate AND @MemEndDate
		AND DM.RevenueGroupSSID = 2




--Reset to NULL - values where the MembershipStartDate is greater than or equal to the TransactionDate (Monthly Fee Adjustment Date)

UPDATE #Comparison
SET TransactionDate = NULL
FROM #Comparison
WHERE #Comparison.ClientMembershipBeginDate >= #Comparison.TransactionDate


/********************************** Filter Report Data Based on MembershipID *************************************/
IF @MembershipID = 0
BEGIN
INSERT  INTO #ComparisonFinal
    SELECT  C.CenterSSID
    ,		C.CenterDescription
    ,		C.CenterDescriptionNumber
    ,		C.CenterTypeDescriptionShort
    ,		C.ClientIdentifier
	,		C.GenderSSID
    ,		C.Client
    ,		C.ClientLastName
    ,		C.ClientFirstName
    ,		C.MembershipSSID
    ,		C.MembershipDescription
    ,		C.ClientMembershipBeginDate
    ,		C.ClientMembershipEndDate
    ,		C.CurrentRate
    ,		C.NationalRate
    ,		(C.CurrentRate -  C.NationalRate) AS 'Difference'
    ,		C.AvgEFT
    ,		C.DeferredBalance
    ,		C.TransactionDate
    FROM    #Comparison C
END
ELSE
BEGIN
INSERT  INTO #ComparisonFinal
    SELECT  C.CenterSSID
    ,		C.CenterDescription
    ,		C.CenterDescriptionNumber
    ,		C.CenterTypeDescriptionShort
    ,		C.ClientIdentifier
	,		C.GenderSSID
    ,		C.Client
    ,		C.ClientLastName
    ,		C.ClientFirstName
    ,		C.MembershipSSID
    ,		C.MembershipDescription
    ,		C.ClientMembershipBeginDate
    ,		C.ClientMembershipEndDate
    ,		C.CurrentRate
    ,		C.NationalRate
	,		(C.CurrentRate -  C.NationalRate) AS 'Difference'
    ,		C.AvgEFT
    ,		C.DeferredBalance
    ,		C.TransactionDate
    FROM    #Comparison C
	WHERE	C.MembershipSSID = @MembershipID
END




/************************************Populate #Final **************************************************/

IF @Filter = 0 --ALL
BEGIN
INSERT INTO #National
    SELECT	C.CenterSSID
    ,		C.CenterDescriptionNumber
    ,		C.Client
	,		C.ClientIdentifier
    ,		C.MembershipSSID
	,		C.MembershipDescription
    ,		C.ClientMembershipBeginDate
    ,		C.ClientMembershipEndDate
    ,		C.CurrentRate
    ,		C.NationalRate
	,		C.[Difference]
	,		C.TransactionDate
    FROM	#ComparisonFinal C
    WHERE	( C.CurrentRate < C.NationalRate
				OR C.CurrentRate > C.NationalRate )
END

IF	@Filter = 1 --Less than
BEGIN
INSERT INTO #National
    SELECT  C.CenterSSID
    ,       C.CenterDescription
    ,       C.Client
	,		C.ClientIdentifier
    ,		C.MembershipSSID
	,       C.MembershipDescription
    ,       C.ClientMembershipBeginDate
    ,       C.ClientMembershipEndDate
    ,       C.CurrentRate
    ,       C.NationalRate
	,		C.[Difference]
	,		C.TransactionDate
    FROM    #ComparisonFinal C
    WHERE   C.CurrentRate < C.NationalRate
END

IF	@Filter = 2 --Greater than
BEGIN
INSERT INTO #National
    SELECT	C.CenterSSID
    ,       C.CenterDescription
    ,       C.Client
	,		C.ClientIdentifier
    ,		C.MembershipSSID
	,       C.MembershipDescription
    ,       C.ClientMembershipBeginDate
    ,       C.ClientMembershipEndDate
    ,       C.CurrentRate
    ,       C.NationalRate
    ,		C.[Difference]
	,		C.TransactionDate
    FROM    #ComparisonFinal C
    WHERE   C.CurrentRate > C.NationalRate
END


INSERT INTO #Final
SELECT NAT.CenterSSID
,       NAT.CenterDescription
,       NAT.Client
,		NAT.ClientIdentifier
,       NAT.MembershipSSID
,       NAT.MembershipDescription
,       NAT.ClientMembershipBeginDate
,       NAT.ClientMembershipEndDate
,       NAT.CurrentRate
,       NAT.NationalRate
,       NAT.[Difference]
,       NAT.TransactionDate
,	(dCLT.BIO_ContractPrice + dCLT.EXT_ContractPrice+ dCLT.SUR_ContractPrice+ dCLT.XTR_ContractPrice) AS TotalContractPrice
,	(dCLT.BIO_TotalPayments + dCLT.EXT_TotalPayments+ dCLT.SUR_TotalPayments+ dCLT.XTR_TotalPayments) AS TotalPayments
,	(dCLT.BIO_ContractPrice + dCLT.EXT_ContractPrice+ dCLT.SUR_ContractPrice+ dCLT.XTR_ContractPrice) - (dCLT.BIO_TotalPayments + dCLT.EXT_TotalPayments+ dCLT.SUR_TotalPayments+ dCLT.XTR_TotalPayments) AS [Difference2]
,	DATEDIFF(DAY,GETDATE(),NAT.ClientMembershipEndDate) AS DaysRemaining
FROM #National NAT
	INNER JOIN HC_ACcounting.dbo.dbaClient dCLT
		ON dCLT.ClientIdentifier = NAT.ClientIdentifier


SELECT *
FROM #Final
WHERE ABS(Difference2) > 20  --Remove records with less than $20 difference


END
GO
