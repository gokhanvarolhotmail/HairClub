/* CreateDate: 05/20/2019 10:57:13.383 , ModifyDate: 05/20/2019 10:57:13.383 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spRpt_FlashNewBusinessDetailsReceivables
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			NB1 Flash Details
AUTHOR:					Marlon Burrell
IMPLEMENTOR:			Marlon Burrell
DATE IMPLEMENTED:
------------------------------------------------------------------------
NOTES:

01/04/2013 - KM - Modified Join to include CurrentEXTClientMemberships
03/27/2013 - KM - Modified output to get Last trx and appt dates
04/12/2013 - KM - Modified to derive FactReceivables from HC_Accounting
10/08/2013 - DL - (#89184) Added Group By Region/RSM filter
10/15/2013 - DL - (#89184) Added @Filter procedure parameter
10/15/2013 - DL - (#89184) Added additional RSM roll-up filters
04/07/2014 - RH - (#100145) Changed WHERE DR.RegionSSID = @CenterSSID to WHERE DC.RegionSSID = @CenterSSID (under Region code for #Center)
06/13/2014 - RH - (WO#102725) Added AND MembershipDescriptionShort NOT IN('POSTEXT','1STSURG','ADDSURG','SHOWNOSALE')for the receivables.
05/26/2015 - DL - Limited query to recurring business memberships only
06/02/2015 - RH - (#115423) Added CurrentXtrandsClientMembershipSSID to the join on DimClientMembership
07/01/2015 - RH - (#116390) Found the AR Balance and FR.Balance separately to remove multiples
01/04/2016 - RH - (#120705) Changed groupings to include by Area Managers and by Centers; (Franchise is only by Region)
01/05/2017 - RH - (#132688) Changed EmployeeKey to CenterManagementAreaSSID; Changed logic for Area Managers
01/24/2018 - RH - (#145957) Added join on CenterType, removed Corporate Regions, added CenterNumber, added @sType
05/20/2019 - JL - (Case 4824) Added drill down to report

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_FlashNewBusinessDetailsReceivables] 2, '01/07/2017', 2
EXEC [spRpt_FlashNewBusinessDetailsReceivables] 804, '01/07/2017', 3

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_FlashNewBusinessDetailsReceivables]
(
	@sType CHAR(1)
,	@MainGroupID INT
,	@EndDate DATETIME
,	@Filter INT
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroupDescription NVARCHAR(60)
,	CenterID INT
,	CenterNumber INT
,	CenterDescriptionNumber NVARCHAR(103)
)

CREATE TABLE #Receivables(
	Center INT
     , Center_Name NVARCHAR(50)
     , CenterManagementAreaSSID INT
     , Region NVARCHAR(50)
     , Client_No INT
     , ClientKey INT
     , Last_Name NVARCHAR(50)
     , First_Name NVARCHAR(50)
     , Member1 NVARCHAR(50)
     , ClientMembershipKey INT
     , Monthly_Fee MONEY
     , Billing_Day DATETIME
     , Balance MONEY
     , Ending_Balance MONEY
	 , NB_ARBalance MONEY
     , Last_Transact DATETIME
     , Last_Appointment DATETIME
     , Next_Appointment DATETIME
     , Ranking INT
)

/********************************** Get list of centers *************************************/
IF (@sType = 'C' AND @Filter = 0)											--All Corporate
BEGIN
	INSERT INTO #Centers
		SELECT  CMA.CenterManagementAreaSSID AS 'MainGroupID'
		,		CMA.CenterManagementAreaDescription AS 'MainGroupDescripton'
		,		DC.CenterSSID
		,		DC.CenterNumber
		,		DC.CenterDescriptionNumber
		FROM   HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
					ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
		WHERE   CMA.Active = 'Y'
				AND DC.Active = 'Y'
				AND CT.CenterTypeDescriptionShort = 'C'
END
ELSE
IF (@sType = 'F' AND @Filter = 0)											--All Franchise
BEGIN
	INSERT INTO #Centers
		SELECT  DR.RegionSSID AS 'MainGroupID'
		,		DR.RegionDescription AS 'MainGroupDescripton'
		,		DC.CenterSSID
		,		DC.CenterNumber
		,		DC.CenterDescriptionNumber
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionSSID = DR.RegionSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
		WHERE   DC.Active = 'Y'
				AND CT.CenterTypeDescriptionShort IN ('F','JV')
