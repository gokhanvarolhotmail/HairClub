/* CreateDate: 08/05/2015 09:01:32.143 , ModifyDate: 08/05/2015 09:01:32.143 */
GO
create procedure [sp_MSdel_dboContactMaritalStatus]
		@pkc1 varchar(10)
as
begin
	delete [dbo].[ContactMaritalStatus]
where [MaritalStatusCode] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
