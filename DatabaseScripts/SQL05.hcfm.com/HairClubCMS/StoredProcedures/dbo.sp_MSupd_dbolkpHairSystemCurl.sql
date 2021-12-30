/* CreateDate: 05/05/2020 17:42:42.030 , ModifyDate: 05/05/2020 17:42:42.030 */
GO
create procedure [sp_MSupd_dbolkpHairSystemCurl]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 nvarchar(100) = NULL,
		@c4 nvarchar(10) = NULL,
		@c5 int = NULL,
		@c6 int = NULL,
		@c7 int = NULL,
		@c8 int = NULL,
		@c9 bit = NULL,
		@c10 datetime = NULL,
		@c11 nvarchar(25) = NULL,
		@c12 datetime = NULL,
		@c13 nvarchar(25) = NULL,
		@c14 bit = NULL,
		@c15 bit = NULL,
		@c16 int = NULL,
		@c17 bit = NULL,
		@c18 bit = NULL,
		@pkc1 int = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[lkpHairSystemCurl] set
		[HairSystemCurlID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [HairSystemCurlID] end,
		[HairSystemCurlSortOrder] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [HairSystemCurlSortOrder] end,
		[HairSystemCurlDescription] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [HairSystemCurlDescription] end,
		[HairSystemCurlDescriptionShort] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [HairSystemCurlDescriptionShort] end,
		[HumanHairLengthMinimum] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [HumanHairLengthMinimum] end,
		[HumanHairLengthMaximum] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [HumanHairLengthMaximum] end,
		[SyntheticHairLengthMinimum] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [SyntheticHairLengthMinimum] end,
		[SyntheticHairLengthMaximum] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [SyntheticHairLengthMaximum] end,
		[IsActiveFlag] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [IsActiveFlag] end,
		[CreateDate] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [LastUpdateUser] end,
		[IsAllowHumanGreyPercentageFlag] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [IsAllowHumanGreyPercentageFlag] end,
		[IsAllowSyntheticGreyPercentageFlag] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [IsAllowSyntheticGreyPercentageFlag] end,
		[HairSystemCurlGroupID] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [HairSystemCurlGroupID] end,
		[IsCuticleIntactAvailableFlag] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [IsCuticleIntactAvailableFlag] end,
		[IsRootShadowingAvailableFlag] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [IsRootShadowingAvailableFlag] end
	where [HairSystemCurlID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[HairSystemCurlID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[lkpHairSystemCurl]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[lkpHairSystemCurl] set
		[HairSystemCurlSortOrder] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [HairSystemCurlSortOrder] end,
		[HairSystemCurlDescription] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [HairSystemCurlDescription] end,
		[HairSystemCurlDescriptionShort] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [HairSystemCurlDescriptionShort] end,
		[HumanHairLengthMinimum] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [HumanHairLengthMinimum] end,
		[HumanHairLengthMaximum] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [HumanHairLengthMaximum] end,
		[SyntheticHairLengthMinimum] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [SyntheticHairLengthMinimum] end,
		[SyntheticHairLengthMaximum] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [SyntheticHairLengthMaximum] end,
		[IsActiveFlag] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [IsActiveFlag] end,
		[CreateDate] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [LastUpdateUser] end,
		[IsAllowHumanGreyPercentageFlag] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [IsAllowHumanGreyPercentageFlag] end,
		[IsAllowSyntheticGreyPercentageFlag] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [IsAllowSyntheticGreyPercentageFlag] end,
		[HairSystemCurlGroupID] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [HairSystemCurlGroupID] end,
		[IsCuticleIntactAvailableFlag] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [IsCuticleIntactAvailableFlag] end,
		[IsRootShadowingAvailableFlag] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [IsRootShadowingAvailableFlag] end
	where [HairSystemCurlID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[HairSystemCurlID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[lkpHairSystemCurl]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
