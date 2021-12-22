/* CreateDate: 02/27/2020 07:44:10.043 , ModifyDate: 02/27/2020 07:44:10.043 */
GO
/***********************************************************************
PROCEDURE:				spSVC_DetailsInsert
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_DeferredRevenue
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		9/17/2018
DESCRIPTION:			9/17/2018
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_DetailsInsert
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_DetailsInsert] (
	@DeferredRevenueHeaderKey INT
,	@ClientMembershipKey INT
,	@MembershipKey INT
,	@MembershipDescription VARCHAR(100)
,	@Period DATETIME
,	@DeferredAmount MONEY
,	@RevenueAmount MONEY
,	@RecognizeAllFlag INT = NULL
)
AS
BEGIN

SET NOCOUNT ON;


IF @DeferredRevenueHeaderKey IS NOT NULL
    AND @ClientMembershipKey IS NOT NULL
    AND @MembershipKey IS NOT NULL
    AND @MembershipDescription IS NOT NULL
    AND @Period IS NOT NULL
BEGIN
	--Update membership detail if it exists
    UPDATE  drd
    SET     drd.Deferred = CASE WHEN ( drh.DeferredRevenueTypeID = 2 OR ISNULL(@RecognizeAllFlag, 0) = 0 ) THEN @DeferredAmount ELSE 0 END
	,		drd.DeferredToDate = CASE WHEN ( drh.DeferredRevenueTypeID = 2 OR ISNULL(@RecognizeAllFlag, 0) = 0 ) THEN @DeferredAmount ELSE 0 END
    ,       drd.Revenue = CASE WHEN ISNULL(@RecognizeAllFlag, 0) = 0 THEN 0 ELSE ISNULL(drd.Revenue, 0) + @RevenueAmount END
    ,       drd.RevenueToDate = CASE WHEN ISNULL(@RecognizeAllFlag, 0) = 0 THEN 0 ELSE ISNULL(drd.RevenueToDate, 0) + @RevenueAmount END
    ,       drd.CreateDate = GETDATE()
    ,       drd.CreateUser = OBJECT_NAME(@@PROCID)
    ,       drd.UpdateDate = GETDATE()
    ,       drd.UpdateUser = OBJECT_NAME(@@PROCID)
    FROM    FactDeferredRevenueDetails drd
			INNER JOIN FactDeferredRevenueHeader drh
				ON drh.DeferredRevenueHeaderKey = drd.DeferredRevenueHeaderKey
    WHERE   drd.DeferredRevenueHeaderKey = @DeferredRevenueHeaderKey
            AND drd.ClientMembershipKey = @ClientMembershipKey
            AND drd.Period = @Period


	--Insert membership detail if it doesn't already exist
    IF NOT EXISTS ( SELECT  drd.DeferredRevenueHeaderKey
                    FROM    FactDeferredRevenueDetails drd
                    WHERE   DeferredRevenueHeaderKey = @DeferredRevenueHeaderKey
                            AND drd.ClientMembershipKey = @ClientMembershipKey
                            AND drd.Period = @Period )
    BEGIN
        INSERT  INTO FactDeferredRevenueDetails (
					DeferredRevenueHeaderKey
                ,	ClientMembershipKey
                ,	MembershipKey
                ,	MembershipDescription
                ,	Period
                ,	Deferred
                ,	Revenue
                ,	DeferredToDate
                ,	RevenueToDate
                ,	CreateDate
                ,	CreateUser
                ,	UpdateDate
                ,	UpdateUser
				)
        VALUES  (
					@DeferredRevenueHeaderKey	--DeferredRevenueHeaderKey
                ,	@ClientMembershipKey		--ClientMembershipKey
                ,	@MembershipKey				--MembershipKey
                ,	@MembershipDescription		--MembershipDescription
                ,	@Period						--Period
                ,	@DeferredAmount				--Deferred
                ,	@RevenueAmount				--Revenue
                ,	@DeferredAmount				--DeferredToDate
                ,	@RevenueAmount				--RevenueToDate
                ,	GETDATE()					--CreateDate
                ,	OBJECT_NAME(@@PROCID)		--CreateUser
                ,	GETDATE()					--UpdateDate
                ,	OBJECT_NAME(@@PROCID)		--UpdateUser
                )
    END
END
END
GO
