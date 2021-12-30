/* CreateDate: 10/12/2016 11:42:43.020 , ModifyDate: 10/12/2016 11:53:58.390 */
GO
/***********************************************************************
PROCEDURE:				spSvc_GetFacebookAudienceClientData
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_GetFacebookAudienceClientData
***********************************************************************/
CREATE PROCEDURE spSvc_GetFacebookAudienceClientData
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


TRUNCATE TABLE tmpFacebookAudienceClients


INSERT  INTO tmpFacebookAudienceClients (
			ClientIdentifier
        ,	EmailAddress
        ,	PhoneNumber1
        ,	PhoneNumber2
        ,	PhoneNumber3
		)
		-- Clients
        SELECT  clt.ClientIdentifier
        ,       clt.ClientEMailAddress AS 'EmailAddress'
        ,       clt.ClientPhone1
        ,       clt.ClientPhone2
        ,       clt.ClientPhone3
        FROM    HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership dcm
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership dm
                    ON dm.MembershipSSID = dcm.MembershipSSID
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
                    ON clt.ClientSSID = dcm.ClientSSID
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
                    ON ctr.CenterSSID = clt.CenterSSID
        WHERE   clt.CenterSSID LIKE '[278]%'
                AND dm.MembershipSSID NOT IN ( 42, 57, 58 )
                AND dcm.ClientMembershipStatusDescription = 'Active'
                AND dcm.ClientMembershipEndDate >= DATEADD(DAY, -0, CONVERT(VARCHAR(11), GETDATE(), 101))

END
GO
