/* CreateDate: 05/20/2019 17:01:54.457 , ModifyDate: 05/20/2019 17:03:49.120 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					[TESTvwd_LASS_Rolling2Years]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		08/02/2016
------------------------------------------------------------------------
NOTES:
------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM [TESTvwd_LASS_Rolling2Years]
***********************************************************************/
CREATE VIEW [dbo].[TESTvwd_LASS_Rolling2Years]
AS


WITH Rolling2Years AS (
				SELECT	DD.DateKey
				,	DD.FullDate
				,	DD.FirstDateOfMonth
				,	DD.MonthNumber
				,	DD.YearNumber
				FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
				WHERE DD.FullDate BETWEEN DATEADD(yy, -1, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  --First date of year one year ago
					AND DATEADD(MINUTE,-1,(DATEADD(DAY,DATEDIFF(DAY,0,GETDATE()+1),0) )) --KEEP Today at 11:59PM

				--For Testing
				--WHERE DD.FullDate BETWEEN '7/1/2016' AND '7/31/2016'
				GROUP BY DD.DateKey
				,	DD.FullDate
				,	DD.FirstDateOfMonth
				,	DD.MonthNumber
				,	DD.YearNumber
		)

,	Leads AS (SELECT DC.CenterKey
					,	ROLL.FirstDateOfMonth
					,	ROLL.MonthNumber
					,	ROLL.YearNumber
					,	SUM(ISNULL(FL.Leads,0)) AS 'Leads'
				FROM HC_BI_MKTG_DDS.bi_mktg_dds.FactLead FL
				INNER JOIN Rolling2Years ROLL
					ON FL.LeadCreationDateKey = ROLL.DateKey
				LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource S
					ON S.SourceKey = FL.SourceKey
 				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
 					ON DC.CenterKey = FL.CenterKey
				WHERE FL.Leads = 1
				GROUP BY DC.CenterKey
					,	ROLL.FirstDateOfMonth
					,	ROLL.MonthNumber
					,	ROLL.YearNumber
					,	DC.CenterDescription
					,	DC.CenterDescriptionNumber
					,	ROLL.FirstDateOfMonth
	    )
,	Appts AS (SELECT ctr.CenterKey
					, ROLL.FirstDateOfMonth
					, COUNT(*) AS 'Appointments'
				FROM HC_BI_MKTG_DDS.bi_mktg_dds.vwDimActivity da
					INNER JOIN Rolling2Years ROLL
						ON da.ActivityDueDate = ROLL.FullDate
					LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivity fa
						ON da.activitykey = fa.ActivityKey
					LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource S
						ON S.SourceSSID = da.SourceSSID
					--LEFT OUTER JOIN dbo.vwChannelTypeSubtype CTS
					--	ON CTS.SourceKey = S.SourceKey
					LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.FactLead fl
						ON fa.ContactKey = fl.ContactKey
					LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwDimContact dc
						ON fl.ContactKey = dc.ContactKey
					LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwDimContactAddress dca
						ON da.contactssid = dca.contactssid
							AND dca.PrimaryFlag = 'Y'
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
						ON da.CenterSSID = ctr.CenterSSID
					LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwDimEmployee emp
						ON fl.EmployeeKey = emp.EmployeeKey
					LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwDimContactPhone dcp
						ON da.ContactSSID = dcp.ContactSSID
							AND dcp.PrimaryFlag = 'Y'
				WHERE da.isappointment = 1
					AND fl.Leads = 1
					AND da.ResultCodeSSID NOT IN ( 'CANCEL', 'RESCHEDULE', 'CTREXCPTN')
				GROUP BY ctr.CenterKey
				,	ROLL.FirstDateOfMonth
	    )
,	Shows AS (SELECT ctr.CenterKey
					, ROLL.FirstDateOfMonth
					, COUNT(*) AS 'Shows'
				FROM HC_BI_MKTG_DDS.bi_mktg_dds.vwDimActivity da
					INNER JOIN Rolling2Years ROLL
						ON da.ActivityDueDate = ROLL.FullDate
					LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource S
						ON S.SourceSSID = da.SourceSSID
					--LEFT OUTER JOIN dbo.vwChannelTypeSubtype CTS
					--	ON CTS.SourceKey = S.SourceKey
					LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivity fa
						ON da.activitykey = fa.ActivityKey
					LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.FactLead fl
						ON fa.ContactKey = fl.ContactKey
					LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwDimContact dc
						ON fl.ContactKey = dc.ContactKey
					LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwDimContactAddress dca
						ON da.contactssid = dca.contactssid
							AND dca.PrimaryFlag = 'Y'
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
						ON da.CenterSSID = ctr.CenterSSID
					LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwDimEmployee emp
						ON fl.EmployeeKey = emp.EmployeeKey
					LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwDimContactPhone dcp
						ON da.ContactSSID = dcp.ContactSSID
							AND dcp.PrimaryFlag = 'Y'
				WHERE da.IsShow = 1
					AND fl.Leads = 1
					AND da.ResultCodeSSID NOT IN ( 'CANCEL', 'RESCHEDULE', 'CTREXCPTN')
				GROUP BY ctr.CenterKey
				,	ROLL.FirstDateOfMonth
	    )
,	Sales AS (SELECT ctr.CenterKey
					, ROLL.FirstDateOfMonth
					, COUNT(*) AS 'Sales'
				FROM HC_BI_MKTG_DDS.bi_mktg_dds.vwDimActivity da
					INNER JOIN Rolling2Years ROLL
						ON da.ActivityDueDate = ROLL.FullDate
					LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivity fa
						ON da.activitykey = fa.ActivityKey
					LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource S
						ON S.SourceSSID = da.SourceSSID
					--LEFT OUTER JOIN dbo.vwChannelTypeSubtype CTS
					--	ON CTS.SourceKey = S.SourceKey
					LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.FactLead fl
						ON fa.ContactKey = fl.ContactKey
					LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwDimContact dc
						ON fl.ContactKey = dc.ContactKey
					LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwDimContactAddress dca
						ON da.contactssid = dca.contactssid
							AND dca.PrimaryFlag = 'Y'
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
						ON da.CenterSSID = ctr.CenterSSID
					LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwDimEmployee emp
						ON fl.EmployeeKey = emp.EmployeeKey
					LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwDimContactPhone dcp
						ON da.ContactSSID = dcp.ContactSSID
							AND dcp.PrimaryFlag = 'Y'
				WHERE da.IsSale = 1
					AND fl.Leads = 1
					AND da.ResultCodeSSID NOT IN ( 'CANCEL', 'RESCHEDULE', 'CTREXCPTN')
				GROUP BY ctr.CenterKey
				,	ROLL.FirstDateOfMonth
	    )

 SELECT L.FirstDateOfMonth
	,	L.MonthNumber
	,	L.YearNumber
	,	DC.CenterSSID
	,	DC.CenterDescription
	,	DC.CenterDescriptionNumber
	,	DC.CenterTypeSSID
	,	CT.CenterTypeDescription
	,	L.Leads

	,	A.Appointments

	,	SH.Shows

    ,	SA.Sales

 FROM Leads L
 	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
 		ON L.CenterKey = DC.CenterKey
	INNER JOIN Appts A
		ON A.CenterKey = DC.CenterKey AND A.FirstDateOfMonth = L.FirstDateOfMonth
	INNER JOIN Shows SH
		ON SH.CenterKey = DC.CenterKey AND SH.FirstDateOfMonth = L.FirstDateOfMonth
	INNER JOIN Sales SA
		ON SA.CenterKey = DC.CenterKey AND SA.FirstDateOfMonth = L.FirstDateOfMonth
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON DC.CenterTypeKey = CT.CenterTypeKey

GROUP BY L.MonthNumber
	,	L.YearNumber
	,	L.FirstDateOfMonth
    ,	DC.CenterSSID
    ,	DC.CenterDescription
    ,	DC.CenterDescriptionNumber

    ,	DC.CenterTypeSSID
    ,	CT.CenterTypeDescription
		,	L.Leads
	,	A.Appointments

	,	SH.Shows

    ,	SA.Sales
GO
