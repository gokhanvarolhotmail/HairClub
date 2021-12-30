/* CreateDate: 05/05/2020 17:42:53.067 , ModifyDate: 05/05/2020 17:42:53.067 */
GO
create procedure [sp_MSupd_dbodatTechnicalProfilePermRelaxer]
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
		@c11 int = NULL,
		@c12 int = NULL,
		@c13 int = NULL,
		@c14 int = NULL,
		@c15 int = NULL,
		@c16 int = NULL,
		@c17 int = NULL,
		@c18 int = NULL,
		@c19 datetime = NULL,
		@c20 nvarchar(25) = NULL,
		@c21 datetime = NULL,
		@c22 nvarchar(25) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[datTechnicalProfilePermRelaxer] set
		[TechnicalProfileID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [TechnicalProfileID] end,
		[PermOwnPermBrandID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [PermOwnPermBrandID] end,
		[PermOwnPermOwnHairRods1ID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [PermOwnPermOwnHairRods1ID] end,
		[PermOwnPermOwnHairRods2ID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [PermOwnPermOwnHairRods2ID] end,
		[PermOwnProcessingTime] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [PermOwnProcessingTime] end,
		[PermOwnProcessingTimeUnitID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [PermOwnProcessingTimeUnitID] end,
		[PermOwnPermTechniqueID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [PermOwnPermTechniqueID] end,
		[PermSystemPermBrandID] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [PermSystemPermBrandID] end,
		[PermSystemPermOwnHairRods1ID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [PermSystemPermOwnHairRods1ID] end,
		[PermSystemPermOwnHairRods2ID] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [PermSystemPermOwnHairRods2ID] end,
		[PermSystemProcessingTime] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [PermSystemProcessingTime] end,
		[PermSystemProcessingTimeUnitID] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [PermSystemProcessingTimeUnitID] end,
		[PermSystemPermTechniqueID] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [PermSystemPermTechniqueID] end,
		[RelaxerBrandID] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [RelaxerBrandID] end,
		[RelaxerStrengthID] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [RelaxerStrengthID] end,
		[RelaxerProcessingTime] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [RelaxerProcessingTime] end,
		[RelaxerProcessingTimeUnitID] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [RelaxerProcessingTimeUnitID] end,
		[CreateDate] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [LastUpdateUser] end
	where [TechnicalProfilePermRelaxerID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[TechnicalProfilePermRelaxerID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datTechnicalProfilePermRelaxer]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
