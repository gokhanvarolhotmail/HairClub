create procedure [dbo].[sp_MSupd_bi_cms_ddsDimClientMembership]
		@c1 int = NULL,
		@c2 uniqueidentifier = NULL,
		@c3 int = NULL,
		@c4 int = NULL,
		@c5 uniqueidentifier = NULL,
		@c6 int = NULL,
		@c7 int = NULL,
		@c8 int = NULL,
		@c9 int = NULL,
		@c10 int = NULL,
		@c11 nvarchar(50) = NULL,
		@c12 nvarchar(10) = NULL,
		@c13 money = NULL,
		@c14 money = NULL,
		@c15 money = NULL,
		@c16 datetime = NULL,
		@c17 datetime = NULL,
		@c18 datetime = NULL,
		@c19 tinyint = NULL,
		@c20 datetime = NULL,
		@c21 datetime = NULL,
		@c22 varchar(200) = NULL,
		@c23 tinyint = NULL,
		@c24 int = NULL,
		@c25 int = NULL,
		@c26 binary(8) = NULL,
		@c27 uniqueidentifier = NULL,
		@c28 nvarchar(50) = NULL,
		@c29 money = NULL,
		@pkc1 int = NULL,
		@bitmap binary(4)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [bi_cms_dds].[DimClientMembership] set
		[ClientMembershipSSID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ClientMembershipSSID] end,
		[Member1_ID_Temp] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [Member1_ID_Temp] end,
		[ClientKey] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ClientKey] end,
		[ClientSSID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ClientSSID] end,
		[CenterKey] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CenterKey] end,
		[CenterSSID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CenterSSID] end,
		[MembershipKey] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [MembershipKey] end,
		[MembershipSSID] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [MembershipSSID] end,
		[ClientMembershipStatusSSID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [ClientMembershipStatusSSID] end,
		[ClientMembershipStatusDescription] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [ClientMembershipStatusDescription] end,
		[ClientMembershipStatusDescriptionShort] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [ClientMembershipStatusDescriptionShort] end,
		[ClientMembershipContractPrice] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [ClientMembershipContractPrice] end,
		[ClientMembershipContractPaidAmount] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [ClientMembershipContractPaidAmount] end,
		[ClientMembershipMonthlyFee] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [ClientMembershipMonthlyFee] end,
		[ClientMembershipBeginDate] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ClientMembershipBeginDate] end,
		[ClientMembershipEndDate] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [ClientMembershipEndDate] end,
		[ClientMembershipCancelDate] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [ClientMembershipCancelDate] end,
		[RowIsCurrent] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [RowIsCurrent] end,
		[RowStartDate] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [RowStartDate] end,
		[RowEndDate] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [RowEndDate] end,
		[RowChangeReason] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [RowChangeReason] end,
		[RowIsInferred] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [RowIsInferred] end,
		[InsertAuditKey] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [UpdateAuditKey] end,
		[RowTimeStamp] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [RowTimeStamp] end,
		[msrepl_tran_version] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [msrepl_tran_version] end,
		[ClientMembershipIdentifier] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [ClientMembershipIdentifier] end,
		[NationalMonthlyFee] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [NationalMonthlyFee] end
	where [ClientMembershipKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ClientMembershipKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_cms_dds].[DimClientMembership]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
