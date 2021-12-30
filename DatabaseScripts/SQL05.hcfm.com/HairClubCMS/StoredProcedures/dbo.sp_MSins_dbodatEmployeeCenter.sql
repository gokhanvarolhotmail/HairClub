/* CreateDate: 05/05/2020 17:42:49.813 , ModifyDate: 05/05/2020 17:42:49.813 */
GO
create procedure [sp_MSins_dbodatEmployeeCenter]
    @c1 uniqueidentifier,
    @c2 uniqueidentifier,
    @c3 int,
    @c4 datetime,
    @c5 nvarchar(25),
    @c6 datetime,
    @c7 nvarchar(25),
    @c8 bit,
    @c9 int
as
begin
	insert into [dbo].[datEmployeeCenter] (
		[EmployeeCenterGUID],
		[EmployeeGUID],
		[CenterID],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[IsActiveFlag],
		[SequenceNumber]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		default,
		@c8,
		@c9	)
end
GO
