create procedure [sp_MSins_bi_cms_ddsFactSurgeryCloseoutEmployee]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 int,
    @c5 int,
    @c6 int,
    @c7 int,
    @c8 uniqueidentifier,
    @c9 uniqueidentifier
as
begin
	insert into [bi_cms_dds].[FactSurgeryCloseoutEmployee] (
		[SurgeryCloseOutEmployeeKey],
		[AppointmentKey],
		[EmployeeKey],
		[CutCount],
		[PlaceCount],
		[InsertAuditKey],
		[UpdateAuditKey],
		[RowTimeStamp],
		[msrepl_tran_version],
		[SurgeryCloseOutEmployeeSSID]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		default,
		@c8,
		@c9	)
end
