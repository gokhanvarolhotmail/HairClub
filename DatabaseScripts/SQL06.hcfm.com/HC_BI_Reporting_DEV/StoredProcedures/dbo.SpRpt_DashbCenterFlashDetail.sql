/*===============================================================================================
 Procedure Name:            [SpRpt_DashbCenterFlashDetail]
 Procedure Description:

 Created By:                Rachelen Hut
 Date Created:              03/05/2015
 Destination Database:      SQL06.HC_BI_Reporting
 Related Application:       Sharepoint Report for Center Flash - AR Balances
================================================================================================
CHANGE HISTORY:

================================================================================================
NOTES:

================================================================================================
SAMPLE EXECUTION:
EXEC [SpRpt_DashbCenterFlashDetail] 201

================================================================================================*/

CREATE PROCEDURE [dbo].[SpRpt_DashbCenterFlashDetail]
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

	--SET @StartDate = '3/27/2015'
	--SET @EndDate = '3/28/2015'

	PRINT @StartDate
	PRINT @EndDate

	--Find Create Date for Declines
	DECLARE @CreateDate DATETIME
	SELECT @CreateDate = DATEADD(MONTH, -6, GETUTCDATE())


	CREATE TABLE #detail(
		AppointmentKey INT
	,	CenterKey INT
	,	Client NVARCHAR(104)
	,	ClientKey INT
	,	ClientPhone1 NVARCHAR(50)
	,	CenterDescriptionNumber NVARCHAR(104)
	,	ApptDate DATETIME
	,	AppointmentStartTime DATETIME
	,	AppointmentEndTime DATETIME
	,	AR MONEY
	,	EmployeeInitials1   NVARCHAR(5)
	,	EmployeeInitials2   NVARCHAR(5)
	,	EmployeeInitials3   NVARCHAR(5)
	)

	CREATE TABLE #rank (AppointmentKey INT
		,	EmployeeInitials NVARCHAR(5)
		,	RANKING INT)


	SELECT ap.AppointmentKey
		,	ap.CenterKey
		,	ap.ClientKey
		,	ap.AppointmentDate 'ApptDate'
		,	ap.AppointmentStartTime
		,	ap.AppointmentEndTime
		,	ap.ClientMembershipKey
	INTO #begin
	FROM  HC_BI_CMS_DDS.bi_cms_dds.DimAppointment ap
	WHERE ap.AppointmentDate >= @StartDate
		AND ap.AppointmentDate <= @EndDate
		AND ap.CenterSSID = @CenterSSID
		AND ap.IsDeletedFlag = 0
		AND ap.ClientKey <> -1

	--SELECT * FROM #begin

	INSERT INTO #detail
	SELECT 	b.AppointmentKey
		,	b.CenterKey
		,	(clt.ClientFirstName + ' ' + clt.ClientLastName + ' (' + CAST(clt.ClientIdentifier AS NVARCHAR(10)) + ')') AS 'Client'
		,	b.ClientKey
		,	('(' + LEFT(clt.ClientPhone1,3) + ') ' + SUBSTRING(clt.ClientPhone1,4,3) + '-' + RIGHT(clt.ClientPhone1,4)) AS 'ClientPhone1'
		,	c.CenterDescriptionNumber
		,	b.ApptDate
		,	b.AppointmentStartTime
		,	b.AppointmentEndTime
		,	MAX(clt.ClientARBalance) AS 'AR'
		,	NULL AS EmployeeInitials1
		,	NULL AS EmployeeInitials2
		,	NULL AS EmployeeInitials3
	FROM #begin b
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
			ON b.CenterKey = c.CenterKey
		INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimClient clt
			ON b.ClientKey = clt.ClientKey
	WHERE clt.ClientARBalance > 0
	GROUP BY b.AppointmentKey
		,	b.CenterKey
		,	c.CenterDescriptionNumber
		,	b.ClientKey
		,	clt.ClientFirstName
		,	clt.ClientLastName
		,	clt.ClientIdentifier
		,	clt.ClientPhone1
		,	b.ApptDate
		,	b.AppointmentStartTime
		,	b.AppointmentEndTime


		--SELECT * FROM #detail

	/************Use ranking to partition employee initials *****************************************/

	INSERT INTO #rank
	SELECT ap.AppointmentKey
	,	e.EmployeeInitials
	,	ROW_NUMBER() OVER(PARTITION BY ap.AppointmentKey ORDER BY e.EmployeeInitials ASC) AS RANKING
	FROM #detail ap
		INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].FactAppointmentEmployee fae
			ON ap.AppointmentKey = fae.AppointmentKey
		INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimEmployee e
			ON fae.EmployeeKey = e.EmployeeKey
		INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimEmployeePositionJoin epj
			ON e.EmployeeSSID = epj.EmployeeGUID
		INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimEmployeePosition ep
			ON epj.EmployeePositionID = ep.EmployeePositionSSID
	WHERE e.IsActiveFlag = 1
	GROUP BY ap.AppointmentKey
		,	e.EmployeeInitials

	--SELECT * FROM #rank
	--UPDATE the initials into three possible fields for EmployeeInitials


	UPDATE p
	SET p.EmployeeInitials1 = #rank.EmployeeInitials
	FROM #detail p
	INNER JOIN #rank ON p.AppointmentKey = #rank.AppointmentKey
	WHERE RANKING = 1
	AND p.EmployeeInitials1 IS NULL

	UPDATE p
	SET p.EmployeeInitials2 = #rank.EmployeeInitials
	FROM #detail p
	INNER JOIN #rank ON p.AppointmentKey = #rank.AppointmentKey
	WHERE RANKING = 2
	AND p.EmployeeInitials2 IS NULL

	UPDATE p
	SET p.EmployeeInitials3 = #rank.EmployeeInitials
	FROM #detail p
	INNER JOIN #rank ON p.AppointmentKey = #rank.AppointmentKey
	WHERE RANKING = 3
	AND p.EmployeeInitials3 IS NULL

	--SELECT * FROM #detail

	--Find clients who have had declines in the past six months
