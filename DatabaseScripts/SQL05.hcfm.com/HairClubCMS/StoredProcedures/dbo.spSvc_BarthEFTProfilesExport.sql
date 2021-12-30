/* CreateDate: 04/06/2015 08:46:09.890 , ModifyDate: 01/09/2018 21:41:21.377 */
GO
/***********************************************************************
PROCEDURE:				spSvc_BarthEFTProfilesExport
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HairClubCMS
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		04/10/2014
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_BarthEFTProfilesExport
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_BarthEFTProfilesExport]
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


DECLARE @LastRun TABLE (
	ClientGUID UNIQUEIDENTIFIER
,	ClientMembershipGUID UNIQUEIDENTIFIER
,	LastRunDate DATETIME
)


/********************************** Get EFT Data *************************************/
INSERT	INTO @LastRun
		SELECT  so.ClientGUID
		,       cm.ClientMembershipGUID
		,       MAX(so.OrderDate) AS 'LastRunDate'
		FROM    dbo.datSalesOrderDetail sod
				INNER JOIN datSalesOrder so
					ON so.SalesOrderGUID = sod.SalesOrderGUID
				INNER JOIN datClientMembership cm
					ON cm.ClientMembershipGUID = so.ClientMembershipGUID
		WHERE   so.CenterID IN ( 807, 804, 821, 745, 748, 806, 811, 805, 817, 746, 814, 747, 820, 822 )
				AND sod.SalesCodeID = 665
				AND so.IsVoidedFlag = 0
		GROUP BY so.ClientGUID
		,       cm.ClientMembershipGUID


SELECT  CTR.CenterID AS 'CenterSSID'
,       CTR.CenterDescriptionFullCalc AS 'CenterDescription'
,       CLT.ClientIdentifier
,       CLT.ClientNumber_Temp AS 'CMSClientIdentifier'
,       REPLACE(CLT.FirstName, ',', '') AS 'FirstName'
,       REPLACE(CLT.LastName, ',', '') AS 'LastName'
,       LEAT.EFTAccountTypeDescription AS 'AccountType'
,       LFPC.FeePayCycleDescription AS 'BillingCycle'
,		DCM.ClientMembershipIdentifier
,       cm.MembershipDescription AS 'Membership'
,       DCM.BeginDate AS 'MembershipBeginDate'
,       DCM.EndDate AS 'MembershipEndDate'
,       CAST(ROUND(DCM.MonthlyFee, 2) AS MONEY) AS 'MonthlyFee'
,       DCE.Freeze_Start AS 'FreezeStartDate'
,       DCE.Freeze_End AS 'FreezeEndDate'
,		ISNULL(LFFR.FeeFreezeReasonDescription, '') AS 'FreezeReason'
,		ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(DCE.FeeFreezeReasonDescription, CHAR(9), ''), CHAR(10), ''), CHAR(13), ''), '''', ''), '{', ''), '}', ''), ',', '') , '') AS 'FeeFreezeReasonManual'
,       DCE.LastUpdate
,       o_LR.LastRunDate AS 'ClientLastRunDate'
,       lr.LastRunDate AS 'CurrentMembershipLastRunDate'
FROM    datClientEFT DCE
        INNER JOIN datClient CLT
            ON CLT.ClientGUID = DCE.ClientGUID
        INNER JOIN cfgCenter CTR
            ON CTR.CenterID = CLT.CenterID
        INNER JOIN datClientMembership DCM
            ON DCM.ClientMembershipGUID = DCE.ClientMembershipGUID
        INNER JOIN cfgMembership cm
            ON cm.MembershipID = DCM.MembershipID
        INNER JOIN lkpEFTAccountType LEAT
            ON LEAT.EFTAccountTypeID = DCE.EFTAccountTypeID
        INNER JOIN lkpFeePayCycle LFPC
            ON LFPC.FeePayCycleID = DCE.FeePayCycleID
        LEFT OUTER JOIN lkpFeeFreezeReason LFFR
            ON LFFR.FeeFreezeReasonID = DCE.FeeFreezeReasonId
        LEFT OUTER JOIN @LastRun lr
            ON lr.ClientGUID = CLT.ClientGUID
               AND lr.ClientMembershipGUID = DCE.ClientMembershipGUID
        OUTER APPLY ( SELECT    lr_cl.ClientGUID
                      ,         MAX(lr_cl.LastRunDate) AS 'LastRunDate'
                      FROM      @LastRun lr_cl
                      WHERE     lr_cl.ClientGUID = CLT.ClientGUID
                      GROUP BY  lr_cl.ClientGUID
                    ) o_LR
WHERE   CTR.CenterID IN ( 807, 804, 821, 745, 748, 806, 811, 805, 817, 746, 814, 747, 820, 822 )

END
GO
