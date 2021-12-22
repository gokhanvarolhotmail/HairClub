/* CreateDate: 07/07/2015 12:17:54.183 , ModifyDate: 05/10/2019 17:51:17.210 */
GO
/***********************************************************************
PROCEDURE:				spRpt_FlashRecurringBusinessDetailsReceivables
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			NB1 Flash Details
AUTHOR:					Marlon Burrell
IMPLEMENTOR:			Marlon Burrell
DATE IMPLEMENTED:
------------------------------------------------------------------------
NOTES: @Filter = 1 is By Regions, 2 is Area Managers, 3 is By Centers
------------------------------------------------------------------------
CHANGE HISTORY:
01/04/2013 - KM - Modified Join to include CurrentEXTClientMemberships
03/27/2013 - KM - Modified output to get Last trx and appt dates
04/12/2013 - KM - Modified to derive FactReceivables from HC_Accounting
10/08/2013 - DL - (#89184) Added Group By Region/RSM filter
10/15/2013 - DL - (#89184) Added @Filter procedure parameter
10/15/2013 - DL - (#89184) Added additional RSM roll-up filters
04/07/2014 - RH - (#100145) Changed WHERE DR.RegionSSID = @CenterSSID to WHERE DC.RegionSSID = @CenterSSID (under Region code for #Center)
06/13/2014 - RH - (#102725) Added AND MembershipDescriptionShort NOT IN('POSTEXT','1STSURG','ADDSURG','SHOWNOSALE')for the receivables.
05/26/2015 - DL - Limited query to recurring business memberships only
06/02/2015 - RH - (#115423) Added CurrentXtrandsClientMembershipSSID to the join on DimClientMembership
07/01/2015 - RH - (#116390) Found the AR Balance and FR.Balance separately to remove multiples
07/07/2015 - RH - (#116440) Changed name from spRpt_FlashNewBusinessDetailsReceivables to spRpt_FlashRecurringBusinessDetailsReceivables; Added DimClientMembership and DimMembership to the #Ending_Balance query to pull only Recurring Business
01/04/2016 - RH - (#120705) Changed groupings to include by Area Managers and by Centers; (Franchise is only by Region)
12/01/2016 - RH - (#133242) Removed clients that were inactive; rewrote the order to make the sp faster; added MembershipStatus to the result
01/05/2017 - RH - (#132688) Changed EmployeeKey to CenterManagementAreaSSID
03/03/2017 - RH - (#136610) Changed Receivables back to show ALL statuses
04/05/2017 - RH - (#137787) Used logic with @ReceivablesDate to match the Warboard Receivables Ranking; AND CLT.ClientARBalance >= 0; AND FR.Balance >= 0
05/01/2017 - RH - (#137787) Removed use of the function fnGetCurrentMembershipDetailsByClientID to match the Flash Recurring Business Receivables
10/16/2017 - RH - (#137105) Changed logic for finding Area centers to use DimCenterManagementArea
01/12/2018 - RH - (#145957) Added join on CenterType and removed Corporate Regions
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_FlashRecurringBusinessDetailsReceivables] 2,  '12/31/2017', 2
EXEC [spRpt_FlashRecurringBusinessDetailsReceivables] 287, '12/31/2017', 3

EXEC [spRpt_FlashRecurringBusinessDetailsReceivables] 6, '12/31/2017', 1
EXEC [spRpt_FlashRecurringBusinessDetailsReceivables] 807, '12/31/2017', 3

EXEC [spRpt_FlashRecurringBusinessDetailsReceivables] 807, '12/31/2017', 4
EXEC [spRpt_FlashRecurringBusinessDetailsReceivables] 293, '5/15/2017', 4


EXEC [spRpt_FlashRecurringBusinessDetailsReceivables] 355, '5/10/2019', 4

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_FlashRecurringBusinessDetailsReceivables]
(
	@CenterSSID INT
,	@EndDate DATETIME
,	@Filter INT
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;



--If @EndDate is this month, then pull yesterday's date, because FactReceivables populates once a day at 3:00 AM
DECLARE @ReceivablesDate DATETIME

IF MONTH(@EndDate) = MONTH(GETDATE())
BEGIN
	SET @ReceivablesDate = CONVERT(VARCHAR(11), DATEADD(dd, -1, GETDATE()), 101)
END
ELSE
BEGIN
	SET @ReceivablesDate = @EndDate
END


/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
	CenterID INT
	,	CenterKey INT
)



CREATE TABLE #Receivables(
	Center INT
     , Center_Name NVARCHAR(50)
     , RegionID INT
     , Region NVARCHAR(50)
     , ClientIdentifier INT
     , ClientKey INT
     , Last_Name NVARCHAR(50)
     , First_Name NVARCHAR(50)
     , Member1 NVARCHAR(50)
     , ClientMembershipKey INT
	 , RevenueGroupSSID INT
     , Monthly_Fee MONEY
     , Billing_Day DATETIME
     , Balance MONEY
     , Ending_Balance MONEY
	 , MembershipStatus NVARCHAR(50)
     , Ranking INT
)

/********************************** Get list of centers *************************************/
IF @Filter = 1 -- A Region has been selected.
	BEGIN
		INSERT INTO #Centers
		SELECT DISTINCT
				DC.CenterNumber, DC.CenterKey
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionSSID = DR.RegionSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
		WHERE   (DC.RegionSSID = @CenterSSID OR @CenterSSID = 0)
				AND DC.Active = 'Y'
				AND CT.CenterTypeDescriptionShort IN ('F','JV')
	END

