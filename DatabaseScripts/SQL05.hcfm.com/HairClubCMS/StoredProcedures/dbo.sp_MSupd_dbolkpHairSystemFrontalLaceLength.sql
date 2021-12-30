/* CreateDate: 05/05/2020 17:42:46.070 , ModifyDate: 05/05/2020 17:42:46.070 */
GO
create procedure [sp_MSupd_dbolkpHairSystemFrontalLaceLength]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 nvarchar(100) = NULL,
		@c4 nvarchar(10) = NULL,
		@c5 decimal(8,4) = NULL,
		@c6 bit = NULL,
		@c7 datetime = NULL,
		@c8 nvarchar(25) = NULL,
		@c9 datetime = NULL,
		@c10 nvarchar(25) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[lkpHairSystemFrontalLaceLength] set
		[HairSystemFrontalLaceLengthID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [HairSystemFrontalLaceLengthID] end,
		[HairSystemFrontalLaceLengthSortOrder] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [HairSystemFrontalLaceLengthSortOrder] end,
		[HairSystemFrontalLaceLengthDescription] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [HairSystemFrontalLaceLengthDescription] end,
		[HairSystemFrontalLaceLengthDescriptionShort] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [HairSystemFrontalLaceLengthDescriptionShort] end,
		[HairSystemFrontalLaceLengthValue] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [HairSystemFrontalLaceLengthValue] end,
		[IsActiveFlag] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [IsActiveFlag] end,
		[CreateDate] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [LastUpdateUser] end
	where [HairSystemFrontalLaceLengthID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[HairSystemFrontalLaceLengthID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[lkpHairSystemFrontalLaceLength]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[lkpHairSystemFrontalLaceLength] set
		[HairSystemFrontalLaceLengthSortOrder] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [HairSystemFrontalLaceLengthSortOrder] end,
		[HairSystemFrontalLaceLengthDescription] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [HairSystemFrontalLaceLengthDescription] end,
		[HairSystemFrontalLaceLengthDescriptionShort] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [HairSystemFrontalLaceLengthDescriptionShort] end,
		[HairSystemFrontalLaceLengthValue] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [HairSystemFrontalLaceLengthValue] end,
		[IsActiveFlag] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [IsActiveFlag] end,
		[CreateDate] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [LastUpdateUser] end
	where [HairSystemFrontalLaceLengthID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[HairSystemFrontalLaceLengthID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[lkpHairSystemFrontalLaceLength]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
