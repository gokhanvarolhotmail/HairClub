/* CreateDate: 05/05/2020 17:42:51.447 , ModifyDate: 05/05/2020 17:42:51.447 */
GO
create procedure [sp_MSins_dbodatNotification]
    @c1 int,
    @c2 datetime,
    @c3 int,
    @c4 uniqueidentifier,
    @c5 int,
    @c6 date,
    @c7 int,
    @c8 bit,
    @c9 nvarchar(200),
    @c10 datetime,
    @c11 nvarchar(25),
    @c12 datetime,
    @c13 nvarchar(25),
    @c14 uniqueidentifier,
    @c15 bit,
    @c16 int
as
begin
	insert into [dbo].[datNotification] (
		[NotificationID],
		[NotificationDate],
		[NotificationTypeID],
		[ClientGUID],
		[FeePayCycleID],
		[FeeDate],
		[CenterID],
		[IsAcknowledgedFlag],
		[Description],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[AppointmentGUID],
		[IsHairOrderRequestedFlag],
		[VisitingCenterID]
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
		default,
		@c14,
		@c15,
		@c16	)
end
GO