IF @Filter = 2  --An Area Manager has been selected
BEGIN
	INSERT INTO #Centers
	SELECT DISTINCT DC.CenterNumber, DC.CenterKey
		FROM   HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
					ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
		WHERE   --CMA.CenterManagementAreaSSID = @Center
		        (CMA.CenterManagementAreaSSID = @CenterSSID OR @CenterSSID = 0)
				AND CMA.Active = 'Y'
				AND CT.CenterTypeDescriptionShort = 'C'
END
IF @Filter = 3  -- A Center has been selected.
	BEGIN
		INSERT INTO #Centers
		SELECT DISTINCT
				DC.CenterNumber, DC.CenterKey
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		WHERE   DC.CenterNumber = @CenterSSID
				AND DC.Active = 'Y'
	END


IF @Filter = 4 AND @CenterSSID = 355
BEGIN
	INSERT INTO #Centers
	SELECT DISTINCT CTR.CenterNumber, CTR.CenterKey
	FROM   HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
				ON CTR.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON CT.CenterTypeKey = CTR.CenterTypeKey
	WHERE   CMA.Active = 'Y'
			AND CT.CenterTypeDescriptionShort IN('HW')
END


IF @Filter = 4 AND @CenterSSID <> 355
BEGIN
	INSERT INTO #Centers
	SELECT DISTINCT CTR.CenterNumber, CTR.CenterKey
	FROM   HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
				ON CTR.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON CT.CenterTypeKey = CTR.CenterTypeKey
	WHERE   CMA.Active = 'Y'
			AND CT.CenterTypeDescriptionShort IN('C')
END

--IF @Filter = 3 -- A Center has been selected.
--	BEGIN
--		INSERT INTO #Centers
--		SELECT DISTINCT
--				DC.CenterSSID
--		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
--		WHERE   DC.CenterSSID = @CenterSSID
--				AND DC.Active = 'Y'
--	END
--ELSE IF @Filter = 1 -- A Region has been selected.
--	BEGIN
--		INSERT INTO #Centers
--		SELECT DISTINCT
--				DC.CenterSSID
--		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
--			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
--				ON R.RegionSSID = DC.RegionSSID
--			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
--				ON CT.CenterTypeKey = DC.CenterTypeKey
--		WHERE   (DC.RegionSSID = @CenterSSID OR @CenterSSID = 0)
--				AND DC.Active = 'Y'
--				AND CT.CenterTypeDescriptionShort IN ('F','JV')
--	END

