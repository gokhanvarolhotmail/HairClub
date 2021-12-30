/* CreateDate: 05/05/2020 17:42:55.427 , ModifyDate: 05/05/2020 17:42:55.427 */
GO
create procedure [sp_MSins_dbomtnActiveDirectoryImport]
    @c1 int,
    @c2 varbinary(100),
    @c3 nvarchar(50),
    @c4 nvarchar(50),
    @c5 nvarchar(50),
    @c6 nvarchar(50),
    @c7 int,
    @c8 int,
    @c9 nvarchar(5),
    @c10 datetime,
    @c11 nvarchar(20),
    @c12 int
as
begin
	insert into [dbo].[mtnActiveDirectoryImport] (
		[ActiveDirectoryID],
		[ADSID],
		[ADUserLogin],
		[ADCenter],
		[ADFirstName],
		[ADLastName],
		[CenterID],
		[EmployeePositionID],
		[EmployeeInitials],
		[CreateDate],
		[EmployeePayrollID],
		[EmployeeTitleID]
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
		@c12	)
end
GO
