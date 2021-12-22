/* CreateDate: 03/10/2015 11:10:55.900 , ModifyDate: 03/30/2015 09:15:04.570 */
GO
/*===============================================================================================
 Procedure Name:            [SpRpt_DashbCenterDeclines]
 Procedure Description:

 Created By:                Rachelen Hut
 Date Created:              03/05/2015
 Destination Database:      SQL06.HC_BI_Reporting
 Related Application:       Sharepoint Report for Center Flash for Renewals and Declines
================================================================================================
CHANGE HISTORY:

================================================================================================
SAMPLE EXECUTION:
EXEC [SpRpt_DashbCenterDeclines] 201

================================================================================================*/

CREATE PROCEDURE [dbo].[SpRpt_DashbCenterDeclines]
	@CenterSSID INT
AS
BEGIN

	DECLARE @StartDate DATETIME
	DECLARE @EndDate DATETIME

	SET @StartDate = DATEADD(day,DATEDIFF(day,0,GETUTCDATE()),0)							--Today at 12:00AM
	SET @EndDate = DATEADD(MINUTE,-1,(DATEADD(day,DATEDIFF(day,0,GETUTCDATE()+1),0)))		--Today at 11:59PM



		--For Testing on the weekend
	--SET @StartDate = DATEADD(day,DATEDIFF(day,0,GETUTCDATE()-2),0)							--Two days ago
	--SET @EndDate = DATEADD(MINUTE,-1,(DATEADD(day,DATEDIFF(day,0,GETUTCDATE()-1),0) ))


	--Find Create Date for Declines
	DECLARE @CreateDate DATETIME
	SELECT @CreateDate = DATEADD(MONTH, -6, GETUTCDATE())

	PRINT @StartDate
	PRINT @EndDate
	PRINT @CreateDate

	--Create temp tables

	CREATE TABLE #declines(
	AppointmentSSID UNIQUEIDENTIFIER
	,	AppointmentKey INT
	,	ClientKey INT
	,	Client NVARCHAR(104)
	,	ClientPhone1 NVARCHAR(50)
	,	AR MONEY
	,	CenterDescriptionNumber NVARCHAR(104)
	,	MembershipDescription NVARCHAR(50)
	,	RenewalDate DATETIME
	,	AnniversaryDate DATETIME
	,	SalesCodeDescription NVARCHAR(50)
	,	ApptDate DATETIME
	,	AppointmentStartTime DATETIME
	,	ApptTime NVARCHAR(50)
	,	EmployeeInitials1   NVARCHAR(5)
	,	EmployeeInitials2   NVARCHAR(5)
	,	EmployeeInitials3   NVARCHAR(5)
	,	Decline1 NVARCHAR(50)
	,	Decline2 NVARCHAR(50)
	,	Decline3 NVARCHAR(50)
	,	Decline4 NVARCHAR(50)
	,	Decline5 NVARCHAR(50)
	,	Decline6 NVARCHAR(50)
	)

	CREATE TABLE #rank (AppointmentKey INT
	,	EmployeeInitials NVARCHAR(5)
	,	RANKING INT)

	CREATE TABLE #declinerank (ClientKey INT
	,	[MonthName] NVARCHAR(3)
	,	[Month]	INT
	,	[Year] NVARCHAR(4)
	,	DeclineRank INT)

	--Main select statement

	INSERT INTO #declines
	SELECT 	ap.AppointmentSSID
		,	ap.AppointmentKey
		,	ap.ClientKey
		,	(clt.ClientFirstName + ' ' + clt.ClientLastName + ' (' + CAST(clt.ClientIdentifier AS NVARCHAR(10)) + ')') AS 'Client'
		,	'(' + LEFT(clt.ClientPhone1,3) + ') ' + SUBSTRING(clt.ClientPhone1,4,3) + '-' + RIGHT(clt.ClientPhone1,4) AS 'ClientPhone1'
		,	MAX(clt.ClientARBalance) AS 'AR'
		,	ce.CenterDescriptionNumber
		,	m.MembershipDescription
		,	cm.ClientMembershipBeginDate AS 'RenewalDate'
		,	cm.ClientMembershipEndDate AS 'AnniversaryDate'
		,	salesc.SalesCodeDescription
		,	ap.AppointmentDate ApptDate
		,	ap.AppointmentStartTime
		,	LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.AppointmentStartTime, 100), 7)) + ' - ' + LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.AppointmentEndTime, 100), 7)) 'ApptTime'
		,	NULL AS EmployeeInitials1
		,	NULL AS EmployeeInitials2
		,	NULL AS EmployeeInitials3
		,	NULL AS Decline1
		,	NULL AS Decline2
		,	NULL AS Decline3
		,	NULL AS Decline4
		,	NULL AS Decline5
		,	NULL AS Decline6
	FROM HC_BI_CMS_DDS.bi_cms_dds.DimAppointment ap
		CROSS APPLY (SELECT TOP 1 sc.SalesCodeDescription
						FROM HC_BI_CMS_DDS.bi_cms_dds.FactAppointmentDetail ad
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
								ON ad.SalesCodeKey = sc.SalesCodeKey
						WHERE ad.AppointmentKey = ap.AppointmentKey) salesc

		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
			ON ap.ClientKey = clt.ClientKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce
			ON ap.CenterKey = ce.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm   -- pull the client membership from the appointment to match the Appointment2.rdl
			ON ap.ClientMembershipKey = cm.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
			ON cm.MembershipKey = m.MembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembershipAccum acc
			ON cm.ClientMembershipKey = acc.ClientMembershipKey
	WHERE ap.AppointmentDate >= @StartDate
		AND ap.AppointmentDate <= @EndDate
		AND m.RevenueGroupSSID = 2  --Recurring
		AND ISNULL(ap.IsDeletedFlag, 0) = 0
		AND ap.CenterSSID = @CenterSSID
		AND clt.ClientFullName NOT LIKE '%Lunch%'
		AND clt.ClientFullName NOT LIKE '%Hold%'
		AND clt.ClientFullName NOT LIKE '%Meeting%'
		AND clt.ClientFullName NOT LIKE '%Out%Time%'
		AND clt.ClientFullName NOT LIKE '%Out%Sick%'
		AND clt.ClientFullName NOT LIKE '%Donot%Donot%'
		AND clt.ClientFullName NOT LIKE '%Book%Do%not%'
		AND clt.ClientFullName NOT LIKE '%Day%Off%'
		AND clt.ClientFullName NOT LIKE '%Time%Technical%'
		AND clt.ClientFullName NOT LIKE '%Time%Block%'
		AND clt.ClientFullName NOT LIKE '%Training%'
		AND clt.ClientFullName NOT LIKE '%Vacation%'
		AND ap.ClientKey <> -1

	GROUP BY ap.AppointmentSSID
		,	ap.AppointmentKey
		,	clt.ClientFirstName
		,	clt.ClientLastName
		,	clt.ClientIdentifier
		,	ap.ClientKey
		,	clt.ClientPhone1
		,	ce.CenterDescriptionNumber
		,	m.MembershipDescription
		,	cm.ClientMembershipBeginDate
		,	cm.ClientMembershipEndDate
		,	salesc.SalesCodeDescription
		,	ap.AppointmentDate
		,	ap.AppointmentStartTime
		,	ap.AppointmentEndTime


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
	AND ap.AppointmentKey IN (SELECT AppointmentKey FROM #declines)
	AND ap.CenterSSID = @CenterSSID
	AND e.IsActiveFlag = 1


	--UPDATE the initials into three possible fields for EmployeeInitials

	UPDATE p
	SET p.EmployeeInitials1 = #rank.EmployeeInitials
	FROM #declines p
	INNER JOIN #rank ON p.AppointmentKey = #rank.AppointmentKey
	WHERE RANKING = 1
	AND p.EmployeeInitials1 IS NULL

	UPDATE p
	SET p.EmployeeInitials2 = #rank.EmployeeInitials
	FROM #declines p
	INNER JOIN #rank ON p.AppointmentKey = #rank.AppointmentKey
	WHERE RANKING = 2
	AND p.EmployeeInitials2 IS NULL

	UPDATE p
	SET p.EmployeeInitials3 = #rank.EmployeeInitials
	FROM #declines p
	INNER JOIN #rank ON p.AppointmentKey = #rank.AppointmentKey
	WHERE RANKING = 3
	AND p.EmployeeInitials3 IS NULL

	/************Use ranking to partition  Decline information - Month and Year ********************/

	INSERT INTO #declinerank
	SELECT q.ClientKey
	,	LEFT(q.[MonthName],3) AS 'MonthName'
	,	q.[Month]
	,	q.[Year]
	,	ROW_NUMBER() OVER(PARTITION BY q.ClientKey ORDER BY q.[Year],q.[Month] ASC) AS 'DeclineRank'
	FROM (SELECT CLT.ClientKey
			,	PCD.CreateDate
			,	MONTH(PCD.CreateDate) AS 'Month'
			,	DATENAME(MONTH,PCD.CreateDate) AS 'MonthName'
			,	Year(PCD.CreateDate) AS 'Year'
		FROM SQL05.HairclubCMS.dbo.datPayCycleTransaction PCD
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
				ON PCD.ClientGUID = CLT.ClientSSID
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
				ON PCD.SalesOrderGUID = SO.SalesOrderSSID
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
				ON PCD.SalesOrderGUID = SOD.SalesOrderSSID
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
				ON SOD.SalesCodeSSID = SC.SalesCodeSSID
		WHERE PCD.CreateDate >= @CreateDate
			AND CLT.CenterSSID = @CenterSSID
			AND CLT.ClientKey IN (SELECT ClientKey FROM #declines)
			AND HCStatusCode = 'D'
			AND PCD.Verbiage LIKE '%Auth%Decline%'
			AND SC.SalesCodeDepartmentSSID = 2020
		GROUP BY CLT.ClientKey
			,	PCD.CreateDate
		)q
	 GROUP BY q.ClientKey
	,	q.[Month]
	,	q.[Year]
	,	q.[MonthName]


	--UPDATE the decline dates into six possible fields for Declines

	UPDATE p
	SET p.Decline1 = #declinerank.[MonthName] + ' ' + #declinerank.[Year]
	FROM #declines p
	INNER JOIN #declinerank ON p.ClientKey = #declinerank.ClientKey
	WHERE DeclineRank = 1
	AND p.Decline1 IS NULL

	UPDATE p
	SET p.Decline2 = #declinerank.[MonthName] + ' ' + #declinerank.[Year]
	FROM #declines p
	INNER JOIN #declinerank ON p.ClientKey = #declinerank.ClientKey
	WHERE DeclineRank = 2
	AND p.Decline2 IS NULL

	UPDATE p
	SET p.Decline3 = #declinerank.[MonthName] + ' ' + #declinerank.[Year]
	FROM #declines p
	INNER JOIN #declinerank ON p.ClientKey = #declinerank.ClientKey
	WHERE DeclineRank = 3
	AND p.Decline3 IS NULL

	UPDATE p
	SET p.Decline4 = #declinerank.[MonthName] + ' ' + #declinerank.[Year]
	FROM #declines p
	INNER JOIN #declinerank ON p.ClientKey = #declinerank.ClientKey
	WHERE DeclineRank = 4
	AND p.Decline4 IS NULL

	UPDATE p
	SET p.Decline5 = #declinerank.[MonthName] + ' ' + #declinerank.[Year]
	FROM #declines p
	INNER JOIN #declinerank ON p.ClientKey = #declinerank.ClientKey
	WHERE DeclineRank = 5
	AND p.Decline5 IS NULL

	UPDATE p
	SET p.Decline6 = #declinerank.[MonthName] + ' ' + #declinerank.[Year]
	FROM #declines p
	INNER JOIN #declinerank ON p.ClientKey = #declinerank.ClientKey
	WHERE DeclineRank = 6
	AND p.Decline6 IS NULL

	--Final select

	 SELECT AppointmentSSID
		,	ClientKey
		,	Client
		,	CASE WHEN ClientPhone1 = '() -' THEN '0' ELSE ClientPhone1 END AS 'ClientPhone1'
		,	AR
		,	CenterDescriptionNumber
		,	MembershipDescription
		,	RenewalDate
		,	AnniversaryDate
		,	SalesCodeDescription
		,	ApptDate
		,	AppointmentStartTime
		,	ApptTime
		,	EmployeeInitials1
		,	CASE WHEN EmployeeInitials2 = '' THEN ''
				WHEN EmployeeInitials2 = EmployeeInitials1  THEN ''
				ELSE (', ' + EmployeeInitials2) END AS 'EmployeeInitials2'
		,	CASE WHEN EmployeeInitials3 = '' THEN ''
				WHEN (EmployeeInitials3 = EmployeeInitials1 OR EmployeeInitials3 = EmployeeInitials2)  THEN ''
				ELSE (', ' + EmployeeInitials3) END AS 'EmployeeInitials3'
		,	ISNULL(Decline1,'NotApply') AS Decline1
		,	CASE WHEN Decline2 = '' THEN '' ELSE (', ' + Decline2) END AS 'Decline2'
		,	CASE WHEN Decline3 = '' THEN '' ELSE (', ' + Decline3) END AS 'Decline3'
		,	CASE WHEN Decline4 = '' THEN '' ELSE (', ' + Decline4) END AS 'Decline4'
		,	CASE WHEN Decline5 = '' THEN '' ELSE (', ' + Decline5) END AS 'Decline5'
		,	CASE WHEN Decline6 = '' THEN '' ELSE (', ' + Decline6) END AS 'Decline6'
	 FROM #declines
	 --WHERE Decline1 IS NOT NULL




END
GO
