/* CreateDate: 05/05/2020 17:42:52.697 , ModifyDate: 05/05/2020 17:42:52.697 */
GO
create procedure [sp_MSupd_dbodatTechnicalProfileExt]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 datetime = NULL,
		@c4 datetime = NULL,
		@c5 int = NULL,
		@c6 int = NULL,
		@c7 int = NULL,
		@c8 nvarchar(200) = NULL,
		@c9 int = NULL,
		@c10 int = NULL,
		@c11 int = NULL,
		@c12 int = NULL,
		@c13 bit = NULL,
		@c14 int = NULL,
		@c15 bit = NULL,
		@c16 nvarchar(200) = NULL,
		@c17 int = NULL,
		@c18 int = NULL,
		@c19 datetime = NULL,
		@c20 nvarchar(25) = NULL,
		@c21 datetime = NULL,
		@c22 nvarchar(25) = NULL,
		@c23 bit = NULL,
		@c24 int = NULL,
		@c25 datetime = NULL,
		@c26 int = NULL,
		@c27 int = NULL,
		@c28 int = NULL,
		@pkc1 int = NULL,
		@bitmap binary(4)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[datTechnicalProfileExt] set
		[TechnicalProfileID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [TechnicalProfileID] end,
		[LastTrichoViewDate] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [LastTrichoViewDate] end,
		[LastExtServiceDate] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [LastExtServiceDate] end,
		[HairHealthID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [HairHealthID] end,
		[ScalpHealthID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [ScalpHealthID] end,
		[CleanserUsedSalesCodeID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CleanserUsedSalesCodeID] end,
		[ElixirFormulation] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [ElixirFormulation] end,
		[MassagePressureID] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [MassagePressureID] end,
		[LaserDeviceSalesCodeID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [LaserDeviceSalesCodeID] end,
		[CleanserSalesCodeID] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [CleanserSalesCodeID] end,
		[ConditionerSalesCodeID] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [ConditionerSalesCodeID] end,
		[IsMinoxidilUsed] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [IsMinoxidilUsed] end,
		[MinoxidilSalesCodeID] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [MinoxidilSalesCodeID] end,
		[IsScalpEnzymeCleanserUsed] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [IsScalpEnzymeCleanserUsed] end,
		[Other] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [Other] end,
		[ServiceDuration] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [ServiceDuration] end,
		[ServiceTimeUnitID] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [ServiceTimeUnitID] end,
		[CreateDate] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [LastUpdateUser] end,
		[IsSurgeryClient] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [IsSurgeryClient] end,
		[GraftCount] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [GraftCount] end,
		[LastSurgeryDate] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [LastSurgeryDate] end,
		[OtherServiceSalesCodeID] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [OtherServiceSalesCodeID] end,
		[OtherServiceDuration] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [OtherServiceDuration] end,
		[OtherServiceTimeUnitID] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [OtherServiceTimeUnitID] end
	where [TechnicalProfileExtID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[TechnicalProfileExtID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datTechnicalProfileExt]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
