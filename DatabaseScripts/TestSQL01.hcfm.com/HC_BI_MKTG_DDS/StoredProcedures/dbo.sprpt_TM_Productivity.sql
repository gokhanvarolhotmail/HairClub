/* CreateDate: 08/18/2011 11:24:48.760 , ModifyDate: 08/18/2011 15:43:15.357 */
GO
/***********************************************************************

PROCEDURE:				sprpt_TM_Productivity

VERSION:				v3.0

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_Reporting

RELATED APPLICATION:  	TM Productivity Report

AUTHOR: 				Howard Abelow

IMPLEMENTOR: 			Kevin Murdoch

DATE IMPLEMENTED: 		11/1/2007

LAST REVISION DATE: 	8/18/2011

------------------------------------------------------------------------
NOTES: Gets Query For Report
------------------------------------------------------------------------

SAMPLE EXECUTION: EXEC sprpt_TM_Productivity '7/21/11', '8/15/11',  '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36'

							EXEC sprpt_TM_Productivity '7/21/11', '8/4/11',  '35'

***********************************************************************/


CREATE   PROCEDURE [dbo].[sprpt_TM_Productivity]
    (
      @BegDt datetime,
      @EndDt datetime,
      @Groups varchar(500)
    )
AS


SET @EndDt = @EndDt + ' 23:59:00'

SELECT
		s.EmployeeSSID  as 'telemarketer'
	,	s.EmployeeTitle as 'nccgroup'
	,	s.employeefullname as 'tmname'
INTO #SALESPERSON
FROM bi_mktg_dds.DimEmployee s
		inner join [DimSalespersonGroups] sg ON RTRIM(s.[EmployeeTitle]) =  RTRIM(sg.[Groups])
		INNER JOIN dbo.SplitCenterIDs(@Groups) g ON sg.[SalesPersonGroupsId] = g.[CenterNumber]

--
-- Inbound Leads & Leads Emails
--

SELECT
		emp.EmployeeSSID as 'Telemarketer'
	,	fl.AssignedEmployeeKey
	,	fl.contactkey
	,	SUM(CASE WHEN  (con.contactfirstname <> '' or con.contactlastname <> '')
					THEN 1
				 ELSE	0
				 END) as 'I_Lead'
	,	SUM(CASE WHEN  (con.contactfirstname <> '' or con.contactlastname <> '')
				AND LEN(email.Email) > 0
					THEN 1
				 ELSE	0
				 END) as 'I_Lead_Emails'

INTO #LEADS
FROM
	bi_mktg_dds.FactLead fl
	inner join HC_BI_ENT_DDS.bi_ent_dds.vwDimDate dd
		on fl.LeadCreationDateKey = dd.DateKey
	inner join bi_mktg_dds.vwDimEmployee emp
		on fl.AssignedEmployeeKey = emp.EmployeeKey
	inner join bi_mktg_dds.vwDimContact con
		on fl.contactkey = con.contactkey
	left outer join bi_mktg_dds.vwDimContactEmail email
		on con.ContactSSID = email.ContactSSID

WHERE
	dd.FullDate between @BegDt and @EndDt
		AND emp.EmployeeSSID like 'TM%'
		and fl.ContactKey in (	select contactkey from bi_mktg_dds.vwDimActivity
								inner join bi_mktg_dds.vwFactActivity on
									vwDimActivity.ActivityKey = vwFactActivity.ActivityKey
								where activityduedate between @BegDt and @EndDt
										and ActionCodeSSID = 'INCALL'
										and ResultCodeSSID in ('APPOINT','BROCHURE')
										and vwFactActivity.ActivityEmployeeKey = fl.AssignedEmployeeKey
							 )
GROUP BY emp.EmployeeSSID,fl.contactkey,fl.AssignedEmployeeKey
ORDER BY emp.EmployeeSSID


--
-- Inbound Appointments & Brochures
--

SELECT
		emp.EmployeeSSID as 'Telemarketer'
	,	fact.ActivityEmployeeKey as 'EmployeeKey'
	,	fl.ContactKey
	,	SUM(CASE WHEN  dact.ActionCodeSSID = 'INCALL'
						AND DACT.ResultCodeSSID = 'APPOINT'
					THEN 1
				 ELSE	0
				 END) as 'I_Appt'
	,	SUM(CASE WHEN  dact.ActionCodeSSID = 'INCALL'
						AND DACT.ResultCodeSSID = 'BROCHURE'
					THEN 1
				 ELSE	0
				 END) as 'I_Broch'

