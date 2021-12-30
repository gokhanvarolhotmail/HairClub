/* CreateDate: 04/10/2014 12:09:19.497 , ModifyDate: 03/07/2017 18:44:52.607 */
GO
/***********************************************************************
PROCEDURE:				spSvc_BarthClientsExport
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		04/10/2014
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_BarthClientsExport
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_BarthClientsExport]
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


SELECT  DR.RegionSSID
,       DR.RegionDescription
,       CTR.CenterSSID
,       CTR.CenterDescriptionNumber AS 'CenterDescription'
,       DCT.CenterTypeDescriptionShort AS 'CenterType'
,       CASE WHEN CON.ContactSSID = '-2' THEN ''
             ELSE CON.ContactSSID
        END AS 'LeadID'
,       CLT.ClientKey
,       CLT.ClientIdentifier
,       CLT.ClientNumber_Temp AS 'CMSClientIdentifier'
,		REPLACE(CLT.ClientLastName, ',', '') AS 'LastName'
,		REPLACE(CLT.ClientFirstName, ',', '') AS 'FirstName'
,       REPLACE(CLT.ClientAddress1, ',', ' ') AS 'Address1'
,       REPLACE(CLT.ClientAddress2, ',', ' ') AS 'Address2'
,       REPLACE(CLT.City, ',', ' ') AS 'CityCode'
,       CLT.StateProvinceDescriptionShort AS 'StateCode'
,       CLT.PostalCode AS 'ZipCode'
,       CLT.ClientPhone1 AS 'HomePhoneNumber'
,       CLT.ClientPhone2 AS 'WorkPhoneNumber'
,       CLT.ClientEMailAddress AS 'EmailAddress'
,		ISNULL(C.IsAutoConfirmEmail, 0) AS 'IsAutoConfirmEmail'
,       DG.GenderSSID AS 'GenderSSID'
,       CLT.ClientDateOfBirth AS 'Birthday'
,       ISNULL(Active_Memberships.MembershipKey, All_Memberships.MembershipKey) AS 'MembershipKey'
,       ISNULL(Active_Memberships.MembershipSSID, All_Memberships.MembershipSSID) AS 'MembershipSSID'
,       ISNULL(Active_Memberships.Membership, All_Memberships.Membership) AS 'Membership'
,       ISNULL(Active_Memberships.MembershipDescriptionShort, All_Memberships.MembershipDescriptionShort) AS 'MembershipDescriptionShort'
,       ISNULL(Active_Memberships.ClientMembershipKey, All_Memberships.ClientMembershipKey) AS 'ClientMembershipKey'
,       ISNULL(Active_Memberships.ClientMembershipIdentifier, All_Memberships.ClientMembershipIdentifier) AS 'ClientMembershipIdentifier'
,       ISNULL(Active_Memberships.MembershipBeginDate, All_Memberships.MembershipBeginDate) AS 'MembershipBeginDate'
,       ISNULL(Active_Memberships.MembershipEndDate, All_Memberships.MembershipEndDate) AS 'MembershipEndDate'
,       ISNULL(Active_Memberships.ContractPrice, All_Memberships.ContractPrice) AS 'ContractPrice'
,       ISNULL(Active_Memberships.MonthlyFee, All_Memberships.MonthlyFee) AS 'MonthlyFee'
,       ISNULL(Active_Memberships.MembershipStatus, All_Memberships.MembershipStatus) AS 'MembershipStatus'
,       Cancel.CancelDate
,		REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Cancel.CancelReason, CHAR(9), ''), CHAR(10), ''), CHAR(13), ''), '''', ''), '{', ''), '}', ''), ',', '') AS 'CancelReason'
,       CLT.ClientARBalance AS 'ARBalance'
,       SUM(CASE WHEN DCMA.AccumulatorSSID IN ( 8 ) THEN DCMA.TotalAccumQuantity
                 ELSE 0
            END) AS 'SystemsAvailable'
,       SUM(CASE WHEN DCMA.AccumulatorSSID IN ( 8 ) THEN DCMA.UsedAccumQuantity
                 ELSE 0
            END) AS 'SystemsUsed'
,       SUM(CASE WHEN DCMA.AccumulatorSSID IN ( 9 ) THEN DCMA.TotalAccumQuantity
                 ELSE 0
            END) AS 'ServicesAvailable'
,       SUM(CASE WHEN DCMA.AccumulatorSSID IN ( 9 ) THEN DCMA.UsedAccumQuantity
                 ELSE 0
            END) AS 'ServicesUsed'
,       SUM(CASE WHEN DCMA.AccumulatorSSID IN ( 10 ) THEN DCMA.TotalAccumQuantity
                 ELSE 0
            END) AS 'SolutionsAvailable'
,       SUM(CASE WHEN DCMA.AccumulatorSSID IN ( 10 ) THEN DCMA.UsedAccumQuantity
                 ELSE 0
            END) AS 'SolutionsUsed'
,       SUM(CASE WHEN DCMA.AccumulatorSSID IN ( 11 ) THEN DCMA.TotalAccumQuantity
                 ELSE 0
            END) AS 'ProductKitsAvailable'
,       SUM(CASE WHEN DCMA.AccumulatorSSID IN ( 11 ) THEN DCMA.UsedAccumQuantity
                 ELSE 0
            END) AS 'ProductKitsUsed'
FROM    HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
		INNER JOIN SQL05.HairClubCMS.dbo.datClient C
			ON C.ClientIdentifier = CLT.ClientIdentifier
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
            ON CTR.CenterSSID = CLT.CenterSSID
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
            ON DCT.CenterTypeKey = CTR.CenterTypeKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
            ON DR.RegionKey = CTR.RegionKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimGender DG
            ON DG.GenderKey = CLT.GenderSSID
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact CON
            ON CON.ContactKey = CLT.contactkey
        OUTER APPLY ( SELECT TOP 1
                                DCM.ClientMembershipKey
                      ,         DCM.ClientMembershipSSID
                      ,         DM.MembershipKey
                      ,         DM.MembershipSSID
                      ,         DM.MembershipDescription AS 'Membership'
                      ,         DM.MembershipDescriptionShort
                      ,         DCM.ClientMembershipStatusDescription AS 'MembershipStatus'
                      ,         DM.MembershipSortOrder
                      ,         DCM.ClientMembershipContractPrice AS 'ContractPrice'
                      ,         DCM.ClientMembershipContractPaidAmount AS 'ContractPaidAmount'
                      ,         DCM.ClientMembershipMonthlyFee AS 'MonthlyFee'
                      ,         DCM.ClientMembershipBeginDate AS 'MembershipBeginDate'
                      ,         DCM.ClientMembershipEndDate AS 'MembershipEndDate'
                      ,         DM.BusinessSegmentSSID
                      ,         DM.RevenueGroupSSID
                      ,         DCM.ClientMembershipIdentifier
                      FROM      HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
                                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
                                    ON DM.MembershipKey = DCM.MembershipKey
                      WHERE     ( DCM.ClientMembershipSSID = CLT.CurrentBioMatrixClientMembershipSSID
                                  OR DCM.ClientMembershipSSID = CLT.CurrentExtremeTherapyClientMembershipSSID
                                  OR DCM.ClientMembershipSSID = CLT.CurrentSurgeryClientMembershipSSID
                                  OR DCM.ClientMembershipSSID = CLT.CurrentXtrandsClientMembershipSSID )
                                AND DCM.ClientMembershipStatusDescription = 'Active'
                      ORDER BY  DCM.ClientMembershipEndDate DESC
                    ) Active_Memberships
        OUTER APPLY ( SELECT TOP 1
                                DCM.ClientMembershipKey
                      ,         DCM.ClientMembershipSSID
                      ,         DM.MembershipKey
                      ,         DM.MembershipSSID
                      ,         DM.MembershipDescription AS 'Membership'
                      ,         DM.MembershipDescriptionShort
                      ,         DCM.ClientMembershipStatusDescription AS 'MembershipStatus'
                      ,         DM.MembershipSortOrder
                      ,         DCM.ClientMembershipContractPrice AS 'ContractPrice'
                      ,         DCM.ClientMembershipContractPaidAmount AS 'ContractPaidAmount'
                      ,         DCM.ClientMembershipMonthlyFee AS 'MonthlyFee'
                      ,         DCM.ClientMembershipBeginDate AS 'MembershipBeginDate'
                      ,         DCM.ClientMembershipEndDate AS 'MembershipEndDate'
                      ,         DM.BusinessSegmentSSID
                      ,         DM.RevenueGroupSSID
                      ,         DCM.ClientMembershipIdentifier
                      FROM      HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
                                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
                                    ON DM.MembershipKey = DCM.MembershipKey
                      WHERE     ( DCM.ClientMembershipSSID = CLT.CurrentBioMatrixClientMembershipSSID
                                  OR DCM.ClientMembershipSSID = CLT.CurrentExtremeTherapyClientMembershipSSID
                                  OR DCM.ClientMembershipSSID = CLT.CurrentSurgeryClientMembershipSSID
                                  OR DCM.ClientMembershipSSID = CLT.CurrentXtrandsClientMembershipSSID )
                      ORDER BY  DCM.ClientMembershipEndDate DESC
                    ) All_Memberships
        OUTER APPLY ( SELECT TOP 1
                                FST.ClientKey
                      ,         CM.ClientMembershipKey
                      ,         DSO.OrderDate AS 'CancelDate'
                      ,         DMOR.MembershipOrderReasonDescription AS 'CancelReason'
                      FROM      HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
                                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                                    ON FST.OrderDateKey = DD.DateKey
                                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
                                    ON FST.SalesCodeKey = DSC.SalesCodeKey
                                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
                                    ON FST.SalesOrderKey = DSO.SalesOrderKey
                                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD
                                    ON FST.SalesOrderDetailKey = DSOD.SalesOrderDetailKey
                                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
                                    ON DSO.ClientMembershipKey = CM.ClientMembershipKey
                                LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembershipOrderReason DMOR
                                    ON DSOD.MembershipOrderReasonID = DMOR.MembershipOrderReasonID
                      WHERE     DSC.SalesCodeDepartmentSSID IN ( 1099 )
                                AND FST.ClientKey = CLT.ClientKey
                                AND CM.ClientMembershipKey = ISNULL(Active_Memberships.ClientMembershipKey, All_Memberships.ClientMembershipKey)
                      ORDER BY  DSO.OrderDate DESC
                    ) Cancel
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembershipAccum DCMA
            ON DCMA.ClientMembershipKey = ISNULL(Active_Memberships.ClientMembershipKey, All_Memberships.ClientMembershipKey)
WHERE   CTR.CenterSSID IN ( 807, 804, 821, 745, 748, 806, 811, 805, 817, 746, 814, 747, 820, 822 )
GROUP BY DR.RegionSSID
,       DR.RegionDescription
,       CTR.CenterSSID
,       CTR.CenterDescriptionNumber
,       DCT.CenterTypeDescriptionShort
,       CASE WHEN CON.ContactSSID = '-2' THEN ''
             ELSE CON.ContactSSID
        END
,       CLT.ClientKey
,       CLT.ClientIdentifier
,       CLT.ClientNumber_Temp
,       CLT.ClientLastName
,       CLT.ClientFirstName
,       REPLACE(CLT.ClientAddress1, ',', ' ')
,       REPLACE(CLT.ClientAddress2, ',', ' ')
,       REPLACE(CLT.City, ',', ' ')
,       CLT.StateProvinceDescriptionShort
,       CLT.PostalCode
,       CLT.ClientPhone1
,       CLT.ClientPhone2
,       CLT.ClientEMailAddress
,		ISNULL(C.IsAutoConfirmEmail, 0)
,       DG.GenderSSID
,       CLT.ClientDateOfBirth
,       ISNULL(Active_Memberships.MembershipKey, All_Memberships.MembershipKey)
,       ISNULL(Active_Memberships.MembershipSSID, All_Memberships.MembershipSSID)
,       ISNULL(Active_Memberships.Membership, All_Memberships.Membership)
,       ISNULL(Active_Memberships.MembershipDescriptionShort, All_Memberships.MembershipDescriptionShort)
,       ISNULL(Active_Memberships.ClientMembershipKey, All_Memberships.ClientMembershipKey)
,       ISNULL(Active_Memberships.ClientMembershipIdentifier, All_Memberships.ClientMembershipIdentifier)
,       ISNULL(Active_Memberships.MembershipBeginDate, All_Memberships.MembershipBeginDate)
,       ISNULL(Active_Memberships.MembershipEndDate, All_Memberships.MembershipEndDate)
,       ISNULL(Active_Memberships.ContractPrice, All_Memberships.ContractPrice)
,       ISNULL(Active_Memberships.MonthlyFee, All_Memberships.MonthlyFee)
,       ISNULL(Active_Memberships.MembershipStatus, All_Memberships.MembershipStatus)
,       Cancel.CancelDate
,       Cancel.CancelReason
,       CLT.ClientARBalance
ORDER BY CTR.CenterSSID
,       CLT.ClientIdentifier

END
GO
