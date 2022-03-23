/* CreateDate: 03/17/2022 11:57:04.900 , ModifyDate: 03/17/2022 11:57:04.900 */
GO
create procedure [dbo].[sp_MSdel_bi_cms_ddsDimEmployeePositionJoin]
		@pkc1 uniqueidentifier,
		@pkc2 int
as
begin
	declare @primarykey_text nvarchar(100) = ''
	delete [bi_cms_dds].[DimEmployeePositionJoin]
	where [EmployeeGUID] = @pkc1
  and [EmployeePositionID] = @pkc2
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[EmployeeGUID] = ' + convert(nvarchar(100),@pkc1,1) + ', '
				set @primarykey_text = @primarykey_text + '[EmployeePositionID] = ' + convert(nvarchar(100),@pkc2,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_cms_dds].[DimEmployeePositionJoin]', @param2=@primarykey_text, @param3=13234
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
