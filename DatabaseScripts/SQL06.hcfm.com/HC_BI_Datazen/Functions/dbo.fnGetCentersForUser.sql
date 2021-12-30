/* CreateDate: 07/22/2015 14:24:35.567 , ModifyDate: 07/22/2015 14:26:31.907 */
GO
/***********************************************************************
NAME:					fnGetCentersForUser
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Dominic Leiba
------------------------------------------------------------------------
NOTES:
------------------------------------------------------------------------
CHANGE HISTORY:
10/21/2013 - DL - Created function to return centers based on a user name
------------------------------------------------------------------------
USAGE:
------------------------------------------------------------------------

SELECT * FROM dbo.fnGetCentersForUser('dleiba')
***********************************************************************/
CREATE FUNCTION [dbo].[fnGetCentersForUser]
(
	@UserID VARCHAR(50)
)
RETURNS @Centers TABLE (
	CenterType NVARCHAR(50)
,	RegionName NVARCHAR(50)
,	CenterSSID INT
,	CenterName NVARCHAR(255)
,   Country NVARCHAR(10)
,	Manager NVARCHAR(50)
,	NB_RSM NVARCHAR(50)
,	MA_RSM NVARCHAR(50)
,	RTM NVARCHAR(50)
,	UNIQUE CLUSTERED (CenterSSID)
)
AS
BEGIN

INSERT	INTO @Centers
SELECT  DCT.CenterTypeDescriptionShort AS 'CenterType'
,       DR.RegionDescription AS 'RegionName'
,       DC.CenterSSID
,       DC.CenterDescriptionNumber AS 'CenterName'
,       DC.CountryRegionDescriptionShort AS 'Country'
,       ISNULL(CMD.UserLogin, '') AS 'Manager'
,       NB_RSM.UserLogin AS 'NB_RSM'
,       MA_RSM.UserLogin AS 'MA_RSM'
,       RTM.UserLogin AS 'RTM'
FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
            ON DC.CenterTypeKey = DCT.CenterTypeKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
            ON DC.RegionSSID = DR.RegionKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
            ON DE.CenterSSID = DC.CenterSSID
               OR DE.CenterSSID = 100
        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee NB_RSM
            ON NB_RSM.EmployeeSSID = DC.RegionRSMNBConsultantSSID
        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee MA_RSM
            ON MA_RSM.EmployeeSSID = DC.RegionRSMMembershipAdvisorSSID
        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee RTM
            ON RTM.EmployeeSSID = DC.RegionRTMTechnicalManagerSSID
        OUTER APPLY ( SELECT TOP 1
                                DE.CenterID AS 'CenterSSID'
                      ,         DE.UserLogin
                      FROM      SQL05.HairClubCMS.dbo.datEmployee DE
                                INNER JOIN SQL05.HairClubCMS.dbo.cfgEmployeePositionJoin CEPJ
                                    ON CEPJ.EmployeeGUID = DE.EmployeeGUID
                                INNER JOIN SQL05.HairClubCMS.dbo.lkpEmployeePosition LEP
                                    ON LEP.EmployeePositionID = CEPJ.EmployeePositionID
                      WHERE     LEP.EmployeePositionID = 6
                                AND ISNULL(DE.CenterID, 100) <> 100
                                AND DE.CenterID = DC.CenterSSID
                                AND DE.FirstName NOT IN ( 'EC', 'Test' )
                                AND DE.IsActiveFlag = 1
                      ORDER BY  DE.CenterID
                      ,         DE.EmployeePayrollID DESC
                    ) CMD
WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
        AND DC.Active = 'Y'
		AND ( DE.UserLogin = @UserID
		OR CMD.UserLogin = @UserID
		OR NB_RSM.UserLogin = @UserID
		OR MA_RSM.UserLogin = @UserID
		OR RTM.UserLogin = @UserID )
UNION
SELECT  DCT.CenterTypeDescriptionShort AS 'CenterType'
,       DR.RegionDescription AS 'RegionName'
,       DC.CenterSSID
,       DC.CenterDescriptionNumber AS 'CenterName'
,       DC.CountryRegionDescriptionShort AS 'Country'
,       ISNULL(CMD.UserLogin, '') AS 'Manager'
,       NB_RSM.UserLogin AS 'NB_RSM'
,       MA_RSM.UserLogin AS 'MA_RSM'
,       RTM.UserLogin AS 'RTM'
FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
            ON DC.CenterTypeKey = DCT.CenterTypeKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
            ON DC.RegionKey = DR.RegionKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
            ON DE.CenterSSID = DC.CenterSSID
               OR DE.CenterSSID = 100
        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee NB_RSM
            ON NB_RSM.EmployeeSSID = DC.RegionRSMNBConsultantSSID
        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee MA_RSM
            ON MA_RSM.EmployeeSSID = DC.RegionRSMMembershipAdvisorSSID
        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee RTM
            ON RTM.EmployeeSSID = DC.RegionRTMTechnicalManagerSSID
        OUTER APPLY ( SELECT TOP 1
                                DE.CenterID AS 'CenterSSID'
                      ,         DE.UserLogin
                      FROM      SQL05.HairClubCMS.dbo.datEmployee DE
                                INNER JOIN SQL05.HairClubCMS.dbo.cfgEmployeePositionJoin CEPJ
                                    ON CEPJ.EmployeeGUID = DE.EmployeeGUID
                                INNER JOIN SQL05.HairClubCMS.dbo.lkpEmployeePosition LEP
                                    ON LEP.EmployeePositionID = CEPJ.EmployeePositionID
                      WHERE     LEP.EmployeePositionID = 6
                                AND ISNULL(DE.CenterID, 100) <> 100
                                AND DE.CenterID = DC.CenterSSID
                                AND DE.FirstName NOT IN ( 'EC', 'Test' )
                                AND DE.IsActiveFlag = 1
                      ORDER BY  DE.CenterID
                      ,         DE.EmployeePayrollID DESC
                    ) CMD
WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[78]%'
        AND DC.Active = 'Y'
		AND ( DE.UserLogin = @UserID
		OR CMD.UserLogin = @UserID
		OR NB_RSM.UserLogin = @UserID
		OR MA_RSM.UserLogin = @UserID
		OR RTM.UserLogin = @UserID )
ORDER BY DC.CenterSSID

RETURN

END
GO
