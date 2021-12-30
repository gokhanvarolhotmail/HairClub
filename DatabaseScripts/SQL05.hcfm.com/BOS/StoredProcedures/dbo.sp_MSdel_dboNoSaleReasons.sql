/* CreateDate: 08/05/2015 09:01:32.300 , ModifyDate: 08/05/2015 09:01:32.300 */
GO
create procedure [sp_MSdel_dboNoSaleReasons]
		@pkc1 varchar(50)
as
begin
	delete [dbo].[NoSaleReasons]
where [ReasonCode] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
