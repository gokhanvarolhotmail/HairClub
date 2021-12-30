/* CreateDate: 05/05/2020 17:42:41.683 , ModifyDate: 05/05/2020 17:42:41.683 */
GO
create procedure [dbo].[sp_MSins_dbocfgEmployeePositionJoin]
    @c1 uniqueidentifier,
    @c2 int,
    @c3 datetime,
    @c4 nvarchar(25),
    @c5 datetime,
    @c6 nvarchar(25),
    @c7 binary(8),
    @c8 bit
as
begin
	insert into [dbo].[cfgEmployeePositionJoin] (
		[EmployeeGUID],
		[EmployeePositionID],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[IsActiveFlag]
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
