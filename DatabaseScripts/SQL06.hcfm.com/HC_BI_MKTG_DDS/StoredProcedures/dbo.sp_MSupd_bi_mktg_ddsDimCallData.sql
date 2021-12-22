/* CreateDate: 09/03/2021 09:37:07.040 , ModifyDate: 09/03/2021 09:37:07.040 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSupd_bi_mktg_ddsDimCallData]
		@c1 int = NULL,
		@c2 nvarchar(50) = NULL,
		@c3 nvarchar(50) = NULL,
		@c4 nvarchar(10) = NULL,
		@c5 date = NULL,
		@c6 varchar(8) = NULL,
		@c7 nvarchar(15) = NULL,
		@c8 nvarchar(50) = NULL,
		@c9 nvarchar(15) = NULL,
		@c10 nvarchar(18) = NULL,
		@c11 nvarchar(30) = NULL,
		@c12 nvarchar(100) = NULL,
		@c13 nvarchar(18) = NULL,
		@c14 nvarchar(30) = NULL,
		@c15 nvarchar(100) = NULL,
		@c16 nvarchar(15) = NULL,
		@c17 nvarchar(50) = NULL,
		@c18 nvarchar(15) = NULL,
		@c19 nvarchar(18) = NULL,
		@c20 nvarchar(18) = NULL,
		@c21 nvarchar(18) = NULL,
		@c22 nvarchar(30) = NULL,
		@c23 nvarchar(100) = NULL,
		@c24 nvarchar(50) = NULL,
		@c25 nvarchar(15) = NULL,
		@c26 nvarchar(50) = NULL,
		@c27 nvarchar(50) = NULL,
		@c28 nvarchar(10) = NULL,
		@c29 int = NULL,
		@c30 int = NULL,
		@c31 binary(8) = NULL,
		@c32 nvarchar(20) = NULL,
		@c33 nvarchar(105) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(5)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [bi_mktg_dds].[DimCallData] set
		[CallRecordKey] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [CallRecordKey] end,
		[CallRecordSSID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [CallRecordSSID] end,
		[OriginalCallRecordSSID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [OriginalCallRecordSSID] end,
		[CenterSSID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [CenterSSID] end,
		[CallDate] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [CallDate] end,
		[CallTime] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CallTime] end,
		[CallTypeSSID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CallTypeSSID] end,
		[CallTypeDescription] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [CallTypeDescription] end,
		[CallTypeGroup] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [CallTypeGroup] end,
		[InboundCampaignID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [InboundCampaignID] end,
		[InboundSourceSSID] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [InboundSourceSSID] end,
		[InboundSourceDescription] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [InboundSourceDescription] end,
		[LeadCampaignID] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [LeadCampaignID] end,
		[LeadSourceSSID] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [LeadSourceSSID] end,
		[LeadSourceDescription] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [LeadSourceDescription] end,
		[CallStatusSSID] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [CallStatusSSID] end,
		[CallStatusDescription] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [CallStatusDescription] end,
		[CallPhoneNo] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CallPhoneNo] end,
		[SFDC_LeadID] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [SFDC_LeadID] end,
		[SFDC_TaskID] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [SFDC_TaskID] end,
		[TaskCampaignID] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [TaskCampaignID] end,
		[TaskSourceSSID] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [TaskSourceSSID] end,
		[TaskSourceDescription] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [TaskSourceDescription] end,
		[UsedBy] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [UsedBy] end,
		[AdditionalCallStatusSSID] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [AdditionalCallStatusSSID] end,
		[AdditionalCallStatusDescription] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [AdditionalCallStatusDescription] end,
		[UserSSID] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [UserSSID] end,
		[NobleUserSSID] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [NobleUserSSID] end,
		[IsViableCall] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [IsViableCall] end,
		[CallLength] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [CallLength] end,
		[RowTimeStamp] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [RowTimeStamp] end,
		[TollFreeNumber] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [TollFreeNumber] end,
		[UserFullName] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [UserFullName] end
	where [CallRecordKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[CallRecordKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_mktg_dds].[DimCallData]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [bi_mktg_dds].[DimCallData] set
		[CallRecordSSID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [CallRecordSSID] end,
		[OriginalCallRecordSSID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [OriginalCallRecordSSID] end,
		[CenterSSID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [CenterSSID] end,
		[CallDate] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [CallDate] end,
		[CallTime] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CallTime] end,
		[CallTypeSSID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CallTypeSSID] end,
		[CallTypeDescription] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [CallTypeDescription] end,
		[CallTypeGroup] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [CallTypeGroup] end,
		[InboundCampaignID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [InboundCampaignID] end,
		[InboundSourceSSID] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [InboundSourceSSID] end,
		[InboundSourceDescription] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [InboundSourceDescription] end,
		[LeadCampaignID] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [LeadCampaignID] end,
		[LeadSourceSSID] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [LeadSourceSSID] end,
		[LeadSourceDescription] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [LeadSourceDescription] end,
		[CallStatusSSID] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [CallStatusSSID] end,
		[CallStatusDescription] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [CallStatusDescription] end,
		[CallPhoneNo] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CallPhoneNo] end,
		[SFDC_LeadID] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [SFDC_LeadID] end,
		[SFDC_TaskID] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [SFDC_TaskID] end,
		[TaskCampaignID] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [TaskCampaignID] end,
		[TaskSourceSSID] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [TaskSourceSSID] end,
		[TaskSourceDescription] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [TaskSourceDescription] end,
		[UsedBy] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [UsedBy] end,
		[AdditionalCallStatusSSID] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [AdditionalCallStatusSSID] end,
		[AdditionalCallStatusDescription] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [AdditionalCallStatusDescription] end,
		[UserSSID] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [UserSSID] end,
		[NobleUserSSID] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [NobleUserSSID] end,
		[IsViableCall] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [IsViableCall] end,
		[CallLength] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [CallLength] end,
		[RowTimeStamp] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [RowTimeStamp] end,
		[TollFreeNumber] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [TollFreeNumber] end,
		[UserFullName] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [UserFullName] end
	where [CallRecordKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[CallRecordKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_mktg_dds].[DimCallData]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
