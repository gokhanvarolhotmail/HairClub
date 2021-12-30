/* CreateDate: 01/03/2018 16:31:36.283 , ModifyDate: 01/03/2018 16:31:36.283 */
GO
create procedure [sp_MSins_dbocstd_contact_marketing_score]
    @c1 uniqueidentifier,
    @c2 nchar(10),
    @c3 nchar(10),
    @c4 nvarchar(50),
    @c5 decimal(15,4),
    @c6 datetime,
    @c7 nchar(20),
    @c8 datetime,
    @c9 nchar(20)
as
begin
	insert into [dbo].[cstd_contact_marketing_score](
		[contact_marketing_score_id],
		[contact_id],
		[marketing_score_contact_type_code],
		[marketing_score_type],
		[marketing_score],
		[creation_date],
		[created_by_user_code],
		[updated_date],
		[updated_by_user_code]
	) values (
    @c1,
    @c2,
    @c3,
    @c4,
    @c5,
    @c6,
    @c7,
    @c8,
    @c9	)
end
GO
