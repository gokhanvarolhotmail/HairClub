/* CreateDate: 02/08/2022 11:21:42.003 , ModifyDate: 02/08/2022 11:21:42.003 */
GO
/*
==============================================================================

PROCEDURE:				[spSVC_NonProgram_Step1_CreateHeader]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_DeferredRevenue_DEV]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Create NonProgram - Membership headers
==============================================================================
NOTES:
	06/11/2013 - MB - Changed from temp table to static table for headers to process
	06/18/2013 - MB - Added renewals to list of codes to trigger new membership record
	03/10/2014 - MB - Changed derivation of ClientMembershipKey to come from SO instead of FST to get latest membership
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_NonProgram_Step1_CreateHeader] '1/1/11'
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_NonProgram_Step1_CreateHeader] (@Month DATETIME)
AS
BEGIN
	SET NOCOUNT ON

	TRUNCATE TABLE HeadersToProcess


	--Declare local variables
	DECLARE @StartDate DATETIME
	,	@EndDate DATETIME
	,	@DeferredRevenueTypeID INT


	--Initialize first and last day of given month
	SELECT @DeferredRevenueTypeID = 5
	,	@StartDate = CONVERT(DATETIME, DATEADD(DD, -(DAY(@Month)-1), @Month), 101)
	,	@EndDate = DATEADD(S, -1, DATEADD(MM, DATEDIFF(M, 0, @Month) + 1, 0))


	--Get all membership change transactions for current membership type
	INSERT INTO HeadersToProcess (
		CenterSSID
	,	ClientKey
	,	ClientMembershipKey
	,	MembershipKey
	,	MembershipDescription
	,	MembershipRateKey
	,	MonthsRemaining)
	SELECT C.CenterSSID
	,	FST.ClientKey
	,	CASE WHEN CONVERT(INT, RIGHT(CM1.ClientMembershipIdentifier, 2)) > CONVERT(INT, RIGHT(CM2.ClientMembershipIdentifier, 2)) THEN FST.ClientMembershipKey ELSE SO.ClientMembershipKey END AS 'ClientMembershipKey'
	,	CASE WHEN CONVERT(INT, RIGHT(CM1.ClientMembershipIdentifier, 2)) > CONVERT(INT, RIGHT(CM2.ClientMembershipIdentifier, 2)) THEN M1.MembershipKey ELSE M2.MembershipKey END AS 'MembershipKey'
	,	CASE WHEN CONVERT(INT, RIGHT(CM1.ClientMembershipIdentifier, 2)) > CONVERT(INT, RIGHT(CM2.ClientMembershipIdentifier, 2)) THEN M1.MembershipDescription ELSE M2.MembershipDescription END AS 'MembershipDescription'
	,	-1 AS 'MembershipRateKey'
	,	CASE WHEN CONVERT(INT, RIGHT(CM1.ClientMembershipIdentifier, 2)) > CONVERT(INT, RIGHT(CM2.ClientMembershipIdentifier, 2))
			THEN DATEDIFF(MONTH, CM1.ClientMembershipBeginDate, CM1.ClientMembershipEndDate)
			ELSE DATEDIFF(MONTH, CM2.ClientMembershipBeginDate, CM2.ClientMembershipEndDate)
		END AS 'MonthsRemaining'
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
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
	WHERE DD.FullDate BETWEEN @StartDate AND @EndDate
		AND SC.SalesCodeDepartmentSSID IN (1010, 1015, 1090)
		AND CASE WHEN CONVERT(INT, RIGHT(CM1.ClientMembershipIdentifier, 2)) > CONVERT(INT, RIGHT(CM2.ClientMembershipIdentifier, 2)) THEN M1.MembershipKey ELSE M2.MembershipKey END = 68
	ORDER BY FST.ClientKey
	,	CASE WHEN CONVERT(INT, RIGHT(CM1.ClientMembershipIdentifier, 2)) > CONVERT(INT, RIGHT(CM2.ClientMembershipIdentifier, 2)) THEN FST.ClientMembershipKey ELSE SO.ClientMembershipKey END


	DECLARE @CurrentCount INT
	,	@TotalCount INT
	,	@CenterSSID INT
	,	@ClientKey INT
	,	@ClientMembershipKey INT
	,	@MembershipKey INT
	,	@MembershipDescription VARCHAR(100)
	,	@MembershipRateKey INT
	,	@MonthsRemaining INT


	SELECT @CurrentCount = 1
	,	@TotalCount = MAX(RowID)
	FROM HeadersToProcess


	WHILE @CurrentCount <= @TotalCount
	BEGIN
		SELECT @CenterSSID = CenterSSID
		,	@ClientKey = ClientKey
		,	@ClientMembershipKey = ClientMembershipKey
		,	@MembershipKey = MembershipKey
		,	@MembershipDescription = MembershipDescription
		,	@MembershipRateKey = MembershipRateKey
		,	@MonthsRemaining = MonthsRemaining
		FROM HeadersToProcess
		WHERE RowID = @CurrentCount


		EXEC spSVC_HeaderInsert
			@DeferredRevenueTypeID
		,	@CenterSSID
		,	@ClientKey
		,	@ClientMembershipKey
		,	@MembershipKey
		,	@MembershipDescription
		,	@MembershipRateKey
		,	@MonthsRemaining


		--Clear variables
		SELECT @CenterSSID = NULL
		,	@ClientKey = NULL
		,	@ClientMembershipKey = NULL
		,	@MembershipKey = NULL
		,	@MembershipDescription = NULL
		,	@MembershipRateKey = NULL
		,	@MonthsRemaining = NULL


		SET @CurrentCount = @CurrentCount + 1
	END


END
GO
