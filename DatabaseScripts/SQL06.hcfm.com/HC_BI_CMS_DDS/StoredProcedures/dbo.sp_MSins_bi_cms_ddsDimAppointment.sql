create procedure [dbo].[sp_MSins_bi_cms_ddsDimAppointment]
    @c1 int,
    @c2 uniqueidentifier,
    @c3 int,
    @c4 int,
    @c5 int,
    @c6 int,
    @c7 int,
    @c8 uniqueidentifier,
    @c9 int,
    @c10 uniqueidentifier,
    @c11 datetime,
    @c12 int,
    @c13 nvarchar(50),
    @c14 int,
    @c15 nvarchar(50),
    @c16 int,
    @c17 nvarchar(50),
    @c18 time,
    @c19 time,
    @c20 time,
    @c21 time,
    @c22 varchar(500),
    @c23 varchar(50),
    @c24 varchar(100),
    @c25 varchar(50),
    @c26 varchar(50),
    @c27 tinyint,
    @c28 tinyint,
    @c29 tinyint,
    @c30 tinyint,
    @c31 datetime,
    @c32 datetime,
    @c33 varchar(200),
    @c34 tinyint,
    @c35 int,
    @c36 int,
    @c37 binary(8),
    @c38 uniqueidentifier,
    @c39 nvarchar(18),
    @c40 nvarchar(18)
as
begin
	insert into [bi_cms_dds].[DimAppointment] (
		[AppointmentKey],
		[AppointmentSSID],
		[CenterKey],
		[CenterSSID],
		[ClientHomeCenterKey],
		[ClientHomeCenterSSID],
		[ClientKey],
		[ClientSSID],
		[ClientMembershipKey],
		[ClientMembershipSSID],
		[AppointmentDate],
		[ResourceSSID],
		[ResourceDescription],
		[ConfirmationTypeSSID],
		[ConfirmationTypeDescription],
		[AppointmentTypeSSID],
		[AppointmentTypeDescription],
		[AppointmentStartTime],
		[AppointmentEndTime],
		[CheckInTime],
		[CheckOutTime],
		[AppointmentSubject],
		[AppointmentStatusSSID],
		[AppointmentStatusDescription],
		[OnContactActivitySSID],
		[OnContactContactSSID],
		[CanPrinTCommentFlag],
		[IsNonAppointmentFlag],
		[IsDeletedFlag],
		[RowIsCurrent],
		[RowStartDate],
		[RowEndDate],
		[RowChangeReason],
		[RowIsInferred],
		[InsertAuditKey],
		[UpdateAuditKey],
		[RowTimeStamp],
		[msrepl_tran_version],
		[SFDC_TaskID],
		[SFDC_LeadID]
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
		@c31,
		@c32,
		@c33,
		@c34,
		@c35,
		@c36,
		@c37,
		@c38,
		@c39,
		@c40	)
end
