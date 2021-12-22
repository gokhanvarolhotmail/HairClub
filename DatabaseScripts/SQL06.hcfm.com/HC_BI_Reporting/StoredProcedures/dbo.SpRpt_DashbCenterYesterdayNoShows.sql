/* CreateDate: 02/27/2015 09:56:55.080 , ModifyDate: 12/13/2019 14:33:11.973 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
 Procedure Name:            [SpRpt_DashbCenterYesterdayNoShows]
 Procedure Description:

 Created By:                Rachelen Hut
 Date Created:              2/27/2015
 Destination Database:      SQL06.HC_BI_Reporting
 Related Application:       Sharepoint Report for Center Flash
================================================================================================
CHANGE HISTORY:

================================================================================================
NOTES:

================================================================================================
SAMPLE EXECUTION:
EXEC [SpRpt_DashbCenterYesterdayNoShows] 212

================================================================================================*/

CREATE PROCEDURE [dbo].[SpRpt_DashbCenterYesterdayNoShows]
	@CenterSSID INT
AS
BEGIN
--DECLARE @listStr VARCHAR(MAX)
	DECLARE @YesterdayStartDate DATETIME
	DECLARE @YesterdayEndDate DATETIME
	SET @YesterdayStartDate = CASE WHEN DATEPART(dw,GETUTCDATE()) = 3 THEN DATEADD(day,DATEDIFF(day,0,GETDATE()-3),0)	--If it is Tuesday then pull from either Sat at 12:00AM  --Tuesday = 3
								ELSE DATEADD(Day,DATEDIFF(day,0,GETDATE()-1),0) END										--Yesterday at 12:00AM
	SET @YesterdayEndDate = DATEADD(MINUTE,-1,(DATEADD(day,DATEDIFF(day,0,GETDATE()),0))) 								--Yesterday at 11:59PM

	----For Testing on the weekend
	--SET @YesterdayStartDate = DATEADD(day,DATEDIFF(day,0,GETDATE()-2),0)
	--SET @YesterdayEndDate = DATEADD(MINUTE,-1,(DATEADD(day,DATEDIFF(day,0,GETDATE()-1),0) ))

