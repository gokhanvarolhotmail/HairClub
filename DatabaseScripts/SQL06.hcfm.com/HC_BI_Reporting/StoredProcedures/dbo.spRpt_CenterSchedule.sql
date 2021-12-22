/* CreateDate: 06/02/2017 13:22:36.417 , ModifyDate: 06/02/2017 15:35:34.130 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spRpt_CenterSchedule
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		6/2/2017
DESCRIPTION:			6/2/2017
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_CenterSchedule 201, '6/2/2017'

EXEC spRpt_CenterSchedule 270, '6/1/2017'
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_CenterSchedule]
(
	@CenterID INT,
	@DateScheduled DATETIME
)
AS
BEGIN

SET NOCOUNT ON;


CREATE TABLE #Center (
	CenterID INT
,	CenterName NVARCHAR(50)
,	CenterType NVARCHAR(10)
,	RegionID INT
,	RegionName NVARCHAR(100)
,	Address1 NVARCHAR(50)
,   Address2 NVARCHAR(50)
,   City NVARCHAR(50)
,   StateCode NVARCHAR(10)
,   ZipCode NVARCHAR(15)
,   Country NVARCHAR(100)
,	PhoneNumber NVARCHAR(15)
)

CREATE TABLE #CenterSchedule (
	CenterID INT
,	CenterDescription NVARCHAR(103)
,	FirstName NVARCHAR(50)
,	LastName NVARCHAR(50)
,	RecordType NVARCHAR(50)
)


INSERT  INTO #Center
		SELECT  CTR.CenterID
		,       CTR.CenterDescription
		,       CT.CenterTypeDescriptionShort AS 'CenterType'
		,       ISNULL(LR.RegionID, 1) AS 'RegionID'
		,       ISNULL(LR.RegionDescription, 'Corporate') AS 'RegionName'
		,       CTR.Address1
		,       CTR.Address2
		,       CTR.City
		,       LS.StateDescriptionShort AS 'StateCode'
		,       CTR.PostalCode AS 'ZipCode'
		,       LC.CountryDescription AS 'Country'
		,       CTR.Phone1 AS 'PhoneNumber'
		FROM    SQL05.HairClubCMS.dbo.cfgCenter CTR WITH ( NOLOCK )
				INNER JOIN SQL05.HairClubCMS.dbo.lkpCenterType CT WITH ( NOLOCK )
					ON CT.CenterTypeID = CTR.CenterTypeID
				INNER JOIN SQL05.HairClubCMS.dbo.lkpRegion LR WITH ( NOLOCK )
					ON LR.RegionID = CTR.RegionID
				INNER JOIN SQL05.HairClubCMS.dbo.lkpState LS WITH ( NOLOCK )
					ON LS.StateID = CTR.StateID
				INNER JOIN SQL05.HairClubCMS.dbo.lkpCountry LC WITH ( NOLOCK )
					ON LC.CountryID = CTR.CountryID
		WHERE   CONVERT(VARCHAR, CTR.CenterID) LIKE '[1278]%'
				AND CTR.IsActiveFlag = 1


INSERT  INTO #CenterSchedule
        SELECT  DISTINCT
                ctr.CenterID
        ,       ctr.CenterDescription AS 'CenterDescription'
        ,       clt.FirstName
        ,       clt.LastName
        ,       'Appointment' AS 'RecordType'
        FROM    SQL05.HairClubCMS.dbo.datAppointment da
                INNER JOIN SQL05.HairClubCMS.dbo.cfgCenter ctr WITH ( NOLOCK )
                    ON ctr.CenterID = da.CenterID
                INNER JOIN SQL05.HairClubCMS.dbo.datClient clt WITH ( NOLOCK )
                    ON clt.ClientGUID = da.ClientGUID
                LEFT OUTER JOIN SQL05.HairClubCMS.dbo.lkpAppointmentType lat WITH ( NOLOCK )
                    ON lat.AppointmentTypeID = da.AppointmentTypeID
        WHERE   da.AppointmentDate = CAST(@DateScheduled AS DATE)
                AND da.CenterID = @CenterID
                AND ISNULL(lat.AppointmentTypeDescriptionShort, '') <> 'BosleyAppt'
                AND da.OnContactActivityID IS NULL
                AND da.IsDeletedFlag = 0


INSERT  INTO #CenterSchedule
		SELECT	ISNULL(C.cst_center_number, LC.cst_center_number) AS 'CenterID'
		,		ISNULL(C.company_name_1, LC.company_name_1) AS 'CenterDescription'
		,		OC.first_name AS 'FirstName'
		,		OC.last_name AS 'LastName'
		,       'Consultation' AS 'RecordType'
		FROM    SQL05.HCM.dbo.oncd_activity OA WITH ( NOLOCK )
				INNER JOIN SQL05.HCM.dbo.oncd_activity_contact OAC WITH ( NOLOCK )
					ON OAC.activity_id = OA.activity_id
				INNER JOIN SQL05.HCM.dbo.oncd_contact OC WITH ( NOLOCK )
					ON OC.contact_id = OAC.contact_id
				LEFT OUTER JOIN SQL05.HCM.dbo.oncd_contact_company CC WITH ( NOLOCK ) -- Lead Center Join
					ON CC.contact_id = OC.contact_id
						AND CC.primary_flag = 'Y'
				LEFT OUTER JOIN SQL05.HCM.dbo.oncd_company LC WITH ( NOLOCK ) -- Lead Center
					ON LC.company_id = CC.company_id
				LEFT OUTER JOIN SQL05.HCM.dbo.oncd_activity_company AC WITH ( NOLOCK )  -- Activity Center Join
					ON AC.activity_id = OA.activity_id
						AND AC.primary_flag = 'Y'
				LEFT OUTER JOIN SQL05.HCM.dbo.oncd_company C WITH ( NOLOCK ) -- Activity Center
					ON C.company_id = AC.company_id
		WHERE   OA.due_date = CAST(@DateScheduled AS DATE)
				AND ISNULL(C.cst_center_number, LC.cst_center_number) = @CenterID
				AND OA.action_code IN ( 'APPOINT' )


SELECT  c.CenterID
,       c.CenterName
,       c.CenterType
,       c.RegionID
,       c.RegionName
,       c.Address1
,       c.Address2
,       c.City
,       c.StateCode
,       c.ZipCode
,       c.Country
,       c.PhoneNumber
,       UPPER(cs.LastName) AS 'LastName'
,       UPPER(cs.FirstName) AS 'FirstName'
,       cs.RecordType
,		@DateScheduled AS 'DateScheduled'
FROM    #CenterSchedule cs
        INNER JOIN #Center c
            ON c.CenterID = cs.CenterID
--ORDER BY cs.LastName
--,       cs.FirstName

END
GO
