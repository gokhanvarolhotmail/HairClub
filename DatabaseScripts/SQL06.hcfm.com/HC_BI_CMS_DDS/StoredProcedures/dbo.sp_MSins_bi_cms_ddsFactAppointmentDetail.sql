/* CreateDate: 10/03/2019 23:03:42.133 , ModifyDate: 10/03/2019 23:03:42.133 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSins_bi_cms_ddsFactAppointmentDetail]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 int,
    @c5 int,
    @c6 int,
    @c7 uniqueidentifier,
    @c8 uniqueidentifier
as
begin
	insert into [bi_cms_dds].[FactAppointmentDetail] (
		[AppointmentDetailKey],
		[AppointmentKey],
		[SalesCodeKey],
		[AppointmentDetailDuration],
		[InsertAuditKey],
		[UpdateAuditKey],
		[RowTimeStamp],
		[msrepl_tran_version],
		[AppointmentDetailSSID]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		default,
		@c7,
		@c8	)
end
GO
