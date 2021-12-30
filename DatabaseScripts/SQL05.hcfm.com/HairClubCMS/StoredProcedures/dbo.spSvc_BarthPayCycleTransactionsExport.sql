/* CreateDate: 04/23/2015 15:25:32.880 , ModifyDate: 03/07/2017 18:39:39.547 */
GO
/***********************************************************************
PROCEDURE:				spSvc_BarthPayCycleTransactionsExport
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HairClubCMS
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		04/10/2014
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_BarthPayCycleTransactionsExport
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_BarthPayCycleTransactionsExport]
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


/********************************** Get Data *************************************/
SELECT  cfb.CenterID AS 'CenterSSID'
,       pc.FeePayCycleDescription AS 'PayCycleDescription'
,       cfb.FeeMonth
,       cfb.FeeYear
,       cfb.RunDate
,       CASE WHEN pct.CenterDeclineBatchGUID IS NULL THEN 0
             ELSE 1
        END AS IsDeclineBatch
,       cdb.RunDate AS DeclineBatchRunDate
,       t.PayCycleTransactionTypeDescription AS 'PayCycleTransactionType'
,		CLT.ClientIdentifier
,		CLT.ClientNumber_Temp AS 'ClientIdentifierCMS'
,		CM.MembershipID AS 'MembershipSSID'
,		CM.MembershipDescription AS 'Membership'
,       DCM.ClientMembershipIdentifier
,		DCM.BeginDate AS 'MembershipBeginDate'
,		DCM.EndDate AS 'MembershipEndDate'
,       DCM.MonthlyFee AS 'MonthlyFee'
,       so.SalesOrderKey
,       pct.ApprovalCode
,       pct.FeeAmount
,       pct.TaxAmount
,       pct.ChargeAmount
,       pct.Verbiage
,       pct.Last4Digits
,       pct.ExpirationDate
,       pct.IsSuccessfulFlag
,       pct.IsReprocessFlag
FROM    HairClubCMS.dbo.datPayCycleTransaction pct
        INNER JOIN HairClubCMS.dbo.lkpPayCycleTransactionType t
            ON t.PayCycleTransactionTypeID = pct.PayCycleTransactionTypeID
        INNER JOIN HairClubCMS.dbo.datCenterFeeBatch cfb
            ON cfb.CenterFeeBatchGUID = pct.CenterFeeBatchGUID
        INNER JOIN HairClubCMS.dbo.lkpFeePayCycle pc
            ON pc.FeePayCycleID = cfb.FeePayCycleID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
            ON so.SalesOrderSSID = pct.SalesOrderGUID
		INNER JOIN HairClubCMS.dbo.datClient CLT
			ON CLT.ClientGUID = pct.ClientGUID
        INNER JOIN HairClubCMS.dbo.cfgCenter CTR
            ON CTR.CenterID = cfb.CenterID
		INNER JOIN HairClubCMS.dbo.datClientMembership DCM
			ON DCM.ClientMembershipGUID = so.ClientMembershipSSID
		INNER JOIN HairClubCMS.dbo.cfgMembership CM
			ON CM.MembershipID = DCM.MembershipID
        LEFT JOIN HairClubCMS.dbo.datCenterDeclineBatch cdb
            ON cdb.CenterDeclineBatchGUID = pct.CenterDeclineBatchGUID
WHERE   cfb.FeeMonth = MONTH(GETDATE())
        AND cfb.FeeYear = YEAR(GETDATE())
        AND CTR.CenterID IN ( 807, 804, 821, 745, 748, 806, 811, 805, 817, 746, 814, 747, 820, 822 )
        AND CTR.IsActiveFlag = 1
ORDER BY pct.CreateDate

END
GO
