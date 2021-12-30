/* CreateDate: 08/05/2015 09:01:32.263 , ModifyDate: 08/05/2015 09:01:32.263 */
GO
create procedure [sp_MSdel_dboContactSalesType]
		@pkc1 varchar(50)
as
begin
	delete [dbo].[ContactSalesType]
where [SalesTypeCode] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
