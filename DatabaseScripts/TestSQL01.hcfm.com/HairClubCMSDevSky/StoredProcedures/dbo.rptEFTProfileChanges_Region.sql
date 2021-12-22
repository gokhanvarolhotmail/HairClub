/* CreateDate: 05/25/2017 16:57:17.877 , ModifyDate: 02/12/2018 09:59:08.050 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
-- Procedure Name:				rptEFTProfileChanges_Region
-- Created By:					Rachelen Hut
-- Date Created:				12/20/13
--
-- Destination Server:			SQL01
-- Destination Database:		Hairclub CMS
================================================================================================
**NOTES**

================================================================================================
CHANGE HISTORY:
06/01/2017 - RH - Added Is CC on File (#139551); Added WHEN CT.ClientProcessID = 10, CT.PreviousBankAccountNumber and CT.BankAccountNumber
06/13/2017 - RH - Added WHEN CT.ClientProcessID = 9, CT.PreviousFeeFreezeReasonDescription and CT.FeeFreezeReasonDescription (#140082)
================================================================================================
Sample Execution:

EXEC rptEFTProfileChanges_Region '1/1/2018','2/8/2018', 'C', '1,2,3,4,5,6,7,8,9,10'

EXEC rptEFTProfileChanges_Region '1/1/2018','2/8/2018', 'F', '1,2,3,4,5,6,7,8,9,10'
================================================================================================*/
CREATE PROCEDURE [dbo].[rptEFTProfileChanges_Region]
	@StartDate DATETIME
,	@EndDate DATETIME
,	@CenterType VARCHAR(1)
,	@ClientProcessID NVARCHAR(50)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


/*********************************************** Create temp table objects *************************************/
CREATE TABLE #Process(ClientProcessID INT)

CREATE TABLE #Centers (
	CenterID INT
,	CenterDescriptionFullCalc VARCHAR(50)
,	RegionDescription VARCHAR(50)
,	RegionID INT
,	RegionSortOrder INT
,	CenterManagementAreaID INT
,	CenterManagementAreaDescription VARCHAR(50)
,	CenterManagementAreaSortOrder INT
)

CREATE TABLE #Changes(RegionID INT
,	RegionDescription NVARCHAR(50)
,	RegionSortOrder INT
,	CenterManagementAreaID INT
,	CenterManagementAreaDescription NVARCHAR(50)
,	CenterManagementAreaSortOrder INT
,	CenterID INT
,	CenterDescriptionFullCalc NVARCHAR(104)
,	ClientIdentifier INT
,	ClientGUID NVARCHAR(50)
,	ClientFullNameCalc NVARCHAR(150)
,	ClientMembershipGUID NVARCHAR(50)
,	TransactionDate DATETIME
,	ClientProcessID INT
,	ClientProcessDescription  NVARCHAR(150)
,	BeginningValue NVARCHAR(150)
,	EndingValue NVARCHAR(150)
,	EnteredBy NVARCHAR(50)
)


/*********************************************** Get list of processes *************************************/
INSERT  INTO #Process
        SELECT  item
        FROM    dbo.fnSplit(@ClientProcessID, ',')


/*********************************************** Get list of centers *************************************/
IF @CenterType = 'C'
BEGIN
    INSERT  INTO #Centers
            SELECT  ctr.CenterID
            ,       ctr.CenterDescriptionFullCalc
            ,       lr.RegionDescription
            ,       lr.RegionID
            ,       lr.RegionSortOrder
            ,       cma.CenterManagementAreaID
            ,       cma.CenterManagementAreaDescription
            ,       cma.CenterManagementAreaSortOrder
            FROM    cfgCenter ctr
					INNER JOIN lkpCenterType ct
						ON ct.CenterTypeID = ctr.CenterTypeID
                    INNER JOIN dbo.lkpRegion lr
                        ON lr.RegionID = ctr.RegionID
                    INNER JOIN dbo.cfgCenterManagementArea cma
                        ON cma.CenterManagementAreaID = ctr.CenterManagementAreaID
            WHERE   ct.CenterTypeDescriptionShort = 'C'
                    AND ctr.IsActiveFlag = 1
END


IF @CenterType = 'F'
BEGIN
    INSERT  INTO #Centers
            SELECT  ctr.CenterID
            ,       ctr.CenterDescriptionFullCalc
            ,       lr.RegionDescription
            ,       lr.RegionID
            ,       lr.RegionSortOrder
            ,       NULL AS 'CenterManagementAreaID'
            ,       NULL AS 'CenterManagementAreaDescription'
            ,       NULL AS 'CenterManagementAreaSortOrder'
            FROM    cfgCenter ctr
					INNER JOIN lkpCenterType ct
						ON ct.CenterTypeID = ctr.CenterTypeID
                    INNER JOIN dbo.lkpRegion lr
                        ON lr.RegionID = ctr.RegionID
            WHERE   ct.CenterTypeDescriptionShort IN ( 'JV', 'F' )
                    AND ctr.IsActiveFlag = 1
