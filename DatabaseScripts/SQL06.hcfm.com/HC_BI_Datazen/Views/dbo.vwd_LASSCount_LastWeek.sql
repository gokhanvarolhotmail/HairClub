/* CreateDate: 07/27/2016 12:46:23.040 , ModifyDate: 07/27/2016 12:46:23.040 */
GO
/***********************************************************************
VIEW:					[vwd_LASSCount_LastWeek]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Paoli Torres
IMPLEMENTOR:			Paoli Torres
DATE IMPLEMENTED:		07/27/2016
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM [vwd_LASSCount_LastWeek]
***********************************************************************/
CREATE VIEW [dbo].[vwd_LASSCount_LastWeek]
AS


WITH LASS
          AS ( SELECT   SUM(FL.Leads) AS 'Leads'
               FROM     HC_BI_MKTG_DDS.bi_mktg_dds.FactLead FL
                        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                            ON FL.LeadCreationDateKey = DD.DateKey
               WHERE    DD.FullDate BETWEEN dateadd(wk, datediff(wk, 0, getdate()) - 1, 0) -- LastWeekStart
							AND DATEADD(DAY,-1,(DATEADD(wk, datediff(wk, 0, getdate()), 0))) -- EndofLastWeek

             ),

	 Counts AS (SELECT SUM(Appointments) AS 'Appointments'
						, SUM(Show) AS 'Show'
						, SUM(Sale) AS 'Sale'
					FROM HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
						INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
							ON FAR.ActivityDueDateKey = DD.DateKey
					 WHERE DD.FullDate BETWEEN dateadd(wk, datediff(wk, 0, getdate()) - 1, 0) -- LastWeekStart
							AND DATEADD(DAY,-1,(DATEADD(wk, datediff(wk, 0, getdate()), 0))) -- EndofLastWeek
 )

 SELECT Leads, Appointments, Show, Sale
 FROM LASS, Counts
GO
