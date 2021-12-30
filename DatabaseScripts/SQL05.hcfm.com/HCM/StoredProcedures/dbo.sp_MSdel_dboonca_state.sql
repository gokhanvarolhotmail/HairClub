/* CreateDate: 01/03/2018 16:31:35.200 , ModifyDate: 01/03/2018 16:31:35.200 */
GO
create procedure [dbo].[sp_MSdel_dboonca_state]
		@pkc1 nchar(20)
as
begin
	delete [dbo].[onca_state]
where [state_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
