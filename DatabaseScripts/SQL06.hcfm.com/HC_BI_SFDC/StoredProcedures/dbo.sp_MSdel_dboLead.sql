create procedure [sp_MSdel_dboLead]     @pkc1 nvarchar(18)
as
begin   	delete [dbo].[Lead]
where [Id] = @pkc1 if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598 end    --