--ELSE -- An Area Manager has been selected
--		BEGIN
--		IF @Filter = 2
--		BEGIN
--			INSERT INTO #Centers
--			SELECT DISTINCT DC.CenterSSID
--			FROM   HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
--					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
--						ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
--					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
--						ON CT.CenterTypeKey = DC.CenterTypeKey
--			WHERE   --CMA.CenterManagementAreaSSID = @CenterSSID
--			        (CMA.CenterManagementAreaSSID = @CenterSSID OR @CenterSSID = 0)
--					AND CMA.Active = 'Y'
--					AND CT.CenterTypeDescriptionShort = 'C'
--		END
--END



--ELSE IF @Filter = 4 AND @CenterSSID = 355
--BEGIN
--	INSERT INTO #Centers
--	SELECT DISTINCT CTR.CenterSSID
--	FROM   HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
--			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
--				ON CTR.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
--			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
--						ON CT.CenterTypeKey = CTR.CenterTypeKey
--	WHERE   CMA.Active = 'Y'
--			AND CT.CenterTypeDescriptionShort IN('HW')
--END

--ELSE IF @Filter = 4 AND @CenterSSID <> 355
--BEGIN
--	INSERT INTO #Centers
--	SELECT DISTINCT CTR.CenterSSID
--	FROM   HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
--			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
--				ON CTR.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
--			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
--						ON CT.CenterTypeKey = CTR.CenterTypeKey
--	WHERE   CMA.Active = 'Y'
--			AND CT.CenterTypeDescriptionShort IN('C')
--END


/********** Find clients with AR balances and membership status ***************************************/
INSERT  INTO #Receivables
SELECT *
FROM
	(
	SELECT  C.CenterNumber AS 'Center'
	    ,   C.CenterDescription AS 'Center_Name'
		,	CASE WHEN @Filter = 1 THEN R.RegionSSID
						WHEN @Filter = 3 AND C.CenterTypeKey IN(3,4) THEN R.RegionSSID
							ELSE CMA.CenterManagementAreaSSID END AS 'RegionID'
		,	CASE WHEN @Filter = 1 THEN R.RegionDescription  --Check Center alias
						WHEN @Filter = 3 AND C.CenterTypeKey IN(3,4) THEN R.RegionDescription
							ELSE CMA.CenterManagementAreaDescription END AS 'Region'
		,   CLT.ClientIdentifier
		,	CLT.ClientKey
		,   CLT.ClientLastName AS 'Last_Name'
		,   CLT.ClientFirstName AS 'First_Name'
		,       M.MembershipDescription AS 'Member1'
		,       CM.ClientMembershipKey
		,		M.RevenueGroupSSID
		,       CM.ClientMembershipMonthlyFee AS 'Monthly_Fee'
		,       NULL AS 'Billing_Day'
		,		CLT.ClientARBalance AS 'Balance'

		,		'0.00' AS 'Ending_Balance'
		,		CM.ClientMembershipStatusDescription
		,		ROW_NUMBER()OVER(PARTITION BY CLT.ClientIdentifier ORDER BY CM.ClientMembershipEndDate DESC) AS Ranking

	FROM    HC_Accounting.dbo.FactReceivables FR
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON FR.DateKey = DD.DateKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
				ON FR.ClientKey = CLT.ClientKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
				ON FR.CenterKey = C.CenterKey

			--INNER JOIN #Centers
			--	ON C.CenterSSID = #Centers.CenterID

			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
				ON( CLT.CurrentBioMatrixClientMembershipSSID = CM.ClientMembershipSSID
					OR CLT.CurrentExtremeTherapyClientMembershipSSID = CM.ClientMembershipSSID
					OR CLT.CurrentXtrandsClientMembershipSSID = CM.ClientMembershipSSID )
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
				ON CM.MembershipSSID = M.MembershipSSID

			LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
				ON C.RegionKey = r.RegionKey
			LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
				ON C.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID

	WHERE   DD.FullDate = @ReceivablesDate
		AND M.RevenueGroupSSID = 2
		--AND DCM.MembershipStatus <> 'Inactive'  --CHANGED
		AND FR.Balance >= 0
		) b
