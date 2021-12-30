/* CreateDate: 01/03/2018 16:31:35.140 , ModifyDate: 01/03/2018 16:31:35.140 */
GO
create procedure [dbo].[sp_MSupd_dboonca_country]
		@c1 nchar(20) = NULL,
		@c2 nchar(100) = NULL,
		@c3 nchar(10) = NULL,
		@c4 nchar(1) = NULL,
		@pkc1 nchar(20) = NULL,
		@bitmap binary(1)
as
begin
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[onca_country] set
		[country_code] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [country_code] end,
		[country_name] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [country_name] end,
		[country_code_prefix] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [country_code_prefix] end,
		[active] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [active] end
where [country_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
else
begin
update [dbo].[onca_country] set
		[country_name] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [country_name] end,
		[country_code_prefix] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [country_code_prefix] end,
		[active] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [active] end
where [country_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
end
GO
