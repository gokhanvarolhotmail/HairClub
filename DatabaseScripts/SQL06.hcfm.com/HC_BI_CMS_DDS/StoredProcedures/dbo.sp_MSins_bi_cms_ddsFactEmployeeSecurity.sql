/* CreateDate: 10/03/2019 23:03:42.240 , ModifyDate: 10/03/2019 23:03:42.240 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