END
ELSE
IF (@sType = 'F' AND @Filter = 1)										-- A Franchise Region has been selected.
	BEGIN
		INSERT INTO #Centers
		SELECT  DR.RegionSSID AS 'MainGroupID'
		,		DR.RegionDescription AS 'MainGroupDescripton'
		,		DC.CenterSSID
		,		DC.CenterNumber
		,		DC.CenterDescriptionNumber
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionSSID = DR.RegionSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
		WHERE   DC.RegionSSID = @MainGroupID
				AND DC.Active = 'Y'
				AND CT.CenterTypeDescriptionShort IN ('F','JV')
	END
ELSE
	IF (@sType = 'C' AND @Filter = 2)									-- An Area Manager has been selected
	BEGIN
		INSERT INTO #Centers
		SELECT CMA.CenterManagementAreaSSID AS 'MainGroupID'
		,		CMA.CenterManagementAreaDescription AS 'MainGroupDescripton'
		,		DC.CenterSSID
		,		DC.CenterNumber
		,		DC.CenterDescriptionNumber
		FROM   HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
					ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
		WHERE   CMA.CenterManagementAreaSSID = @MainGroupID
				AND CMA.Active = 'Y'
				AND DC.Active = 'Y'
				AND CT.CenterTypeDescriptionShort = 'C'
	END
ELSE
IF (@sType = 'C' AND @Filter = 3)										-- A Corporate Center has been selected.
	BEGIN
		INSERT INTO #Centers
		SELECT DC.CenterNumber AS 'MainGroupID'
		,		DC.CenterDescriptionNumber AS 'MainGroupDescripton'
		,		DC.CenterSSID
		,		DC.CenterNumber
		,		DC.CenterDescriptionNumber
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
		WHERE   DC.CenterSSID = @MainGroupID
				AND DC.Active = 'Y'
				AND CT.CenterTypeDescriptionShort = 'C'

	END
ELSE
IF (@sType = 'F' AND @Filter = 3)										-- A Franchise Center has been selected.
	BEGIN
		INSERT INTO #Centers
		SELECT  DR.RegionSSID AS 'MainGroupID'
		,		DR.RegionDescription AS 'MainGroupDescripton'
		,		DC.CenterSSID
		,		DC.CenterNumber
		,		DC.CenterDescriptionNumber
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionSSID = DR.RegionSSID
		WHERE   DC.CenterSSID = @MainGroupID
				AND DC.Active = 'Y'
				AND CT.CenterTypeDescriptionShort IN('F','JV')

	END
/******************************************************************************************/

--
-- Determine Last Transaction Date
--
SELECT  DSO.ClientKey
,       DSO.ClientMembershipKey
,       MAX(DSO.OrderDate) AS 'Last_Transact'
INTO    #LastTRX
FROM    HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
        INNER JOIN #Centers C
            ON DSO.CenterSSID = C.CenterID
GROUP BY DSO.ClientKey
,       DSO.ClientMembershipKey


--
-- Determine Last Appointment Date
--
SELECT  DA.ClientKey
,       DA.ClientMembershipKey
,       MAX(DA.Appointmentdate) AS 'Last_Appointment'
INTO    #LastAppt
FROM    HC_BI_CMS_DDS.bi_cms_dds.DimAppointment DA
        INNER JOIN #Centers C
            ON DA.CenterSSID = C.CenterID
WHERE   DA.AppointmentDate < GETDATE()
GROUP BY DA.ClientKey
,       DA.ClientMembershipKey


--
-- Determine Last Appointment Date
--
SELECT  DA.ClientKey
,       DA.ClientMembershipKey
,       MIN(Appointmentdate) AS 'Next_Appointment'
INTO    #NextAppt
FROM    HC_BI_CMS_DDS.bi_cms_dds.DimAppointment DA
        INNER JOIN #Centers C
            ON DA.CenterSSID = C.CenterID
WHERE   DA.AppointmentDate > GETDATE()
GROUP BY DA.ClientKey
,       DA.ClientMembershipKey



