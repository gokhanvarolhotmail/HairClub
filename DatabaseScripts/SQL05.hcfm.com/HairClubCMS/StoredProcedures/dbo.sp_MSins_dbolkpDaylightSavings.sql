/* CreateDate: 05/05/2020 17:42:53.700 , ModifyDate: 05/05/2020 17:42:53.700 */
GO
create procedure [sp_MSins_dbolkpDaylightSavings]
    @c1 int,
    @c2 int,
    @c3 datetime,
    @c4 datetime,
    @c5 datetime,
    @c6 nvarchar(50),
    @c7 datetime,
    @c8 nvarchar(50)
as
begin
	insert into [dbo].[lkpDaylightSavings] (
		[DaylightSavingsID],
		[Year],
		[DSTStartDate],
		[DSTEndDate],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8	)
end
GO
