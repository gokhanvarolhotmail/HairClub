/* CreateDate: 08/18/2011 16:33:57.420 , ModifyDate: 01/24/2017 16:50:59.900 */
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
EXEC sprpt_TM_Productivity '1/1/2016', '2/3/2016',  '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,47,48'

EXEC sprpt_TM_Productivity '8/26/2015', '8/26/2015',  '47,35'

***********************************************************************/


CREATE PROCEDURE [dbo].[sprpt_TM_Productivity]
    (
      @BegDt datetime,
      @EndDt datetime,
      @Groups varchar(500)
    )
AS


SET @EndDt = @EndDt + ' 23:59:59'

SELECT

		s.EmployeeSSID  as 'telemarketer'
	,	s.EmployeeTitle as 'nccgroup'
	,	s.employeefullname as 'tmname'
INTO #SALESPERSON
FROM dbo.synHC_MKTG_DDS_vwDimEmployee s
		inner join [DimSalespersonGroups] sg ON RTRIM(s.[EmployeeTitle]) =  RTRIM(sg.[Groups])
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
	dbo.synHC_MKTG_DDS_vwFactLead fl
	inner join dbo.synHC_ENT_DDS_vwDimDate dd
		on fl.LeadCreationDateKey = dd.DateKey
	inner join dbo.synHC_MKTG_DDS_vwDimEmployee emp
		on fl.EmployeeKey = emp.EmployeeKey
	inner join dbo.synHC_MKTG_DDS_vwDimContact con
		on fl.contactkey = con.contactkey
	left outer join dbo.synHC_MKTG_DDS_vwDimContactEmail email
		on con.ContactSSID = email.ContactSSID
		AND email.PrimaryFlag = 'Y'

WHERE
	dd.FullDate between @BegDt and @EndDt
		AND emp.EmployeeSSID like 'TM%'
		AND con.ContactStatusDescription IN ( 'Lead', 'Client' )
		and fl.ContactKey in (	select contactkey from dbo.synHC_MKTG_DDS_vwDimActivity vwDimActivity
								inner join dbo.synHC_MKTG_DDS_vwFactActivity vwFactActivity on
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
	dbo.synHC_MKTG_DDS_vwFactLead fl
	inner join dbo.synHC_ENT_DDS_vwDimDate dd
		on fl.LeadCreationDateKey = dd.DateKey
	inner join dbo.synHC_MKTG_DDS_vwDimEmployee emp
		on fl.EmployeeKey = emp.EmployeeKey
	inner join dbo.synHC_MKTG_DDS_vwDimContact con
		on fl.contactkey = con.contactkey
	inner join dbo.synHC_MKTG_DDS_vwDimActivity dact
		on con.Contactssid = dact.ContactSSID and
			dact.ActionCodeSSID = 'INCALL'
						AND DACT.ResultCodeSSID in ( 'APPOINT','BROCHURE' )
	inner join dbo.synHC_MKTG_DDS_vwFactActivity fact
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
FROM dbo.synHC_MKTG_DDS_vwDimActivity da
	inner join dbo.synHC_MKTG_DDS_vwFactActivity fa
		on da.ActivityKey = fa.ActivityKey
	inner join dbo.synHC_MKTG_DDS_vwDimEmployee emp
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
FROM dbo.synHC_MKTG_DDS_vwDimActivity da
	inner join dbo.synHC_MKTG_DDS_vwFactActivity fa
		on da.ActivityKey = fa.ActivityKey
	inner join dbo.synHC_MKTG_DDS_vwDimEmployee emp
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
FROM dbo.synHC_MKTG_DDS_vwDimActivity da
	inner join dbo.synHC_MKTG_DDS_vwFactActivity fa
		on da.ActivityKey = fa.ActivityKey
	inner join dbo.synHC_MKTG_DDS_vwDimEmployee emp
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
	,	#SALESPERSON.nccgroup
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
order by #SALESPERSON.nccgroup, #SALESPERSON.telemarketer


	--select * from bi_mktg_dds.DimEmployee
	--SELECT * FROM bi_mktg_dds.vwdimContact where contactfirstname =''
	--select * from bi_mktg_dds.dimactivity
	--select * from bi_mktg_dds.factactivity
GO
