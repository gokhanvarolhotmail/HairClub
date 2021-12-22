/* CreateDate: 10/03/2019 23:03:40.433 , ModifyDate: 10/03/2019 23:03:40.433 */
GO
create procedure [dbo].[sp_MSins_bi_cms_ddsDimEmployeePositionJoin]
    @c1 uniqueidentifier,
    @c2 int,
    @c3 datetime,
    @c4 nvarchar(25),
    @c5 datetime,
    @c6 nvarchar(25),
    @c7 binary(8)
as
begin
	insert into [bi_cms_dds].[DimEmployeePositionJoin] (
		[EmployeeGUID],
		[EmployeePositionID],
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
		@c7	)
end
GO
