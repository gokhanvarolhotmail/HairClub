/* CreateDate: 06/19/2018 16:46:06.637 , ModifyDate: 06/20/2018 16:50:00.517 */
GO
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO


		/***********************************************************************

		PROCEDURE:				rptMemberWOFutureAppointment_SP

		DESTINATION SERVER:		SQL01

		DESTINATION DATABASE: 	HairClubCMS

		RELATED APPLICATION:  	CMS

		AUTHOR:

		IMPLEMENTOR:

		DATE IMPLEMENTED:

		LAST REVISION DATE: 	 06/18/2018

		--------------------------------------------------------------------------------------------------------
		NOTES:
		--------------------------------------------------------------------------------------------------------
		SAMPLE EXECUTION:

        exec [dbo].[rptMemberWOFutureAppointment_sp] 'C', '1', '1'
		***********************************************************************/




CREATE PROCEDURE [dbo].[rptMemberWOFutureAppointment_SP]
(
	@sType CHAR(1),
    @Filter INT
,	@BusinessSegment INT
)
AS
BEGIN

--DECLARE @sType NVARCHAR(1), @Filter INT, @CenterID INT, @BusinessSegment INT


--SET @CenterID = 250
--SET @sType = 'C'
--SET @Filter = 1
--SET @BusinessSegment = 1


--IF OBJECT_ID('tempdb..#ClientMembership') IS NOT NULL
--   DROP TABLE #ClientMembership
--IF OBJECT_ID('tempdb..#ClientPhone') IS NOT NULL
--   DROP TABLE #ClientPhone
--IF OBJECT_ID('tempdb..#Payment') IS NOT NULL
--   DROP TABLE #Payment
--IF OBJECT_ID('tempdb..#Client') IS NOT NULL
--   DROP TABLE #Client
--IF OBJECT_ID('tempdb..#stylist') IS NOT NULL
--   DROP TABLE #stylist
--IF OBJECT_ID('tempdb..#LastVisit') IS NOT NULL
--   DROP TABLE #LastVisit
--IF OBJECT_ID('tempdb..#Centers') IS NOT NULL
--   DROP TABLE #Centers


CREATE TABLE #ClientMembership (
       ClientMembershipGUID UNIQUEIDENTIFIER
,      ClientGUID UNIQUEIDENTIFIER
,      Membership NVARCHAR(50)
,      BusinessSegment NVARCHAR(100)
,      RevenueGroup NVARCHAR(100)
,      BeginDate DATETIME
,      EndDate DATETIME
,      MembershipStatus NVARCHAR(100)
,      CenterID INT
)

CREATE TABLE #ClientPhone (
       ClientGUID UNIQUEIDENTIFIER
,      PhoneNumber NVARCHAR(15)
,      PhoneType NVARCHAR(100)
,      CanConfirmAppointmentByCall BIT
,      CanConfirmAppointmentByText BIT
,      CanContactForPromotionsByCall BIT
,      CanContactForPromotionsByText BIT
,      ClientPhoneSortOrder INT
)

CREATE TABLE #Payment (
       ClientGUID UNIQUEIDENTIFIER
,      ClientMembershipGUID UNIQUEIDENTIFIER
,      SalesOrderGUID UNIQUEIDENTIFIER
,      LastPaymentDate DATETIME
,      SalesCode NVARCHAR(15)
,      SalesCodeDescription NVARCHAR(50)
)


CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroupDescription NVARCHAR(50)
,	CenterID INT
,	CenterDescription NVARCHAR(50)
,	CenterDescriptionFullCalc NVARCHAR(104)
,	CenterAreaManagementID INT
,	CenterAreaManagementDescription NVARCHAR(50)
,	CenterAreaManagementSortOrder INT
)

