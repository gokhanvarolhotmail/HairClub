/* CreateDate: 05/05/2020 17:42:56.043 , ModifyDate: 05/05/2020 17:42:56.043 */
GO
create procedure [dbo].[sp_MSins_dbodatAppointmentScorecardMetric]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 bit,
    @c5 datetime,
    @c6 nvarchar(25),
    @c7 datetime,
    @c8 nvarchar(25),
    @c9 binary(8)
as
begin
	insert into [dbo].[datAppointmentScorecardMetric] (
		[AppointmentScorecardMetricID],
		[AppointmentScorecardID],
		[ScorecardMetricID],
		[ScorecardMetricAnswer],
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
		@c9	)
end
GO
