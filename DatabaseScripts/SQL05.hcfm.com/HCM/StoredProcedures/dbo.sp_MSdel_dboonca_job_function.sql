/* CreateDate: 01/03/2018 16:31:33.687 , ModifyDate: 01/03/2018 16:31:33.687 */
GO
create procedure [dbo].[sp_MSdel_dboonca_job_function]
		@pkc1 nchar(10)
as
begin
	delete [dbo].[onca_job_function]
where [job_function_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
