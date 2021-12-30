/* CreateDate: 05/05/2020 17:42:48.787 , ModifyDate: 05/05/2020 17:42:48.787 */
GO
create procedure [sp_MSupd_dbolkpEthnicity]
		@c1 int = NULL,
		@c2 nvarchar(10) = NULL,
		@c3 int = NULL,
		@c4 nvarchar(100) = NULL,
		@c5 nvarchar(10) = NULL,
		@c6 bit = NULL,
		@c7 datetime = NULL,
		@c8 nvarchar(25) = NULL,
		@c9 datetime = NULL,
		@c10 nvarchar(25) = NULL,
		@c11 nvarchar(100) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[lkpEthnicity] set
		[BOSEthnicityCode] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [BOSEthnicityCode] end,
		[EthnicitySortOrder] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [EthnicitySortOrder] end,
		[EthnicityDescription] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [EthnicityDescription] end,
		[EthnicityDescriptionShort] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [EthnicityDescriptionShort] end,
		[IsActiveFlag] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [IsActiveFlag] end,
		[CreateDate] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [LastUpdateUser] end,
		[DescriptionResourceKey] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [DescriptionResourceKey] end
	where [EthnicityID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[EthnicityID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[lkpEthnicity]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
