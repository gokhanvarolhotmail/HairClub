/* CreateDate: 01/03/2018 16:31:35.253 , ModifyDate: 01/03/2018 16:31:35.253 */
GO
create procedure [dbo].[sp_MSupd_dboonca_time_zone]
		@c1 nchar(10) = NULL,
		@c2 nchar(50) = NULL,
		@c3 float = NULL,
		@c4 nchar(20) = NULL,
		@pkc1 nchar(10) = NULL,
		@bitmap binary(1)
as
begin
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[onca_time_zone] set
		[time_zone_code] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [time_zone_code] end,
		[description] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [description] end,
		[greenwich_offset] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [greenwich_offset] end,
		[country_code] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [country_code] end
where [time_zone_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
else
begin
update [dbo].[onca_time_zone] set
		[description] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [description] end,
		[greenwich_offset] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [greenwich_offset] end,
		[country_code] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [country_code] end
where [time_zone_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
end
GO