/********************************** Get list of centers *************************************/
IF (@sType = 'C' AND @Filter = 1)  --By Regions
BEGIN
INSERT  INTO #Centers
		SELECT  R.RegionID AS 'MainGroupID'
		,		R.RegionDescription AS 'MainGroupDescription'
		,		C.CenterID
		,		C.CenterDescription
		,		C.CenterDescriptionFullCalc
		,		CMA.CenterManagementAreaID
		,		CMA.CenterManagementAreaDescription
		,		CMA.CenterManagementAreaSortOrder
		FROM    cfgCenter C
				INNER JOIN dbo.cfgCenterManagementArea CMA
					ON C.CenterManagementAreaID = CMA.CenterManagementAreaID
				INNER JOIN lkpRegion R
					ON C.RegionID = R.RegionID
		WHERE   CONVERT(VARCHAR, C.CenterNumber) LIKE '[2]%'
				AND C.IsActiveFlag = 1
END

IF (@sType = 'C' AND @Filter = 2)  --By Areas
BEGIN
INSERT  INTO #Centers
		SELECT  CMA.CenterManagementAreaID AS 'MainGroupID'
		,		CMA.CenterManagementAreaDescription AS 'MainGroupDescription'
		,		C.CenterID
		,		C.CenterDescription
		,		C.CenterDescriptionFullCalc
		,		CMA.CenterManagementAreaID
		,		CMA.CenterManagementAreaDescription
		,		CMA.CenterManagementAreaSortOrder
		FROM    cfgCenter C
			INNER JOIN dbo.cfgCenterManagementArea CMA
				ON CMA.CenterManagementAreaID = C.CenterManagementAreaID
		WHERE   CMA.IsActiveFlag = 1
END
IF (@sType = 'C' AND @Filter = 3)  -- By Centers
BEGIN
INSERT  INTO #Centers
		SELECT  C.CenterID AS 'MainGroupID'
		,		C.CenterDescriptionFullCalc AS 'MainGroupDescription'
		,		C.CenterID
		,		C.CenterDescription
		,		C.CenterDescriptionFullCalc
		,		CMA.CenterManagementAreaID
		,		CMA.CenterManagementAreaDescription
		,		CMA.CenterManagementAreaSortOrder
		FROM    cfgCenter C
				INNER JOIN dbo.cfgCenterManagementArea CMA
					ON C.CenterManagementAreaID = CMA.CenterManagementAreaID
				INNER JOIN lkpRegion R
					ON C.RegionID = R.RegionID
		WHERE   CONVERT(VARCHAR, C.CenterNumber) LIKE '[2]%'
				AND C.IsActiveFlag = 1
END


IF @sType = 'F'  --Always By Regions for Franchises
BEGIN
INSERT  INTO #Centers
		SELECT  R.RegionID AS 'MainGroupID'
		,		R.RegionDescription AS 'MainGroupDescription'
		,		C.CenterID
		,		C.CenterDescription
		,		C.CenterDescriptionFullCalc
		,		NULL AS CenterManagementAreaID
		,		NULL AS CenterManagementAreaDescription
		,		NULL AS CenterManagementAreaSortOrder
		FROM    cfgCenter C
				INNER JOIN lkpRegion R
					ON C.RegionID = R.RegionID
		WHERE   CONVERT(VARCHAR, C.CenterNumber) LIKE '[78]%'
				AND C.IsActiveFlag = 1
END



