/* CreateDate: 01/03/2018 16:31:32.767 , ModifyDate: 01/03/2018 16:31:32.767 */
GO
create procedure [dbo].[sp_MSins_dbocsta_contact_saletype]
    @c1 nchar(10),
    @c2 nchar(50),
    @c3 nchar(1),
    @c4 int,
    @c5 decimal(15,4),
    @c6 nchar(1),
    @c7 nchar(1),
    @c8 nchar(1),
    @c9 nchar(1),
    @c10 int,
    @c11 nvarchar(100),
    @c12 nvarchar(100),
    @c13 int,
    @c14 int
as
begin
	insert into [dbo].[csta_contact_saletype](
		[saletype_code],
		[description],
		[active],
		[frame],
		[price],
		[select_size_flag],
		[size_sets_price],
		[length_sets_price],
		[base_is_init_pay],
		[percentage],
		[message_under],
		[message_over],
		[systems],
		[BusinessSegmentID]
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
