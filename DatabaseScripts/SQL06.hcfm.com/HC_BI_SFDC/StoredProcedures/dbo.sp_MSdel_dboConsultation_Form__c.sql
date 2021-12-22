/* CreateDate: 03/11/2021 15:38:03.530 , ModifyDate: 03/11/2021 15:38:03.530 */
GO
create procedure [dbo].[sp_MSdel_dboConsultation_Form__c]     @pkc1 nvarchar(18)
as
begin   	delete [dbo].[Consultation_Form__c]
where [Id] = @pkc1 if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598 end    --
GO
