/* CreateDate: 12/16/2020 14:47:25.397 , ModifyDate: 12/16/2020 14:47:25.397 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create VIEW [dbo].[vw_TaskNew]
AS
SELECT  t.Id
,		t.CenterNumber__c AS 'CenterNumber'
,		ctr.CenterDescription
,		t.ActivityID__c
,		t.ActivityDate
,		t.WhoId
,		l.ContactID__c
,		l.FirstName
,		l.LastName
,		l.Source_Code_Legacy__c
,		l.Status
,		t.Action__c
,		t.Result__c
,		a.AppointmentDate
,		a.AppointmentStartTime
,		a.CheckinTime
,		a.CheckoutTime
,        CASE
           WHEN t.Action__c IN ( 'Be back' )
                AND
                (
                    t.Result__c NOT IN ( 'Reschedule', 'Cancel', 'Center Exception', 'VOID' )
                    OR t.Result__c IS NULL
                    OR t.Result__c = ''
                ) THEN
               1
           ELSE
               0
        END AS 'Beback'
,        CASE
           WHEN t.Action__c IN ( 'Appointment', 'In House' )
                AND
                (
                    t.Result__c NOT IN ( 'Reschedule', 'Cancel', 'Center Exception', 'VOID' )
                    OR t.Result__c IS NULL
                    OR t.Result__c = ''
                ) THEN
               1
           ELSE
               0
        END AS 'Appointment'
,	    CASE WHEN Result__c IN ('Show Sale','Show No Sale') THEN 1
		   ELSE 0
	    END AS 'Show'
,	    CASE WHEN Result__c IN ('Show Sale') THEN 1
		   ELSE 0
	    END AS 'Sale'
FROM    Task t
		INNER JOIN Lead l
			ON l.Id = t.WhoId
		LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
			ON ctr.CenterNumber = t.CenterNumber__c
				AND ctr.Active = 'Y'
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimAppointment a
			ON a.SFDC_TaskID = t.Id
WHERE   LTRIM(RTRIM(t.Action__c)) IN ( 'Appointment', 'Be Back', 'In House', 'Recovery' )
		AND CAST(t.ReportCreateDate__c AS DATE) > '06/01/2020'
		--AND ( CAST(t.ReportCreateDate__c AS DATE) BETWEEN DATEADD(YEAR, DATEDIFF(YEAR, 0,CURRENT_TIMESTAMP), 0) AND DATEADD(YEAR, 1, DATEADD(DAY, -1, DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP), 0)))
		--		OR t.ActivityDate BETWEEN DATEADD(YEAR, DATEDIFF(YEAR, 0,CURRENT_TIMESTAMP), 0) AND DATEADD(YEAR, 1, DATEADD(DAY, -1, DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP), 0)))
		--		OR t.CompletionDate__c BETWEEN DATEADD(YEAR, DATEDIFF(YEAR, 0,CURRENT_TIMESTAMP), 0) AND DATEADD(YEAR, 1, DATEADD(DAY, -1, DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP), 0))) )
		AND ISNULL(t.IsDeleted, 0) = 0
GO
