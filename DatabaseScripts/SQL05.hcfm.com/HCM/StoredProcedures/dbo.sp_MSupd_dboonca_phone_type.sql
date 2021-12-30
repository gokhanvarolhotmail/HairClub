/* CreateDate: 01/03/2018 16:31:35.990 , ModifyDate: 01/03/2018 16:31:35.990 */
GO
create procedure [sp_MSupd_dboonca_phone_type]
		@c1 nchar(10) = NULL,
		@c2 nchar(50) = NULL,
		@c3 nchar(1) = NULL,
		@c4 nchar(1) = NULL,
		@c5 nchar(10) = NULL,
		@c6 nchar(1) = NULL,
		@pkc1 nchar(10) = NULL,
		@bitmap binary(1)
as
begin
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[onca_phone_type] set
		[phone_type_code] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [phone_type_code] end,
		[description] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [description] end,
		[active] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [active] end,
		[device_type] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [device_type] end,
		[cst_entity_code] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [cst_entity_code] end,
		[cst_is_cell_phone] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [cst_is_cell_phone] end
where [phone_type_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
else
begin
update [dbo].[onca_phone_type] set
		[description] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [description] end,
		[active] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [active] end,
		[device_type] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [device_type] end,
		[cst_entity_code] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [cst_entity_code] end,
		[cst_is_cell_phone] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [cst_is_cell_phone] end
where [phone_type_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
end
GO
