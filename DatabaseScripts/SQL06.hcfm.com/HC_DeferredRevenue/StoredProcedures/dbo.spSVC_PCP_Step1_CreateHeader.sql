/***********************************************************************
PROCEDURE:				spSVC_PCP_Step1_CreateHeader
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_DeferredRevenue_DEV
AUTHOR:					Marlon Burrell
IMPLEMENTOR:			Marlon Burrell
DATE IMPLEMENTED:
------------------------------------------------------------------------
NOTES:

04/24/2013 - MB - Excluded Non-Program memberships from calculation
06/11/2013 - MB - Changed from temp table to static table for headers to process
12/04/2013 - MB - Changed code to look at the last numbered section of the ClientMembershipIdentifier to determine the current membership
05/29/2014 - DL - Included Sales Code Department used for Center Transfers (1050)
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSVC_PCP_Step1_CreateHeader '4/1/2013'
***********************************************************************/
CREATE PROCEDURE [dbo].[spSVC_PCP_Step1_CreateHeader]
(
	@Month DATETIME
)
AS
BEGIN

SET NOCOUNT ON;


TRUNCATE TABLE HeadersToProcess


--Declare local variables
DECLARE @StartDate DATETIME
,       @EndDate DATETIME
,       @DeferredRevenueTypeID INT


--Initialize first and last day of given month
SELECT  @DeferredRevenueTypeID = 4
,       @StartDate = CONVERT(DATETIME, DATEADD(DD, -( DAY(@Month) - 1 ), @Month), 101)
,       @EndDate = DATEADD(S, -1, DATEADD(MM, DATEDIFF(M, 0, @Month) + 1, 0))


--Get all membership change transactions for current membership type
SELECT  C.CenterSSID
,       FST.ClientKey
,		CM1.ClientMembershipIdentifier AS 'PrevCMID'
,		FST.ClientMembershipKey AS 'PrevCMKey'
,		M1.MembershipKey AS 'PrevMKey'
,		M1.MembershipDescription AS 'PrevMDesc'
,		M1.RevenueGroupSSID AS 'PrevMRevGroup'
,		DATEDIFF(MONTH, CM1.ClientMembershipBeginDate, CM1.ClientMembershipEndDate) AS 'PrevCMMonthsRemaining'
,		[dbo].[GetClientMembershipRanking] (FST.ClientKey, CM1.ClientMembershipIdentifier) AS 'PrevCMRank'
,		CM2.ClientMembershipIdentifier AS 'CurrCMID'
,		SO.ClientMembershipKey AS 'CurrCMKey'
,		M2.MembershipKey AS 'CurrMKey'
,		M2.MembershipDescription AS 'CurrMDesc'
,		M2.RevenueGroupSSID AS 'CurrMRevGroup'
,		DATEDIFF(MONTH, CM2.ClientMembershipBeginDate, CM2.ClientMembershipEndDate) AS 'CurrCMMonthsRemaining'
,		[dbo].[GetClientMembershipRanking] (FST.ClientKey, CM2.ClientMembershipIdentifier) AS 'CurrCMRank'
,		SC.SalesCodeDepartmentSSID
,       0 AS 'MembershipRateKey'
INTO	#Transactions
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FST.OrderDateKey = DD.DateKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
            ON FST.SalesCodeKey = SC.SalesCodeKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
            ON FST.SalesOrderKey = SO.SalesOrderKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM1
            ON FST.ClientMembershipKey = CM1.ClientMembershipKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M1
            ON CM1.MembershipKey = M1.MembershipKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM2
            ON SO.ClientMembershipKey = CM2.ClientMembershipKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M2
            ON CM2.MembershipKey = M2.MembershipKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
            ON CM2.CenterKey = C.CenterKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
		AND SC.SalesCodeDepartmentSSID IN ( 1010, 1099, 1075, 1090, 1080, 1070, 1015, 1050 )
        AND SC.SalesCodeTypeSSID IN ( 4, 5 )
ORDER BY FST.ClientKey


