/****** Object:  View [dbo].[VWConsultationScore]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VWConsultationScore]
AS select  a.id leadid, leadkey,a.CreatedDate LeadCreatedDate,
 a.Gender__c ,
Age__c, AgeRange__c, Language__c,HairLossExperience__c,HairLossFamily__c, HairLossProductUsed__c,
HairLossProductOther__c,HairLossSpot__c,Birthday__c,a.MaritalStatus__c,Occupation__c,DISC__c,NorwoodScale__c,LudwigScale__c,
(case when a.Gender__c is null or a.Gender__c=''  then 0 else 1 end)  +
(case when Age__c is null   then 0 else 1 end) + 
(case when AgeRange__c is null then 0 else 1 end)+ 
(case when Language__c is null then 0 else 1 end)+
(case when HairLossExperience__c is null then 0 else 1 end)+
(case when HairLossFamily__c is null then 0 else 1 end)+
(case when HairLossProductUsed__c is null then 0 else 1 end)+
(case when HairLossProductOther__c is null then 0 else 1 end)+
(case when HairLossSpot__c is null then 0 else 1 end)+
(case when Birthday__c is null then 0 else 1 end)+
(case when a.MaritalStatus__c is null then  0 else 1 end)+
(case when Occupation__c is null then 0 else 1 end)+
(case when DISC__c is null then 0   else 1 end)+
(case when NorwoodScale__c is null and LudwigScale__c is  null  then 0 else 1 end ) ConsultReadyLeads,
c.createddate ConsultationFormDate,lead__c, How_did_you_hear_about_Hair__club__c,Referred_By__c, Steps_Taken__c,
How_Long_Thinking__c,Research_Done__c,Hair_Loss_Effects__c,Tell_Anyone__c,Goal_Of_Visit__c,Special_Events_Impacted__c,
Scale_Hair_Restore__c,Reason_For_Hair_Back__c,
(case when How_did_you_hear_about_Hair__club__c is  null  then 0 else 1 end)+
(case when [Referred_By__c] is null  then 0 else 1 end)+
(case when [Steps_Taken__c] is null  then 0 else 1 end)+
(case when [How_Long_Thinking__c] is null then 0 else 1 end)+
(case when [Research_Done__c] is null then 0 else 1 end)+
(case when [Hair_Loss_Effects__c] is null  then 0 else 1 end)+
(case when [Tell_Anyone__c] is null  then 0 else 1 end)+
(case when [Goal_Of_Visit__c] is null  then 0 else 1 end)+
(case when [Special_Events_Impacted__c] is null   then 0 else 1 end)+
(case when [Scale_Hair_Restore__c] is null  then 0 else 1 end)+
(case when [Reason_For_Hair_Back__c] is null   then 0 else 1 end) ConsulReadyConsultationForm
from [ODS].[SFDC_Lead] a
inner join dimlead b on a.id=b.LeadId
left join [ODS].[SFDC_ConsultationForm] c on c.Lead__c=a.Id;
GO
