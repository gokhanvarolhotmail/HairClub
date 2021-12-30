/* CreateDate: 01/03/2018 16:31:36.490 , ModifyDate: 01/03/2018 16:31:36.490 */
GO
create procedure [dbo].[sp_MSdel_dbocstd_text_msg_temp]
		@pkc1 int
as
begin
	delete [dbo].[cstd_text_msg_temp]
where [temp_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