--DROP TABLE #yesterday

	PRINT @YesterdayStartDate
	PRINT @YesterdayEndDate

	--Create temp tables

	CREATE TABLE #yesterday(yesID INT IDENTITY(1,1)
		,	AppointmentSSID UNIQUEIDENTIFIER
		,	AppointmentKey INT
		,	ClientKey INT
		,	Client NVARCHAR(250)
		,	ClientPhone1 NVARCHAR(50)
		,	MembershipDescription NVARCHAR(60)
		,	RevenueGroupDescription NVARCHAR(60)
		,	ApptDate DATETIME
		,	AppointmentStartTime DATETIME
		,	ApptTime NVARCHAR(60)
		,	SalesCodeDescription NVARCHAR(60)
		,	EmployeeInitials1   NVARCHAR(5)
		,	EmployeeInitials2   NVARCHAR(5)
		,	EmployeeInitials3   NVARCHAR(5)
		)

	CREATE TABLE #rank (AppointmentKey INT
		,	EmployeeInitials NVARCHAR(5)
		,	RANKING INT)

	INSERT INTO #yesterday
	SELECT 	ap.AppointmentSSID
		,	ap.AppointmentKey
		,	ap.ClientKey
		,	(cl.ClientFirstName + ' ' + cl.ClientLastName + ' (' + CAST(cl.ClientIdentifier AS NVARCHAR(10)) + ')') AS 'Client'
		,	'(' + LEFT(cl.ClientPhone1,3) + ') ' + SUBSTRING(cl.ClientPhone1,4,3) + '-' + RIGHT(cl.ClientPhone1,4) AS 'ClientPhone1'
		,	m.MembershipDescription
		,	m.RevenueGroupDescription
		,	ap.AppointmentDate ApptDate
		,	ap.AppointmentStartTime
		,	LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.AppointmentStartTime, 100), 7)) + ' - ' + LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.AppointmentEndTime, 100), 7)) 'ApptTime'
		,	scd.SalesCodeDescription
		,	NULL AS EmployeeInitials1
		,	NULL AS EmployeeInitials2
		,	NULL AS EmployeeInitials3
	FROM HC_BI_CMS_DDS.bi_cms_dds.DimAppointment ap
		CROSS APPLY
			(SELECT TOP(1) SalesCodeDescription
				FROM HC_BI_CMS_DDS.bi_cms_dds.FactAppointmentDetail ad
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
						ON ad.SalesCodeKey = sc.SalesCodeKey
				WHERE ap.AppointmentKey = ad.AppointmentKey
				) scd
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl
			ON ap.ClientKey = cl.ClientKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce
			ON ap.CenterKey = ce.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm   -- pull the client membership from the appointment to match the Appointment2.rdl
			ON ap.ClientMembershipKey = cm.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
			ON m.MembershipKey = cm.MembershipKey
	WHERE ap.AppointmentDate >= @YesterdayStartDate
		AND ap.AppointmentDate <= @YesterdayEndDate
		AND ISNULL(ap.IsDeletedFlag, 0) = 0
		AND ap.CenterSSID = @CenterSSID
		AND ap.ClientKey <> -1
		AND ap.CheckInTime IS NULL
	GROUP BY ap.AppointmentSSID
		,	ap.AppointmentKey
		,	ap.ClientKey
		,	cl.ClientFirstName
		,	cl.ClientLastName
		,	cl.ClientIdentifier
		,	cl.ClientPhone1
		,	m.MembershipDescription
		,	m.RevenueGroupDescription
		,	ap.AppointmentDate
		,	ap.AppointmentStartTime
		,	ap.AppointmentEndTime
		,	scd.SalesCodeDescription

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
	WHERE ap.AppointmentDate >= @YesterdayStartDate
	AND ap.AppointmentDate <= @YesterdayEndDate
	AND ap.AppointmentKey IN (SELECT AppointmentKey FROM #yesterday)
	AND ap.CenterSSID = @CenterSSID
	AND e.IsActiveFlag = 1

	--SELECT * FROM #rank

	--UPDATE the initials into three possible fields for EmployeeInitials

	UPDATE p
	SET p.EmployeeInitials1 = #rank.EmployeeInitials
	FROM #yesterday p
	INNER JOIN #rank ON p.AppointmentKey = #rank.AppointmentKey
	WHERE RANKING = 1
	AND p.EmployeeInitials1 IS NULL

	UPDATE p
	SET p.EmployeeInitials2 = #rank.EmployeeInitials
	FROM #yesterday p
	INNER JOIN #rank ON p.AppointmentKey = #rank.AppointmentKey
	WHERE RANKING = 2
	AND p.EmployeeInitials2 IS NULL

	UPDATE p
	SET p.EmployeeInitials3 = #rank.EmployeeInitials
	FROM #yesterday p
	INNER JOIN #rank ON p.AppointmentKey = #rank.AppointmentKey
	WHERE RANKING = 3
	AND p.EmployeeInitials3 IS NULL

	--Final select

	SELECT AppointmentSSID
		,	AppointmentKey
		,	ClientKey
		,	Client
		,	CASE WHEN ClientPhone1 = '() -' THEN '0'
				WHEN ClientPhone1 ='() -) -) --) -' THEN '0'
				ELSE ClientPhone1 END AS 'ClientPhone1'
		,	MembershipDescription
		,	RevenueGroupDescription
		,	ApptDate
		,	AppointmentStartTime
		,	ApptTime
		,	SalesCodeDescription as 'SalesCodeDescription'
		,	MAX(ApptDate) AS 'PreviousDate'
		,	@YesterdayEndDate AS 'EndDate'
		,	EmployeeInitials1
		,	CASE WHEN EmployeeInitials2 = '' THEN ''
				WHEN EmployeeInitials2 = EmployeeInitials1  THEN ''
				ELSE (', ' + EmployeeInitials2) END AS 'EmployeeInitials2'
		,	CASE WHEN EmployeeInitials3 = '' THEN ''
				WHEN (EmployeeInitials3 = EmployeeInitials1 OR EmployeeInitials3 = EmployeeInitials2)  THEN ''
				ELSE (', ' + EmployeeInitials3) END AS 'EmployeeInitials3'
	FROM #yesterday
		WHERE Client NOT LIKE '%Lunch%'
		AND Client NOT LIKE '%Hold%'
		AND Client NOT LIKE '%Meeting%'
		AND Client NOT LIKE '%Out%Time%'
		AND Client NOT LIKE '%Out%Sick%'
		AND Client NOT LIKE '%Donot%Donot%'
		AND Client NOT LIKE '%Book%Do%not%'
		AND Client NOT LIKE '%Off, Day%'
		AND Client NOT LIKE '%Vacation%'
		AND Client NOT LIKE '%Day%Off%'
		AND Client NOT LIKE '%Time%Technical%'
		AND Client NOT LIKE '%Time%Block%'
		AND Client NOT LIKE '%Training%'
	GROUP BY  AppointmentSSID
		,	AppointmentKey
		,	ClientKey
		,	Client
		,	ClientPhone1
		,	MembershipDescription
		,	RevenueGroupDescription
		,	ApptDate
		,	AppointmentStartTime
		,	ApptTime
		,	SalesCodeDescription
		,	EmployeeInitials1
		,	EmployeeInitials2
		,	EmployeeInitials3

END
GO
