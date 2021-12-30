/* CreateDate: 01/03/2018 16:31:32.810 , ModifyDate: 01/03/2018 16:31:32.810 */
GO
create procedure [dbo].[sp_MSupd_dbocsta_contact_saletype]
		@c1 nchar(10) = NULL,
		@c2 nchar(50) = NULL,
		@c3 nchar(1) = NULL,
		@c4 int = NULL,
		@c5 decimal(15,4) = NULL,
		@c6 nchar(1) = NULL,
		@c7 nchar(1) = NULL,
		@c8 nchar(1) = NULL,
		@c9 nchar(1) = NULL,
		@c10 int = NULL,
		@c11 nvarchar(100) = NULL,
		@c12 nvarchar(100) = NULL,
		@c13 int = NULL,
		@c14 int = NULL,
		@pkc1 nchar(10) = NULL,
		@bitmap binary(2)
as
begin
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[csta_contact_saletype] set
		[saletype_code] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [saletype_code] end,
		[description] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [description] end,
		[active] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [active] end,
		[frame] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [frame] end,
		[price] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [price] end,
		[select_size_flag] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [select_size_flag] end,
		[size_sets_price] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [size_sets_price] end,
		[length_sets_price] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [length_sets_price] end,
		[base_is_init_pay] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [base_is_init_pay] end,
		[percentage] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [percentage] end,
		[message_under] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [message_under] end,
		[message_over] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [message_over] end,
		[systems] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [systems] end,
		[BusinessSegmentID] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [BusinessSegmentID] end
where [saletype_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
else
begin
update [dbo].[csta_contact_saletype] set
		[description] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [description] end,
		[active] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [active] end,
		[frame] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [frame] end,
		[price] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [price] end,
		[select_size_flag] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [select_size_flag] end,
		[size_sets_price] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [size_sets_price] end,
		[length_sets_price] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [length_sets_price] end,
		[base_is_init_pay] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [base_is_init_pay] end,
		[percentage] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [percentage] end,
		[message_under] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [message_under] end,
		[message_over] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [message_over] end,
		[systems] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [systems] end,
		[BusinessSegmentID] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [BusinessSegmentID] end
where [saletype_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
end
GO
