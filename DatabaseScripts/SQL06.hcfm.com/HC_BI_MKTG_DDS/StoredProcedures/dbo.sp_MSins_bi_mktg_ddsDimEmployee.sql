/* CreateDate: 09/03/2021 09:37:05.977 , ModifyDate: 09/03/2021 09:37:05.977 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSins_bi_mktg_ddsDimEmployee]
    @c1 int,
    @c2 nvarchar(20),
    @c3 nvarchar(50),
    @c4 nvarchar(80),
    @c5 nvarchar(50),
    @c6 nvarchar(50),
    @c7 nvarchar(50),
    @c8 nvarchar(10),
    @c9 nvarchar(50),
    @c10 nvarchar(10),
    @c11 nvarchar(50),
    @c12 tinyint,
    @c13 datetime,
    @c14 datetime,
    @c15 varchar(200),
    @c16 tinyint,
    @c17 int,
    @c18 int
as
begin
	insert into [bi_mktg_dds].[DimEmployee] (
		[EmployeeKey],
		[EmployeeSSID],
		[EmployeeFirstName],
		[EmployeeLastName],
		[EmployeeDescription],
		[EmployeeTitle],
		[ActionSetCode],
		[EmployeeDepartmentSSID],
		[EmployeeDepartmentDescription],
		[EmployeeJobFunctionSSID],
		[EmployeeJobFunctionDescription],
		[RowIsCurrent],
		[RowStartDate],
		[RowEndDate],
		[RowChangeReason],
		[RowIsInferred],
		[InsertAuditKey],
		[UpdateAuditKey],
		[RowTimeStamp]
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
		default	)
end
GO
