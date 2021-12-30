/* CreateDate: 01/03/2018 16:31:36.000 , ModifyDate: 01/03/2018 16:31:36.000 */
GO
create procedure [sp_MSdel_dboonca_phone_type]
		@pkc1 nchar(10)
as
begin
	delete [dbo].[onca_phone_type]
where [phone_type_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