SELECT d.ClientKey
			,	COUNT(*) as 'Decline'
	INTO #decline3
		FROM #detail d
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
				ON d.ClientKey = SO.ClientKey
			INNER JOIN SQL05.HairclubCMS.dbo.datPayCycleTransaction PCD
				ON SO.ClientSSID = PCD.ClientGUID
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
				ON PCD.SalesOrderGUID = SOD.SalesOrderSSID
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
				ON SOD.SalesCodeSSID = SC.SalesCodeSSID
		WHERE PCD.CreateDate >= @CreateDate
			AND HCStatusCode = 'D'
			AND PCD.Verbiage LIKE '%Auth%Decline%'
			AND SC.SalesCodeDepartmentSSID = 2020
		GROUP BY d.ClientKey

		--SELECT * FROM #decline3

	--ROWNUMBER()PARTITION BY
	SELECT 	AppointmentKey
		,	#detail.ClientKey
		,	Client
		,	CASE WHEN ClientPhone1 = '() -' THEN '0' ELSE ClientPhone1 END AS 'ClientPhone1'
		,	ApptDate
		,	AppointmentStartTime
		,	LTRIM(RIGHT(CONVERT(VARCHAR(25), AppointmentStartTime, 100), 7)) + ' - ' + LTRIM(RIGHT(CONVERT(VARCHAR(25), AppointmentEndTime, 100), 7)) AS 'ApptTime'
		,	AR
		,	EmployeeInitials1
		,	CASE WHEN EmployeeInitials2 = '' THEN ''
				WHEN EmployeeInitials2 = EmployeeInitials1  THEN ''
				ELSE (', ' + EmployeeInitials2)
			END AS 'EmployeeInitials2'
		,	CASE WHEN EmployeeInitials3 = '' THEN ''
				WHEN (EmployeeInitials3 = EmployeeInitials1 OR EmployeeInitials3 = EmployeeInitials2)  THEN ''
				ELSE (', ' + EmployeeInitials3)
			END AS 'EmployeeInitials3'
		,	CAST(SUM(Decline) AS NVARCHAR(12)) AS 'Decline1'
	INTO #final
	FROM #detail
	LEFT JOIN #decline3  d3
		ON #detail.ClientKey = d3.ClientKey
	WHERE  Client NOT LIKE '%Lunch%'
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
	GROUP BY #detail.AppointmentKey
			,	#detail.ClientKey
		,	Client
         ,	ClientPhone1
         ,	ApptDate
		 ,	AppointmentStartTime
		 ,	AppointmentEndTime
         ,	AR
		 ,	EmployeeInitials1
		 ,	EmployeeInitials2
		 ,	EmployeeInitials3

	SELECT ClientKey
		,	AR
		,	AppointmentStartTime
		,	ROW_NUMBER() OVER(PARTITION BY ClientKey ORDER BY AppointmentStartTime ASC) CMRANK
	INTO #ranking
	FROM #final

	UPDATE #final
	SET #final.AR = '0.00'
	FROM #final
	INNER JOIN #ranking ON #final.ClientKey =  #ranking.ClientKey
	WHERE #final.AppointmentStartTime =  #ranking.AppointmentStartTime
	AND #ranking.CMRANK = 2

	SELECT AppointmentKey
         , ClientKey
         , Client
         , ClientPhone1
         , ApptDate
         , AppointmentStartTime
         , ApptTime
         , AR
         , EmployeeInitials1
         , EmployeeInitials2
         , EmployeeInitials3
         , CASE WHEN Decline1 IS NULL THEN 'NotApply' ELSE Decline1 END AS 'Decline1'
	FROM #final
	--ORDER BY AppointmentStartTime




END
