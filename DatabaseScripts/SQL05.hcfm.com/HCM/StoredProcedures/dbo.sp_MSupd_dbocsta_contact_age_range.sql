/* CreateDate: 01/03/2018 16:31:30.400 , ModifyDate: 01/03/2018 16:31:30.400 */
GO
create procedure [dbo].[sp_MSupd_dbocsta_contact_age_range]
		@c1 nchar(10) = NULL,
		@c2 nchar(50) = NULL,
		@c3 nchar(1) = NULL,
		@c4 int = NULL,
		@c5 int = NULL,
		@pkc1 nchar(10) = NULL,
		@bitmap binary(1)
as
begin
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[csta_contact_age_range] set
		[age_range_code] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [age_range_code] end,
		[description] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [description] end,
		[active] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [active] end,
		[minimum_age] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [minimum_age] end,
		[maximum_age] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [maximum_age] end
where [age_range_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
else
begin
update [dbo].[csta_contact_age_range] set
		[description] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [description] end,
		[active] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [active] end,
		[minimum_age] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [minimum_age] end,
		[maximum_age] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [maximum_age] end
where [age_range_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
end
GO
