/* CreateDate: 10/03/2019 22:32:12.237 , ModifyDate: 10/03/2019 22:32:12.237 */
GO
create procedure [sp_MSins_dboEmployeeCertipay]
    @c1 nvarchar(64),
    @c2 nvarchar(64),
    @c3 varchar(50),
    @c4 varchar(50),
    @c5 varchar(50),
    @c6 varchar(12),
    @c7 varchar(10),
    @c8 varchar(7),
    @c9 varchar(50),
    @c10 varchar(50),
    @c11 varchar(50),
    @c12 int,
    @c13 varchar(50),
    @c14 varchar(50),
    @c15 varchar(25),
    @c16 datetime,
    @c17 datetime,
    @c18 varchar(12),
    @c19 tinyint,
    @c20 int,
    @c21 datetime,
    @c22 int,
    @c23 varchar(100),
    @c24 int
as
begin
	insert into [dbo].[EmployeeCertipay] (
		[LastName],
		[FirstName],
		[Address],
		[City],
		[State],
		[Zip],
		[Phone],
		[Gender],
		[JobCode],
		[Title],
		[PayGroup],
		[HomeDepartment],
		[EmployeeID],
		[EmployeeNumber],
		[Status],
		[HireDate],
		[TerminationDate],
		[EmployeeType],
		[CommissionFlag],
		[PerformerHomeCenter],
		[ImportDate],
		[GeneralLedger],
		[JobClassification],
		[ID]
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
		@c14,
		@c15,
		@c16,
		@c17,
		@c18,
		@c19,
		@c20,
		@c21,
		@c22,
		@c23,
		@c24	)
end
GO
