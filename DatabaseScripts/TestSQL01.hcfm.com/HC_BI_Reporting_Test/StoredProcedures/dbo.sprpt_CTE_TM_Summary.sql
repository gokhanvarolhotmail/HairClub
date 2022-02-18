/* CreateDate: 02/10/2022 09:39:31.497 , ModifyDate: 02/10/2022 09:39:31.497 */
GO
Create PROCEDURE [dbo].[sprpt_CTE_TM_Summary]
    ( @ReportType INT,
      @BegDt datetime,
      @EndDt datetime,
      @Flags NVARCHAR(5)
    )
AS
BEGIN
;with cte_Centers as(
		SELECT  DR.RegionSSID AS MainGroupSSID
		,		DR.RegionDescription AS MainGroupDescription
		,		DC.CenterSSID
		,		DC.CenterKey
		,		DC.CenterDescriptionNumber
		,		DCT.CenterTypeDescriptionShort
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionKey = DR.RegionKey
		WHERE  DCT.CenterTypeDescriptionShort IN('F','JV')
				AND DC.Active = 'Y'
), cte_Shows as (
	SELECT
		ctr.CenterSSID as 'Center'
	,	SUM(Appointments) as 'Appt'
	,	SUM(Show) as 'Show'
	,	SUM(Sale) as 'Sale'
	FROM HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults far
		inner join cte_Centers ctr
			on far.CenterKey = ctr.CenterKey
		inner join HC_BI_ENT_DDS.bi_ent_dds.vwDimDate dd
			on far.ActivityDueDateKey = dd.datekey
	WHERE dd.FullDate between @BegDt and @EndDt
	GROUP BY ctr.CenterSSID
), cte_Leads as (
	SELECT
		ctr.CenterSSID as 'Center'
	,	SUM(fl.Leads) as 'Lead'
	FROM HC_BI_MKTG_DDS.bi_mktg_dds.vwFactLead fl
		inner join cte_Centers ctr
			on fl.CenterKey = ctr.CenterKey
		inner join HC_BI_ENT_DDS.bi_ent_dds.vwDimDate dd
			on fl.LeadCreationDateKey = dd.datekey
	WHERE dd.FullDate between @BegDt and @EndDt
	GROUP BY ctr.CenterSSID
)
SELECT  ctr.CenterSSID
,		ctr.MainGroupDescription
,		ctr.CenterDescriptionNumber
,		ISNULL(l.Lead,0) as 'Lead'
,		ISNULL(s.Appt,0) as 'Appt'
,		ISNULL(s.Show,0) as 'Show'
,		ISNULL(s.Sale,0) as 'Sale'
,		dbo.DIVIDE_NOROUND(ISNULL(s.Appt,0), ISNULL(l.Lead,0)) as 'BookingPace'
,		dbo.DIVIDE_NOROUND(ISNULL(s.Show,0), ISNULL(s.Appt,0)) as 'ShowRate'
,		dbo.DIVIDE_NOROUND(ISNULL(s.Sale,0), ISNULL(s.Show,0)) as 'ClosingRate'
,		dbo.DIVIDE_NOROUND(ISNULL(s.Sale,0), ISNULL(l.Lead,0)) as 'SalesToLeads'
FROM    cte_Centers ctr
		LEFT OUTER JOIN cte_Leads l
			ON l.Center = ctr.CenterSSID
		LEFT OUTER JOIN cte_Shows s
			ON s.Center = ctr.CenterSSID
Order by ctr.CenterSSID
END
GO
