create procedure [dbo].[sp_MSdel_bi_cms_ddsDimClientAppend]     @pkc1 int
as
begin   	delete [bi_cms_dds].[DimClientAppend]
where [ClientAppendKey] = @pkc1 if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598 end    --
