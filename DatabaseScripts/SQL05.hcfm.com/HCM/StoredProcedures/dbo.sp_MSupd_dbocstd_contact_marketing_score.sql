/* CreateDate: 01/03/2018 16:31:36.293 , ModifyDate: 01/03/2018 16:31:36.293 */
GO
create procedure [sp_MSupd_dbocstd_contact_marketing_score]
		@c1 uniqueidentifier = NULL,
		@c2 nchar(10) = NULL,
		@c3 nchar(10) = NULL,
		@c4 nvarchar(50) = NULL,
		@c5 decimal(15,4) = NULL,
		@c6 datetime = NULL,
		@c7 nchar(20) = NULL,
		@c8 datetime = NULL,
		@c9 nchar(20) = NULL,
		@pkc1 uniqueidentifier = NULL,
		@bitmap binary(2)
as
begin
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[cstd_contact_marketing_score] set
		[contact_marketing_score_id] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [contact_marketing_score_id] end,
		[contact_id] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [contact_id] end,
		[marketing_score_contact_type_code] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [marketing_score_contact_type_code] end,
		[marketing_score_type] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [marketing_score_type] end,
		[marketing_score] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [marketing_score] end,
		[creation_date] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [creation_date] end,
		[created_by_user_code] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [created_by_user_code] end,
		[updated_date] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [updated_date] end,
		[updated_by_user_code] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [updated_by_user_code] end
where [contact_marketing_score_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
else
begin
update [dbo].[cstd_contact_marketing_score] set
		[contact_id] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [contact_id] end,
		[marketing_score_contact_type_code] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [marketing_score_contact_type_code] end,
		[marketing_score_type] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [marketing_score_type] end,
		[marketing_score] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [marketing_score] end,
		[creation_date] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [creation_date] end,
		[created_by_user_code] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [created_by_user_code] end,
		[updated_date] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [updated_date] end,
		[updated_by_user_code] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [updated_by_user_code] end
where [contact_marketing_score_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
end
GO