INTO #APPTS
FROM
	bi_mktg_dds.FactLead fl
	inner join HC_BI_ENT_DDS.bi_ent_dds.vwDimDate dd
		on fl.LeadCreationDateKey = dd.DateKey
	inner join bi_mktg_dds.vwDimEmployee emp
		on fl.AssignedEmployeeKey = emp.EmployeeKey
	inner join bi_mktg_dds.vwDimContact con
		on fl.contactkey = con.contactkey
	inner join bi_mktg_dds.vwDimActivity dact
		on con.Contactssid = dact.ContactSSID and
			dact.ActionCodeSSID = 'INCALL'
						AND DACT.ResultCodeSSID in ( 'APPOINT','BROCHURE' )
	inner join bi_mktg_dds.vwFactActivity fact
		on dact.ActivityKey = fact.ActivityKey
			AND fact.ActivityEmployeeKey = fl.AssignedEmployeeKey
WHERE
	dd.FullDate between @BegDt and @EndDt
		AND emp.EmployeeSSID like 'TM%'
GROUP BY emp.EmployeeSSID,fl.ContactKey,fact.ActivityEmployeeKey
ORDER BY emp.EmployeeSSID

--
-- Join the 2 tables to create Inbound Section
--

SELECT
			#APPTS.Telemarketer
		,	SUM(#LEADS.I_Lead) as 'Inbound_Lead'
		,	SUM(#LEADS.I_Lead_Emails) as 'Inbound_Lead_Emails'
		,	SUM(CASE WHEN #APPTS.I_APPT = 1 THEN 0
					 WHEN #APPTS.I_Broch >=1 THEN 1 END) as 'Inbound_Broch'
		,	SUM(#APPTS.I_Appt) as 'Inbound_Appt'
INTO #INBOUND
FROM #APPTS
	inner join #LEADS
		on #APPTS.ContactKey = #LEADS.ContactKey
GROUP BY #APPTS.Telemarketer
ORDER BY #APPTS.Telemarketer

--
-- Inbound Scheduled & Outbound
--

SELECT
		emp.EmployeeSSID as 'Telemarketer'
	,	SUM(CASE WHEN [ActionCodeSSID] = 'APPOINT' AND ActivityTypeSSID = 'INBOUND'
                       AND ResultCodeSSID NOT IN ('CANCEL', 'RESCHEDULE', 'CTREXCPTN') THEN 1
                 ELSE 0
                 END) as 'Inbound_Scheduled_Appt'
	,	SUM(CASE WHEN [ActionCodeSSID] = 'APPOINT' AND ActivityTypeSSID = 'INBOUND'
                       AND ResultCodeSSID IN ('SHOWNOSALE', 'SHOWSALE' ) THEN 1
                 ELSE 0
                 END) AS 'Inbound_Scheduled_Show'
	,	SUM(CASE WHEN [ActionCodeSSID] = 'APPOINT' AND ActivityTypeSSID = 'INBOUND'
                       AND ResultCodeSSID IN ('SHOWSALE') THEN 1
                 ELSE 0
                 END) AS 'Inbound_Scheduled_Sale'
	,	SUM(CASE WHEN [ActionCodeSSID] = 'APPOINT' AND ActivityTypeSSID = 'OUTBOUND'
                       AND ResultCodeSSID NOT IN ('CANCEL', 'RESCHEDULE', 'CTREXCPTN' ) THEN 1
                 ELSE 0
                 END) AS 'Outbound_Scheduled_Appt'
	,	SUM(CASE WHEN [ActionCodeSSID] = 'APPOINT' AND ActivityTypeSSID = 'OUTBOUND'
                       AND ResultCodeSSID IN ('SHOWNOSALE', 'SHOWSALE' ) THEN 1
                 ELSE 0
                 END) AS 'Outbound_Scheduled_Show'
	,	SUM(CASE WHEN [ActionCodeSSID] = 'APPOINT' AND ActivityTypeSSID = 'OUTBOUND'
                       AND ResultCodeSSID IN ('SHOWSALE') THEN 1
                 ELSE 0
                 END) AS 'Outbound_Scheduled_Sale'
INTO #SCHEDULED
FROM bi_mktg_dds.vwdimActivity da
	inner join bi_mktg_dds.vwFactActivity fa
		on da.ActivityKey = fa.ActivityKey
	inner join bi_mktg_dds.vwDimEmployee emp
		on fa.ActivityEmployeeKey = emp.EmployeeKey
WHERE
	emp.EmployeeSSID LIKE 'TM%'
		AND ActivityDueDate between @BegDt and @EndDt
		AND ActionCodeSSID = 'APPOINT'
GROUP BY emp.EmployeeSSID
ORDER by emp.employeessid

--
-- Result = Appoint
--

SELECT
		emp.EmployeeSSID as 'Telemarketer'
	,	SUM(CASE WHEN --[ActionCodeSSID] IN ('BROCHCALL', 'NOSHOWCALL', 'CANCELCALL', 'EXOUTCALL')
					   ActivityTypeSSID = 'OUTBOUND'
					   AND ResultCodeSSID = 'APPOINT' THEN 1
                 ELSE 0
                 END) AS 'Result_Appt'
INTO #RESULTAPPTS
FROM bi_mktg_dds.vwdimActivity da
	inner join bi_mktg_dds.vwFactActivity fa
		on da.ActivityKey = fa.ActivityKey
	inner join bi_mktg_dds.vwDimEmployee emp
		on fa.CompletedByEmployeeKey = emp.EmployeeKey

WHERE
	emp.EmployeeSSID LIKE 'TM%'
		AND ActivityCompletionDate between @BegDt and @EndDt
		AND ResultCodeSSID = 'APPOINT'
GROUP BY emp.EmployeeSSID
ORDER by emp.employeessid

--
--	Create Result Set
--

SELECT
		#SALESPERSON.telemarketer
	,	#SALESPERSON.nccgroup
	,	#SALESPERSON.tmname
	,	ISNULL(#INBOUND.Inbound_Lead,0)
	,	ISNULL(#INBOUND.Inbound_Lead_Emails,0)
	,	ISNULL(#INBOUND.Inbound_Broch,0)
	,	ISNULL(#INBOUND.Inbound_Appt,0)
	,	ISNULL(dbo.DIVIDE_NOROUND(cast(#INBOUND.Inbound_Appt as SMALLMONEY),CAST(#INBOUND.Inbound_Lead AS SMALLMONEY)),0)
		AS 'Lead_Conversion_%'
	,	ISNULL(#SCHEDULED.Inbound_Scheduled_Appt,0)
	,	ISNULL(#SCHEDULED.Inbound_Scheduled_Show,0)
	,	ISNULL(#SCHEDULED.Inbound_Scheduled_Sale,0)
	,	ISNULL(dbo.DIVIDE_NOROUND(cast(#SCHEDULED.Inbound_Scheduled_Appt as SMALLMONEY),CAST(#SCHEDULED.Inbound_Scheduled_Appt AS SMALLMONEY)),0)
		AS 'Inbound_Conversion_%'
	,	ISNULL(#RESULTAPPTS.Result_Appt,0)
	,	ISNULL(#SCHEDULED.Outbound_Scheduled_Appt,0)
	,	ISNULL(#SCHEDULED.Outbound_Scheduled_Show,0)
	,	ISNULL(#SCHEDULED.Outbound_Scheduled_Sale,0)
	,	ISNULL(dbo.DIVIDE_NOROUND(cast(#SCHEDULED.Outbound_Scheduled_Appt as SMALLMONEY),CAST(#SCHEDULED.Outbound_Scheduled_Appt AS SMALLMONEY)),0)
		AS 'Outbound_Conversion_%'
	,	ISNULL(#SCHEDULED.Inbound_Scheduled_Appt,0) + ISNULL(#SCHEDULED.Outbound_Scheduled_Appt,0) as 'Total_Appt'
	,	ISNULL(#SCHEDULED.Inbound_Scheduled_Show,0) + ISNULL(#SCHEDULED.Outbound_Scheduled_Show,0) as 'Total_Show'
	,	ISNULL(dbo.DIVIDE_NOROUND(ISNULL(#SCHEDULED.Inbound_Scheduled_Show,0) + ISNULL(#SCHEDULED.Outbound_Scheduled_Show,0),
				ISNULL(#SCHEDULED.Inbound_Scheduled_Appt,0) + ISNULL(#SCHEDULED.Outbound_Scheduled_Appt,0)),0)
		AS 'Total_Conversion_%'

FROM #SALESPERSON
	left outer join #INBOUND
		ON #SALESPERSON.telemarketer = #INBOUND.Telemarketer
	left outer join #SCHEDULED
		ON #SALESPERSON.telemarketer = #SCHEDULED.Telemarketer
	left outer join #RESULTAPPTS
		ON #SALESPERSON.telemarketer = #RESULTAPPTS.Telemarketer
WHERE
(
		ISNULL([Inbound_Lead],0) > 0
	OR ISNULL([Inbound_Lead_Emails],0) > 0
	OR ISNULL([Inbound_Appt],0) > 0
	OR ISNULL([Inbound_Broch],0) > 0
	OR ISNULL([Inbound_Scheduled_Appt],0) > 0
	OR ISNULL([Result_Appt],0) > 0
	OR ISNULL([Inbound_Scheduled_Show],0) > 0
	OR ISNULL([Inbound_Scheduled_Sale] ,0) > 0
	OR ISNULL([Outbound_Scheduled_Appt]  ,0) > 0
	OR ISNULL([Outbound_Scheduled_Show] ,0) > 0
	OR ISNULL([Outbound_Scheduled_Sale] ,0) > 0
	)
order by #SALESPERSON.nccgroup, #SALESPERSON.telemarketer


	--select * from bi_mktg_dds.DimEmployee
	--SELECT * FROM bi_mktg_dds.vwdimContact where contactfirstname =''
	--select * from bi_mktg_dds.dimactivity
	--select * from bi_mktg_dds.factactivity
GO