/********************************** Get Client Membership Data *************************************/
INSERT INTO #ClientMembership
              SELECT  dcm.ClientMembershipGUID
              ,             dcm.ClientGUID
              ,             cm.MembershipDescription AS 'Membership'
              ,             bs.BusinessSegmentDescription AS 'BusinessSegment'
              ,             rg.RevenueGroupDescription AS 'RevenueGroup'
              ,             dcm.BeginDate
              ,             dcm.EndDate
              ,             cms.ClientMembershipStatusDescription AS 'MembershipStatus'
			  ,             c.centerid
              FROM    datClientMembership dcm WITH ( NOLOCK )
                           INNER JOIN datClient clt WITH ( NOLOCK )
                                  ON clt.ClientGUID = dcm.ClientGUID
                           INNER JOIN cfgMembership cm WITH ( NOLOCK )
                                  ON cm.MembershipID = dcm.MembershipID
                           INNER JOIN lkpClientMembershipStatus cms WITH ( NOLOCK )
                                  ON cms.ClientMembershipStatusID = dcm.ClientMembershipStatusID
                           INNER JOIN lkpRevenueGroup rg WITH ( NOLOCK )
                                  ON rg.RevenueGroupID = cm.RevenueGroupID
                           INNER JOIN lkpBusinessSegment bs WITH ( NOLOCK )
                                  ON bs.BusinessSegmentID = cm.BusinessSegmentID

						   INNER JOIN #Centers c WITH ( NOLOCK )
								  ON c.CenterID = clt.CenterID

			  WHERE       -- clt.CenterID in (select CenterID from #Centers) AND
                            cm.BusinessSegmentID = @BusinessSegment
                           AND cm.MembershipDescriptionShort NOT IN ( 'SHOWNOSALE', 'SNSSURGOFF', 'EMPLOYEE', 'EMPLOYEXT', 'MODELEXT', 'EMPLOYXTR', 'MODELXTR', 'RETAIL' )
                           AND cms.ClientMembershipStatusDescription = 'Active' -- Memberships with Active status
                           AND dcm.EndDate >= GETDATE()


/********************************** Get Client Phone Data *************************************/
--INSERT INTO #ClientPhone
--              SELECT  dcp.ClientGUID
--              ,       dcp.PhoneNumber
--              ,       pt.PhoneTypeDescription AS 'PhoneType'
--              ,       dcp.CanConfirmAppointmentByCall
--              ,       dcp.CanConfirmAppointmentByText
--              ,       dcp.CanContactForPromotionsByCall
--              ,       dcp.CanContactForPromotionsByText
--              ,       dcp.ClientPhoneSortOrder
--              FROM    datClientPhone dcp WITH ( NOLOCK )
--                           INNER JOIN #ClientMembership cm
--                                  ON cm.ClientGUID = dcp.ClientGUID
--                           INNER JOIN lkpPhoneType pt WITH ( NOLOCK )
--                                  ON pt.PhoneTypeID = dcp.PhoneTypeID
--              WHERE  pt.PhoneTypeDescription IN ( 'Home', 'Work' )
--			  ORDER BY 1


/********************************** Get Payment Data *************************************/
--INSERT INTO #Payment
--              SELECT  cm.ClientGUID
--              ,       cm.ClientMembershipGUID
--              ,       x_Lp.SalesOrderGUID
--              ,       x_Lp.OrderDate
--              ,       x_Lp.SalesCodeDescriptionShort
--              ,       x_Lp.SalesCodeDescription
--              FROM    #ClientMembership cm
--                           CROSS APPLY ( SELECT TOP 1
--                                                            so.SalesOrderGUID
--                                                  ,         so.OrderDate
--                                                  ,         sc.SalesCodeDescriptionShort
--                                                  ,         sc.SalesCodeDescription
--                                                  FROM      datSalesOrder so
--                                                                     INNER JOIN datSalesOrderDetail sod
--                                                                           ON sod.SalesOrderGUID = so.SalesOrderGUID
--                                                                     INNER JOIN cfgSalesCode sc
--                                                                           ON sc.SalesCodeID = sod.SalesCodeID
--                                                  WHERE     so.ClientGUID = cm.ClientGUID
--                                                                     AND sc.SalesCodeDepartmentID IN ( 2020, 2025 )
--                                                                     AND so.IsVoidedFlag = 0
--                                                  ORDER BY  so.OrderDate DESC
--                                                ) x_Lp



/********************************** Get Client Data *************************************/
SELECT clt.ClientFullNameCalc AS 'ClientName'
,             cm.Membership
,             cm.EndDate
,             cm.MembershipStatus
,             clt.ARBalance
--,             CASE WHEN CONVERT(VARCHAR(11), clt.AnniversaryDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), clt.AnniversaryDate, 101) END AS 'AnniversaryDate'
--,             CASE WHEN CONVERT(VARCHAR(11), clt.AnniversaryDate, 101) = '01/01/1900' THEN 0 ELSE DATEDIFF(YEAR, clt.AnniversaryDate, GETDATE()) END AS 'Years'
,             CASE WHEN YEAR(clt.AnniversaryDate) = '1900' THEN '' ELSE CONVERT(VARCHAR(11), clt.AnniversaryDate, 101) END AS 'AnniversaryDate'
,             CASE WHEN CONVERT(VARCHAR(11), clt.AnniversaryDate, 101) = '01/01/1900' THEN 0
		           WHEN YEAR(clt.AnniversaryDate) = '1900' THEN 0
			       WHEN isnull(clt.AnniversaryDate, '') = '' THEN 0
			       ELSE DATEDIFF(YEAR, clt.AnniversaryDate, GETDATE()) END AS 'Years'
