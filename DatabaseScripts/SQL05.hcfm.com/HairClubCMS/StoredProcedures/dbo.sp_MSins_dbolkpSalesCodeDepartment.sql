/* CreateDate: 05/05/2020 17:42:37.910 , ModifyDate: 05/05/2020 17:42:37.910 */
GO
create procedure [sp_MSins_dbolkpSalesCodeDepartment]
    @c1 int,
    @c2 int,
    @c3 nvarchar(100),
    @c4 nvarchar(10),
    @c5 int,
    @c6 bit,
    @c7 datetime,
    @c8 nvarchar(25),
    @c9 datetime,
    @c10 nvarchar(25)
as
begin
	insert into [dbo].[lkpSalesCodeDepartment] (
		[SalesCodeDepartmentID],
		[SalesCodeDepartmentSortOrder],
		[SalesCodeDepartmentDescription],
		[SalesCodeDepartmentDescriptionShort],
		[SalesCodeDivisionID],
		[IsActiveFlag],
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
		@c10,
		default	)
end
GO
