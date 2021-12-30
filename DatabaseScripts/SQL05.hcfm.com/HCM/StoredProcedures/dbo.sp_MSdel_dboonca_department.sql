/* CreateDate: 01/03/2018 16:31:33.580 , ModifyDate: 01/03/2018 16:31:33.580 */
GO
create procedure [dbo].[sp_MSdel_dboonca_department]
		@pkc1 nchar(10)
as
begin
	delete [dbo].[onca_department]
where [department_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
