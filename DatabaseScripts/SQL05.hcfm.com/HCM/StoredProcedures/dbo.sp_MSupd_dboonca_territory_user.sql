/* CreateDate: 01/03/2018 16:31:35.417 , ModifyDate: 01/03/2018 16:31:35.417 */
GO
create procedure [dbo].[sp_MSupd_dboonca_territory_user]
		@c1 nchar(10) = NULL,
		@c2 nchar(10) = NULL,
		@c3 nchar(20) = NULL,
		@c4 datetime = NULL,
		@c5 int = NULL,
		@c6 nchar(1) = NULL,
		@pkc1 nchar(10) = NULL,
		@bitmap binary(1)
as
begin
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[onca_territory_user] set
		[territory_user_id] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [territory_user_id] end,
		[territory_code] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [territory_code] end,
		[user_code] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [user_code] end,
		[assignment_date] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [assignment_date] end,
		[sort_order] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [sort_order] end,
		[active] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [active] end
where [territory_user_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
else
begin
update [dbo].[onca_territory_user] set
		[territory_code] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [territory_code] end,
		[user_code] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [user_code] end,
		[assignment_date] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [assignment_date] end,
		[sort_order] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [sort_order] end,
		[active] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [active] end
where [territory_user_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
end
GO
