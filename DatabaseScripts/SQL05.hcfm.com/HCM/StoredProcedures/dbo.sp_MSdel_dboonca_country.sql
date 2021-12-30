/* CreateDate: 01/03/2018 16:31:35.147 , ModifyDate: 01/03/2018 16:31:35.147 */
GO
create procedure [dbo].[sp_MSdel_dboonca_country]
		@pkc1 nchar(20)
as
begin
	delete [dbo].[onca_country]
where [country_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
