/* CreateDate: 05/05/2020 17:42:50.267 , ModifyDate: 05/05/2020 17:42:50.267 */
GO
create procedure [sp_MSupd_dbodatHairSystemOrderMeasurement]
		@c1 uniqueidentifier = NULL,
		@c2 uniqueidentifier = NULL,
		@c3 decimal(10,4) = NULL,
		@c4 decimal(10,4) = NULL,
		@c5 decimal(10,4) = NULL,
		@c6 decimal(10,4) = NULL,
		@c7 decimal(10,4) = NULL,
		@c8 decimal(10,4) = NULL,
		@c9 decimal(10,4) = NULL,
		@c10 decimal(10,4) = NULL,
		@c11 decimal(10,4) = NULL,
		@c12 int = NULL,
		@c13 bit = NULL,
		@c14 int = NULL,
		@c15 datetime = NULL,
		@c16 nvarchar(25) = NULL,
		@c17 datetime = NULL,
		@c18 nvarchar(25) = NULL,
		@pkc1 uniqueidentifier = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[datHairSystemOrderMeasurement] set
		[HairSystemOrderMeasurementGUID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [HairSystemOrderMeasurementGUID] end,
		[HairSystemOrderGUID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [HairSystemOrderGUID] end,
		[StartingPointMeasurement] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [StartingPointMeasurement] end,
		[CircumferenceMeasurement] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [CircumferenceMeasurement] end,
		[FrontToBackMeasurement] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [FrontToBackMeasurement] end,
		[EarToEarOverFrontMeasurement] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [EarToEarOverFrontMeasurement] end,
		[EarToEarOverTopMeasurement] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [EarToEarOverTopMeasurement] end,
		[SideburnToSideburnMeasurement] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [SideburnToSideburnMeasurement] end,
		[TempleToTempleMeasurement] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [TempleToTempleMeasurement] end,
		[NapeAreaMeasurement] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [NapeAreaMeasurement] end,
		[FrontLaceMeasurement] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [FrontLaceMeasurement] end,
		[HairSystemRecessionID] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [HairSystemRecessionID] end,
		[AreSideburnsAndTemplesLaceFlag] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [AreSideburnsAndTemplesLaceFlag] end,
		[SideburnTemplateDiagram] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [SideburnTemplateDiagram] end,
		[CreateDate] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [LastUpdateUser] end
	where [HairSystemOrderMeasurementGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[HairSystemOrderMeasurementGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datHairSystemOrderMeasurement]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[datHairSystemOrderMeasurement] set
		[HairSystemOrderGUID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [HairSystemOrderGUID] end,
		[StartingPointMeasurement] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [StartingPointMeasurement] end,
		[CircumferenceMeasurement] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [CircumferenceMeasurement] end,
		[FrontToBackMeasurement] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [FrontToBackMeasurement] end,
		[EarToEarOverFrontMeasurement] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [EarToEarOverFrontMeasurement] end,
		[EarToEarOverTopMeasurement] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [EarToEarOverTopMeasurement] end,
		[SideburnToSideburnMeasurement] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [SideburnToSideburnMeasurement] end,
		[TempleToTempleMeasurement] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [TempleToTempleMeasurement] end,
		[NapeAreaMeasurement] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [NapeAreaMeasurement] end,
		[FrontLaceMeasurement] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [FrontLaceMeasurement] end,
		[HairSystemRecessionID] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [HairSystemRecessionID] end,
		[AreSideburnsAndTemplesLaceFlag] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [AreSideburnsAndTemplesLaceFlag] end,
		[SideburnTemplateDiagram] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [SideburnTemplateDiagram] end,
		[CreateDate] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [LastUpdateUser] end
	where [HairSystemOrderMeasurementGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[HairSystemOrderMeasurementGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datHairSystemOrderMeasurement]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