INSERT INTO #Receivables
SELECT  C.ReportingCenterSSID AS 'Center'
,       C.CenterDescription AS 'Center_Name'
,       #Centers.CenterManagementAreaSSID
,       #Centers.CenterManagementAreaDescription
,       CLT.ClientIdentifier AS 'Client_No'
,		CLT.ClientKey
,       CLT.ClientLastName AS 'Last_Name'
,       CLT.ClientFirstName AS 'First_Name'
,       M.MembershipDescription AS 'Member1'
,       CM.ClientMembershipKey
,       CM.ClientMembershipMonthlyFee AS 'Monthly_Fee'
,       NULL AS 'Billing_Day'
,		'0.00' AS 'Balance'
,		'0.00' AS 'Ending_Balance'
,		'0.00' AS 'NB_ARBalance'
,       CMA_LastTransact.Last_Transact AS 'Last_Transact'
,       CMA_LastAppt.Last_Appointment AS 'Last_Appointment'
,       CMA_NextAppt.Next_Appointment AS 'Next_Appointment'
,		ROW_NUMBER()OVER(PARTITION BY CLT.ClientIdentifier ORDER BY CM.ClientMembershipEndDate DESC) AS Ranking
FROM    HC_Accounting.dbo.FactReceivables FR
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FR.DateKey = DD.DateKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
            ON FR.ClientKey = CLT.ClientKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
            ON FR.CenterKey = C.CenterKey
		INNER JOIN #Centers
            ON C.ReportingCenterSSID = #Centers.CenterID
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
			ON( CLT.CurrentBioMatrixClientMembershipSSID = CM.ClientMembershipSSID
						OR CLT.CurrentExtremeTherapyClientMembershipSSID = CM.ClientMembershipSSID
						OR CLT.CurrentXtrandsClientMembershipSSID = CM.ClientMembershipSSID )
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
            ON CM.MembershipSSID = M.MembershipSSID
        LEFT OUTER JOIN #LastTRX CMA_LastTransact
            ON CM.ClientMembershipKey = CMA_LastTransact.ClientMembershipKey
        LEFT OUTER JOIN #LastAppt CMA_LastAppt
            ON CM.ClientMembershipKey = CMA_LastAppt.ClientMembershipKey
        LEFT OUTER JOIN #NextAppt CMA_NextAppt
            ON CM.ClientMembershipKey = CMA_NextAppt.ClientMembershipKey
WHERE   DD.FullDate = @EndDate
		AND M.RevenueGroupSSID = 2

--
-- Find the AR Balance
--
SELECT  CLT.ClientKey
	,	CLT.ClientARBalance AS 'Balance'
INTO    #AR
FROM    HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
        INNER JOIN #Centers C
            ON CLT.CenterSSID = C.CenterID
WHERE CLT.ClientARBalance <> 0


--
-- Find the New Business AR Balance
--
SELECT  CLT.ClientKey
	,	CLT.ClientARBalance AS 'NB_ARBalance'
INTO    #NB_ARBalance
FROM    #Receivables REC
        INNER JOIN #Centers C
            ON REC.Center = C.CenterID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON REC.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
			ON( CLT.CurrentBioMatrixClientMembershipSSID = CM.ClientMembershipSSID
						OR CLT.CurrentExtremeTherapyClientMembershipSSID = CM.ClientMembershipSSID
						OR CLT.CurrentXtrandsClientMembershipSSID = CM.ClientMembershipSSID )
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON CM.MembershipKey = M.MembershipKey
WHERE CLT.ClientARBalance <> 0
		AND M.RevenueGroupDescription  = 'New Business'
		AND CLT.ClientARBalance <> 0



--
-- Determine the MAX Balance
--
SELECT  CLT.ClientKey
,       MAX(FR.Balance) AS 'Ending_Balance'
INTO    #Balance
FROM    HC_Accounting.dbo.FactReceivables FR
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FR.DateKey = DD.DateKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
            ON FR.ClientKey = CLT.ClientKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
            ON FR.CenterKey = C.CenterKey
		INNER JOIN #Centers
            ON C.ReportingCenterSSID = #Centers.CenterID
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
            ON C.RegionKey = R.RegionKey
WHERE DD.FullDate = @EndDate
        AND FR.Balance <> 0
GROUP BY CLT.ClientKey


UPDATE #Receivables
SET #Receivables.Balance = #AR.Balance
FROM #Receivables, #AR
WHERE #Receivables.ClientKey = #AR.ClientKey
	AND #Receivables.Ranking = 1

UPDATE #Receivables
SET #Receivables.Ending_Balance = #Balance.Ending_Balance
FROM #Receivables, #Balance
WHERE #Receivables.ClientKey = #Balance.ClientKey
	AND #Receivables.Ranking = 1

UPDATE #Receivables
SET #Receivables.NB_ARBalance = #NB_ARBalance.NB_ARBalance
FROM #Receivables, #NB_ARBalance
WHERE #Receivables.ClientKey = #NB_ARBalance.ClientKey
	AND #Receivables.Ranking = 1

SELECT * FROM #Receivables


END
GO