--,             o_Hp.PhoneNumber AS 'HomePhoneNumber'
--,             o_Wp.PhoneNumber AS 'WorkPhoneNumber'
--,             dbo.fn_GetPreviousAppointmentDate(cm.ClientMembershipGUID) AS 'LastAppointmentDate'
--,             dbo.GetLocalFromUTC(p.LastPaymentDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) AS 'LastPaymentDate'
--,             p.SalesCode AS 'LastPaymentCode'
--,             p.SalesCodeDescription AS 'LastPaymentCodeDescription'
--,             o_Tt.TenderType
--,             o_Tt.TenderAmount
,             cm.ClientGUID
,             cm.CenterID
INTO    #Client
FROM    datClient clt
        INNER JOIN #ClientMembership cm
            ON cm.ClientGUID = clt.ClientGUID
--        INNER JOIN cfgCenter ctr
--            ON ctr.CenterID = clt.CenterID
        --INNER JOIN lkpTimeZone tz
        --   ON tz.TimeZoneID = ctr.TimeZoneID
        --LEFT OUTER JOIN #stylist s
		--    ON cm.ClientGUID = s.ClientGUID --and s.LastVisitDate = dbo.fn_GetPreviousAppointmentDate(cm.ClientMembershipGUID)
        --LEFT OUTER JOIN #Payment p
        --    ON p.ClientGUID = clt.ClientGUID
        --       AND p.ClientMembershipGUID = cm.ClientMembershipGUID
        --OUTER APPLY ( SELECT TOP 1
        --                        cp.PhoneNumber
        --              FROM      #ClientPhone cp
        --              WHERE     cp.PhoneType = 'Home'
        --              ORDER BY  cp.ClientPhoneSortOrder
        --            ) o_Hp
        --OUTER APPLY ( SELECT TOP 1
        --                        cp.PhoneNumber
        --              FROM      #ClientPhone cp
        --              WHERE     cp.PhoneType = 'Work'
        --              ORDER BY  cp.ClientPhoneSortOrder
        --            ) o_Wp
        --OUTER APPLY ( SELECT    sot_B.SalesOrderGUID
        --              ,         STUFF(( SELECT  ', '
        --                                        + ltt.TenderTypeDescription
        --                                FROM    datSalesOrderTender sot_A
        --                                        INNER JOIN lkpTenderType ltt
        --                                            ON ltt.TenderTypeID = sot_A.TenderTypeID
        --                                WHERE   sot_A.SalesOrderGUID = sot_B.SalesOrderGUID
        --                              FOR XML PATH('')), 1, 1, '') AS 'TenderType'
        --              ,         SUM(sot_B.Amount) AS 'TenderAmount'
        --              FROM      datSalesOrderTender sot_B
        --              WHERE     sot_B.SalesOrderGUID = p.SalesOrderGUID
        --                        AND sot_B.Amount > 0
        --              GROUP BY  sot_B.SalesOrderGUID
        --            ) o_Tt



--select * from #client where clientguid = 'CAC83FAC-BB3E-44C2-A723-0E2DEAE75656'

