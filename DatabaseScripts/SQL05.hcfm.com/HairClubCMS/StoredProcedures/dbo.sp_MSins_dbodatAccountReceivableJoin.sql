/* CreateDate: 05/05/2020 17:42:47.977 , ModifyDate: 05/05/2020 17:42:47.977 */
GO
create procedure [sp_MSins_dbodatAccountReceivableJoin]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 money,
    @c5 datetime,
    @c6 nvarchar(25),
    @c7 datetime,
    @c8 nvarchar(25)
as
begin
	insert into [dbo].[datAccountReceivableJoin] (
		[AccountReceivableJoinID],
		[ARChargeID],
		[ARPaymentID],
		[Amount],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		default	)
end
GO
