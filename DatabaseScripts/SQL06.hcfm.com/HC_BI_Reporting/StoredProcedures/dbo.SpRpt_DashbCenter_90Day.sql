/*===============================================================================================
 Procedure Name:            [SpRpt_DashbCenter_90Day]
 Procedure Description:

 Created By:                Rachelen Hut
 Date Created:              02/26/2015
 Destination Database:      SQL06.HC_BI_Reporting
 Related Application:       Sharepoint Report for Center Flash 90 Day Protocol for Today
================================================================================================
CHANGE HISTORY:

================================================================================================
NOTES:
For 90-Day Protocol
SalesCodeSSID	SalesCodeDescription
389				Checkup - New Member
647				New Style
711				Salon Visit
727				Checkup - 24 Hour
728				Checkup - Pre Check
783				Women's New Style
782				Women's Salon Visit

================================================================================================
SAMPLE EXECUTION:
EXEC [SpRpt_DashbCenter_90Day] 230

EXEC [SpRpt_DashbCenter_90Day] 201

================================================================================================*/

CREATE PROCEDURE [dbo].[SpRpt_DashbCenter_90Day]
	@CenterSSID INT
AS
BEGIN

	DECLARE @StartDate DATETIME
	DECLARE @EndDate DATETIME
	SET @StartDate = DATEADD(day,DATEDIFF(day,0,GETUTCDATE()),0)							--Today at 12:00AM
	SET @EndDate = DATEADD(MINUTE,-1,(DATEADD(day,DATEDIFF(day,0,GETUTCDATE()+1),0)))		--Today at 11:59PM

	PRINT @StartDate
	PRINT @EndDate

	--Create temp tables

	CREATE TABLE #90day(
	AppointmentSSID UNIQUEIDENTIFIER
	,	AppointmentKey INT
	,	ClientKey INT
	,	Client NVARCHAR(104)
	,	ClientPhone1 NVARCHAR(50)
	,	CenterDescriptionNumber NVARCHAR(104)
	,	RenewalDate DATETIME
	,	AnniversaryDate DATETIME
	,	ApptDate DATETIME
	,	AppointmentStartTime DATETIME
	,	ApptTime NVARCHAR(50)
	,	SalesCodeDescription NVARCHAR(50)
	,	NB1AppDate DATETIME
	,	Diff INT
	,	EmployeeInitials1   NVARCHAR(5)
	,	EmployeeInitials2   NVARCHAR(5)
	,	EmployeeInitials3   NVARCHAR(5)
	)

	CREATE TABLE #rank (AppointmentKey INT
	,	EmployeeInitials NVARCHAR(5)
	,	RANKING INT)

	INSERT INTO #90day
	SELECT  ap.AppointmentSSID
		,	ap.AppointmentKey
		,	ap.ClientKey
		,	(cl.ClientFirstName + ' ' + cl.ClientLastName + ' (' + CAST(cl.ClientIdentifier AS NVARCHAR(10)) + ')') AS 'Client'
		,	'(' + LEFT(cl.ClientPhone1,3) + ') ' + SUBSTRING(cl.ClientPhone1,4,3) + '-' + RIGHT(cl.ClientPhone1,4) AS 'ClientPhone1'
		,	ce.CenterDescriptionNumber
		,	cm.ClientMembershipBeginDate AS 'RenewalDate'
		,	cm.ClientMembershipEndDate AS 'AnniversaryDate'
		,	ap.AppointmentDate ApptDate
		,	ap.AppointmentStartTime
		,	LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.AppointmentStartTime, 100), 7)) + ' - ' + LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.AppointmentEndTime, 100), 7)) 'ApptTime'
		,	sc.SalesCodeDescription
		,	NB1App.NB1AppDate
		,	DATEDIFF(DAY,NB1App.NB1AppDate,GETUTCDATE()) AS Diff
		,	NULL AS EmployeeInitials1
		,	NULL AS EmployeeInitials2
		,	NULL AS EmployeeInitials3
	FROM HC_BI_CMS_DDS.bi_cms_dds.DimAppointment ap
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactAppointmentDetail ad
			ON ap.AppointmentKey = ad.AppointmentKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
			ON ad.SalesCodeKey = sc.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl
			ON ap.ClientKey = cl.ClientKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce
			ON ap.CenterKey = ce.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm   -- pull the client membership from the appointment to match the Appointment2.rdl
			ON ap.ClientMembershipKey = cm.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
			ON cm.MembershipKey = m.MembershipKey
		LEFT OUTER JOIN (
			-- Get NB1 Application Data  (This code is from the stored procedure for the 90-Day Protocol report in SharePoint)
			SELECT  FST.ClientKey
			,       DD.FullDate AS 'NB1AppDate'
			,       ROW_NUMBER() OVER ( PARTITION BY FST.ClientKey ORDER BY DD.FullDate DESC ) AS 'Ranking'
			FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
					INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
						ON FST.OrderDateKey = DD.DateKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						ON FST.CenterKey = DC.CenterKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
						ON FST.SalesCodeKey = SC.SalesCodeKey
			WHERE   DC.CenterSSID = @CenterSSID
					AND SC.SalesCodeDepartmentSSID = 5010
		) NB1App
			ON cl.ClientKey = NB1App.ClientKey
				AND NB1App.Ranking = 1
	WHERE ap.AppointmentDate = @StartDate
		AND ap.IsDeletedFlag <> 1
		AND ap.CenterSSID = @CenterSSID
		AND ap.ClientKey <> -1
		AND m.BusinessSegmentSSID = 1	--BIO
		AND sc.SalesCodeSSID IN(389,647,648,711,727,728,783,782)
	GROUP BY ap.AppointmentSSID
		,	ap.AppointmentKey
		,	ap.ClientKey
		,	cl.ClientFirstName
		,	cl.ClientLastName
		,	cl.ClientIdentifier
		,	cl.ClientFullName
		,	cl.ClientPhone1
		,	ce.CenterDescriptionNumber
		,	cm.ClientMembershipBeginDate
		,	cm.ClientMembershipEndDate
		,	ap.AppointmentDate
		,	ap.AppointmentStartTime
		,	ap.AppointmentEndTime
		,	sc.SalesCodeDescription
		,	NB1App.NB1AppDate
		,	DATEDIFF(DAY,NB1AppDate,GETUTCDATE())


	/************Use ranking to partition employee initials *****************************************/

	INSERT INTO #rank
	SELECT ap.AppointmentKey
	,  e.EmployeeInitials
	,	ROW_NUMBER() OVER(PARTITION BY ap.AppointmentKey ORDER BY e.EmployeeInitials DESC) AS RANKING
		FROM HC_BI_CMS_DDS.bi_cms_dds.DimAppointment ap
		INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].FactAppointmentEmployee fae
			ON ap.AppointmentKey = fae.AppointmentKey
		INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimEmployee e
			ON fae.EmployeeKey = e.EmployeeKey
		INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimEmployeePositionJoin epj
			ON e.EmployeeSSID = epj.EmployeeGUID
		INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimEmployeePosition ep
			ON epj.EmployeePositionID = ep.EmployeePositionSSID
	WHERE ap.AppointmentDate >= @StartDate
	AND ap.AppointmentDate <= @EndDate
	AND ap.AppointmentKey IN (SELECT AppointmentKey FROM #90day)
	AND ap.CenterSSID = @CenterSSID
	AND e.IsActiveFlag = 1

	--SELECT * FROM #rank

	--UPDATE the initials into three possible fields for EmployeeInitials

	UPDATE p
	SET p.EmployeeInitials1 = #rank.EmployeeInitials
	FROM #90day p
	INNER JOIN #rank ON p.AppointmentKey = #rank.AppointmentKey
	WHERE RANKING = 1
	AND p.EmployeeInitials1 IS NULL

	UPDATE p
	SET p.EmployeeInitials2 = #rank.EmployeeInitials
	FROM #90day p
	INNER JOIN #rank ON p.AppointmentKey = #rank.AppointmentKey
	WHERE RANKING = 2
	AND p.EmployeeInitials2 IS NULL

	UPDATE p
	SET p.EmployeeInitials3 = #rank.EmployeeInitials
	FROM #90day p
	INNER JOIN #rank ON p.AppointmentKey = #rank.AppointmentKey
	WHERE RANKING = 3
	AND p.EmployeeInitials3 IS NULL

	--Final select

	SELECT AppointmentSSID
		,	AppointmentKey
		,	ClientKey
		,	Client
		,	CASE WHEN ClientPhone1 = '() -' THEN '0' ELSE ClientPhone1 END AS 'ClientPhone1'
		,	CenterDescriptionNumber
		,	RenewalDate
		,	AnniversaryDate
		,	ApptDate
		,	AppointmentStartTime
		,	ApptTime
		,	SalesCodeDescription
		,	NB1AppDate
		,	Diff
		,	EmployeeInitials1
		,	CASE WHEN EmployeeInitials2 = '' THEN ''
				WHEN EmployeeInitials2 = EmployeeInitials1  THEN ''
				ELSE (', ' + EmployeeInitials2) END AS 'EmployeeInitials2'
		,	CASE WHEN EmployeeInitials3 = '' THEN ''
				WHEN (EmployeeInitials3 = EmployeeInitials1 OR EmployeeInitials3 = EmployeeInitials2)  THEN ''
				ELSE (', ' + EmployeeInitials3) END AS 'EmployeeInitials3'
	FROM #90day
	WHERE Client NOT LIKE '%Lunch%'
		AND Client NOT LIKE '%Hold%'
		AND Client NOT LIKE '%Meeting%'
		AND Client NOT LIKE '%Out%Time%'
		AND Client NOT LIKE '%Out%Sick%'
		AND Client NOT LIKE '%Donot%Donot%'
		AND Client NOT LIKE '%Book%Do%not%'
		AND Client NOT LIKE '%Day%Off%'
		AND Client NOT LIKE '%Vacation%'
		AND Client NOT LIKE '%Training%'
		AND Client NOT LIKE '%Time%Technical%'
		AND Client NOT LIKE '%Time%Block%'
		AND Client NOT LIKE '%Training%'
		AND Diff <= 90   --The time between the initial app and today is less than or equal to 90 days

END
