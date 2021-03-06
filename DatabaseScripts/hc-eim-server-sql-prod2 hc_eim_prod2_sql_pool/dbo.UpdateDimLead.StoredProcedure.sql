/****** Object:  StoredProcedure [dbo].[UpdateDimLead]    Script Date: 3/23/2022 10:16:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[UpdateDimLead] AS
BEGIN

 

 

 
/***********************************QUERY TO UPDATE LEADS WITHOUTH CAMPAIGN***********************************************************************/
--Create temp tables
Create Table #Contact
	(
	    LeadId varchar(50),
	    Subject varchar(400),
        RowNum int,
        OriginalCampaignId varchar(1024)
	);

Create Table #NoTask
	(
	    LeadId varchar(50),
	    Subject varchar(400),
        OriginalCampaignId varchar(1024)
	);
/************************************** Insert into temp tables*************************************************************************************/
    
----Leads withouth campaign

    WITH LeadSC  AS (
    SELECT Id, Name,TOLL_FREE, Status, CreatedDate
    FROM LeadWithoutCampaignPhone 
        UNION ALL
    SELECT A.Id ,A.Name ,A.TOLL_FREE, A.Status, A.CreatedDate
    FROM LeadWithoutCampaignMPhone A
    LEFT JOIN LeadWithoutCampaignPhone B ON A.Id = B.Id
    WHERE B.Id IS NULL
), ALLCAMPAIGN AS(
    SELECT C.Id AS ExternaIdCampaign, C.TollFreeMobileName__c, C.TollFreeName__c , C.Name  AS CampaignName,  C.SourceCode_L__c
    FROM [ODS].[SFDC_Campaign_Old_Prod] C
    WHERE C.Status != 'Merged'
), LeadMobile AS(
    SELECT L.*, C.ExternaIdCampaign, C.CampaignName, NC.Status AS CampaignStatus, NC.Id AS NewCampaignId
        , ROW_NUMBER() OVER( partition by L.Id order by NC.Status DESC) AS RowNum
    FROM LeadSC L
    INNER JOIN ALLCAMPAIGN C ON C.TollFreeMobileName__c = L.TOLL_FREE
    INNER JOIN [ODS].[SF_Campaign] NC ON NC.External_Id__c = C.ExternaIdCampaign
    WHERE L.CreatedDate BETWEEN NC.StartDate AND NC.EndDate  



)SELECT * 
into #leadsWC
FROM LeadMobile
WHERE RowNum =1;


---Leads duplicate by email

 

 with dup as
    (SELECT
    ROW_NUMBER() OVER(partition by email ORDER BY email ASC) AS RowNum,
    a.id,a.email,a.name from [ODS].[SF_Lead] a
    inner join dimlead b on a.id=b.leadid
    where  b.isvalid=1 and a.isdeleted=0 and email is not null
    and   email  in
    (
        select email from [ODS].[SF_Lead] where  convert(date,createddate)>='2021-06-01' and isdeleted=0
        group by email
        having count(*)>1
        )
    )
select * into #DupByEmail from dup
where RowNum>1;

 

 


---Leads duplicate by name

 

 with dupname as
    (SELECT
    ROW_NUMBER() OVER(partition by a.name ORDER BY name,createddate desc) AS RowNum,
    a.id,a.email,a.name,a.createddate from [ODS].[SF_Lead] a
    inner join dimlead b on a.id=b.leadid
    where  b.isvalid=1 and a.isdeleted=0
    )
select * into #DupByName from dupname
where RowNum>1;

/*******************************************************UPDATE ***************************/
/******************************************************* NEW LOGIC IMPLEMENTED FOR THE WALKS IN ***************************/
 
--CASE ONE, WHEN A LEAD HAVE A TASK ASSOSIATED


with cte as (
    select a.LeadId,b.Subject,ROW_NUMBER() OVER(PARTITION BY a.leadid ORDER BY b.CreatedDate ASC)
	AS RowNum from DimLead a --1769
    inner join ODS.SF_Task b on a.LeadId = b.WhoId -- 3084
    where OriginalCampaignId is null and LeadSource is null and b.Subject is not null
)

insert into #Contact (LeadId, Subject, RowNum)
select LeadId,
	   trim(Subject) ,
       RowNum from cte where RowNum = 1

update #Contact
set subject = 'Call'
where  trim(Subject) in (
    'Brochure Call',
    'Brochure Call Call Back',
    'Call',
    'call tried to connect  threw a text message ,call and sight call, on Saturday no answer . will reach out on tuesday again',
    'Call: HC - Dial Now',
    'Call: HC English - Inbound Ad Call with MHSA Promo',
    'Call: HC English - Inbound Bosley Referral Call',
    'Call: HC English - Inbound Caller ID Call',
    'Call: HC English - Inbound Reschedule Line Call',
    'Call: HC English - Inbound Text Reschedule Line Call',
    'Call: HC English - Outbound Call',
    'Call: HC English - Outbound Confirmation Call',
    'Call: HC Spanish - Inbound Ad Call with MHSA Promo',
    'Call: HC Spanish - Inbound Ad Call with Special Promo',
    'Call: HC Spanish - Inbound Caller ID Call',
    'Call: HC Spanish - Outbound Call',
    'Call: HC Spanish- Inbound Reschedule Line Call',
    'Call: HW - Dial Now',
    'Call: HW English  - Outbound Confirmation Call',
    'Call: HW English - Inbound Ad Call with MHSA Promo',
    'Call: IC Calls',
    'Cancel Call',
    'Cancel Call Call Back',
    'Confirmation Call',
    'Inbound Call',
    'Inbound Chat Interaction',
    'Llamada',
    'Llamada: HC - Dial Now',
    'Llamada: HC English - Inbound Ad Call with MHSA Promo',
    'Llamada: HC English - Inbound Ad Call with Special Promo',
    'Llamada: HC English - Outbound Confirmation Call',
    'Llamada: HC Spanish - Inbound Ad Call with MHSA Promo',
    'Llamada: HC Spanish - Outbound Call',
    'Manual Outbound Call',
    'No Show Call',
    'No Show Call Call Back',
    'Preview: HC English - Outbound Call',
    'Preview: HC English - Outbound Confirmation Call',
    'Preview: HC Spanish - Outbound Call',
    'Vista Previa (preview): HC English - Outbound Call',
    'Vista Previa (preview): HC Spanish - Outbound Call'

    )

