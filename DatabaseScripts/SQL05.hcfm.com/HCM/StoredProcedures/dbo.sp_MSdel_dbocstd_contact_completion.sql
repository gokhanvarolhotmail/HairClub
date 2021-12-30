/* CreateDate: 01/03/2018 16:31:35.080 , ModifyDate: 01/03/2018 16:31:35.080 */
GO
create procedure [dbo].[sp_MSdel_dbocstd_contact_completion]
		@pkc1 nchar(10)
as
begin
	delete [dbo].[cstd_contact_completion]
where [contact_completion_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
