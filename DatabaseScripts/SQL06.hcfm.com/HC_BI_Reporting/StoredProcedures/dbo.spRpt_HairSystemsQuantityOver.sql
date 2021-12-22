/***********************************************************************
PROCEDURE:				spRpt_HairSystemsQuantityOver
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		04/13/2015
------------------------------------------------------------------------
NOTES:
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_HairSystemsQuantityOver  '292'
EXEC spRpt_HairSystemsQuantityOver  '1' --ALL

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_HairSystemsQuantityOver]
(@CenterSSID NVARCHAR(MAX)
) AS

BEGIN

	SET NOCOUNT OFF;

	DECLARE @StartDate DATETIME
	DECLARE @EndDate DATETIME

	SET @StartDate = DATEADD(MONTH,-36,(CAST(CAST(DATEPART(MONTH,GETUTCDATE())AS VARCHAR(2)) + '/1/' + CAST(DATEPART(YEAR,GETUTCDATE())AS VARCHAR(4)) AS DATE))) --36 months ago
	SET @EndDate = GETUTCDATE()

	PRINT @StartDate
	PRINT @EndDate

	/********************************** Create temp table objects ************************************/

	CREATE TABLE #Center (
		CenterSSID INT
	)

	/********************************** Find Centers **************************************************/


	IF @CenterSSID = '1'  --ALL
	BEGIN
		INSERT  INTO #Center
		SELECT  DC.CenterSSID
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[278]%'
				AND DC.Active = 'Y'
	END
	ELSE
	BEGIN
		INSERT  INTO #Center
		SELECT SplitValue
		FROM   dbo.fnSplit(@CenterSSID, ',')
	END

			--SELECT * FROM #Center

	/********************************** Main select statement *******************************************/

	SELECT CLT.CenterSSID
		,	CTR.CenterDescriptionNumber
		,	CTR.CenterDescription
		,	VW.ClientMembershipKey
		,	VW.ClientMembershipSSID
		,	VW.AccumulatorKey
		,	VW.AccumulatorSSID
		,	VW.AccumulatorDescription
		,	VW.AccumulatorDescriptionShort
		,	VW.UsedAccumQuantity
		,	VW.TotalAccumQuantity
		,	CLT.ClientIdentifier
		,	CLT.ClientFullName
		,	M.MembershipDescription
		,	CM.ClientMembershipBeginDate
		,	CM.ClientMembershipEndDate
		,	(VW.TotalAccumQuantity - VW.UsedAccumQuantity) AS 'QtyDifference'
	INTO #Clients
	FROM HC_BI_CMS_DDS.bi_cms_dds.vwDimClientMembershipAccum VW
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
			ON VW.ClientMembershipKey = CM.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON CM.MembershipKey = M.MembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON CM.ClientKey = CLT.ClientKey
		INNER JOIN #Center C
			ON CLT.CenterSSID = C.CenterSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			ON C.CenterSSID = CTR.CenterSSID
	WHERE AccumulatorSSID = 8
		AND TotalAccumQuantity <> 0
		AND CM.ClientMembershipBeginDate >= @StartDate
		AND M.MembershipDescription NOT LIKE '%Employee%'
		AND M.MembershipDescription NOT LIKE '%Kids%'
		AND M.MembershipDescription NOT LIKE '%Model%'

	/********************************** Final Select ******************************************************/


	SELECT CenterSSID
		,	CenterDescriptionNumber
		,	CenterDescription
		,	ClientMembershipKey
		,	ClientMembershipSSID
		,	AccumulatorKey
		,	AccumulatorSSID
		,	AccumulatorDescription
		,	AccumulatorDescriptionShort
		,	UsedAccumQuantity
		,	TotalAccumQuantity
		,	ClientIdentifier
		,	ClientFullName
		,	MembershipDescription
		,	ClientMembershipBeginDate
		,	ClientMembershipEndDate
		,	CASE WHEN QtyDifference < 0 THEN (-1 * QtyDifference) ELSE QtyDifference END AS 'QtyDifference'  --Change the negative number to a positive
	FROM #Clients
	WHERE QtyDifference < 0
END
