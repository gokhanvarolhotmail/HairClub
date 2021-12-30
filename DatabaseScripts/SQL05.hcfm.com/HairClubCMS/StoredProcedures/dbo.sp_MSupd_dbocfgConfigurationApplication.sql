/* CreateDate: 05/05/2020 17:42:41.250 , ModifyDate: 05/05/2020 17:42:41.250 */
GO
create procedure [sp_MSupd_dbocfgConfigurationApplication]
		@c1 int = NULL,
		@c2 date = NULL,
		@c3 datetime = NULL,
		@c4 nvarchar(25) = NULL,
		@c5 datetime = NULL,
		@c6 nvarchar(25) = NULL,
		@c7 date = NULL,
		@c8 int = NULL,
		@c9 int = NULL,
		@c10 int = NULL,
		@c11 int = NULL,
		@c12 nvarchar(250) = NULL,
		@c13 int = NULL,
		@c14 int = NULL,
		@c15 int = NULL,
		@c16 int = NULL,
		@c17 int = NULL,
		@c18 int = NULL,
		@c19 int = NULL,
		@c20 datetime = NULL,
		@c21 int = NULL,
		@c22 int = NULL,
		@c23 int = NULL,
		@c24 int = NULL,
		@c25 bit = NULL,
		@pkc1 int = NULL,
		@bitmap binary(4)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[cfgConfigurationApplication] set
		[Version32ReleaseDate] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [Version32ReleaseDate] end,
		[CreateDate] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [LastUpdateUser] end,
		[Version41ReleaseDate] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [Version41ReleaseDate] end,
		[ScheduleCreateRange] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [ScheduleCreateRange] end,
		[HairSystemOrderCounter] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [HairSystemOrderCounter] end,
		[HairSystemOrderMaximumDaysInFuture] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [HairSystemOrderMaximumDaysInFuture] end,
		[AccountingExportBatchCounter] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [AccountingExportBatchCounter] end,
		[AccountingExportDefaultPath] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [AccountingExportDefaultPath] end,
		[HairSystemTurnaroundDaysRange1] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [HairSystemTurnaroundDaysRange1] end,
		[HairSystemTurnaroundDaysRange2] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [HairSystemTurnaroundDaysRange2] end,
		[HairSystemTurnaroundDaysRange3] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [HairSystemTurnaroundDaysRange3] end,
		[HairSystemTurnaroundLongHairExtraDays] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [HairSystemTurnaroundLongHairExtraDays] end,
		[HairSystemTurnaroundLongHairLength] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [HairSystemTurnaroundLongHairLength] end,
		[AccountingExportReceiveAPVarianceGLNumber] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [AccountingExportReceiveAPVarianceGLNumber] end,
		[AccountingExportReceiveAPCreditGLNumber] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [AccountingExportReceiveAPCreditGLNumber] end,
		[LastUpdateClientEFT] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [LastUpdateClientEFT] end,
		[MonetraProcessingBufferInMinutes] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [MonetraProcessingBufferInMinutes] end,
		[SalesConsultationDayBuffer] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [SalesConsultationDayBuffer] end,
		[NumberOfRefundMonths] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [NumberOfRefundMonths] end,
		[PhotoQuality] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [PhotoQuality] end,
		[IsPreviousConsultationWarningEnabled] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [IsPreviousConsultationWarningEnabled] end
	where [ConfigurationApplicationID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ConfigurationApplicationID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[cfgConfigurationApplication]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
