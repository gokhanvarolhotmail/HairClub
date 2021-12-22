/* CreateDate: 04/23/2021 08:07:54.050 , ModifyDate: 04/23/2021 08:07:54.050 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSdel_dboLead]     @pkc1 nvarchar(18)
as
begin   	delete [dbo].[Lead]
where [Id] = @pkc1 if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598 end    --
GO
