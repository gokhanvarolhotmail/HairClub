/* CreateDate: 03/17/2022 11:57:07.933 , ModifyDate: 03/17/2022 11:57:07.933 */
GO
create procedure [sp_MSins_bi_cms_ddsFactEmployeeSecurity]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 int,
    @c5 int,
    @c6 int,
    @c7 int,
    @c8 int,
    @c9 uniqueidentifier,
    @c10 uniqueidentifier
as
begin
	insert into [bi_cms_dds].[FactEmployeeSecurity] (
		[EmployeeSecurityKey],
		[EmployeeKey],
		[EmployeePositionKey],
		[ActiveDirectoryGroupKey],
		[HasAccess],
		[SecurityElementKey],
		[InsertAuditKey],
		[UpdateAuditKey],
		[RowTimeStamp],
		[msrepl_tran_version],
		[AppointmentEmployeeSSID]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		default,
		@c9,
		@c10	)
end
GO
