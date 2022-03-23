/* CreateDate: 03/17/2022 11:57:07.723 , ModifyDate: 03/17/2022 11:57:07.723 */
GO
create procedure [sp_MSins_bi_cms_ddsFactAppointmentEmployee]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 int,
    @c5 int,
    @c6 uniqueidentifier,
    @c7 uniqueidentifier
as
begin
	insert into [bi_cms_dds].[FactAppointmentEmployee] (
		[AppointmentEmployeeKey],
		[AppointmentKey],
		[EmployeeKey],
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
		default,
		@c6,
		@c7	)
end
GO
