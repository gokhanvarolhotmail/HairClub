create procedure [dbo].[sp_MSdel_dbodbaOrder]     @pkc1 int
as
begin   	delete [dbo].[dbaOrder]
where [OrderID] = @pkc1 if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598 end    --
