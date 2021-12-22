/* CreateDate: 12/17/2012 11:06:08.290 , ModifyDate: 03/02/2015 14:34:12.583 */
GO
/***********************************************************************
PROCEDURE:				spSVC_PCP_Step4_CalculateDeferredRevenue
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_DeferredRevenue_DEV
AUTHOR:					Marlon Burrell
IMPLEMENTOR:			Marlon Burrell
DATE IMPLEMENTED:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_PCP_Step4_CalculateDeferredRevenue '4/1/2013'
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_PCP_Step4_CalculateDeferredRevenue]
(
	@Month DATETIME
)
AS
BEGIN

SET NOCOUNT ON;


TRUNCATE TABLE ClientsToProcess


DECLARE @StartDate DATETIME
,       @DeferredRevenueTypeID INT


SELECT  @DeferredRevenueTypeID = 4
,       @StartDate = CONVERT(DATETIME, DATEADD(DD, -( DAY(@Month) - 1 ), @Month), 101)


INSERT  INTO ClientsToProcess (
			DeferredRevenueHeaderKey
        ,	ClientMembershipKey
        ,	MembershipKey
        ,	MembershipDescription
        ,	DeferredAmount
        ,	MonthsRemaining
        ,	MembershipRate
        ,	CenterSSID
		)
        SELECT  DRH.DeferredRevenueHeaderKey
        ,       DRH.ClientMembershipKey
        ,       DRH.MembershipKey
        ,       DRH.MembershipDescription
        ,       DRH.Deferred
        ,       DRH.MonthsRemaining
        ,       DRC.MembershipRate
        ,       DRH.CenterSSID
        FROM    FactDeferredRevenueHeader DRH
                INNER JOIN DimMembershipRatesByCenter DRC
                    ON DRH.CenterSSID = DRC.CenterSSID
                       AND DRH.MembershipKey = DRC.MembershipKey
                       AND @StartDate BETWEEN DRC.RateStartDate AND drc.RateEndDate
        WHERE   DRH.DeferredRevenueTypeID = @DeferredRevenueTypeID
                AND DRH.Deferred <> 0


DECLARE @CurrentCount INT
,       @TotalCount INT
,       @CurrentDeferredRevenueHeaderKey INT
,       @CurrentClientMembershipKey INT
,       @CurrentMembershipKey INT
,       @CurrentMembershipDescription VARCHAR(50)
,       @CurrentDeferredAmount MONEY
,       @CurrentRevenueAmount MONEY
,       @CurrentMembershipRateKey INT
,       @CurrentMembershipRate MONEY
,       @TmpDeferred MONEY
,       @TmpRevenue MONEY
,       @CurrentCenterSSID INT


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    ClientsToProcess


WHILE @CurrentCount <= @TotalCount
      BEGIN
            SELECT  @CurrentDeferredRevenueHeaderKey = DeferredRevenueHeaderKey
            ,       @CurrentClientMembershipKey = ClientMembershipKey
            ,       @CurrentMembershipKey = MembershipKey
            ,       @CurrentMembershipDescription = MembershipDescription
            ,       @CurrentDeferredAmount = DeferredAmount
            ,       @CurrentMembershipRateKey = MembershipRateKey
            ,       @CurrentMembershipRate = MembershipRate
            ,       @CurrentCenterSSID = CenterSSID
            FROM    ClientsToProcess
            WHERE   RowID = @CurrentCount


			--Update membership rate for the current center/date
            UPDATE  DRH
            SET     DRH.MembershipRateKey = MC.MembershipRateKey
            ,       DRH.UpdateDate = GETDATE()
            ,       DRH.UpdateUser = 'spSVC_PCP_Step4_CalculateDeferredRevenue'
            ,       @CurrentMembershipRateKey = MC.MembershipRateKey
            ,       @CurrentMembershipRate = MC.MembershipRate
            FROM    FactDeferredRevenueHeader DRH
                    INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
                        ON DRH.CenterSSID = CTR.CenterSSID
                    INNER JOIN DimMembershipRatesByCenter MC
                        ON CTR.CenterKey = MC.CenterKey
                           AND DRH.MembershipKey = MC.MembershipKey
                           AND @StartDate BETWEEN MC.RateStartDate AND MC.RateEndDate
            WHERE   DRH.DeferredRevenueHeaderKey = @CurrentDeferredRevenueHeaderKey


            IF @CurrentDeferredAmount > 0
               BEGIN
                     SELECT @TmpDeferred = @CurrentDeferredAmount - CASE WHEN @CurrentDeferredAmount > @CurrentMembershipRate THEN @CurrentMembershipRate
                                                                         ELSE @CurrentDeferredAmount
                                                                    END
                     ,      @TmpRevenue = CASE WHEN @CurrentDeferredAmount > @CurrentMembershipRate THEN @CurrentMembershipRate
                                               ELSE @CurrentDeferredAmount
                                          END
               END
            ELSE
               BEGIN
                     SELECT @TmpDeferred = 0
                     ,      @TmpRevenue = @CurrentDeferredAmount
               END


            UPDATE  DRH
            SET     DRH.Deferred = @TmpDeferred
            ,       DRH.Revenue = @TmpRevenue
            ,       DRH.DeferredToDate = ISNULL(DRH.DeferredToDate, 0) + @TmpDeferred
            ,       DRH.RevenueToDate = ISNULL(DRH.RevenueToDate, 0) + @TmpRevenue
            FROM    FactDeferredRevenueHeader DRH
            WHERE   DRH.DeferredRevenueHeaderKey = @CurrentDeferredRevenueHeaderKey
                    AND DRH.ClientMembershipKey = @CurrentClientMembershipKey


            EXEC spSVC_DetailsInsert
                @CurrentDeferredRevenueHeaderKey
            ,   @CurrentClientMembershipKey
            ,   @CurrentMembershipKey
            ,   @CurrentMembershipDescription
            ,   @StartDate
            ,   @TmpDeferred
            ,   @TmpRevenue


            SELECT  @CurrentDeferredRevenueHeaderKey = NULL
            ,       @CurrentClientMembershipKey = NULL
            ,       @CurrentMembershipKey = NULL
            ,       @CurrentMembershipDescription = NULL
            ,       @CurrentDeferredAmount = NULL
            ,       @TmpDeferred = NULL
            ,       @TmpRevenue = NULL


            SET @CurrentCount = @CurrentCount + 1
      END


UPDATE  DRD
SET     DRD.Client_No = C.ClientIdentifier
,       DRD.Member1_ID = CM.Member1_ID_Temp
,       DRD.CenterSSID = CM.CenterSSID
FROM    [dbo].[FactDeferredRevenueDetails] DRD
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
            ON DRD.ClientMembershipKey = CM.ClientMembershipKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient C
            ON CM.ClientKey = C.ClientKey


UPDATE  DRH
SET     DRH.Client_No = C.ClientIdentifier
,       DRH.Member1_ID = CM.Member1_ID_Temp
FROM    [dbo].FactDeferredRevenueHeader DRH
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
            ON DRH.ClientMembershipKey = CM.ClientMembershipKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient C
            ON CM.ClientKey = C.ClientKey

END
GO
