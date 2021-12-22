/* CreateDate: 08/03/2011 09:48:26.243 , ModifyDate: 08/03/2011 10:31:11.670 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				sprpt_TM_Summary_by_DMA

VERSION:				v3.0

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_Reporting

RELATED APPLICATION:  	Bookings Report

AUTHOR: 				Howard Abelow

IMPLEMENTOR: 			Kevin Murdoch

DATE IMPLEMENTED: 		10/11/2007

LAST REVISION DATE: 	08/03/2011

------------------------------------------------------------------------
NOTES: Gets Query For Report
	11/12/2007		HAbelow		- revised for Lead/Activity tqbles
	08/03/2011		KMurdoch	- Migrated to BI Environment
------------------------------------------------------------------------

SAMPLE EXECUTION:
		EXEC sprpt_TM_Summary_by_DMA '7/1/11', '7/15/11',  'F'

***********************************************************************/


CREATE   PROCEDURE [dbo].[sprpt_TM_Summary_by_DMA]
    (
      @BegDt datetime,
      @EndDt datetime,
      @Flags varchar(4)
    )

AS

--
-- Get Appointment, Show, Sale count by Due Date by Center
--
	SELECT
		ctr.CenterSSID as 'Center'
	,	SUM(Appointments) as 'Appt'
	,	SUM(Show) as 'Show'
	,	SUM(Sale) as 'Sale'
	INTO    #shows
	FROM dbo.synHC_MKTG_DDS_vwFactActivityResults far
		inner join dbo.synHC_ENT_DDS_vwDimCenter ctr
			on far.CenterKey = ctr.CenterKey
		inner join dbo.synHC_ENT_DDS_vwDimDate dd
			on far.ActivityDueDateKey = dd.datekey
	WHERE dd.FullDate between @BegDt and @EndDt
		AND CTR.CenterSSID LIKE
			CASE WHEN @FLAGS = 'C' THEN '[2]__'
				ELSE CASE WHEN @FLAGS = 'F' THEN '[78]__'
					ELSE CASE WHEN @FLAGS = 'A' THEN '[278]__'
				ELSE @FLAGS
					END
				END
			END
		AND CTR.Active = 'Y'
	GROUP BY ctr.CenterSSID
--
--	Get Lead Count by Create Date by Center
--

	SELECT
		ctr.CenterSSID as 'Center'
	,	count(*) as 'Lead'
	INTO #leads
	FROM dbo.synHC_MKTG_DDS_vwFactLead fl
		inner join dbo.synHC_ENT_DDS_vwDimCenter ctr
			on fl.CenterKey = ctr.CenterKey
		inner join dbo.synHC_ENT_DDS_vwDimDate dd
			on fl.LeadCreationDateKey = dd.datekey
	WHERE dd.FullDate between @BegDt and @EndDt
		AND CTR.CenterSSID LIKE
			CASE WHEN @FLAGS = 'C' THEN '[2]__'
				ELSE CASE WHEN @FLAGS = 'F' THEN '[78]__'
					ELSE CASE WHEN @FLAGS = 'A' THEN '[278]__'
				ELSE @FLAGS
					END
				END
			END
		AND CTR.Active = 'Y'
	GROUP BY ctr.CenterSSID
--
--	Join Leads and Show tables
--
	SELECT
		#leads.Center
	,	#leads.Lead
	,	#shows.Appt
	,	#shows.Show
	,	#shows.Sale
	INTO #results
	FROM #leads
	LEFT OUTER JOIN #shows ON #leads.Center = #shows.Center

--
-- Get Center/Region Descriptions, do calculations
--
	SELECT
		#results.Center
	,	reg.RegionDescription
	,	ctr.CenterDescriptionNumber
	,	#results.Lead
	,	#results.Appt
	,	#results.Show
	,	#results.Sale
	,	dbo.DIVIDE_NOROUND(#results.Appt,#results.Lead) as 'BookingPace'
	,	dbo.DIVIDE_NOROUND(#results.Show,#results.Appt) as 'ShowRate'
	,	dbo.DIVIDE_NOROUND(#results.Sale,#results.Show) as 'ClosingRate'
	,	dbo.DIVIDE_NOROUND(#results.Sale,#results.Lead) as 'SalesToLeads'
	FROM #results
	inner join dbo.synHC_ENT_DDS_vwDimCenter ctr
		on #results.Center = ctr.CenterSSID
	inner join dbo.synHC_ENT_DDS_vwDimRegion reg
		on  ctr.RegionKey = reg.RegionKey
	ORDER BY
		reg.RegionDescription
	,	ctr.CenterDescriptionNumber
GO
