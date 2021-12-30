/* CreateDate: 05/05/2020 17:42:47.710 , ModifyDate: 05/05/2020 17:42:47.710 */
GO
create procedure [sp_MSins_dbodatInterCompanyTransaction]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 datetime,
    @c5 uniqueidentifier,
    @c6 uniqueidentifier,
    @c7 uniqueidentifier,
    @c8 bit,
    @c9 datetime,
    @c10 nvarchar(25),
    @c11 datetime,
    @c12 nvarchar(25),
    @c13 uniqueidentifier
as
begin
	insert into [dbo].[datInterCompanyTransaction] (
		[InterCompanyTransactionId],
		[CenterId],
		[ClientHomeCenterId],
		[TransactionDate],
		[AppointmentGUID],
		[ClientGUID],
		[ClientMembershipGUID],
		[IsClosed],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[SalesOrderGUID]
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
		default,
		@c13	)
end
GO