--Insert membership change transactions for current membership type
INSERT  INTO HeadersToProcess (
			CenterSSID
        ,	ClientKey
        ,	ClientMembershipKey
        ,	MembershipKey
        ,	MembershipDescription
        ,	MembershipRateKey
        ,	MonthsRemaining
		)
		SELECT  T.CenterSSID
		,       T.ClientKey
		,       CASE WHEN T.PrevCMRank > T.CurrCMRank THEN T.PrevCMKey
					 ELSE T.CurrCMKey
				END AS 'ClientMembershipKey'
		,       CASE WHEN T.PrevCMRank > T.CurrCMRank THEN T.PrevMKey
					 ELSE T.CurrMKey
				END AS 'MembershipKey'
		,       CASE WHEN T.PrevCMRank > T.CurrCMRank THEN T.PrevMDesc
					 ELSE T.CurrMDesc
				END AS 'MembershipDescription'
		,       T.MembershipRateKey
		,       CASE WHEN T.PrevCMRank > T.CurrCMRank THEN T.PrevCMMonthsRemaining
					 ELSE T.CurrCMMonthsRemaining
				END AS 'MonthsRemaining'
		FROM    #Transactions T
		WHERE   CASE WHEN T.PrevCMRank > T.CurrCMRank THEN T.PrevMRevGroup
					 ELSE T.CurrMRevGroup
				END = 2
				AND CASE WHEN T.PrevCMRank > T.CurrCMRank THEN T.PrevMKey
						 ELSE T.CurrMKey
					END != 68
		ORDER BY T.ClientKey
		,       CASE WHEN T.PrevCMRank > T.CurrCMRank THEN T.PrevCMKey
					 ELSE T.CurrCMKey
				END


        --SELECT  C.CenterSSID
        --,       FST.ClientKey
        --,       CASE WHEN CONVERT(INT, RIGHT(CM1.ClientMembershipIdentifier, 2)) > CONVERT(INT, RIGHT(CM2.ClientMembershipIdentifier, 2))
        --             THEN FST.ClientMembershipKey
        --             ELSE SO.ClientMembershipKey
        --        END AS 'ClientMembershipKey'
        --,       CASE WHEN CONVERT(INT, RIGHT(CM1.ClientMembershipIdentifier, 2)) > CONVERT(INT, RIGHT(CM2.ClientMembershipIdentifier, 2)) THEN M1.MembershipKey
        --             ELSE M2.MembershipKey
        --        END AS 'MembershipKey'
        --,       CASE WHEN CONVERT(INT, RIGHT(CM1.ClientMembershipIdentifier, 2)) > CONVERT(INT, RIGHT(CM2.ClientMembershipIdentifier, 2))
        --             THEN M1.MembershipDescription
        --             ELSE M2.MembershipDescription
        --        END AS 'MembershipDescription'
        --,       0
        --,       CASE WHEN CONVERT(INT, RIGHT(CM1.ClientMembershipIdentifier, 2)) > CONVERT(INT, RIGHT(CM2.ClientMembershipIdentifier, 2))
        --             THEN DATEDIFF(MONTH, CM1.ClientMembershipBeginDate, CM1.ClientMembershipEndDate)
        --             ELSE DATEDIFF(MONTH, CM2.ClientMembershipBeginDate, CM2.ClientMembershipEndDate)
        --        END AS 'MonthsRemaining'
        --FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
        --        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
        --            ON FST.OrderDateKey = DD.DateKey
        --        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
        --            ON FST.SalesCodeKey = SC.SalesCodeKey
        --        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
        --            ON FST.SalesOrderKey = SO.SalesOrderKey
        --        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM1
        --            ON FST.ClientMembershipKey = CM1.ClientMembershipKey
        --        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M1
        --            ON CM1.MembershipKey = M1.MembershipKey
        --        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM2
        --            ON SO.ClientMembershipKey = CM2.ClientMembershipKey
        --        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M2
        --            ON CM2.MembershipKey = M2.MembershipKey
        --        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
        --            ON CM2.CenterKey = C.CenterKey
        --WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
        --        AND SC.SalesCodeDepartmentSSID IN ( 1010, 1099, 1075, 1090, 1080, 1070, 1015, 1050 )
        --        AND SC.SalesCodeTypeSSID IN ( 4, 5 )
        --        AND CASE WHEN CONVERT(INT, RIGHT(CM1.ClientMembershipIdentifier, 2)) > CONVERT(INT, RIGHT(CM2.ClientMembershipIdentifier, 2))
        --                 THEN M1.RevenueGroupSSID
        --                 ELSE M2.RevenueGroupSSID
        --            END = 2
        --        AND CASE WHEN CONVERT(INT, RIGHT(CM1.ClientMembershipIdentifier, 2)) > CONVERT(INT, RIGHT(CM2.ClientMembershipIdentifier, 2))
        --                 THEN M1.MembershipKey
        --                 ELSE M2.MembershipKey
        --            END != 68
        --ORDER BY FST.ClientKey
        --,       CASE WHEN CONVERT(INT, RIGHT(CM1.ClientMembershipIdentifier, 2)) > CONVERT(INT, RIGHT(CM2.ClientMembershipIdentifier, 2))
        --             THEN FST.ClientMembershipKey
        --             ELSE SO.ClientMembershipKey
        --        END


DECLARE @CenterSSID INT
,       @ClientKey INT
,       @ClientMembershipKey INT
,       @MembershipKey INT
,       @MembershipDescription VARCHAR(100)
,       @MembershipRateKey INT
,       @MonthsRemaining INT
,       @PreviousMembershipHeaderKey INT
,       @PreviousMembershipDeferredBalance MONEY
,       @LastInsertedMembershipHeaderKey INT
,       @CurrentCount INT
,       @TotalCount INT
,       @ClientMembershipIdentifier NVARCHAR(50)


SELECT  @CurrentCount = 1
,       @TotalCount = MAX(RowID)
FROM    HeadersToProcess


WHILE @CurrentCount <= @TotalCount
      BEGIN
            SELECT  @CenterSSID = CenterSSID
            ,       @ClientKey = ClientKey
            ,       @ClientMembershipKey = ClientMembershipKey
            ,       @MembershipKey = MembershipKey
            ,       @MembershipDescription = MembershipDescription
            ,       @MembershipRateKey = MembershipRateKey
            ,       @MonthsRemaining = MonthsRemaining
            FROM    HeadersToProcess
            WHERE   RowID = @CurrentCount


            EXEC spSVC_HeaderInsert
                @DeferredRevenueTypeID
            ,   @CenterSSID
            ,   @ClientKey
            ,   @ClientMembershipKey
            ,   @MembershipKey
            ,   @MembershipDescription
            ,   @MembershipRateKey
            ,   @MonthsRemaining


			--Clear variables
            SELECT  @CenterSSID = NULL
            ,       @ClientKey = NULL
            ,       @ClientMembershipKey = NULL
            ,       @MembershipKey = NULL
            ,       @MembershipDescription = NULL
            ,       @MembershipRateKey = NULL
            ,       @MonthsRemaining = NULL
            ,       @ClientMembershipIdentifier = NULL


            SET @CurrentCount = @CurrentCount + 1
      END

END