END


/*********************************************** Get Data ***********************************************/
INSERT  INTO #Changes
        SELECT  CTR.RegionID
        ,       CTR.RegionDescription
        ,       CTR.RegionSortOrder
        ,       CTR.CenterManagementAreaID
        ,       CTR.CenterManagementAreaDescription
        ,       CTR.CenterManagementAreaSortOrder
        ,       CTR.CenterID
        ,       CTR.CenterDescriptionFullCalc
        ,       CLT.ClientIdentifier
        ,       CLT.ClientGUID
        ,       CLT.ClientFullNameCalc
        ,       CM.ClientMembershipGUID
        ,       CT.TransactionDate
        ,       #Process.ClientProcessID
        ,       CP.ClientProcessDescription
        ,       CASE WHEN CT.ClientProcessID = 1
                     THEN CONVERT(NVARCHAR, CT.PreviousEFTFreezeStartDate, 101)
                     WHEN CT.ClientProcessID = 2
                     THEN CONVERT(NVARCHAR, CT.PreviousEFTFreezeEndDate, 101)
                     WHEN CT.ClientProcessID = 3
                     THEN CONVERT(NVARCHAR, CT.PreviousEFTHoldEndDate, 101)
                     WHEN CT.ClientProcessID = 4
                     THEN CONVERT(NVARCHAR, CT.PreviousEFTHoldStartDate, 101)
                     WHEN CT.ClientProcessID = 5
                     THEN CONVERT(NVARCHAR, CT.PreviousCCNumber)
                     WHEN CT.ClientProcessID = 6
                     THEN CONVERT(NVARCHAR, CT.PreviousCCExpirationDate, 101)
                     WHEN CT.ClientProcessID = 7
                     THEN CONVERT(NVARCHAR, FPC1.FeePayCycleDescription)
                     WHEN CT.ClientProcessID = 8
                     THEN CONVERT(NVARCHAR, CT.PreviousMonthlyFeeAmount, 101)
                     WHEN CT.ClientProcessID = 9
                     THEN CT.PreviousFeeFreezeReasonDescription
                     WHEN CT.ClientProcessID = 10
                     THEN CONVERT(NVARCHAR, CT.PreviousBankAccountNumber)
                END AS 'BeginningValue'
        ,       CASE WHEN CT.ClientProcessID = 1
                     THEN CONVERT(NVARCHAR, CT.EFTFreezeStartDate, 101)
                     WHEN CT.ClientProcessID = 2
                     THEN CONVERT(NVARCHAR, CT.EFTFreezeEndDate, 101)
                     WHEN CT.ClientProcessID = 3
                     THEN CONVERT(NVARCHAR, CT.EFTHoldEndDate, 101)
                     WHEN CT.ClientProcessID = 4
                     THEN CONVERT(NVARCHAR, CT.EFTHoldStartDate, 101)
                     WHEN CT.ClientProcessID = 5
                     THEN CONVERT(NVARCHAR, CT.CCNumber)
                     WHEN CT.ClientProcessID = 6
                     THEN CONVERT(NVARCHAR, CT.CCExpirationDate, 101)
                     WHEN CT.ClientProcessID = 7
                     THEN CONVERT(NVARCHAR, FPC2.FeePayCycleDescription)
                     WHEN CT.ClientProcessID = 8
                     THEN CONVERT(NVARCHAR, CT.MonthlyFeeAmount)
                     WHEN CT.ClientProcessID = 9
                     THEN CT.FeeFreezeReasonDescription
                     WHEN CT.ClientProcessID = 10
                     THEN CONVERT(NVARCHAR, CT.BankAccountNumber)
                END AS 'EndingValue'
        ,       CT.CreateUser AS 'EnteredBy'
        FROM    datClientTransaction CT
				INNER JOIN #Process p
					ON p.ClientProcessID = CT.ClientProcessID
                INNER JOIN datClient CLT
                    ON CT.ClientGUID = CLT.ClientGUID
                INNER JOIN cfgCenter C
                    ON CLT.CenterID = C.CenterID
                INNER JOIN #Centers CTR
                    ON CLT.CenterID = CTR.CenterID
                INNER JOIN dbo.datClientMembership CM
                    ON ( CLT.CurrentBioMatrixClientMembershipGUID = CM.ClientMembershipGUID
                         OR CLT.CurrentExtremeTherapyClientMembershipGUID = CM.ClientMembershipGUID
                         OR CLT.CurrentSurgeryClientMembershipGUID = CM.ClientMembershipGUID
                         OR CLT.CurrentXtrandsClientMembershipGUID = CM.ClientMembershipGUID )
                INNER JOIN #Process
                    ON CT.ClientProcessID = #Process.ClientProcessID
                INNER JOIN lkpClientProcess CP
                    ON #Process.ClientProcessID = CP.ClientProcessID
                LEFT OUTER JOIN lkpFeePayCycle FPC1
                    ON CT.PreviousFeePayCycleId = FPC1.FeePayCycleID
                LEFT OUTER JOIN lkpFeePayCycle FPC2
                    ON CT.FeePayCycleId = FPC2.FeePayCycleID
        WHERE   CT.TransactionDate BETWEEN @StartDate AND @EndDate


