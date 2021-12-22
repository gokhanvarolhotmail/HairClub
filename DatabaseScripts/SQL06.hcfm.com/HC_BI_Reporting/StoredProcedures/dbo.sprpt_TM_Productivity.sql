/* CreateDate: 08/18/2011 16:33:57.420 , ModifyDate: 01/29/2019 16:10:46.980 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
CHANGE HISTORY:
09/09/2011 - HDu - Debugging and corrections
10/11/2016 - RH  - Added section for BeBacks (#131331)
------------------------------------------------------------------------

SAMPLE EXECUTION:
EXEC sprpt_TM_Productivity '11/17/2018', '11/30/2018', '47,2,3,4,49,5,6,50,7,45,57,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,56,24,25,26,27,28,29,30,51,54,46,44,31,32,52,48,33,47,34,35,36,53,37,38,39,40,41,42,43,55'
***********************************************************************/
CREATE PROCEDURE [dbo].[sprpt_TM_Productivity]
    (
      @BegDt datetime,
      @EndDt datetime,
      @Groups varchar(500)
    )
AS
BEGIN

SET @EndDt = @EndDt + ' 23:59:59'

SELECT

		s.EmployeeSSID  as 'telemarketer'
	,	ISNULL(s.EmployeeTitle, 'UNKNOWN') as 'nccgroup'
	,	s.employeefullname as 'tmname'
INTO #SALESPERSON
FROM HC_BI_MKTG_DDS.bi_mktg_dds.DimEmployee s
		left join [DimSalespersonGroups] sg ON RTRIM(s.[EmployeeTitle]) =  RTRIM(sg.[Groups])
		inner join dbo.SplitCenterIDs(@Groups) g ON sg.[SalesPersonGroupsId] = g.[CenterNumber]
GROUP BY s.EmployeeSSID
	,	s.EmployeeTitle
	,	s.employeefullname


/************************************************************************************************/
/******************************* Appointment Section ********************************************/
/************************************************************************************************/

--
-- Inbound Leads & Leads Emails
--

SELECT
		emp.EmployeeSSID as 'Telemarketer'
	,	fl.EmployeeKey
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
	HC_BI_MKTG_DDS.bi_mktg_dds.FactLead fl
	inner join HC_BI_ENT_DDS.bief_dds.DimDate dd
		on fl.LeadCreationDateKey = dd.DateKey
	inner join HC_BI_MKTG_DDS.bi_mktg_dds.DimEmployee emp
		on fl.EmployeeKey = emp.EmployeeKey
	inner join HC_BI_MKTG_DDS.bi_mktg_dds.DimContact con
		on fl.contactkey = con.contactkey
	left outer join HC_BI_MKTG_DDS.bi_mktg_dds.DimContactEmail email
		on con.SFDC_LeadID = email.SFDC_LeadID
		--ON con.ContactSSID = email.ContactSSID
		AND email.PrimaryFlag = 'Y'

WHERE
	dd.FullDate between @BegDt and @EndDt
		AND emp.EmployeeSSID like 'TM%'
		AND con.ContactStatusDescription IN ( 'Lead', 'Client' )
		and fl.ContactKey in (	select contactkey from HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity vwDimActivity
								inner join HC_BI_MKTG_DDS.bi_mktg_dds.FactActivity vwFactActivity on
									vwDimActivity.ActivityKey = vwFactActivity.ActivityKey
								where activityduedate between @BegDt and @EndDt
										and ActionCodeSSID = 'INCALL'
										and ResultCodeSSID in ('APPOINT','BROCHURE')
										and vwFactActivity.ActivityEmployeeKey = fl.EmployeeKey
							 )
GROUP BY emp.EmployeeSSID,fl.contactkey,fl.EmployeeKey
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
	HC_BI_MKTG_DDS.bi_mktg_dds.FactLead fl
	inner join HC_BI_ENT_DDS.bief_dds.DimDate dd
		on fl.LeadCreationDateKey = dd.DateKey
	inner join HC_BI_MKTG_DDS.bi_mktg_dds.DimEmployee emp
		on fl.EmployeeKey = emp.EmployeeKey
	inner join HC_BI_MKTG_DDS.bi_mktg_dds.DimContact con
		on fl.contactkey = con.contactkey
	inner join HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity dact
		on con.SFDC_LeadID = dact.SFDC_LeadID and
			dact.ActionCodeSSID = 'INCALL'
						AND DACT.ResultCodeSSID in ( 'APPOINT','BROCHURE' )
	inner join HC_BI_MKTG_DDS.bi_mktg_dds.FactActivity fact
		on dact.ActivityKey = fact.ActivityKey
			AND fact.ActivityEmployeeKey = fl.EmployeeKey
