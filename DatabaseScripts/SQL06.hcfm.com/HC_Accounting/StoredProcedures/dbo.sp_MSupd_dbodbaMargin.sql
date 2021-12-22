/* CreateDate: 10/03/2019 22:32:12.040 , ModifyDate: 10/03/2019 22:32:12.040 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSupd_dbodbaMargin]
		@c1 int = NULL,
		@c2 uniqueidentifier = NULL,
		@c3 nvarchar(100) = NULL,
		@c4 int = NULL,
		@c5 int = NULL,
		@c6 uniqueidentifier = NULL,
		@c7 int = NULL,
		@c8 nvarchar(100) = NULL,
		@c9 nvarchar(100) = NULL,
		@c10 nvarchar(100) = NULL,
		@c11 nvarchar(50) = NULL,
		@c12 bit = NULL,
		@c13 datetime = NULL,
		@c14 datetime = NULL,
		@c15 int = NULL,
		@c16 money = NULL,
		@c17 money = NULL,
		@c18 money = NULL,
		@c19 money = NULL,
		@c20 int = NULL,
		@c21 money = NULL,
		@c22 int = NULL,
		@c23 int = NULL,
		@c24 int = NULL,
		@c25 int = NULL,
		@c26 money = NULL,
		@c27 datetime = NULL,
		@c28 nvarchar(25) = NULL,
		@c29 datetime = NULL,
		@c30 nvarchar(25) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(4)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[dbaMargin] set
		[ClientGUID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ClientGUID] end,
		[ClientName] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ClientName] end,
		[ClientIdentifier] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ClientIdentifier] end,
		[ClientCenterId] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ClientCenterId] end,
		[ClientMembershipGUID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [ClientMembershipGUID] end,
		[MembershipID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [MembershipID] end,
		[BusinessSegment] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [BusinessSegment] end,
		[MembershipDescription] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [MembershipDescription] end,
		[Status] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [Status] end,
		[MembershipIdentifier] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [MembershipIdentifier] end,
		[IsMembershipActive] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [IsMembershipActive] end,
		[MembershipStartDate] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [MembershipStartDate] end,
		[MembershipEndDate] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [MembershipEndDate] end,
		[MembershipDuration] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [MembershipDuration] end,
		[PaymentsTotal] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [PaymentsTotal] end,
		[RefundsTotal] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [RefundsTotal] end,
		[ServiceRevenue] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [ServiceRevenue] end,
		[ProductRevenue] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [ProductRevenue] end,
		[HairOrderCount] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [HairOrderCount] end,
		[HairOrderTotalCost] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [HairOrderTotalCost] end,
		[FullService] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [FullService] end,
		[Applications] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [Applications] end,
		[Services] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [Services] end,
		[ServiceDuration] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [ServiceDuration] end,
		[ServiceCost] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [ServiceCost] end,
		[CreateDate] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [LastUpdateUser] end
	where [ClientProfitabilityID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ClientProfitabilityID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[dbaMargin]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
