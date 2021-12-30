/* CreateDate: 07/25/2018 14:51:34.047 , ModifyDate: 07/25/2018 14:51:34.047 */
GO
create procedure [dbo].[sp_MSins_dboonca_source]
    @c1 nchar(30),
    @c2 nchar(50),
    @c3 nchar(10),
    @c4 nchar(1),
    @c5 int,
    @c6 nchar(10),
    @c7 nchar(10),
    @c8 nchar(10),
    @c9 nchar(10),
    @c10 nchar(20),
    @c11 datetime,
    @c12 nchar(20),
    @c13 datetime,
    @c14 nchar(1)
as
begin
	insert into [dbo].[onca_source](
		[source_code],
		[description],
		[campaign_code],
		[active],
		[cst_dnis_number],
		[cst_promotion_code],
		[cst_age_range_code],
		[cst_hair_loss_code],
		[cst_language_code],
		[cst_created_by_user_code],
		[cst_created_date],
		[cst_updated_by_user_code],
		[cst_updated_date],
		[publish]
	) values (
    @c1,
    @c2,
    @c3,
    @c4,
    @c5,
    @c6,
    @c7,
    @c8,
    @c9,
    @c10,
    @c11,
    @c12,
    @c13,
    @c14	)
end
GO
