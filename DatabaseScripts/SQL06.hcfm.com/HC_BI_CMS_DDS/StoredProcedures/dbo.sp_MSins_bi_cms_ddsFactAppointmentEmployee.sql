/* CreateDate: 10/03/2019 23:03:42.190 , ModifyDate: 10/03/2019 23:03:42.190 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
