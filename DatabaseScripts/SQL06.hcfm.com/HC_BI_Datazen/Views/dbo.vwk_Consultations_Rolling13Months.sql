/* CreateDate: 07/23/2015 08:39:08.727 , ModifyDate: 08/04/2015 17:12:40.263 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					vw_Consultations_Rolling13Months
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Scott Hietpas
IMPLEMENTOR:			Scott Hietpas
DATE IMPLEMENTED:		07/21/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vw_Consultations_Rolling13Months
***********************************************************************/
CREATE VIEW [dbo].[vwk_Consultations_Rolling13Months]
AS

WITH CurrentMTD AS (
	SELECT Datekey
		,YearMonthNumber
		--, CummWorkdays
		--,MAX(CummWorkdays)OVER(PARTITION BY [YearMonthNumber]) as CurMTDWorkdays
	FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
	WHERE DD.FullDate BETWEEN DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) - 12, 0) AND DATEADD(DAY,-1,GETDATE()) --Rolling 12 month + current MTD
)
, CorporateCenters AS (
	SELECT DC.CenterKey
		,	DC.CenterDescriptionNumber
	FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenterType] CT
               ON DC.CenterTypeKey = CT.CenterTypeKey
      WHERE  CT.[CenterTypeDescriptionShort] = 'C' --Corporate
)
, Consultations AS (
       SELECT
					CorporateCenters.CenterKey
					,	CurrentMTD.YearMonthNumber
					,   SUM(Consultation) AS 'Consultations'  --These values have been set in the view vwFactActivityResults - referrals have already been removed.
       FROM    HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
                     INNER JOIN CorporateCenters
                           ON FAR.CenterKey = CorporateCenters.CenterKey
                     INNER JOIN CurrentMTD
                           ON FAR.ActivityDueDateKey = CurrentMTD.DateKey
       WHERE  FAR.BeBack <> 1 --ignore additional consultations beyond initial (they came back)
	   GROUP BY CorporateCenters.CenterKey
			,	CurrentMTD.YearMonthNumber
)

SELECT CC.CenterDescriptionNumber
	,	Cons.YearMonthNumber
	,	SUM(Cons.Consultations)  AS 'Consultations'
FROM Consultations Cons
INNER JOIN CorporateCenters CC
	ON Cons.CenterKey = CC.CenterKey
GROUP BY CC.CenterDescriptionNumber
	,Cons.YearMonthNumber
GO
