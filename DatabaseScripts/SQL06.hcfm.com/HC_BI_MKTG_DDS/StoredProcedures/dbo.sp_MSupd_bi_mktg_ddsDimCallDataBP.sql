/* CreateDate: 09/03/2021 09:37:07.320 , ModifyDate: 09/03/2021 09:37:07.320 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSupd_bi_mktg_ddsDimCallDataBP]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 nvarchar(50) = NULL,
		@c4 nvarchar(10) = NULL,
		@c5 date = NULL,
		@c6 varchar(8) = NULL,
		@c7 varchar(255) = NULL,
		@c8 nvarchar(50) = NULL,
		@c9 nvarchar(50) = NULL,
		@c10 nvarchar(15) = NULL,
		@c11 nvarchar(30) = NULL,
		@c12 nvarchar(18) = NULL,
		@c13 nvarchar(255) = NULL,
		@c14 nvarchar(30) = NULL,
		@c15 nvarchar(18) = NULL,
		@c16 nvarchar(255) = NULL,
		@c17 nvarchar(255) = NULL,
		@c18 nvarchar(max) = NULL,
		@c19 nvarchar(255) = NULL,
		@c20 nvarchar(50) = NULL,
		@c21 nvarchar(50) = NULL,
		@c22 nvarchar(18) = NULL,
		@c23 nvarchar(18) = NULL,
		@c24 nvarchar(30) = NULL,
		@c25 nvarchar(18) = NULL,
		@c26 nvarchar(255) = NULL,
		@c27 varchar(255) = NULL,
		@c28 varchar(255) = NULL,
		@c29 int = NULL,
		@c30 int = NULL,
		@c31 int = NULL,
		@c32 int = NULL,
		@c33 int = NULL,
		@c34 int = NULL,
		@c35 int = NULL,
		@c36 int = NULL,
		@c37 binary(8) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(5)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [bi_mktg_dds].[DimCallDataBP] set
		[Call_RecordKey] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [Call_RecordKey] end,
		[BPpk_ID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [BPpk_ID] end,
		[Media_Type] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [Media_Type] end,
		[CenterSSID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [CenterSSID] end,
		[Call_Date] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Call_Date] end,
		[Call_Time] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [Call_Time] end,
		[Service_Name] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [Service_Name] end,
		[Caller_Phone_Type] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [Caller_Phone_Type] end,
		[Callee_Phone_Type] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [Callee_Phone_Type] end,
		[Call_Type_Group] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [Call_Type_Group] end,
		[InboundSourceSSID] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [InboundSourceSSID] end,
		[Inbound_Campaign_ID] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [Inbound_Campaign_ID] end,
		[Inbound_Campaign_Name] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [Inbound_Campaign_Name] end,
		[LeadSourceSSID] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [LeadSourceSSID] end,
		[Lead_Campaign_ID] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [Lead_Campaign_ID] end,
		[Lead_Campaign_Name] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [Lead_Campaign_Name] end,
		[Agent_Disposition] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [Agent_Disposition] end,
		[Agent_Disposition_Notes] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [Agent_Disposition_Notes] end,
		[System_Disposition] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [System_Disposition] end,
		[Lead_Phone] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [Lead_Phone] end,
		[Inbound_Phone] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [Inbound_Phone] end,
		[SFDC_LeadID] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [SFDC_LeadID] end,
		[SFDC_TaskID] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [SFDC_TaskID] end,
		[TaskSourceSSID] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [TaskSourceSSID] end,
		[Task_Campaign_ID] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [Task_Campaign_ID] end,
		[Task_Campaign_Name] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [Task_Campaign_Name] end,
		[User_Login_ID] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [User_Login_ID] end,
		[User_Login_Name] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [User_Login_Name] end,
		[Is_Viable_Call] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [Is_Viable_Call] end,
		[Is_Productive_Call] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [Is_Productive_Call] end,
		[Call_Length] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [Call_Length] end,
		[IVR_Time] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [IVR_Time] end,
		[Queue_Time] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [Queue_Time] end,
		[Pending_Time] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [Pending_Time] end,
		[Talk_Time] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [Talk_Time] end,
		[Hold_Time] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [Hold_Time] end,
		[RowTimeStamp] = case substring(@bitmap,5,1) & 16 when 16 then @c37 else [RowTimeStamp] end
	where [Call_RecordKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[Call_RecordKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_mktg_dds].[DimCallDataBP]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [bi_mktg_dds].[DimCallDataBP] set
		[BPpk_ID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [BPpk_ID] end,
		[Media_Type] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [Media_Type] end,
		[CenterSSID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [CenterSSID] end,
		[Call_Date] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Call_Date] end,
		[Call_Time] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [Call_Time] end,
		[Service_Name] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [Service_Name] end,
		[Caller_Phone_Type] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [Caller_Phone_Type] end,
		[Callee_Phone_Type] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [Callee_Phone_Type] end,
		[Call_Type_Group] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [Call_Type_Group] end,
		[InboundSourceSSID] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [InboundSourceSSID] end,
		[Inbound_Campaign_ID] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [Inbound_Campaign_ID] end,
		[Inbound_Campaign_Name] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [Inbound_Campaign_Name] end,
		[LeadSourceSSID] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [LeadSourceSSID] end,
		[Lead_Campaign_ID] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [Lead_Campaign_ID] end,
		[Lead_Campaign_Name] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [Lead_Campaign_Name] end,
		[Agent_Disposition] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [Agent_Disposition] end,
		[Agent_Disposition_Notes] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [Agent_Disposition_Notes] end,
		[System_Disposition] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [System_Disposition] end,
		[Lead_Phone] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [Lead_Phone] end,
		[Inbound_Phone] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [Inbound_Phone] end,
		[SFDC_LeadID] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [SFDC_LeadID] end,
		[SFDC_TaskID] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [SFDC_TaskID] end,
		[TaskSourceSSID] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [TaskSourceSSID] end,
		[Task_Campaign_ID] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [Task_Campaign_ID] end,
		[Task_Campaign_Name] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [Task_Campaign_Name] end,
		[User_Login_ID] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [User_Login_ID] end,
		[User_Login_Name] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [User_Login_Name] end,
		[Is_Viable_Call] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [Is_Viable_Call] end,
		[Is_Productive_Call] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [Is_Productive_Call] end,
		[Call_Length] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [Call_Length] end,
		[IVR_Time] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [IVR_Time] end,
		[Queue_Time] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [Queue_Time] end,
		[Pending_Time] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [Pending_Time] end,
		[Talk_Time] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [Talk_Time] end,
		[Hold_Time] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [Hold_Time] end,
		[RowTimeStamp] = case substring(@bitmap,5,1) & 16 when 16 then @c37 else [RowTimeStamp] end
	where [Call_RecordKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[Call_RecordKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_mktg_dds].[DimCallDataBP]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
