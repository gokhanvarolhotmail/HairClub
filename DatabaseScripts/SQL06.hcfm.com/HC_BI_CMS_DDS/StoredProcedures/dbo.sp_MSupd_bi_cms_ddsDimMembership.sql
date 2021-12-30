/* CreateDate: 10/03/2019 23:03:41.320 , ModifyDate: 10/03/2019 23:03:41.320 */
GO
create procedure [sp_MSupd_bi_cms_ddsDimMembership]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 nvarchar(50) = NULL,
		@c4 nvarchar(10) = NULL,
		@c5 int = NULL,
		@c6 int = NULL,
		@c7 int = NULL,
		@c8 nvarchar(50) = NULL,
		@c9 nvarchar(10) = NULL,
		@c10 int = NULL,
		@c11 nvarchar(50) = NULL,
		@c12 nvarchar(10) = NULL,
		@c13 int = NULL,
		@c14 money = NULL,
		@c15 money = NULL,
		@c16 tinyint = NULL,
		@c17 datetime = NULL,
		@c18 datetime = NULL,
		@c19 varchar(200) = NULL,
		@c20 tinyint = NULL,
		@c21 int = NULL,
		@c22 int = NULL,
		@c23 uniqueidentifier = NULL,
		@c24 int = NULL,
		@c25 nvarchar(50) = NULL,
		@c26 nvarchar(50) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(4)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [bi_cms_dds].[DimMembership] set
		[MembershipSSID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [MembershipSSID] end,
		[MembershipDescription] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [MembershipDescription] end,
		[MembershipDescriptionShort] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [MembershipDescriptionShort] end,
		[BusinessSegmentKey] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [BusinessSegmentKey] end,
		[BusinessSegmentSSID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [BusinessSegmentSSID] end,
		[RevenueGroupSSID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [RevenueGroupSSID] end,
		[RevenueGroupDescription] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [RevenueGroupDescription] end,
		[RevenueGroupDescriptionShort] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [RevenueGroupDescriptionShort] end,
		[GenderSSID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [GenderSSID] end,
		[GenderDescription] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [GenderDescription] end,
		[GenderDescriptionShort] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [GenderDescriptionShort] end,
		[MembershipDurationMonths] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [MembershipDurationMonths] end,
		[MembershipContractPrice] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [MembershipContractPrice] end,
		[MembershipMonthlyFee] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [MembershipMonthlyFee] end,
		[RowIsCurrent] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [RowIsCurrent] end,
		[RowStartDate] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [RowStartDate] end,
		[RowEndDate] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [RowEndDate] end,
		[RowChangeReason] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [RowChangeReason] end,
		[RowIsInferred] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [RowIsInferred] end,
		[InsertAuditKey] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [UpdateAuditKey] end,
		[msrepl_tran_version] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [msrepl_tran_version] end,
		[MembershipSortOrder] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [MembershipSortOrder] end,
		[BusinessSegmentDescription] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [BusinessSegmentDescription] end,
		[BusinessSegmentDescriptionShort] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [BusinessSegmentDescriptionShort] end
	where [MembershipKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[MembershipKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_cms_dds].[DimMembership]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
