create procedure [dbo].[sp_MSdel_bi_cms_ddsDimClient]     @pkc1 int
as
begin   	delete [bi_cms_dds].[DimClient]
where [ClientKey] = @pkc1 if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598 end    --