--Get Last AppointmentDate & Stylist
SELECT q.ClientGUID
,	   q.LastVisitDate
,	   q.LastStylist
INTO #LastVisit
FROM(
		SELECT	ROW_NUMBER() OVER ( PARTITION BY MBR.ClientGUID ORDER BY MBR.ClientGUID, APPT.AppointmentDate DESC ) AS Ranking
		,   MBR.ClientGUID
		,	APPT.AppointmentDate AS 'LastVisitDate'
		,	E.EmployeeInitials AS 'LastStylist'
		FROM	datAppointment APPT
				INNER JOIN #Client MBR
					ON APPT.ClientGUID = MBR.ClientGUID
				--INNER JOIN dbo.datClientMembership CM
					--ON APPT.ClientMembershipGUID = CM.ClientMembershipGUID
				LEFT OUTER JOIN dbo.datAppointmentEmployee AE
					ON APPT.AppointmentGUID = AE.AppointmentGUID
				LEFT OUTER JOIN dbo.datEmployee E
					ON AE.EmployeeGUID = E.EmployeeGUID
		WHERE   APPT.IsDeletedFlag = 0
		AND APPT.AppointmentDate < GETDATE()
		AND APPT.CheckoutTime IS NOT NULL
		GROUP BY MBR.ClientGUID
		,	APPT.AppointmentDate
		,	E.EmployeeInitials
	)q
WHERE Ranking = 1
--and clientguid = 'EB414277-7003-49BA-BB6F-8FA07AA10F09'


/********************************** Display Client Data *************************************/
SELECT  c.ClientName as 'ClientFullNameCalc'
,       c.Membership as 'CurrentMembership'
,       c.EndDate
,       c.MembershipStatus
,       c.ARBalance
,       c.AnniversaryDate
,       c.Years
--,       c.HomePhoneNumber as 'HomePhone'
--,       c.WorkPhoneNumber as 'WorkPhone'
--,       c.LastAppointmentDate   --last membership appointmentdate
,       l.LastVisitDate  as 'LastAppointmentDate'         --last client appointmentdate
,       DATEDIFF(DAY, l.LastVisitDate, GETDATE()) AS 'DaysSinceLastApt'
--,       c.LastPaymentDate
--,       c.LastPaymentCode
--,       c.LastPaymentCodeDescription as 'SalesCodeDescription'
--,       c.TenderType  as 'TenderTypeDescription'
--,       c.TenderAmount
,	    l.LastStylist
,       c.CenterID

FROM    #Client c
			LEFT OUTER JOIN #LastVisit l
			ON c.clientguid = l.clientguid
--where c.clientguid = 'CAC83FAC-BB3E-44C2-A723-0E2DEAE75656'
ORDER BY CenterID
END



/*
declare @AnnDt datetime
set @AnnDt = '01/01/1900'

select  CASE WHEN CONVERT(VARCHAR(11), @anndt, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), @anndt, 101) END AS 'AnniversaryDate',
        CASE WHEN CONVERT(VARCHAR(11), @anndt, 101) = '01/01/1900'
		     WHEN THEN 0 ELSE DATEDIFF(YEAR, @anndt, GETDATE()) END AS 'Years'

select AnniversaryDate, clientguid from datClient where lastname = 'Habert' and firstname = 'Joey'

select  CASE WHEN CONVERT(VARCHAR(11), AnniversaryDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), AnniversaryDate, 101) END AS 'AnniversaryDate',
        CASE WHEN CONVERT(VARCHAR(11), AnniversaryDate, 101) = '01/01/1900' THEN 0
		     WHEN YEAR(AnniversaryDate) = '1900' THEN 0
			 WHEN isnull(AnniversaryDate, '') = '' THEN 0
			 ELSE DATEDIFF(YEAR, AnniversaryDate, GETDATE()) END AS 'Years'
from datClient

where lastname = 'Habert' and firstname = 'Joey'


		Plerqui, Angel (26200)
		Freundlich, Jerry (25909)
		*/
GO
