create procedure [sp_MSupd_bi_cms_ddsDimMembershipOrderReason]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 int = NULL,
		@c4 nvarchar(100) = NULL,
		@c5 nvarchar(10) = NULL,
		@c6 int = NULL,
		@c7 int = NULL,
		@c8 bit = NULL,
		@c9 datetime = NULL,
		@c10 nvarchar(25) = NULL,
		@c11 datetime = NULL,
		@c12 nvarchar(25) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [bi_cms_dds].[DimMembershipOrderReason] set
		[MembershipOrderReasonID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [MembershipOrderReasonID] end,
		[MembershipOrderReasonTypeID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [MembershipOrderReasonTypeID] end,
		[MembershipOrderReasonSortOrder] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [MembershipOrderReasonSortOrder] end,
		[MembershipOrderReasonDescription] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [MembershipOrderReasonDescription] end,
		[MembershipOrderReasonDescriptionShort] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [MembershipOrderReasonDescriptionShort] end,
		[BusinessSegmentID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [BusinessSegmentID] end,
		[RevenueTypeID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [RevenueTypeID] end,
		[IsActiveFlag] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [IsActiveFlag] end,
		[CreateDate] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [LastUpdateUser] end
	where [MembershipOrderReasonID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[MembershipOrderReasonID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_cms_dds].[DimMembershipOrderReason]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [bi_cms_dds].[DimMembershipOrderReason] set
		[MembershipOrderReasonTypeID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [MembershipOrderReasonTypeID] end,
		[MembershipOrderReasonSortOrder] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [MembershipOrderReasonSortOrder] end,
		[MembershipOrderReasonDescription] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [MembershipOrderReasonDescription] end,
		[MembershipOrderReasonDescriptionShort] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [MembershipOrderReasonDescriptionShort] end,
		[BusinessSegmentID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [BusinessSegmentID] end,
		[RevenueTypeID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [RevenueTypeID] end,
		[IsActiveFlag] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [IsActiveFlag] end,
		[CreateDate] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [LastUpdateUser] end
	where [MembershipOrderReasonID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[MembershipOrderReasonID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_cms_dds].[DimMembershipOrderReason]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
