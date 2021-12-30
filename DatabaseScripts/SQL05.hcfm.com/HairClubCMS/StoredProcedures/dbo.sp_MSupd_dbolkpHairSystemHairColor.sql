/* CreateDate: 05/05/2020 17:42:41.843 , ModifyDate: 05/05/2020 17:42:41.843 */
GO
create procedure [sp_MSupd_dbolkpHairSystemHairColor]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 nvarchar(100) = NULL,
		@c4 nvarchar(10) = NULL,
		@c5 bit = NULL,
		@c6 datetime = NULL,
		@c7 nvarchar(25) = NULL,
		@c8 datetime = NULL,
		@c9 nvarchar(25) = NULL,
		@c10 bit = NULL,
		@c11 int = NULL,
		@c12 bit = NULL,
		@c13 bit = NULL,
		@c14 bit = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[lkpHairSystemHairColor] set
		[HairSystemHairColorID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [HairSystemHairColorID] end,
		[HairSystemHairColorSortOrder] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [HairSystemHairColorSortOrder] end,
		[HairSystemHairColorDescription] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [HairSystemHairColorDescription] end,
		[HairSystemHairColorDescriptionShort] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [HairSystemHairColorDescriptionShort] end,
		[IsActiveFlag] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [IsActiveFlag] end,
		[CreateDate] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [LastUpdateUser] end,
		[IsHairSampleFlag] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [IsHairSampleFlag] end,
		[HairSystemHairColorGroupID] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [HairSystemHairColorGroupID] end,
		[IsAvailableForOmbreOnlyFlag] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [IsAvailableForOmbreOnlyFlag] end,
		[IsCuticleIntactColor] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [IsCuticleIntactColor] end,
		[IsRootShadowingColor] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [IsRootShadowingColor] end
	where [HairSystemHairColorID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[HairSystemHairColorID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[lkpHairSystemHairColor]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[lkpHairSystemHairColor] set
		[HairSystemHairColorSortOrder] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [HairSystemHairColorSortOrder] end,
		[HairSystemHairColorDescription] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [HairSystemHairColorDescription] end,
		[HairSystemHairColorDescriptionShort] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [HairSystemHairColorDescriptionShort] end,
		[IsActiveFlag] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [IsActiveFlag] end,
		[CreateDate] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [LastUpdateUser] end,
		[IsHairSampleFlag] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [IsHairSampleFlag] end,
		[HairSystemHairColorGroupID] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [HairSystemHairColorGroupID] end,
		[IsAvailableForOmbreOnlyFlag] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [IsAvailableForOmbreOnlyFlag] end,
		[IsCuticleIntactColor] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [IsCuticleIntactColor] end,
		[IsRootShadowingColor] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [IsRootShadowingColor] end
	where [HairSystemHairColorID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[HairSystemHairColorID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[lkpHairSystemHairColor]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
