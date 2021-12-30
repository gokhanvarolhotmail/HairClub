/* CreateDate: 02/09/2021 15:14:10.543 , ModifyDate: 02/09/2021 15:14:10.543 */
GO
-- =============================================
-- Author:		rrojas
-- Create date: 01/01/2021 TFS14795
-- Description:	get clients by center type
-- =============================================
create PROCEDURE spRptGetClientsByCenterType
	-- Add the parameters for the stored procedure here
	@centerType nvarchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT DISTINCT
       ISNULL(cma.CenterManagementAreaDescription, 'Corporate') AS 'Area'
,            ctr.CenterNumber
,            ctr.CenterDescriptionFullCalc AS 'CenterName'
,             ct.CenterTypeDescription AS 'CenterType'
,             clt.SalesforceContactID AS 'SFDC_LeadID'
--,          clt.ClientIdentifier
,            clt.FirstName
,            clt.LastName
,             ISNULL(lg.GenderDescription, 'Male') AS 'Gender'
,            ISNULL(l.LanguageDescription, 'English') AS 'Language'
,            clt.EMailAddress
,             ISNULL(clt.DoNotContactFlag, 0) AS 'DoNotContactFlag'
FROM   datClientMembership cm
             INNER JOIN datClient clt  ON clt.ClientGUID = cm.ClientGUID
             INNER JOIN cfgCenter ctr  ON ctr.CenterID = clt.CenterID
			 INNER JOIN lkpCenterType ct  ON ct.CenterTypeID = ctr.CenterTypeID
             INNER JOIN cfgMembership m  ON m.MembershipID = cm.MembershipID
             INNER JOIN lkpBusinessSegment bs  ON bs.BusinessSegmentID = m.BusinessSegmentID
			 INNER JOIN lkpRevenueGroup rg  ON rg.RevenueGroupID = m.RevenueGroupID
			 INNER JOIN lkpClientMembershipStatus cms  ON cms.ClientMembershipStatusID = cm.ClientMembershipStatusID
             LEFT OUTER JOIN lkpGender lg ON lg.GenderID = clt.GenderID
             LEFT OUTER JOIN lkpLanguage l  ON l.LanguageID = clt.LanguageID
             LEFT OUTER JOIN cfgCenterManagementArea cma  ON cma.CenterManagementAreaID = ctr.CenterManagementAreaID
WHERE        m.MembershipDescriptionShort NOT IN ( 'SHOWSALE', 'SNSSURGOFF', 'SHOWNOSALE', 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP', 'MODEL', 'MODELEXT', 'MODELXTR', 'MDLEXTUG', 'MDLEXTUGSL' )
             AND cms.ClientMembershipStatusDescription = 'Active'
             AND LEN(clt.EMailAddress) > 0
			 AND ct.CenterTypeDescriptionShort in (SELECT value
													FROM STRING_SPLIT(@centerType, ',')
													WHERE RTRIM(value) <> '')

END
GO
