/* CreateDate: 05/05/2020 17:42:55.990 , ModifyDate: 05/05/2020 17:42:55.990 */
GO
create procedure [dbo].[sp_MSins_dbodatAppointmentScorecard]
    @c1 int,
    @c2 uniqueidentifier,
    @c3 int,
    @c4 datetime,
    @c5 uniqueidentifier,
    @c6 datetime,
    @c7 nvarchar(25),
    @c8 datetime,
    @c9 nvarchar(25),
    @c10 binary(8)
as
begin
	insert into [dbo].[datAppointmentScorecard] (
		[AppointmentScorecardID],
		[AppointmentGUID],
		[ScorecardCategoryID],
		[CompleteDate],
		[CompletedByEmployeeGUID],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp]
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
		@c10	)
end
GO
