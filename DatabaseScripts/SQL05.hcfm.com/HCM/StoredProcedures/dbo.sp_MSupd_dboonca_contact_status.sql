/* CreateDate: 01/03/2018 16:31:34.840 , ModifyDate: 01/03/2018 16:31:34.840 */
GO
create procedure [dbo].[sp_MSupd_dboonca_contact_status]
		@c1 nchar(10) = NULL,
		@c2 nchar(50) = NULL,
		@c3 nchar(1) = NULL,
		@c4 nchar(1) = NULL,
		@pkc1 nchar(10) = NULL,
		@bitmap binary(1)
as
begin
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[onca_contact_status] set
		[contact_status_code] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [contact_status_code] end,
		[description] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [description] end,
		[active] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [active] end,
		[active_flag] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [active_flag] end
where [contact_status_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
else
begin
update [dbo].[onca_contact_status] set
		[description] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [description] end,
		[active] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [active] end,
		[active_flag] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [active_flag] end
where [contact_status_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
end
GO
