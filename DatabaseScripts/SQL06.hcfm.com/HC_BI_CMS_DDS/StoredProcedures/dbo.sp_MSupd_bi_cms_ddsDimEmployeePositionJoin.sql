/* CreateDate: 03/17/2022 11:57:04.890 , ModifyDate: 03/17/2022 11:57:04.890 */
GO
create procedure [dbo].[sp_MSupd_bi_cms_ddsDimEmployeePositionJoin]
		@c1 uniqueidentifier = NULL,
		@c2 int = NULL,
		@c3 datetime = NULL,
		@c4 nvarchar(25) = NULL,
		@c5 datetime = NULL,
		@c6 nvarchar(25) = NULL,
		@c7 binary(8) = NULL,
		@pkc1 uniqueidentifier = NULL,
		@pkc2 int = NULL,
		@bitmap binary(1)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1) or
 (substring(@bitmap,1,1) & 2 = 2)
begin
update [bi_cms_dds].[DimEmployeePositionJoin] set
		[EmployeeGUID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [EmployeeGUID] end,
		[EmployeePositionID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [EmployeePositionID] end,
		[CreateDate] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [LastUpdateUser] end,
		[UpdateStamp] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [UpdateStamp] end
	where [EmployeeGUID] = @pkc1
  and [EmployeePositionID] = @pkc2
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[EmployeeGUID] = ' + convert(nvarchar(100),@pkc1,1) + ', '
				set @primarykey_text = @primarykey_text + '[EmployeePositionID] = ' + convert(nvarchar(100),@pkc2,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_cms_dds].[DimEmployeePositionJoin]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [bi_cms_dds].[DimEmployeePositionJoin] set
		[CreateDate] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [LastUpdateUser] end,
		[UpdateStamp] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [UpdateStamp] end
	where [EmployeeGUID] = @pkc1
  and [EmployeePositionID] = @pkc2
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[EmployeeGUID] = ' + convert(nvarchar(100),@pkc1,1) + ', '
				set @primarykey_text = @primarykey_text + '[EmployeePositionID] = ' + convert(nvarchar(100),@pkc2,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_cms_dds].[DimEmployeePositionJoin]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
