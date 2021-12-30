/* CreateDate: 05/05/2020 17:42:49.907 , ModifyDate: 05/05/2020 17:42:49.907 */
GO
create procedure [sp_MSins_dbodatEmployeeVisitCenter]
    @c1 uniqueidentifier,
    @c2 uniqueidentifier,
    @c3 int,
    @c4 datetime,
    @c5 datetime,
    @c6 datetime,
    @c7 nvarchar(25),
    @c8 datetime,
    @c9 nvarchar(25)
as
begin
	insert into [dbo].[datEmployeeVisitCenter] (
		[EmployeeCenterGUID],
		[EmployeeGUID],
		[CenterID],
		[BeginDate],
		[EndDate],
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
		default	)
end
GO
