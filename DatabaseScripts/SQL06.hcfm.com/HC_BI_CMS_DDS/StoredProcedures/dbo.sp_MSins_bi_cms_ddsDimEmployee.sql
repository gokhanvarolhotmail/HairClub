create procedure [sp_MSins_bi_cms_ddsDimEmployee]
    @c1 int,
    @c2 uniqueidentifier,
    @c3 nvarchar(50),
    @c4 nvarchar(50),
    @c5 nvarchar(5),
    @c6 int,
    @c7 nvarchar(50),
    @c8 nvarchar(10),
    @c9 nvarchar(50),
    @c10 nvarchar(50),
    @c11 nvarchar(50),
    @c12 nvarchar(50),
    @c13 nvarchar(10),
    @c14 nvarchar(50),
    @c15 nvarchar(10),
    @c16 nvarchar(50),
    @c17 nvarchar(15),
    @c18 nvarchar(50),
    @c19 nvarchar(25),
    @c20 nvarchar(25),
    @c21 nvarchar(100),
    @c22 nvarchar(20),
    @c23 nvarchar(20),
    @c24 tinyint,
    @c25 datetime,
    @c26 datetime,
    @c27 varchar(200),
    @c28 tinyint,
    @c29 int,
    @c30 int,
    @c31 uniqueidentifier,
    @c32 int,
    @c33 nvarchar(20),
    @c34 bit
as
begin
	insert into [bi_cms_dds].[DimEmployee] (
		[EmployeeKey],
		[EmployeeSSID],
		[EmployeeFirstName],
		[EmployeeLastName],
		[EmployeeInitials],
		[SalutationSSID],
		[EmployeeSalutationDescription],
		[EmployeeSalutationDescriptionShort],
		[EmployeeAddress1],
		[EmployeeAddress2],
		[EmployeeAddress3],
		[CountryRegionDescription],
		[CountryRegionDescriptionShort],
		[StateProvinceDescription],
		[StateProvinceDescriptionShort],
		[City],
		[PostalCode],
		[UserLogin],
		[EmployeePhoneMain],
		[EmployeePhoneAlternate],
		[EmployeeEmergencyContact],
		[EmployeePayrollNumber],
		[EmployeeTimeClockNumber],
		[RowIsCurrent],
		[RowStartDate],
		[RowEndDate],
		[RowChangeReason],
		[RowIsInferred],
		[InsertAuditKey],
		[UpdateAuditKey],
		[RowTimeStamp],
		[msrepl_tran_version],
		[CenterSSID],
		[EmployeePayrollID],
		[IsActiveFlag]
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
		@c24,
		@c25,
		@c26,
		@c27,
		@c28,
		@c29,
		@c30,
		default,
		@c31,
		@c32,
		@c33,
		@c34	)
end
