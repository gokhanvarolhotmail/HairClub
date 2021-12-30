/* CreateDate: 05/05/2020 17:42:52.603 , ModifyDate: 05/05/2020 17:42:52.603 */
GO
create procedure [sp_MSupd_dbodatTechnicalProfileColor]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 int = NULL,
		@c4 nvarchar(50) = NULL,
		@c5 int = NULL,
		@c6 nvarchar(50) = NULL,
		@c7 int = NULL,
		@c8 nvarchar(50) = NULL,
		@c9 int = NULL,
		@c10 int = NULL,
		@c11 int = NULL,
		@c12 int = NULL,
		@c13 int = NULL,
		@c14 datetime = NULL,
		@c15 nvarchar(25) = NULL,
		@c16 datetime = NULL,
		@c17 nvarchar(25) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[datTechnicalProfileColor] set
		[TechnicalProfileID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [TechnicalProfileID] end,
		[ColorBrandID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ColorBrandID] end,
		[ColorFormula1] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ColorFormula1] end,
		[ColorFormulaSize1ID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ColorFormulaSize1ID] end,
		[ColorFormula2] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [ColorFormula2] end,
		[ColorFormulaSize2ID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [ColorFormulaSize2ID] end,
		[ColorFormula3] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [ColorFormula3] end,
		[ColorFormulaSize3ID] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [ColorFormulaSize3ID] end,
		[DeveloperSizeID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [DeveloperSizeID] end,
		[DeveloperVolumeID] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [DeveloperVolumeID] end,
		[ColorProcessingTime] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [ColorProcessingTime] end,
		[ColorProcessingTimeUnitID] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [ColorProcessingTimeUnitID] end,
		[CreateDate] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [LastUpdateUser] end
	where [TechnicalProfileColorID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[TechnicalProfileColorID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datTechnicalProfileColor]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
