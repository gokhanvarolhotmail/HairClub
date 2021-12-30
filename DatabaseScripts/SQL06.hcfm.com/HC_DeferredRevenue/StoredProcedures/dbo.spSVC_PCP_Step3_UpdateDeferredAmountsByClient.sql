/* CreateDate: 12/17/2012 11:05:17.607 , ModifyDate: 02/21/2019 14:39:21.360 */
GO
/***********************************************************************
PROCEDURE:				spSVC_PCP_Step3_UpdateDeferredAmountsByClient
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_DeferredRevenue_DEV
AUTHOR:					Marlon Burrell
IMPLEMENTOR:			Marlon Burrell
DATE IMPLEMENTED:
------------------------------------------------------------------------
NOTES:

07/02/2013 - MB - Changed transfer process so that only monies from PCP memberhsips can be transferred
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_PCP_Step3_UpdateDeferredAmountsByClient '4/1/2013'
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_PCP_Step3_UpdateDeferredAmountsByClient]
(
	@Month DATETIME
)
AS
BEGIN

SET NOCOUNT ON;


TRUNCATE TABLE PaymentsToProcess


--Declare local variables
DECLARE @StartDate DATETIME
,       @EndDate DATETIME
,       @DeferredRevenueTypeID INT


--Initialize first and last day of given month
SELECT  @DeferredRevenueTypeID = 4
,       @StartDate = CONVERT(DATETIME, DATEADD(DD, -( DAY(@Month) - 1 ), @Month), 101)
,       @EndDate = DATEADD(S, -1, DATEADD(MM, DATEDIFF(M, 0, @Month) + 1, 0))


INSERT  INTO PaymentsToProcess (
			DeferredRevenueHeaderKey
        ,	ClientMembershipKey
        ,	NetPayments
		)
        SELECT  DRT.DeferredRevenueHeaderKey
        ,       DRT.ClientMembershipKey
        ,       SUM(DRT.ExtendedPrice) AS 'NetPayments'
        FROM    FactDeferredRevenueTransactions DRT
                INNER JOIN FactDeferredRevenueHeader DRH
                    ON DRT.DeferredRevenueHeaderKey = DRH.DeferredRevenueHeaderKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
                    ON DRT.SalesCodeKey = SC.SalesCodeKey
        WHERE   DRH.DeferredRevenueTypeID = @DeferredRevenueTypeID
                AND DRT.SalesOrderDate BETWEEN @StartDate AND @EndDate
                AND SC.SalesCodeDepartmentSSID IN ( 2020 )
				AND sc.SalesCodeDescription NOT LIKE '%Laser%'
				AND sc.SalesCodeDescription NOT LIKE '%Capillus%'
        GROUP BY DRT.DeferredRevenueHeaderKey
        ,       DRT.ClientMembershipKey


UPDATE  DRH
SET     DRH.Deferred = DRH.Deferred + PMT.NetPayments
FROM    FactDeferredRevenueHeader DRH
        INNER JOIN PaymentsToProcess PMT
            ON DRH.DeferredRevenueHeaderKey = PMT.DeferredRevenueHeaderKey
               AND DRH.ClientMembershipKey = PMT.ClientMembershipKey


----Get current client membership record
--SELECT  ClientKey
--,       MAX(ClientMembershipIdentifier) AS 'ClientMembershipIdentifier'
--INTO    #Current
--FROM    dbo.FactDeferredRevenueHeader
--WHERE   DeferredRevenueTypeID = @DeferredRevenueTypeID
--GROUP BY ClientKey


----Get prior client membership record where there is a deferred balance
--SELECT  H.ClientKey
--,       MAX(H.ClientMembershipIdentifier) AS 'ClientMembershipIdentifier'
--INTO    #Prior
--FROM    dbo.FactDeferredRevenueHeader H
--        INNER JOIN #Current C
--            ON H.ClientKey = C.ClientKey
--        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
--            ON H.MembershipKey = M.MembershipKey
--WHERE   H.ClientMembershipIdentifier < C.ClientMembershipIdentifier
--        AND H.Deferred <> 0
--        AND M.RevenueGroupSSID = 2
--GROUP BY H.ClientKey


-- Get current client membership record
SELECT  DRH.ClientKey
,       CMR.ClientIdentifier
,       CMR.ClientMembershipIdentifier
,       CMR.ClientMembershipKey
,       CMR.MembershipKey
,       CMR.MembershipDescription
INTO    #Current
FROM    FactDeferredRevenueHeader DRH
        CROSS APPLY ( SELECT TOP 1
                                CLT.ClientKey
                      ,         CLT.ClientIdentifier
                      ,         DCM.ClientMembershipIdentifier
                      ,         DCM.ClientMembershipKey
                      ,         DCM.MembershipKey
                      ,         DM.MembershipDescription
                      FROM      FactDeferredRevenueHeader FDRH
                                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
                                    ON DCM.ClientMembershipKey = FDRH.ClientMembershipKey
                                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
                                    ON CLT.ClientKey = DCM.ClientKey
                                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
                                    ON DM.MembershipKey = DCM.MembershipKey
                      WHERE     FDRH.DeferredRevenueTypeID = @DeferredRevenueTypeID
								AND FDRH.ClientKey = DRH.ClientKey
                      ORDER BY  FDRH.DeferredRevenueHeaderKey DESC
                    ) CMR
WHERE   DRH.DeferredRevenueTypeID = @DeferredRevenueTypeID
        --AND DRH.ClientKey = @ClientKey
GROUP BY DRH.ClientKey
,       CMR.ClientIdentifier
,       CMR.ClientMembershipIdentifier
,       CMR.ClientMembershipKey
,       CMR.MembershipKey
,       CMR.MembershipDescription
ORDER BY DRH.ClientKey


-- Get prior client membership record where there is a deferred balance
SELECT  DRH.ClientKey
,       PMR.ClientIdentifier
,       PMR.ClientMembershipIdentifier
,       PMR.ClientMembershipKey
,       PMR.MembershipKey
,       PMR.MembershipDescription
INTO    #Prior
FROM    FactDeferredRevenueHeader DRH
        INNER JOIN #Current C
            ON C.ClientKey = DRH.ClientKey
        CROSS APPLY ( SELECT TOP 1
                                CLT.ClientKey
                      ,         CLT.ClientIdentifier
                      ,         DCM.ClientMembershipIdentifier
                      ,         DCM.ClientMembershipKey
                      ,         DCM.MembershipKey
                      ,         DM.MembershipDescription
                      FROM      FactDeferredRevenueHeader FDRH
                                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
                                    ON DCM.ClientMembershipKey = FDRH.ClientMembershipKey
                                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
                                    ON CLT.ClientKey = DCM.ClientKey
                                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
                                    ON DM.MembershipKey = DCM.MembershipKey
                      WHERE     FDRH.ClientKey = DRH.ClientKey
                                AND FDRH.ClientMembershipIdentifier <> C.ClientMembershipIdentifier
								AND FDRH.Deferred <> 0
								AND ( DM.RevenueGroupSSID = 2 AND DM.MembershipKey <> 68 )
                      ORDER BY  FDRH.DeferredRevenueHeaderKey DESC
                    ) PMR
GROUP BY DRH.ClientKey
,       PMR.ClientIdentifier
,       PMR.ClientMembershipIdentifier
,       PMR.ClientMembershipKey
,       PMR.MembershipKey
,       PMR.MembershipDescription
ORDER BY DRH.ClientKey


--Update the current client membership record with the deferred balance from the prior membership
UPDATE  H_Current
SET     H_Current.Deferred = H_Current.Deferred + H_Prior.Deferred
,       H_Current.DeferredToDate = H_Current.DeferredToDate + H_Prior.Deferred
FROM    FactDeferredRevenueHeader H_Current
        INNER JOIN #Current C
            ON H_Current.ClientMembershipIdentifier = C.ClientMembershipIdentifier
        INNER JOIN #Prior P
            ON C.ClientKey = P.ClientKey
        INNER JOIN FactDeferredRevenueHeader H_Prior
            ON P.ClientMembershipIdentifier = H_Prior.ClientMembershipIdentifier


--Update the deferred balance of the prior membership to zero
UPDATE  H_Prior
SET     H_Prior.TransferDeferredBalance = 1
,       H_Prior.DeferredBalanceTransferred = H_Prior.Deferred
,       H_Prior.Deferred = 0
FROM    FactDeferredRevenueHeader H_Prior
        INNER JOIN #Prior P
            ON H_Prior.ClientMembershipIdentifier = P.ClientMembershipIdentifier

END
GO
