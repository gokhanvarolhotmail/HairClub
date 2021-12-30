/* CreateDate: 04/23/2018 16:25:13.680 , ModifyDate: 04/23/2018 16:25:13.680 */
GO
create procedure [sp_MSdel_dboMediaSourceSources]     @pkc1 int
as
begin   	delete [dbo].[MediaSourceSources]
where [SourceID] = @pkc1 if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598 end    --
GO
