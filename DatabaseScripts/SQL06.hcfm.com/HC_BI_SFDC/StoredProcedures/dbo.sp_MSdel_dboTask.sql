/* CreateDate: 06/17/2020 08:30:35.873 , ModifyDate: 06/17/2020 08:30:35.873 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSdel_dboTask]     @pkc1 nvarchar(18)
as
begin   	delete [dbo].[Task]
where [Id] = @pkc1 if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598 end    --
GO
