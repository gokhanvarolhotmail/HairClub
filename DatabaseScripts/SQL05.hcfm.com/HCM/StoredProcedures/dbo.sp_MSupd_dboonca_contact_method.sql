/* CreateDate: 01/03/2018 16:31:34.793 , ModifyDate: 01/03/2018 16:31:34.793 */
GO
create procedure [sp_MSupd_dboonca_contact_method]
		@c1 nchar(10) = NULL,
		@c2 nchar(50) = NULL,
		@c3 nchar(1) = NULL,
		@pkc1 nchar(10) = NULL,
		@bitmap binary(1)
as
begin
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[onca_contact_method] set
		[contact_method_code] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [contact_method_code] end,
		[description] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [description] end,
		[active] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [active] end
where [contact_method_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
else
begin
update [dbo].[onca_contact_method] set
		[description] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [description] end,
		[active] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [active] end
where [contact_method_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
end
GO
