/* CreateDate: 04/10/2014 12:07:16.477 , ModifyDate: 03/11/2022 07:32:50.743 */
GO
--EXEC [dbo].[spSvc_BarthActivitiesExport] NULL, NULL
CREATE PROCEDURE [dbo].[spSvc_BarthActivitiesExport]
(
	@StartDate DATETIME = NULL
,	@EndDate DATETIME = NULL
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;
SET XACT_ABORT ON;



/********************************** Get Task Data *************************************/
IF ( @StartDate IS NULL OR @EndDate IS NULL )
   BEGIN
		--SET @StartDate = '2021-09-01'
		--SET @EndDate = '2021-09-30'

		SET @StartDate = DATEADD(dd, -21, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
		SET @EndDate = DATEADD(dd, -1, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
   END

 /********************************* Create Table *************************************/

 CREATE TABLE #NoSalesReason(
	[ClientGUID] [uniqueidentifier] NOT NULL,
	[ActivityNote] [varchar](max) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[RowID] int
 );


 /**************************CODE *****************************************************/

 WITH nsr AS ( SELECT [ClientGUID]
				 ,[ActivityNote]
				 ,[CreateDate]
				 ,ROW_NUMBER() OVER ( PARTITION BY ClientGUID ORDER BY [CreateDate] DESC ) AS 'RowID'
				 FROM SQL01.[HairClubCMS].[dbo].[datActivity]
 )

 INSERT INTO #NoSalesReason
 SELECT  [ClientGUID]
 ,[ActivityNote]
 ,[CreateDate]
 ,[RowId]
 FROM nsr
 WHERE RowId = 1

--SET @StartDate = '1/1/2020'

select ctr.CenterSSID                                                                       as CenterSSID
     , ctr.CenterDescription                                                                as [CenterDescription]
     , l.Id                                                                                 as [LeadID]
     , l.FirstName                                                                          as [FirstName]
     , l.LastName                                                                           as [LastName]
     , t.Id                                                                                 as [ActivityID]
     , t.ActivityDate                                                                       as [ActivityDate]
     , t.Action__c                                                                          as [ActionCodeSSID]
     ,case when t.Result__c IN ('Appointment','Be Back','In House') and t.Result__c in ('Cancel','Canceled','No_Transportation','Illness') Then 'Canceled'
		WHEN t.Result__c IN ('Appointment','Be Back','In House') and t.Result__c in ('No Show','No_Show') Then 'No_Show'
		else t.Result__c end																as [ResultCodeSSID]
     , t.ActivityType__c                                                                    as [ActivityTypeSSID]
     , cast(t.CompletionDate__c as date)                                                    as [ActivityCompletionDate]
     , t.EndTime__c                                                                         as [ActivityCompletionTime] --Aun no esta siendo mapeado
     ,CASE WHEN dst.SalesTypeSSID = '-2' THEN NULL ELSE dst.SalesTypeSSID END               as [SaleTypeID]             --Aun no esta mapeado
     ,CASE WHEN dst.SalesTypeSSID = '-2' THEN NULL ELSE dst.SalesTypeDescription END        as [SalesTypeDescription]--Aun no esta mapeado
     , dg.GenderKey                                                                         as [GenderKey]
     , dg.GenderSSID																		as [GenderSSID]
     , l.Gender__c                                                                          as [Gender]
     , CASE WHEN dms.MaritalStatusKey IS NULL THEN -1 ELSE dms.MaritalStatusKey END		    as [MaritalStatusKey]
     , CASE WHEN dms.MaritalStatusSSID IS NULL THEN -2 ELSE dms.MaritalStatusSSID END       as [MaritalStatusSSID]
     , CASE WHEN l.MaritalStatus__c IS NULL THEN 'Unknown' ELSE l.MaritalStatus__c END      as [MaritalStatus]
     , l.Occupation__c                                                                                   as [Occupation]
     , dar.AgeRangeKey                                                                      as [AgeRangeKey]
     , dar.AgeRangeSSID                                                                     as [AgeRangeSSID]
     ,DATEDIFF(year,l.Birthday__c,CAST(GETDATE() as DATE))									as [Age]
     ,coalesce(ds.SourceKey,c.SourceKey,'15928')                                            as [SourceKey]
     ,coalesce(c.SourceCode,l.RecentSourceCode__c,' ')                                      as [Source]
     , dpc.PromotionCodeKey
     , dpc.PromotionCodeSSID                                                                as [PromotionCode]
     , c.CampaignMedia                                             as [MediaType]
     , c.CampaignLocation                                          as [Location]
     , c.CampaignLanguage                                         as [Language]
     , c.CampaignFormat                                             as [Format]
     , l.leadsource                                                                         as [Creative]
     , CAST(REPLACE(REPLACE(REPLACE(ds.Number, '(', ''), ')', ''), '-', ' ')  as nvarchar(4000) )  as [800 Number]
     , REPLACE(de.[EmployeeFullNameCalc], ',','')										   as [Performer]--REPLACE(ISNULL(dad.Performer,sr.Name), ',', '')
     , ISNULL(dad.SolutionOffered,bs.[BusinessSegmentDescription])                         as [SolutionOffered]        --No esta mapeado aun
     , cast(coalesce(cd.PriceQuoted,m.[ContractPrice],t.[OpportunityAmmount]) as money)							   as 'PriceQuoted'
     ,CASE WHEN CHARINDEX('No Sale Reason',da.ActivityNote,0) > 0 THEN REPLACE(REPLACE(SUBSTRING(da.ActivityNote,CHARINDEX('No Sale Reason',da.ActivityNote,0),LEN(da.ActivityNote)-CHARINDEX('No Sale Reason',da.ActivityNote,0)),'No Sale Reason:',''),')','') ELSE NULL END           as [NoSaleReason]
     , CASE
           WHEN t.Action__c IN ('Appointment', 'In House', 'Recovery') AND
                ISNULL(t.Result__c, '') NOT IN
                ('Void', 'Cancel', 'Reschedule', 'Center Exception', 'Canceled', 'Recovery', 'Center Exception',
                 'CLEANUP 09', 'CNTRCXL', 'No Transportation') THEN 1
           ELSE 0 END                                                                      as 'IsAppointment'
     , CASE
           WHEN ISNULL(t.Result__c, '') IN ('Completed') AND
                ISNULL(CASE
                           WHEN (
                                   (
                                           t.Action__c = 'Be Back'
                                           OR t.SourceCode__c IN
                                              ('REFERAFRND', 'STYLEREFER', 'REGISSTYRFR', 'NBREFCARD', 'BOSDMREF',
                                               'BOSREF',
                                               'BOSBIOEMREF', 'BOSNCREF', '4Q2016LWEXLD', 'REFEROTHER',
                                               'IPREFCLRERECA12476',
                                               'IPREFCLRERECA12476DC', 'IPREFCLRERECA12476DF', 'IPREFCLRERECA12476DP',
                                               'IPREFCLRERECA12476MC', 'IPREFCLRERECA12476MF', 'IPREFCLRERECA12476MP'
                                                  )
                                       )
                                   AND t.ActivityDate < '12/1/2020'
                               ) THEN 1
                           ELSE 0
                           END, 0) = 0
               THEN 1
           ELSE 0 END                                                                       as 'IsConsultation'
     , CASE
           WHEN t.Action__c IN ('Be Back') AND ISNULL(t.Result__c, '') IN ('Show No Sale', 'Show Sale') AND
                ISNULL(CASE
                           WHEN t.SourceCode__c IN
                                ('CORP REFER', 'REFERAFRND', 'STYLEREFER', 'REGISSTYRFR', 'NBREFCARD', 'BOSDMREF',
                                 'BOSREF',
                                 'BOSBIOEMREF', 'BOSBIODMREF', '4Q2016LWEXLD', 'REFEROTHER'
                                    ) AND t.ActivityDate < '12/1/2020' THEN 1
                           ELSE 0
                           END, 0) = 0 THEN 1
           ELSE 0 END                                                                       as 'IsBeBack'
     , CASE WHEN ISNULL(t.Result__c, '') IN ('Show No Sale', 'Show Sale') THEN 1 ELSE 0 END as 'IsShow'
     , CASE WHEN ISNULL(t.Result__c, '') = 'Show Sale' THEN 1 ELSE 0 END                    as 'IsSale'
     , CASE WHEN ISNULL(t.Result__c, '') IN ('Show No Sale', 'Show Sale') THEN 0 ELSE 1 END as 'IsNoShow'
     , CASE WHEN ISNULL(t.Result__c, '') = 'Show Sale' THEN 0 ELSE 1 END                    as 'IsNoSale'
     , l.Id                                                                                 as [SFDC_LeadID]
     , t.Id                                                                                 as [SFDC_TaskID]
     , l.CreatedDate				                                                        as [CreatedDate]
     , coalesce(du.UserName,u_cb.UserName)                                                  as [CreatedBy]
     , l.LastModifiedDate                                                                   as [LastModifiedDate]
     , coalesce(du2.UserName,u_ub.UserName)                                                 as [LastModifiedBy]
     , CASE WHEN fac.AppointmentType IN ('Video','Virtual Consultation') THEN 'Virtual' ELSE 'Center' END             as [ConsultationType]
     , l.ConvertedAccountId                                                               as [SFDC_PersonAccountID]
	 INTO #Activities
from HC_BI_SFDC.dbo.Task t
        LEFT OUTER JOIN HC_BI_SFDC.dbo.Lead l
                on l.Id = t.WhoId
        LEFT OUTER JOIN HC_BI_SFDC.Synapse_pool.DimCampaign c
                on l.OriginalCampaignID__c = c.CampaignId
		--LEFT OUTER JOIN [HC_BI_SFDC].[dbo].[Campaign] co
		--		on co.Id = l.OriginalCampaignID__c
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
				ON ctr.CenterNumber = t.CenterNumber__c and ctr.Active = 'Y'
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource ds WITH (NOLOCK)
                    ON ds.SourceSSID = l.RecentSourceCode__c
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimPromotionCode dpc WITH (NOLOCK)
                    ON dpc.PromotionCodeSSID = ds.PromoCode
		LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAgeRange dar WITH ( NOLOCK )
					ON DATEDIFF(year,ISNULL(l.Birthday__c,CAST(GETDATE() as DATE)),CAST(GETDATE() as DATE)) BETWEEN dar.BeginAge AND dar.EndAge
		LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimGender dg WITH ( NOLOCK )--*-
					ON dg.GenderSSID = LEFT(l.Gender__c,1)
		LEFT OUTER JOIN HC_BI_SFDC.dbo.vw_systemUser du
					ON du.userId = l.CreatedById
		LEFT OUTER JOIN HC_BI_SFDC.dbo.vw_systemUser du2
					ON du2.userId = l.LastModifiedById
		LEFT OUTER JOIN HC_BI_SFDC.dbo.vw_systemUser u_cb
					ON u_cb.UserLogin = l.CreatedById
		LEFT OUTER JOIN HC_BI_SFDC.dbo.vw_systemUser u_ub
					ON u_ub.UserLogin = l.LastModifiedById
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivityDemographic dad WITH ( NOLOCK )
					ON COALESCE(dad.SFDC_TaskID, dad.ActivitySSID) = COALESCE(t.id, t.activityType__c)
		--LEFT OUTER JOIN HC_BI_SFDC.Synapse_pool.AssignedResource ass
		--			ON ass.ServiceAppointmentId = t.Id
		--LEFT OUTER JOIN HC_BI_SFDC.Synapse_pool.ServiceResource sr
		--			ON sr.Id = ass.ServiceResourceId
		LEFT OUTER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimMaritalStatus] dms
					ON dms.MaritalStatusDescription = l.MaritalStatus__c
		LEFT OUTER JOIN HC_BI_SFDC.Synapse_pool.FactAppointment as fac
					ON fac.AppointmentId = t.Id
		LEFT OUTER JOIN SQL05.HairClubCMS.dbo.datClient AS clt
					ON clt.SalesforceContactID = l.id and clt.clientIdentifier <> 110960 --ClientIdentifier excluded to avaoid duplication with test record
		LEFT OUTER JOIN SQL05.HairClubCMS.dbo.datClientMembership AS dcm
					ON dcm.ClientGUID = clt.ClientGUID AND CAST(t.ActivityDate as date) = dcm.BeginDate AND dcm.EndDate > CAST(GETDATE() as date) --this filter to exclude duplicates
		LEFT OUTER JOIN SQL05.HairClubCMS.dbo.cfgMembership AS m WITH (NOLOCK)
					ON m.MembershipID = dcm.MembershipID
		LEFT OUTER JOIN SQL05.HairClubCMS.dbo.lkpBusinessSegment AS bs WITH (NOLOCK)
					ON bs.BusinessSegmentID = m.BusinessSegmentID
		LEFT OUTER JOIN [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimSalesType] AS dst WITH (NOLOCK)
					ON m.[BOSSalesTypeCode] = dst.[SalesTypeSSID]
		LEFT OUTER JOIN SQL05.HairClubCMS.dbo.datappointment AS appt WITH (NOLOCK)
					ON appt.salesforcetaskid = t.Id AND CAST(t.ActivityDate as date) = appt.AppointmentDate AND appt.CLientGUID IS NOT NULL
		LEFT OUTER JOIN SQL05.HairClubCMS.dbo.[datClientDemographic] cd
					ON appt.ClientGUID = cd.ClientGUID
		LEFT OUTER JOIN SQL05.HairClubCMS.dbo.datAppointmentEmployee AS datapptemp
					ON appt.AppointmentGUID = datapptemp.AppointmentGUID
		LEFT OUTER JOIN SQL05.HairClubCMS.dbo.datEmployee AS de
					ON de.employeeguid = datapptemp.employeeguid
		LEFT OUTER JOIN #NoSalesReason as da
					ON da.[ClientGUID] = appt.ClientGUID
WHERE ( ctr.CenterSSID IN ( 745, 746, 747, 748, 804, 805, 806, 807, 811, 814, 817, 820, 821, 822 )
	 OR ( ctr.CenterSSID = 100 AND c.AgencyName IN ( 'Barth', 'Jane Creative' ) ) )
	 AND ( t.ActivityDate >= @StartDate)
	 AND t.Action__c IN ('Appointment','Be Back','In Hose')
	 AND l.isValid = 1 AND l.IsDeleted = 0
	 AND t.Result__c NOT IN ('Show Sale','Show No Sale')

INSERT INTO #Activities
Select ctr.CenterSSID                                                                       as CenterSSID
     , ctr.CenterDescription                                                                as [CenterDescription]
     , l.Id                                                                                 as [LeadID]
     , l.FirstName                                                                          as [FirstName]
     , l.LastName                                                                           as [LastName]
     , t.Id                                                                                 as [ActivityID]
     , t.ActivityDate                                                                       as [ActivityDate]
     , t.Action__c                                                                          as [ActionCodeSSID]
     ,case when t.Result__c IN ('Appointment','Be Back','In House') and t.Result__c in ('Cancel','Canceled','No_Transportation','Illness') Then 'Canceled'
		WHEN t.Result__c IN ('Appointment','Be Back','In House') and t.Result__c in ('No Show','No_Show') Then 'No_Show'
		else t.Result__c end																as [ResultCodeSSID]
     , t.ActivityType__c                                                                    as [ActivityTypeSSID]
     , cast(t.CompletionDate__c as date)                                                    as [ActivityCompletionDate]
     , t.EndTime__c                                                                         as [ActivityCompletionTime] --Aun no esta siendo mapeado
     ,CASE WHEN dst.SalesTypeSSID = '-2' THEN NULL ELSE dst.SalesTypeSSID END               as [SaleTypeID]             --Aun no esta mapeado
     ,CASE WHEN dst.SalesTypeSSID = '-2' THEN NULL ELSE dst.SalesTypeDescription END        as [SalesTypeDescription]--Aun no esta mapeado
     , dg.GenderKey                                                                         as [GenderKey]
     , dg.GenderSSID																		as [GenderSSID]
     , l.Gender__c                                                                          as [Gender]
     , CASE WHEN dms.MaritalStatusKey IS NULL THEN -1 ELSE dms.MaritalStatusKey END		    as [MaritalStatusKey]
     , CASE WHEN dms.MaritalStatusSSID IS NULL THEN -2 ELSE dms.MaritalStatusSSID END       as [MaritalStatusSSID]
     , CASE WHEN l.MaritalStatus__c IS NULL THEN 'Unknown' ELSE l.MaritalStatus__c END      as [MaritalStatus]
     , l.Occupation__c                                                                                   as [Occupation]
     , dar.AgeRangeKey                                                                      as [AgeRangeKey]
     , dar.AgeRangeSSID                                                                     as [AgeRangeSSID]
     ,DATEDIFF(year,l.Birthday__c,CAST(GETDATE() as DATE))									as [Age]
     ,coalesce(ds.SourceKey,c.SourceKey,'15928')                                            as [SourceKey]
     ,coalesce(c.SourceCode,l.RecentSourceCode__c,' ')                                      as [Source]
     , dpc.PromotionCodeKey
     , dpc.PromotionCodeSSID                                                                as [PromotionCode]
     , c.CampaignMedia                                              as [MediaType]
     , c.CampaignLocation                                        as [Location]
     , c.CampaignLanguage                                         as [Language]
     , c.CampaignFormat                                                                      as [Format]
     , l.leadsource                                                                         as [Creative]
     , CAST(REPLACE(REPLACE(REPLACE(ds.Number, '(', ''), ')', ''), '-', ' ')  as nvarchar(4000) )  as [800 Number]
     , REPLACE(de.[EmployeeFullNameCalc], ',','')										   as [Performer]--REPLACE(ISNULL(dad.Performer,sr.Name), ',', '')
     , ISNULL(dad.SolutionOffered,bs.[BusinessSegmentDescription])                         as [SolutionOffered]        --No esta mapeado aun
     , cast(coalesce(cd.PriceQuoted,m.[ContractPrice],t.[OpportunityAmmount]) as money)							   as 'PriceQuoted'
     ,CASE WHEN CHARINDEX('No Sale Reason',da.ActivityNote,0) > 0 THEN REPLACE(REPLACE(SUBSTRING(da.ActivityNote,CHARINDEX('No Sale Reason',da.ActivityNote,0),LEN(da.ActivityNote)-CHARINDEX('No Sale Reason',da.ActivityNote,0)),'No Sale Reason:',''),')','') ELSE NULL END           as [NoSaleReason]
     , CASE
           WHEN t.Action__c IN ('Appointment', 'In House', 'Recovery') AND
                ISNULL(t.Result__c, '') NOT IN
                ('Void', 'Cancel', 'Reschedule', 'Center Exception', 'Canceled', 'Recovery', 'Center Exception',
                 'CLEANUP 09', 'CNTRCXL', 'No Transportation') THEN 1
           ELSE 0 END                                                                      as 'IsAppointment'
     , CASE
           WHEN ISNULL(t.Result__c, '') IN ('Completed') AND
                ISNULL(CASE
                           WHEN (
                                   (
                                           t.Action__c = 'Be Back'
                                           OR t.SourceCode__c IN
                                              ('REFERAFRND', 'STYLEREFER', 'REGISSTYRFR', 'NBREFCARD', 'BOSDMREF',
                                               'BOSREF',
                                               'BOSBIOEMREF', 'BOSNCREF', '4Q2016LWEXLD', 'REFEROTHER',
                                               'IPREFCLRERECA12476',
                                               'IPREFCLRERECA12476DC', 'IPREFCLRERECA12476DF', 'IPREFCLRERECA12476DP',
                                               'IPREFCLRERECA12476MC', 'IPREFCLRERECA12476MF', 'IPREFCLRERECA12476MP'
                                                  )
                                       )
                                   AND t.ActivityDate < '12/1/2020'
                               ) THEN 1
                           ELSE 0
                           END, 0) = 0
               THEN 1
           ELSE 0 END                                                                       as 'IsConsultation'
     , CASE
           WHEN t.Action__c IN ('Be Back') AND ISNULL(t.Result__c, '') IN ('Show No Sale', 'Show Sale') AND
                ISNULL(CASE
                           WHEN t.SourceCode__c IN
                                ('CORP REFER', 'REFERAFRND', 'STYLEREFER', 'REGISSTYRFR', 'NBREFCARD', 'BOSDMREF',
                                 'BOSREF',
                                 'BOSBIOEMREF', 'BOSBIODMREF', '4Q2016LWEXLD', 'REFEROTHER'
                                    ) AND t.ActivityDate < '12/1/2020' THEN 1
                           ELSE 0
                           END, 0) = 0 THEN 1
           ELSE 0 END                                                                       as 'IsBeBack'
     , CASE WHEN ISNULL(t.Result__c, '') IN ('Show No Sale', 'Show Sale') THEN 1 ELSE 0 END as 'IsShow'
     , CASE WHEN ISNULL(t.Result__c, '') = 'Show Sale' THEN 1 ELSE 0 END                    as 'IsSale'
     , CASE WHEN ISNULL(t.Result__c, '') IN ('Show No Sale', 'Show Sale') THEN 0 ELSE 1 END as 'IsNoShow'
     , CASE WHEN ISNULL(t.Result__c, '') = 'Show Sale' THEN 0 ELSE 1 END                    as 'IsNoSale'
     , l.Id                                                                                 as [SFDC_LeadID]
     , t.Id                                                                                 as [SFDC_TaskID]
     , l.CreatedDate				                                                        as [CreatedDate]
     , coalesce(du.UserName,u_cb.UserName)                                                  as [CreatedBy]
     , l.LastModifiedDate                                                                   as [LastModifiedDate]
     , coalesce(du2.UserName,u_ub.UserName)                                                 as [LastModifiedBy]
     , CASE WHEN fac.AppointmentType IN ('Video','Virtual Consultation') THEN 'Virtual' ELSE 'Center' END             as [ConsultationType]
     , l.ConvertedAccountId                                                               as [SFDC_PersonAccountID]
from HC_BI_SFDC.dbo.Task t
        LEFT OUTER JOIN HC_BI_SFDC.dbo.Lead l
                on l.Id = t.WhoId
        LEFT OUTER JOIN HC_BI_SFDC.Synapse_pool.DimCampaign c
                on l.OriginalCampaignID__c = c.CampaignId
		--LEFT OUTER JOIN [HC_BI_SFDC].[dbo].[Campaign] co
		--		on co.Id = l.OriginalCampaignID__c
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
				ON ctr.CenterNumber = t.CenterNumber__c and ctr.Active = 'Y'
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource ds WITH (NOLOCK)
                    ON ds.SourceSSID = l.RecentSourceCode__c
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimPromotionCode dpc WITH (NOLOCK)
                    ON dpc.PromotionCodeSSID = ds.PromoCode
		LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAgeRange dar WITH ( NOLOCK )
					ON DATEDIFF(year,ISNULL(l.Birthday__c,CAST(GETDATE() as DATE)),CAST(GETDATE() as DATE)) BETWEEN dar.BeginAge AND dar.EndAge
		LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimGender dg WITH ( NOLOCK )--*-
					ON dg.GenderSSID = LEFT(l.Gender__c,1)
		LEFT OUTER JOIN HC_BI_SFDC.dbo.vw_systemUser du
					ON du.userId = l.CreatedById
		LEFT OUTER JOIN HC_BI_SFDC.dbo.vw_systemUser du2
					ON du2.userId = l.LastModifiedById
		LEFT OUTER JOIN HC_BI_SFDC.dbo.vw_systemUser u_cb
					ON u_cb.UserLogin = l.CreatedById
		LEFT OUTER JOIN HC_BI_SFDC.dbo.vw_systemUser u_ub
					ON u_ub.UserLogin = l.LastModifiedById
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivityDemographic dad WITH ( NOLOCK )
					ON COALESCE(dad.SFDC_TaskID, dad.ActivitySSID) = COALESCE(t.id, t.activityType__c)
		--LEFT OUTER JOIN HC_BI_SFDC.Synapse_pool.AssignedResource ass
		--			ON ass.ServiceAppointmentId = t.Id
		--LEFT OUTER JOIN HC_BI_SFDC.Synapse_pool.ServiceResource sr
		--			ON sr.Id = ass.ServiceResourceId
		LEFT OUTER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimMaritalStatus] dms
					ON dms.MaritalStatusDescription = l.MaritalStatus__c
		LEFT OUTER JOIN HC_BI_SFDC.Synapse_pool.FactAppointment as fac
					ON fac.AppointmentId = t.Id
		LEFT OUTER JOIN SQL05.HairClubCMS.dbo.datClient AS clt
					ON clt.SalesforceContactID = l.id and clt.clientIdentifier <> 110960 --ClientIdentifier excluded to avaoid duplication with test record
		LEFT OUTER JOIN SQL05.HairClubCMS.dbo.datClientMembership AS dcm
					ON dcm.ClientGUID = clt.ClientGUID AND CAST(t.ActivityDate as date) = dcm.BeginDate AND dcm.EndDate > CAST(GETDATE() as date) --this filter to exclude duplicates
		LEFT OUTER JOIN SQL05.HairClubCMS.dbo.cfgMembership AS m WITH (NOLOCK)
					ON m.MembershipID = dcm.MembershipID
		LEFT OUTER JOIN SQL05.HairClubCMS.dbo.lkpBusinessSegment AS bs WITH (NOLOCK)
					ON bs.BusinessSegmentID = m.BusinessSegmentID
		LEFT OUTER JOIN [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimSalesType] AS dst WITH (NOLOCK)
					ON m.[BOSSalesTypeCode] = dst.[SalesTypeSSID]
		LEFT OUTER JOIN SQL05.HairClubCMS.dbo.datappointment AS appt WITH (NOLOCK)
					ON appt.salesforcetaskid = t.Id AND CAST(t.ActivityDate as date) = appt.AppointmentDate AND appt.CLientGUID IS NOT NULL
		LEFT OUTER JOIN SQL05.HairClubCMS.dbo.[datClientDemographic] cd
					ON appt.ClientGUID = cd.ClientGUID
		LEFT OUTER JOIN SQL05.HairClubCMS.dbo.datAppointmentEmployee AS datapptemp
					ON appt.AppointmentGUID = datapptemp.AppointmentGUID
		LEFT OUTER JOIN SQL05.HairClubCMS.dbo.datEmployee AS de
					ON de.employeeguid = datapptemp.employeeguid
		LEFT OUTER JOIN #NoSalesReason as da
					ON da.[ClientGUID] = appt.ClientGUID
WHERE ( ctr.CenterSSID IN ( 745, 746, 747, 748, 804, 805, 806, 807, 811, 814, 817, 820, 821, 822 )
	 OR ( ctr.CenterSSID = 100 AND c.AgencyName IN ( 'Barth', 'Jane Creative' ) ) )
	 AND ( t.ActivityDate >= @StartDate)
	 AND t.Action__c IN ('Appointment','Be Back','In Hose')
	 AND l.isValid = 1 AND l.IsDeleted = 0
	AND (t.Result__c IN ('Show Sale','Show No Sale') AND de.[EmployeeFullNameCalc] IS NOT NULL)


SELECT * FROM #Activities


END
GO
