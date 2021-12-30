/* CreateDate: 01/03/2018 16:31:34.740 , ModifyDate: 01/03/2018 16:31:34.740 */
GO
create procedure [dbo].[sp_MSupd_dbocstd_activity_demographic]
		@c1 nchar(10) = NULL,
		@c2 nchar(10) = NULL,
		@c3 nchar(1) = NULL,
		@c4 datetime = NULL,
		@c5 char(10) = NULL,
		@c6 nchar(10) = NULL,
		@c7 nchar(10) = NULL,
		@c8 nchar(50) = NULL,
		@c9 nchar(50) = NULL,
		@c10 int = NULL,
		@c11 datetime = NULL,
		@c12 nchar(20) = NULL,
		@c13 datetime = NULL,
		@c14 nchar(20) = NULL,
		@c15 varchar(50) = NULL,
		@c16 money = NULL,
		@c17 varchar(100) = NULL,
		@c18 varchar(200) = NULL,
		@c19 nvarchar(1) = NULL,
		@pkc1 nchar(10) = NULL,
		@bitmap binary(3)
as
begin
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[cstd_activity_demographic] set
		[activity_demographic_id] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [activity_demographic_id] end,
		[activity_id] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [activity_id] end,
		[gender] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [gender] end,
		[birthday] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [birthday] end,
		[occupation_code] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [occupation_code] end,
		[ethnicity_code] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [ethnicity_code] end,
		[maritalstatus_code] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [maritalstatus_code] end,
		[norwood] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [norwood] end,
		[ludwig] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [ludwig] end,
		[age] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [age] end,
		[creation_date] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [creation_date] end,
		[created_by_user_code] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [created_by_user_code] end,
		[updated_date] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [updated_date] end,
		[updated_by_user_code] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [updated_by_user_code] end,
		[performer] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [performer] end,
		[price_quoted] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [price_quoted] end,
		[solution_offered] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [solution_offered] end,
		[no_sale_reason] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [no_sale_reason] end,
		[disc_style] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [disc_style] end
where [activity_demographic_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
else
begin
update [dbo].[cstd_activity_demographic] set
		[activity_id] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [activity_id] end,
		[gender] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [gender] end,
		[birthday] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [birthday] end,
		[occupation_code] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [occupation_code] end,
		[ethnicity_code] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [ethnicity_code] end,
		[maritalstatus_code] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [maritalstatus_code] end,
		[norwood] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [norwood] end,
		[ludwig] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [ludwig] end,
		[age] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [age] end,
		[creation_date] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [creation_date] end,
		[created_by_user_code] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [created_by_user_code] end,
		[updated_date] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [updated_date] end,
		[updated_by_user_code] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [updated_by_user_code] end,
		[performer] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [performer] end,
		[price_quoted] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [price_quoted] end,
		[solution_offered] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [solution_offered] end,
		[no_sale_reason] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [no_sale_reason] end,
		[disc_style] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [disc_style] end
where [activity_demographic_id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
end
GO
