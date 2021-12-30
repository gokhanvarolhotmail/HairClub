/* CreateDate: 05/05/2020 17:42:49.717 , ModifyDate: 05/05/2020 17:42:49.717 */
GO
create procedure [sp_MSupd_dbodatCommissionCorrection]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 int = NULL,
		@c4 uniqueidentifier = NULL,
		@c5 int = NULL,
		@c6 uniqueidentifier = NULL,
		@c7 int = NULL,
		@c8 int = NULL,
		@c9 datetime = NULL,
		@c10 money = NULL,
		@c11 int = NULL,
		@c12 nvarchar(200) = NULL,
		@c13 int = NULL,
		@c14 nvarchar(200) = NULL,
		@c15 datetime = NULL,
		@c16 nvarchar(25) = NULL,
		@c17 datetime = NULL,
		@c18 nvarchar(25) = NULL,
		@c19 nvarchar(200) = NULL,
		@c20 datetime = NULL,
		@c21 datetime = NULL,
		@pkc1 int = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[datCommissionCorrection] set
		[CenterID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [CenterID] end,
		[PayPeriodKey] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [PayPeriodKey] end,
		[ClientGUID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ClientGUID] end,
		[EmployeePositionID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [EmployeePositionID] end,
		[EmployeeGUID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [EmployeeGUID] end,
		[CommissionPlanID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CommissionPlanID] end,
		[CommissionPlanSectionID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [CommissionPlanSectionID] end,
		[TransactionDate] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [TransactionDate] end,
		[AmountToBePaid] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [AmountToBePaid] end,
		[CommissionAdjustmentReasonID] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [CommissionAdjustmentReasonID] end,
		[ReasonForCorrection] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [ReasonForCorrection] end,
		[CommissionCorrectionStatusID] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CommissionCorrectionStatusID] end,
		[ReasonForDenial] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [ReasonForDenial] end,
		[CreateDate] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [LastUpdateUser] end,
		[Comments] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [Comments] end,
		[StatusChangeDate] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [StatusChangeDate] end,
		[PayOnDate] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [PayOnDate] end
	where [CommissionCorrectionID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[CommissionCorrectionID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datCommissionCorrection]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
