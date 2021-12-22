/* CreateDate: 02/18/2015 13:49:07.130 , ModifyDate: 10/12/2015 09:32:27.270 */
GO
/***********************************************************************
PROCEDURE:				[spRpt_DashbCenterSalesMix]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:
AUTHOR:					Rachelen Hut
CREATION DATE:			02/18/2015
------------------------------------------------------------------------
CHANGE HISTORY:
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_DashbCenterSalesMix] 201

EXEC [spRpt_DashbCenterSalesMix] 896

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_DashbCenterSalesMix]
(
	@CenterSSID INT
)
AS
BEGIN

	SET NOCOUNT ON
	SET FMTONLY OFF

	DECLARE	@StartDate DATETIME
	,	@EndDate DATETIME

	SET @StartDate = CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME)		--Beginning of the month

	SET @EndDate = DATEADD(MINUTE,-1,(DATEADD(day,DATEDIFF(day,0,GETDATE()+1),0) )) --Today at 11:59PM

	--For testing
	--SET @StartDate = DATEADD(MONTH,-1,CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME))	--Beginning of last month
	--SET @EndDate = DATEADD(Minute,-1,CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME))	--End of last month at 11:59PM										--Today at 11:59PM

	PRINT '@StartDate = ' + CAST(@StartDate AS VARCHAR(100))
	PRINT '@EndDate = ' + CAST(@EndDate AS VARCHAR(100))

	CREATE TABLE #salesmix(
			StartDate DATETIME
		,	CenterType CHAR(1)
		,	CenterSSID INT
		,	CenterDescriptionNumber NVARCHAR(50)
		,	CenterDescription NVARCHAR(50)
		,	XTRPlus_SalesMix FLOAT
		,	EXT_SalesMix FLOAT
		,	Xtrands_SalesMix FLOAT
		,	Surgery_SalesMix FLOAT)

	INSERT INTO #salesmix
	SELECT @StartDate AS 'StartDate'
		,	 CASE WHEN C.CenterTypeSSID = 1 THEN  'C' ELSE 'F' END AS 'CenterType'
		,	C.CenterSSID
		,	C.CenterDescriptionNumber
		,	C.CenterDescription
		,	CASE WHEN CAST(SUM(ISNULL(FST.NB_TradCnt, 0))
				+ SUM(ISNULL(FST.NB_ExtCnt, 0))
				+ SUM(ISNULL(FST.NB_XtrCnt, 0))
                + SUM(ISNULL(FST.NB_GradCnt, 0))
				+ SUM(ISNULL(FST.S_SurCnt, 0))AS FLOAT)=0 THEN 0
			ELSE
				(CAST(SUM(ISNULL(FST.NB_TradCnt, 0)) + SUM(ISNULL(FST.NB_GradCnt, 0)) AS FLOAT)
				/
				CAST(SUM(ISNULL(FST.NB_TradCnt, 0))
				+ SUM(ISNULL(FST.NB_ExtCnt, 0))
				+ SUM(ISNULL(FST.NB_XtrCnt, 0))
				+ SUM(ISNULL(FST.NB_GradCnt, 0))
				+ SUM(ISNULL(FST.S_SurCnt, 0)) AS FLOAT))
			END
			AS 'XTRPlus_SalesMix'

		,	CASE WHEN CAST(SUM(ISNULL(FST.NB_TradCnt, 0))
				+ SUM(ISNULL(FST.NB_ExtCnt, 0))
				+ SUM(ISNULL(FST.NB_XtrCnt, 0))
                + SUM(ISNULL(FST.NB_GradCnt, 0))
				+ SUM(ISNULL(FST.S_SurCnt, 0))AS FLOAT)=0 THEN 0
			ELSE
				(CAST(SUM(ISNULL(FST.NB_EXTCnt, 0)) AS FLOAT)
				/
				CAST(SUM(ISNULL(FST.NB_TradCnt, 0))
				+ SUM(ISNULL(FST.NB_ExtCnt, 0))
				+ SUM(ISNULL(FST.NB_XtrCnt, 0))
				+ SUM(ISNULL(FST.NB_GradCnt, 0))
				+ SUM(ISNULL(FST.S_SurCnt, 0)) AS FLOAT))
			END
			AS 'EXT_SalesMix'

		,	CASE WHEN CAST(SUM(ISNULL(FST.NB_TradCnt, 0))
				+ SUM(ISNULL(FST.NB_ExtCnt, 0))
				+ SUM(ISNULL(FST.NB_XtrCnt, 0))
                + SUM(ISNULL(FST.NB_GradCnt, 0))
				+ SUM(ISNULL(FST.S_SurCnt, 0))AS FLOAT)=0 THEN 0
			ELSE
				(CAST(SUM(ISNULL(FST.NB_XTRCnt, 0)) AS FLOAT)
				/
				CAST(SUM(ISNULL(FST.NB_TradCnt, 0))
				+ SUM(ISNULL(FST.NB_ExtCnt, 0))
				+ SUM(ISNULL(FST.NB_XtrCnt, 0))
				+ SUM(ISNULL(FST.NB_GradCnt, 0))
				+ SUM(ISNULL(FST.S_SurCnt, 0)) AS FLOAT))
			END
			AS 'Xtrands_SalesMix'

		,	CASE WHEN CAST(SUM(ISNULL(FST.NB_TradCnt, 0))
				+ SUM(ISNULL(FST.NB_ExtCnt, 0))
				+ SUM(ISNULL(FST.NB_XtrCnt, 0))
                + SUM(ISNULL(FST.NB_GradCnt, 0))
				+ SUM(ISNULL(FST.S_SurCnt, 0)) AS FLOAT)=0 THEN 0
			ELSE
				(CAST(SUM(ISNULL(FST.S_SurCnt, 0)) AS FLOAT)
				/
				CAST(SUM(ISNULL(FST.NB_TradCnt, 0))
				+ SUM(ISNULL(FST.NB_ExtCnt, 0))
				+ SUM(ISNULL(FST.NB_XtrCnt, 0))
				+ SUM(ISNULL(FST.NB_GradCnt, 0))
				+ SUM(ISNULL(FST.S_SurCnt, 0)) AS FLOAT))
			END
			AS 'Surgery_SalesMix'
	FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FST.OrderDateKey = DD.DateKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON C.CenterKey = FST.CenterKey
	WHERE DD.[FullDate] BETWEEN @StartDate AND @EndDate
		AND C.CenterSSID = @CenterSSID
	GROUP BY C.CenterSSID
	,	C.CenterTypeSSID
	,	C.CenterDescriptionNumber
	,	C.CenterDescription


	--SELECT * FROM #salesmix

	select StartDate
		,	CenterType
		,	CenterSSID
		,	CenterDescriptionNumber
		,	CenterDescription
		,	CASE WHEN subject = 'XTRPlus_SalesMix' THEN 'XTRPlus'
		WHEN subject = 'EXT_SalesMix' THEN 'EXT'
		WHEN subject = 'Xtrands_SalesMix' THEN 'Xtrands'
		WHEN subject = 'Surgery_SalesMix' THEN 'SUR'
		END AS SalesMixName
		,	marks
	from #salesmix
	unpivot
	(
	  marks
	  for subject in (XTRPlus_SalesMix
		,	EXT_SalesMix
		,	Xtrands_SalesMix
		,	Surgery_SalesMix)
	) u;


END
GO