WHERE Ranking = 1
      --AND b.center = 355
	  AND b.center in (SELECT centerid from #centers)
ORDER BY 1


--SELECT  C.CenterSSID AS 'Center'
--,       C.CenterDescription AS 'Center_Name'
--,	CASE WHEN @Filter = 1 THEN R.RegionSSID
--				WHEN @Filter = 3 AND C.CenterTypeKey IN(3,4) THEN R.RegionSSID
--					ELSE CMA.CenterManagementAreaSSID END AS 'RegionID'
--,	CASE WHEN @Filter = 1 THEN R.RegionDescription  --Check Center alias
--				WHEN @Filter = 3 AND C.CenterTypeKey IN(3,4) THEN R.RegionDescription
--					ELSE CMA.CenterManagementAreaDescription END AS 'Region'

--,       CLT.ClientIdentifier
--,		CLT.ClientKey
--,       CLT.ClientLastName AS 'Last_Name'
--,       CLT.ClientFirstName AS 'First_Name'
--,       M.MembershipDescription AS 'Member1'
--,       DCM.ClientMembershipKey
--,		M.RevenueGroupSSID
--,       DCM.ClientMembershipMonthlyFee AS 'Monthly_Fee'
--,       NULL AS 'Billing_Day'
--,		CLT.ClientARBalance AS 'Balance'
--,		'0.00' AS 'Ending_Balance'
--,		DCM.ClientMembershipStatusDescription
--,		ROW_NUMBER()OVER(PARTITION BY CLT.ClientIdentifier ORDER BY DCM.ClientMembershipEndDate DESC) AS Ranking
--FROM    HC_Accounting.dbo.FactReceivables FR
--        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
--            ON FR.DateKey = DD.DateKey
--        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
--            ON FR.ClientKey = CLT.ClientKey
--        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
--            ON FR.CenterKey = C.CenterKey
--		INNER JOIN #Centers
--            ON C.CenterSSID = #Centers.CenterID
--        LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
--				ON C.RegionKey = r.RegionKey
--LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
--	ON C.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
--		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
--				ON( CLT.CurrentBioMatrixClientMembershipSSID = DCM.ClientMembershipSSID
--					OR CLT.CurrentExtremeTherapyClientMembershipSSID = DCM.ClientMembershipSSID
--					OR CLT.CurrentXtrandsClientMembershipSSID = DCM.ClientMembershipSSID
--					OR CLT.CurrentSurgeryClientMembershipSSID = DCM.ClientMembershipSSID )
--		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
--			ON DCM.MembershipKey = M.MembershipKey

--WHERE   DD.FullDate = @EndDate
--		AND M.RevenueGroupSSID = 2
--		AND CLT.ClientARBalance >= 0


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
		INNER JOIN #Receivables R
			ON DSO.ClientKey = R.ClientKey
GROUP BY DSO.ClientKey
,       DSO.ClientMembershipKey


--
-- Determine Last Appointment Date
--

SELECT  DA.ClientKey
,       DA.ClientMembershipKey
,       MAX(DA.Appointmentdate) AS 'Last_Appointment'
,		ROW_NUMBER()OVER(PARTITION BY DA.ClientKey, DA.ClientMembershipKey ORDER BY DA.AppointmentDate DESC) AS ApptOrder
INTO    #LastAppt
FROM    HC_BI_CMS_DDS.bi_cms_dds.DimAppointment DA
        INNER JOIN #Centers C
            ON DA.CenterSSID = C.CenterID
		INNER JOIN #Receivables R
			ON DA.ClientKey = R.ClientKey AND DA.ClientMembershipKey = R.ClientMembershipKey
WHERE   DA.AppointmentDate BETWEEN DATEADD(MONTH,-1,GETDATE()) AND GETDATE()   --between six months ago until today
AND DA.CheckInTime IS NOT NULL
GROUP BY DA.ClientKey
,       DA.ClientMembershipKey
,		DA.AppointmentDate


--
-- Determine Next Appointment Date
--

SELECT  DA.ClientKey
,       DA.ClientMembershipKey
,       MIN(Appointmentdate) AS 'Next_Appointment'
INTO    #NextAppt
FROM    HC_BI_CMS_DDS.bi_cms_dds.DimAppointment DA
        INNER JOIN #Centers C
            ON DA.CenterSSID = C.CenterID
		INNER JOIN #Receivables R
			ON DA.ClientKey = R.ClientKey
WHERE   DA.AppointmentDate > GETDATE()
GROUP BY DA.ClientKey
,       DA.ClientMembershipKey


--Find the AR balance from FactReceivables for the @ReceivablesDate

SELECT CLT.ClientKey
	,	CLT.ClientIdentifier
	,	CLT.ClientFullName
	,	FR.Balance AS 'Ending_Balance'
INTO #Balance
FROM    HC_Accounting.dbo.FactReceivables FR
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
		ON FR.ClientKey = CLT.ClientKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CNTR
		ON FR.CenterKey = CNTR.CenterKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
		ON( CLT.CurrentBioMatrixClientMembershipSSID = CM.ClientMembershipSSID
				OR CLT.CurrentExtremeTherapyClientMembershipSSID = CM.ClientMembershipSSID
				OR CLT.CurrentXtrandsClientMembershipSSID = CM.ClientMembershipSSID )
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
		ON CM.MembershipSSID = M.MembershipSSID
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FR.DateKey = dd.DateKey
	INNER JOIN #Centers C
		ON CNTR.CenterSSID = C.CenterID
WHERE   DD.FullDate = @ReceivablesDate
	AND M.RevenueGroupSSID = 2
	AND FR.Balance >= 0
GROUP BY CLT.ClientKey
	,	CNTR.CenterSSID
    ,	CLT.ClientIdentifier
    ,	CLT.ClientFullName
    ,	FR.Balance


UPDATE #Receivables
SET #Receivables.Ending_Balance = #Balance.Ending_Balance
FROM #Receivables
LEFT JOIN #Balance
ON  #Receivables.ClientKey = #Balance.ClientKey
WHERE #Receivables.Ranking = 1



SELECT R.Center
     , R.Center_Name
     , R.RegionID
     , R.Region
     , R.ClientIdentifier AS 'Client_No'
     , R.ClientKey
     , R.Last_Name
     , R.First_Name
     , R.Member1
     , R.ClientMembershipKey
     , R.Monthly_Fee
     , R.Billing_Day
     , R.Balance
     , R.Ending_Balance
	 , R.MembershipStatus
     , R.Ranking
     , CMA_LastTransact.Last_Transact
     , CMA_LastAppt.Last_Appointment
     , CMA_NextAppt.Next_Appointment
FROM #Receivables R
        LEFT OUTER JOIN #LastTRX CMA_LastTransact
            ON R.ClientMembershipKey = CMA_LastTransact.ClientMembershipKey
        LEFT OUTER JOIN #LastAppt CMA_LastAppt
            ON R.ClientMembershipKey = CMA_LastAppt.ClientMembershipKey
        LEFT OUTER JOIN #NextAppt CMA_NextAppt
            ON R.ClientMembershipKey = CMA_NextAppt.ClientMembershipKey
WHERE R.Ranking = 1
	AND (CMA_LastAppt.ApptOrder IS NULL OR CMA_LastAppt.ApptOrder = 1)

END
GO
