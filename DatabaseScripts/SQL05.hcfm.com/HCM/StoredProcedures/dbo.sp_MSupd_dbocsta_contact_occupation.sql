/* CreateDate: 01/03/2018 16:31:32.270 , ModifyDate: 01/03/2018 16:31:32.270 */
GO
create procedure [dbo].[sp_MSupd_dbocsta_contact_occupation]
		@c1 char(10) = NULL,
		@c2 nchar(50) = NULL,
		@c3 nchar(1) = NULL,
		@pkc1 char(10) = NULL,
		@bitmap binary(1)
as
begin
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[csta_contact_occupation] set
		[occupation_code] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [occupation_code] end,
		[description] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [description] end,
		[active] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [active] end
where [occupation_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
else
begin
update [dbo].[csta_contact_occupation] set
		[description] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [description] end,
		[active] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [active] end
where [occupation_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
end
GO
