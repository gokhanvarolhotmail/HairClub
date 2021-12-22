/* CreateDate: 04/10/2014 12:08:56.480 , ModifyDate: 08/07/2018 16:48:33.127 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSvc_BarthClientMembershipsExport
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		04/10/2014
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_BarthClientMembershipsExport
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_BarthClientMembershipsExport]
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


/********************************** Get Client Membership Data *************************************/
SELECT  CTR.CenterSSID
,		CTR.CenterDescriptionNumber AS 'CenterDescription'
,		DC.ClientIdentifier
,		DC.ClientNumber_Temp AS 'ClientIdentifierCMS'
,		REPLACE(DC.ClientFirstName, ',', '') AS 'FirstName'
,		REPLACE(DC.ClientLastName, ',', '') AS 'LastName'
,		DCM.ClientMembershipKey
,		DCM.ClientMembershipIdentifier
,		DM.MembershipKey
,		DM.MembershipSSID
,		DM.MembershipDescriptionShort
,		DM.MembershipDescription
,		DCM.ClientMembershipBeginDate AS 'MembershipStartDate'
,		DCM.ClientMembershipEndDate AS 'MembershipEndDate'
,		DCM.ClientMembershipMonthlyFee AS 'MonthlyFee'
,		DCM.ClientMembershipContractPrice AS 'ContractPrice'
,		DCM.ClientMembershipContractPaidAmount AS 'ContractPaidAmount'
,		DCM.ClientMembershipStatusSSID
,		DCM.ClientMembershipStatusDescription
,		ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(cm.MembershipCancelReasonDescription, CHAR(9), ''), CHAR(10), ''), CHAR(13), ''), '''', ''), '{', ''), '}', ''), ',', '') , '') AS 'CancelReasonManual'
FROM    HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
		INNER JOIN SQL05.HairClubCMS.dbo.datClientMembership cm
			ON cm.ClientMembershipGUID = DCM.ClientMembershipSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient DC
			ON DCM.ClientSSID = DC.ClientSSID
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
            ON DC.CenterSSID = CTR.CenterSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
			ON DCM.MembershipSSID = DM.MembershipSSID
WHERE	CTR.CenterSSID IN ( 807, 804, 821, 745, 748, 806, 811, 805, 817, 746, 814, 747, 820, 822 )
		AND DM.MembershipKey NOT IN ( 95 )
		AND dcm.ClientMembershipBeginDate >= '1/1/2013'

END
GO
