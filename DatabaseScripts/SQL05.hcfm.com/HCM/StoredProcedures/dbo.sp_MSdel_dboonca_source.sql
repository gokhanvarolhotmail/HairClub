/* CreateDate: 07/25/2018 14:51:34.087 , ModifyDate: 07/25/2018 14:51:34.087 */
GO
create procedure [dbo].[sp_MSdel_dboonca_source]
		@pkc1 nchar(30)
as
begin
	delete [dbo].[onca_source]
where [source_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