WHERE
	dd.FullDate between @BegDt and @EndDt
		AND emp.EmployeeSSID like 'TM%'
		AND con.ContactStatusDescription IN ( 'Lead', 'Client' )
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
                       AND ResultCodeSSID NOT IN ('','CANCEL', 'RESCHEDULE', 'CTREXCPTN') THEN 1
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
                       AND ResultCodeSSID NOT IN ('','CANCEL', 'RESCHEDULE', 'CTREXCPTN' ) THEN 1
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
FROM HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity da
	inner join HC_BI_MKTG_DDS.bi_mktg_dds.FactActivity fa
		on da.ActivityKey = fa.ActivityKey
	inner join HC_BI_MKTG_DDS.bi_mktg_dds.DimEmployee emp
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
FROM HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity da
	inner join HC_BI_MKTG_DDS.bi_mktg_dds.FactActivity fa
		on da.ActivityKey = fa.ActivityKey
	inner join HC_BI_MKTG_DDS.bi_mktg_dds.DimEmployee emp
		on fa.CompletedByEmployeeKey = emp.EmployeeKey

WHERE
	emp.EmployeeSSID LIKE 'TM%'
		AND ActivityCompletionDate between @BegDt and @EndDt
		AND ResultCodeSSID = 'APPOINT'
GROUP BY emp.EmployeeSSID
ORDER by emp.employeessid

/************************************************************************************************/
/******************************* Beback Section *************************************************/
/************************************************************************************************/

--
-- BeBack Inbound Scheduled & Outbound
--

SELECT
		emp.EmployeeSSID as 'Telemarketer'
	,	emp.EmployeeFullName
	,	SUM(CASE WHEN [ActionCodeSSID] = 'BEBACK' AND ActivityTypeSSID = 'INBOUND'
                       AND ResultCodeSSID NOT IN ('','CANCEL', 'RESCHEDULE', 'CTREXCPTN') THEN 1
                 ELSE 0
                 END) as 'BB_Inbound_Scheduled_Appt'
	,	SUM(CASE WHEN [ActionCodeSSID] = 'BEBACK' AND ActivityTypeSSID = 'INBOUND'
                       AND ResultCodeSSID IN ('SHOWNOSALE', 'SHOWSALE' ) THEN 1
                 ELSE 0
                 END) AS 'BB_Inbound_Scheduled_Show'
	,	SUM(CASE WHEN [ActionCodeSSID] = 'BEBACK' AND ActivityTypeSSID = 'INBOUND'
                       AND ResultCodeSSID IN ('SHOWSALE') THEN 1
                 ELSE 0
                 END) AS 'BB_Inbound_Scheduled_Sale'
	,	SUM(CASE WHEN [ActionCodeSSID] = 'BEBACK' AND ActivityTypeSSID = 'OUTBOUND'
                       AND ResultCodeSSID NOT IN ('','CANCEL', 'RESCHEDULE', 'CTREXCPTN' ) THEN 1
                 ELSE 0
                 END) AS 'BB_Outbound_Scheduled_Appt'
	,	SUM(CASE WHEN [ActionCodeSSID] = 'BEBACK' AND ActivityTypeSSID = 'OUTBOUND'
                       AND ResultCodeSSID IN ('SHOWNOSALE', 'SHOWSALE' ) THEN 1
                 ELSE 0
                 END) AS 'BB_Outbound_Scheduled_Show'
	,	SUM(CASE WHEN [ActionCodeSSID] = 'BEBACK' AND ActivityTypeSSID = 'OUTBOUND'
                       AND ResultCodeSSID IN ('SHOWSALE') THEN 1
                 ELSE 0
                 END) AS 'BB_Outbound_Scheduled_Sale'
INTO #BB_SCHEDULED
FROM HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity da
	inner join HC_BI_MKTG_DDS.bi_mktg_dds.FactActivity fa
		on da.ActivityKey = fa.ActivityKey
	inner join HC_BI_MKTG_DDS.bi_mktg_dds.DimEmployee emp
		on fa.ActivityEmployeeKey = emp.EmployeeKey
WHERE  emp.EmployeeSSID LIKE 'TM%'
		AND ActivityDueDate between @BegDt and @EndDt
		AND ActionCodeSSID = 'BEBACK'
GROUP BY emp.EmployeeSSID
	,	emp.EmployeeFullName
ORDER by emp.employeessid


/************************ Final select statement ******************************************************/
--
--	Create Result Set
--

