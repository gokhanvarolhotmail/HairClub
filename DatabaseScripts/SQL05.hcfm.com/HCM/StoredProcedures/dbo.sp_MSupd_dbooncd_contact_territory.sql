/* CreateDate: 01/03/2018 16:31:36.177 , ModifyDate: 01/03/2018 16:31:36.177 */
GO
create procedure [dbo].[sp_MSupd_dbooncd_contact_territory]
		@c1 nchar(10) = NULL,
		@c2 nchar(10) = NULL,
		@c3 nchar(10) = NULL,
		@c4 int = NULL,
		@c5 datetime = NULL,
		@c6 nchar(20) = NULL,
		@c7 datetime = NULL,
		@c8 nchar(20) = NULL,
		@c9 nchar(1) = NULL,
		@pkc1 nchar(10) = NULL,
		@bitmap binary(2)
as
begin
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[oncd_contact_territory] set
		[contact_territory_id] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [contact_territory_id] end,
		[contact_id] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [contact_id] end,
		[territory_code] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [territory_code] end,
		[sort_order] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [sort_order] end,
		[creation_date] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [creation_date] end,
		[created_by_user_code] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [created_by_user_code] end,
		[updated_date] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [updated_date] end,
		[updated_by_user_code] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [updated_by_user_code] end,
		[primary_flag] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [primary_flag] end
where [contact_territory_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
else
begin
update [dbo].[oncd_contact_territory] set
		[contact_id] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [contact_id] end,
		[territory_code] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [territory_code] end,
		[sort_order] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [sort_order] end,
		[creation_date] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [creation_date] end,
		[created_by_user_code] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [created_by_user_code] end,
		[updated_date] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [updated_date] end,
		[updated_by_user_code] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [updated_by_user_code] end,
		[primary_flag] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [primary_flag] end
where [contact_territory_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
end
GO
