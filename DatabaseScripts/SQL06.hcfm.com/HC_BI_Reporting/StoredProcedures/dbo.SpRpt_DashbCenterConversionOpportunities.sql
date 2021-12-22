/* CreateDate: 03/02/2015 15:01:10.253 , ModifyDate: 09/02/2015 09:40:20.113 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
 Procedure Name:            [SpRpt_DashbCenterConversionOpportunities]
 Procedure Description:     For the conversion opportunities grid in the Center Flash dashboard
 Created By:                Rachelen Hut
 Date Created:              03/05/2015
 Destination Database:      SQL06.HC_BI_Reporting
 Related Application:       Sharepoint Report for Center Flash
================================================================================================
CHANGE HISTORY:
09/02/2015 - RH - Added (TotalAccumQuantity - UsedAccumQuantity) AS 'AccumQuantityRemaining'
================================================================================================
SAMPLE EXECUTION:
EXEC [SpRpt_DashbCenterConversionOpportunities] 213
================================================================================================*/

CREATE PROCEDURE [dbo].[SpRpt_DashbCenterConversionOpportunities]
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

	--SET @StartDate = '12/10/2014'
	--SET @EndDate = '12/12/2014'


	--Find Client Membership Begin Date
	DECLARE @CMBeginDate DATETIME
	SELECT @CMBeginDate = DATEADD(Day,+45,GETUTCDATE())

	PRINT @StartDate
	PRINT @EndDate
	PRINT @CMBeginDate


	--Create temp tables

	CREATE TABLE #potential(
	AppointmentSSID UNIQUEIDENTIFIER
	,	AppointmentKey INT
	,	ClientKey INT
	,	Client NVARCHAR(104)
	,	ClientPhone1 NVARCHAR(50)
	,	CenterDescriptionNumber NVARCHAR(104)
	,	MembershipDescription NVARCHAR(50)
	,	RenewalDate DATETIME
	,	ApptDate DATETIME
	,	AppointmentStartTime DATETIME
	,	ApptTime NVARCHAR(50)
	,	AccumulatorDescriptionShort NVARCHAR(50)
	,	AccumQuantityRemaining INT
	,	EmployeeInitials1   NVARCHAR(5)
	,	EmployeeInitials2   NVARCHAR(5)
	,	EmployeeInitials3   NVARCHAR(5)
	)

	CREATE TABLE #rank (AppointmentKey INT
	,	EmployeeInitials NVARCHAR(5)
	,	RANKING INT)


	--Main select statement

	INSERT INTO #potential
	SELECT 	ap.AppointmentSSID
		,	ap.AppointmentKey
		,	ap.ClientKey
		,	(cl.ClientFirstName + ' ' + cl.ClientLastName + ' (' + CAST(cl.ClientIdentifier AS NVARCHAR(10)) + ')') AS 'Client'
		,	'(' + LEFT(cl.ClientPhone1,3) + ') ' + SUBSTRING(cl.ClientPhone1,4,3) + '-' + RIGHT(cl.ClientPhone1,4) AS 'ClientPhone1'
		,	ce.CenterDescriptionNumber
		,	m.MembershipDescription
		,	cm.ClientMembershipBeginDate AS 'RenewalDate'
		,	ap.AppointmentDate ApptDate
		,	ap.AppointmentStartTime
		,	LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.AppointmentStartTime, 100), 7)) + ' - ' + LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.AppointmentEndTime, 100), 7)) 'ApptTime'
		,	CASE WHEN acc.AccumulatorDescriptionShort = 'SERV' THEN 'Serv' ELSE 'BioSys' END AS 'AccumulatorDescriptionShort'
		,	(TotalAccumQuantity - UsedAccumQuantity) AS 'AccumQuantityRemaining'
		,	NULL AS EmployeeInitials1
		,	NULL AS EmployeeInitials2
		,	NULL AS EmployeeInitials3
	FROM HC_BI_CMS_DDS.bi_cms_dds.DimAppointment ap
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl
			ON ap.ClientKey = cl.ClientKey
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
		AND m.RevenueGroupSSID = 1  --New Business
		AND ISNULL(ap.IsDeletedFlag, 0) = 0
		AND ap.CenterSSID = @CenterSSID
		AND cl.ClientFullName NOT LIKE '%Lunch%'
		AND cl.ClientFullName NOT LIKE '%Hold%'
		AND cl.ClientFullName NOT LIKE '%Meeting%'
		AND cl.ClientFullName NOT LIKE '%Out%Time%'
		AND cl.ClientFullName NOT LIKE '%Out%Sick%'
		AND cl.ClientFullName NOT LIKE '%Donot%Donot%'
		AND cl.ClientFullName NOT LIKE '%Book%Do%not%'
		AND cl.ClientFullName NOT LIKE '%Day%Off%'
		AND cl.ClientFullName NOT LIKE '%Time%Technical%'
		AND cl.ClientFullName NOT LIKE '%Time%Block%'
		AND cl.ClientFullName NOT LIKE '%Training%'
		AND cl.ClientFullName NOT LIKE '%Vacation%'
		AND ap.ClientKey <> -1
		AND AccumulatorDescriptionShort IN('BioSys', 'SERV')
		AND cm.ClientMembershipBeginDate <= @CMBeginDate
	GROUP BY ap.AppointmentSSID
		,	ap.AppointmentKey
		,	ap.ClientKey
		,	cl.ClientFirstName
		,	cl.ClientLastName
		,	cl.ClientIdentifier
		,	cl.ClientPhone1
		,	ce.CenterDescriptionNumber
		,	m.MembershipDescription
		,	cm.ClientMembershipBeginDate
		,	ap.AppointmentDate
		,	ap.AppointmentStartTime
		,	ap.AppointmentEndTime
		,	m.RevenueGroupSSID
		,	m.RevenueGroupDescription
		,	acc.AccumulatorDescriptionShort
		,	acc.TotalAccumQuantity
		,	acc.UsedAccumQuantity


	--SELECT * FROM #potential

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
	AND ap.AppointmentKey IN (SELECT AppointmentKey FROM #potential)
	AND ap.CenterSSID = @CenterSSID
	AND e.IsActiveFlag = 1

	--SELECT * FROM #rank

	--UPDATE the initials into three possible fields for EmployeeInitials

	UPDATE p
	SET p.EmployeeInitials1 = #rank.EmployeeInitials
	FROM #potential p
	INNER JOIN #rank ON p.AppointmentKey = #rank.AppointmentKey
	WHERE RANKING = 1
	AND p.EmployeeInitials1 IS NULL

	UPDATE p
	SET p.EmployeeInitials2 = #rank.EmployeeInitials
	FROM #potential p
	INNER JOIN #rank ON p.AppointmentKey = #rank.AppointmentKey
	WHERE RANKING = 2
	AND p.EmployeeInitials2 IS NULL

	UPDATE p
	SET p.EmployeeInitials3 = #rank.EmployeeInitials
	FROM #potential p
	INNER JOIN #rank ON p.AppointmentKey = #rank.AppointmentKey
	WHERE RANKING = 3
	AND p.EmployeeInitials3 IS NULL

	--Final select with a PIVOT for the accumulators
	SELECT AppointmentSSID
		,	ClientKey
		,	Client
		,	ClientPhone1
		,	CenterDescriptionNumber
		,	MembershipDescription
		,	RenewalDate
		,	ApptDate
		,	AppointmentStartTime
		,	ApptTime
		,	EmployeeInitials1
		,	EmployeeInitials2
		,	EmployeeInitials3
		,	Serv
		,	BioSys
	INTO #Final
	FROM (
		SELECT AppointmentSSID
		,	ClientKey
		,	Client
		,	CASE WHEN ClientPhone1 = '() -' THEN '0' ELSE ClientPhone1 END AS 'ClientPhone1'
		,	CenterDescriptionNumber
		,	MembershipDescription
		,	RenewalDate
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
		,	AccumulatorDescriptionShort
		,	ISNULL(AccumQuantityRemaining,0) AS 'AccumQuantityRemaining'
		FROM #potential
		) q
	 PIVOT (SUM(AccumQuantityRemaining) FOR AccumulatorDescriptionShort IN (Serv, BioSys)) AS pvt


	 SELECT AppointmentSSID
          , ClientKey
          , Client
          , ClientPhone1
          , CenterDescriptionNumber
          , MembershipDescription
          , RenewalDate
          , ApptDate
          , AppointmentStartTime
          , ApptTime
          , EmployeeInitials1
          , EmployeeInitials2
          , EmployeeInitials3
		  ,	ISNULL(Serv,0) AS 'Serv'
		  , ISNULL(BioSys,0) AS 'BioSys'
	 FROM #Final



END
GO