SELECT
		#SALESPERSON.telemarketer
	,	ISNULL(#SALESPERSON.nccgroup, 'NCC UNASSIGNED') AS 'nccgroup'
	,	#SALESPERSON.tmname
	,	ISNULL(#INBOUND.Inbound_Lead,0) as 'Inbound_Lead'
	,	ISNULL(#INBOUND.Inbound_Lead_Emails,0) as 'Inbound_Lead_Emails'
	,	ISNULL(#INBOUND.Inbound_Appt,0) as 'Inbound_Appt'
	,	ISNULL(#INBOUND.Inbound_Broch,0) as 'Inbound_Brochure'
	,	ISNULL(dbo.DIVIDE_NOROUND(cast(#INBOUND.Inbound_Appt as SMALLMONEY),CAST(#INBOUND.Inbound_Lead AS SMALLMONEY)),0)
		AS 'Lead_Conversion_%'
	,	ISNULL(#SCHEDULED.Inbound_Scheduled_Appt,0) as 'Inbound_Scheduled_Appt'
	,	ISNULL(#SCHEDULED.Inbound_Scheduled_Show,0) as 'Inbound_Scheduled_Show'
	,	ISNULL(#SCHEDULED.Inbound_Scheduled_Sale,0) as 'Inbound_Scheduled_Sale'
	,	ISNULL(dbo.DIVIDE_NOROUND(cast(#SCHEDULED.Inbound_Scheduled_Show as SMALLMONEY),CAST(#SCHEDULED.Inbound_Scheduled_Appt AS SMALLMONEY)),0)
		AS 'Inbound_Conversion_%'
	,	ISNULL(#SCHEDULED.Outbound_Scheduled_Appt,0) as 'Outbound_Scheduled_Appt'
	,	ISNULL(#RESULTAPPTS.Result_Appt,0) as 'Outbound_Result_Appt'
	,	ISNULL(#SCHEDULED.Outbound_Scheduled_Show,0) as 'Outbound_Scheduled_Show'
	,	ISNULL(#SCHEDULED.Outbound_Scheduled_Sale,0) as 'Outbound_Scheduled_Sale'
	,	ISNULL(dbo.DIVIDE_NOROUND(cast(#SCHEDULED.Outbound_Scheduled_Show as SMALLMONEY),CAST(#SCHEDULED.Outbound_Scheduled_Appt AS SMALLMONEY)),0)
		AS 'Outbound_Conversion_%'
	,	ISNULL(#SCHEDULED.Inbound_Scheduled_Appt,0) + ISNULL(#SCHEDULED.Outbound_Scheduled_Appt,0) as 'Total_Appt'
	,	ISNULL(#SCHEDULED.Inbound_Scheduled_Show,0) + ISNULL(#SCHEDULED.Outbound_Scheduled_Show,0) as 'Total_Show'
	,	CAST(ISNULL(dbo.DIVIDE_NOROUND(ISNULL(#SCHEDULED.Inbound_Scheduled_Show,0) + ISNULL(#SCHEDULED.Outbound_Scheduled_Show,0),
				ISNULL(#SCHEDULED.Inbound_Scheduled_Appt,0) + ISNULL(#SCHEDULED.Outbound_Scheduled_Appt,0)),0) AS SMALLMONEY)
		AS 'Total_Conversion_%'
	,	ISNULL(BB_Inbound_Scheduled_Appt,0) AS 'BB_Inbound_Scheduled_Appt'
	,	ISNULL(BB_Inbound_Scheduled_Show,0) AS 'BB_Inbound_Scheduled_Show'
	,	ISNULL(BB_Inbound_Scheduled_Sale,0) AS 'BB_Inbound_Scheduled_Sale'
	,	ISNULL(BB_Outbound_Scheduled_Appt,0) AS 'BB_Outbound_Scheduled_Appt'
	,	ISNULL(BB_Outbound_Scheduled_Show,0) AS 'BB_Outbound_Scheduled_Show'
	,	ISNULL(BB_Outbound_Scheduled_Sale,0) AS 'BB_Outbound_Scheduled_Sale'

FROM #SALESPERSON
	left outer join #INBOUND
		ON #SALESPERSON.telemarketer = #INBOUND.Telemarketer
	left outer join #SCHEDULED
		ON #SALESPERSON.telemarketer = #SCHEDULED.Telemarketer
	left outer join #RESULTAPPTS
		ON #SALESPERSON.telemarketer = #RESULTAPPTS.Telemarketer
	left outer join #BB_SCHEDULED
		ON #SALESPERSON.telemarketer = #BB_SCHEDULED.Telemarketer
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
order by ISNULL(#SALESPERSON.nccgroup, 'NCC UNASSIGNED'), #SALESPERSON.telemarketer

END
GO