/*********************************************** Find Distinct Client Identifiers ***********************************************/
SELECT  ClientIdentifier
,       ClientGUID
,       NULL AS 'CreditCardOnFile'
INTO    #Clients
FROM    #Changes
GROUP BY ClientIdentifier
,       ClientGUID


/*********************************************** Do these ClientGUID's have a CC on file? ***********************************************/
SELECT  cl.ClientGUID
,       cc.ClientCreditCardID
,       cc.AccountExpiration
,       1 AS 'CreditCardOnFile'
INTO    #CC
FROM    #Clients cl
        INNER JOIN datClientCreditCard cc
            ON cc.ClientGUID = cl.ClientGUID
		INNER JOIN #Changes c
			ON c.ClientGUID = cc.ClientGUID
WHERE   CC.AccountExpiration > GETDATE()
GROUP BY cl.ClientGUID
,       cc.ClientCreditCardID
,       cc.AccountExpiration


/*********************************************** Find monthly fees ***********************************************/
SELECT  tz.TimeZoneID
,       tz.UTCOffset
,       tz.UsesDayLightSavingsFlag
,       tz.IsActiveFlag
,       dbo.GetUTCFromLocal(@StartDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) AS 'UTCStartDate'
,       dbo.GetUTCFromLocal(DATEADD(SECOND, 86399, @EndDate), tz.UTCOffset, tz.UsesDayLightSavingsFlag) AS 'UTCEndDate'
INTO    #UTCDates
FROM    lkpTimeZone tz
WHERE   tz.IsActiveFlag = 1


SELECT  clt.ClientGUID
,		clt.ClientIdentifier
,       clt.ClientFullNameCalc AS 'ClientName'
,       SUM(sod.ExtendedPriceCalc) AS 'TenderAmount'
INTO	#TenderAmt
FROM    datSalesOrderDetail sod
        INNER JOIN datSalesOrder so
            ON so.SalesOrderGUID = sod.SalesOrderGUID
        INNER JOIN cfgSalesCode sc
            ON sc.SalesCodeID = sod.SalesCodeID
        INNER JOIN lkpSalesCodeDepartment dep
            ON dep.SalesCodeDepartmentID = sc.SalesCodeDepartmentID
        INNER JOIN lkpSalesCodeDivision div
            ON div.SalesCodeDivisionID = dep.SalesCodeDivisionID
        INNER JOIN cfgCenter ctr
            ON ctr.CenterID = so.CenterID
        INNER JOIN lkpTimeZone tz
            ON tz.TimeZoneID = ctr.TimeZoneID
		JOIN #UTCDates u
			ON u.TimeZoneID = tz.TimeZoneID
        INNER JOIN datClient clt
            ON clt.ClientGUID = so.ClientGUID
		INNER JOIN #Clients c
			ON c.ClientGUID = clt.ClientGUID
        INNER JOIN datClientMembership cm
            ON cm.ClientMembershipGUID = so.ClientMembershipGUID
        INNER JOIN cfgMembership m
            ON m.MembershipID = cm.MembershipID
WHERE   so.OrderDate BETWEEN u.UTCStartDate AND u.UTCEndDate
		AND div.SalesCodeDivisionID = 20 -- Membership Revenue
		AND m.RevenueGroupID = 2 -- Recurring Business
        AND so.IsVoidedFlag = 0
GROUP BY clt.ClientGUID
,		clt.ClientIdentifier
,       clt.ClientFullNameCalc


/*********************************************** Display Results ***********************************************/
SELECT  c.RegionID
,       c.RegionDescription
,       c.RegionSortOrder
,       c.CenterManagementAreaID
,       c.CenterManagementAreaDescription
,       c.CenterManagementAreaSortOrder
,       c.CenterID
,       c.CenterDescriptionFullCalc
,       c.ClientIdentifier
,       c.ClientFullNameCalc
,		m.MembershipDescription AS 'Membership'
,		dcm.MonthlyFee
,       c.TransactionDate
,       c.ClientProcessID
,       c.ClientProcessDescription
,       c.BeginningValue
,       c.EndingValue
,       c.EnteredBy
,       ISNULL(t.TenderAmount, 0) AS 'TenderAmount'
,       ISNULL(cc.CreditCardOnFile, 0) AS 'CreditCardOnFile'
FROM    #Changes c
		INNER JOIN datClientMembership dcm
			ON dcm.ClientMembershipGUID = c.ClientMembershipGUID
		INNER JOIN cfgMembership m
			ON m.MembershipID = dcm.MembershipID
        LEFT JOIN #TenderAmt t
            ON t.ClientGUID = c.ClientGUID
        LEFT JOIN #CC cc
            ON cc.ClientGUID = c.ClientGUID

END
GO