update #Contact
set subject = 'Email'
where  trim(Subject) in (
    'Email:',
    'Email: 5/20/21 consult appointment',
    'Email: Angela - See you this afternoon!',
    'Email: Appt at Hair Club Amarillo',
    'Email: Black Friday event',
    'Email: Danny - See you Today!',
    'Email: Follow Up',
    'Email: Hair Club Burnaby Consultation',
    'Email: HairClub - Sorry we missed you!',
    'Email: HairClub Louisville Virtual Consultation',
    'Email: Hector - see you tomorrow!',
    'Email: Hello',
    'Email: Hi Sandra',
    'Email: Hola!',
    'Email: I Look Forward to Meeting You!',
    'Email: Jay- See you Saturday!',
    'Email: Martin- See you tomorrow!',
    'Email: Save up to $750 this week',
    'Email: Sorry I missed you!',
    'Email: Spring is in the Hair',
    'Email: Video Consultation',
    'Email: Virtual Consultation'

    )


update #Contact
set subject = 'SMS'
where  trim(Subject) in (
    'SMS Interaction',
    'SMS Message Received',
    'Text Confirmation'

    )

update #Contact
set subject = 'WALK-IN'
where  trim(Subject) in (
    'WALK-IN',
    'Center'
    )

update #Contact
set subject = 'Web Chat'
where  trim(Subject) in (
    'Web Chat',
    'Web Chat : ACE SMS',
    'Web Chat: ACE SMS',
    'Web Chat: HW SMS',
    'Web Chat: IC SMS'

    )

update #Contact
set subject = 'Web Page'
where  trim(Subject) in (
    'Web Form'
    )

update #Contact
set OriginalCampaignId = a.Id
from ODS.SF_Campaign a
where #Contact.Subject = a.SourceCode_L__c and #Contact.Subject  = 'WALK-IN';



--CASE NUMBER TOW WHEN A LEAD DOESN'T HAVE A TASK ASOSSUATED BUT IS CONVERTED

with cte as (
    select a.LeadId from DimLead a --1769
    inner join ODS.SF_Account b on a.ConvertedAccountId = b.id -- 3084
    where OriginalCampaignId is null and LeadSource is null
)

insert into #NoTask (LeadId,Subject)
select LeadId,
       'WALK-IN'
	    from cte

update #NoTask
set OriginalCampaignId = a.Id
from ODS.SF_Campaign a
where #NoTask.Subject = a.SourceCode_L__c and #NoTask.Subject  = 'WALK-IN'
 






/**************************************Update DimLead****************************************************************************/
--Update original campaign
update dbo.dimlead
set OriginalCampaignId = b.NewCampaignId
from dbo.dimlead a
inner join #leadsWC b
on b.ID = a.LeadId
where convert(date,a.LeadCreatedDate) > '2021-06-14' and a.OriginalCampaignId is null

update dbo.DimLead
set OriginalCampaignId = b.CampaignId,
OriginalCampaignSource = c.SourceCode_L__c
from dbo.DimLead a
inner join ods.SF_CampaignMember b on a.LeadId = b.LeadId
inner join ods.SF_Campaign c on b.CampaignId = c.Id
where convert(date,a.LeadCreatedDate) > '2021-06-14' and b.CampaignId is not null



--Update is valid flag and isdupplicatebyemail flag
update dbo.dimlead
set [IsDuplicateByEmail] = 1
    ,[isValid] = 0
from dbo.dimlead a
inner join #DupByEmail b
on b.ID = a.LeadId




--Update isdupplicatebyname flag
update dbo.dimlead
set [IsDuplicateByName] = 1
from dbo.dimlead a
inner join #DupByName b
on b.ID = a.LeadId

update DimLead
set IsDeleted = 1
where LeadId not in (select id from ODS.SF_Lead)

--Update first walkIn case
update DimLead
  set OriginalCampaignId = a.OriginalCampaignId
from #Contact  a
where a.LeadId = DimLead.LeadId and DimLead.LeadId is not null

--Update second WalkIn case
update DimLead
  set OriginalCampaignId = a.OriginalCampaignId
from #NoTask  a
where a.LeadId = DimLead.LeadId and DimLead.LeadId is not null



/*******************************************************Reaload table for barth export***************************/

truncate table dbo.LeadsWithoutCampaign

insert into dbo.LeadsWithoutCampaign (
       [ID]
      ,[NewCampaignId]
      ,[ExternalIdCampaign]
      ,[CreatedDate])

select
       [ID]
      ,[NewCampaignId]
      ,[ExternaIdCampaign]
      ,[CreatedDate]
      from #leadsWC


 
drop Table #Contact
drop Table #NoTask
drop table #leadsWC
drop table #DupByEmail
drop table #DupByName




END
GO
