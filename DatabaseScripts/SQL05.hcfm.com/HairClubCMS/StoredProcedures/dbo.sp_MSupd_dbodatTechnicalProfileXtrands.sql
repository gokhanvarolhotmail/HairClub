/* CreateDate: 05/05/2020 17:42:53.513 , ModifyDate: 05/05/2020 17:42:53.513 */
GO
create procedure [sp_MSupd_dbodatTechnicalProfileXtrands]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 datetime = NULL,
		@c4 datetime = NULL,
		@c5 int = NULL,
		@c6 int = NULL,
		@c7 int = NULL,
		@c8 int = NULL,
		@c9 int = NULL,
		@c10 nvarchar(200) = NULL,
		@c11 bit = NULL,
		@c12 int = NULL,
		@c13 int = NULL,
		@c14 int = NULL,
		@c15 datetime = NULL,
		@c16 nvarchar(25) = NULL,
		@c17 datetime = NULL,
		@c18 nvarchar(25) = NULL,
		@c19 int = NULL,
		@c20 int = NULL,
		@c21 int = NULL,
		@c22 int = NULL,
		@pkc1 int = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[datTechnicalProfileXtrands] set
		[TechnicalProfileID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [TechnicalProfileID] end,
		[LastTrichoViewDate] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [LastTrichoViewDate] end,
		[LastXtrandsServiceDate] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [LastXtrandsServiceDate] end,
		[HairStrandGroupID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [HairStrandGroupID] end,
		[HairHealthID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [HairHealthID] end,
		[LaserDeviceSalesCodeID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [LaserDeviceSalesCodeID] end,
		[ShampooSalesCodeID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [ShampooSalesCodeID] end,
		[ConditionerSalesCodeID] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [ConditionerSalesCodeID] end,
		[Other] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [Other] end,
		[IsMinoxidilUsed] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [IsMinoxidilUsed] end,
		[MinoxidilSalesCodeID] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [MinoxidilSalesCodeID] end,
		[ServiceDuration] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [ServiceDuration] end,
		[ServiceTimeUnitID] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [ServiceTimeUnitID] end,
		[CreateDate] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [LastUpdateUser] end,
		[Strands] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [Strands] end,
		[OtherServiceSalesCodeID] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [OtherServiceSalesCodeID] end,
		[OtherServiceDuration] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [OtherServiceDuration] end,
		[OtherServiceTimeUnitID] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [OtherServiceTimeUnitID] end
	where [TechnicalProfileXtrandsID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[TechnicalProfileXtrandsID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datTechnicalProfileXtrands]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
