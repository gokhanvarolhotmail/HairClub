/* CreateDate: 05/05/2020 17:42:52.367 , ModifyDate: 05/05/2020 17:42:52.367 */
GO
create procedure [sp_MSupd_dbodatTechnicalProfileBio]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 int = NULL,
		@c4 int = NULL,
		@c5 int = NULL,
		@c6 int = NULL,
		@c7 int = NULL,
		@c8 int = NULL,
		@c9 int = NULL,
		@c10 int = NULL,
		@c11 bit = NULL,
		@c12 nvarchar(50) = NULL,
		@c13 datetime = NULL,
		@c14 datetime = NULL,
		@c15 int = NULL,
		@c16 int = NULL,
		@c17 int = NULL,
		@c18 int = NULL,
		@c19 int = NULL,
		@c20 int = NULL,
		@c21 int = NULL,
		@c22 datetime = NULL,
		@c23 nvarchar(25) = NULL,
		@c24 datetime = NULL,
		@c25 nvarchar(25) = NULL,
		@c26 bit = NULL,
		@c27 bit = NULL,
		@c28 bit = NULL,
		@pkc1 int = NULL,
		@bitmap binary(4)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[datTechnicalProfileBio] set
		[TechnicalProfileID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [TechnicalProfileID] end,
		[HairSystemID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [HairSystemID] end,
		[AdhesiveFront1ID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [AdhesiveFront1ID] end,
		[AdhesiveFront2ID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [AdhesiveFront2ID] end,
		[AdhesivePerimeter1ID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [AdhesivePerimeter1ID] end,
		[AdhesivePerimeter2ID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [AdhesivePerimeter2ID] end,
		[AdhesivePerimeter3ID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [AdhesivePerimeter3ID] end,
		[RemovalProcessID] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [RemovalProcessID] end,
		[AdhesiveSolventID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [AdhesiveSolventID] end,
		[IsClientUsingOwnHairline] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [IsClientUsingOwnHairline] end,
		[DistanceHairlineToNose] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [DistanceHairlineToNose] end,
		[LastTemplateDate] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [LastTemplateDate] end,
		[LastTrimDate] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [LastTrimDate] end,
		[ApplicationDuration] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [ApplicationDuration] end,
		[ApplicationTimeUnitID] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ApplicationTimeUnitID] end,
		[FullServiceDuration] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [FullServiceDuration] end,
		[FullServiceTimeUnitID] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [FullServiceTimeUnitID] end,
		[OtherServiceSalesCodeID] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [OtherServiceSalesCodeID] end,
		[OtherServiceDuration] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [OtherServiceDuration] end,
		[OtherServiceTimeUnitID] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [OtherServiceTimeUnitID] end,
		[CreateDate] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [LastUpdateUser] end,
		[IsHairOrderReviewRequired] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [IsHairOrderReviewRequired] end,
		[IsHairSystemColorRequired] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [IsHairSystemColorRequired] end,
		[IsHairSystemHighlightRequired] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [IsHairSystemHighlightRequired] end
	where [TechnicalProfileBioID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[TechnicalProfileBioID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datTechnicalProfileBio]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
