/* CreateDate: 05/05/2020 17:42:44.690 , ModifyDate: 05/05/2020 17:42:44.690 */
GO
create procedure [sp_MSins_dbocfgRegister]
    @c1 int,
    @c2 nvarchar(100),
    @c3 nvarchar(20),
    @c4 int,
    @c5 bit,
    @c6 bit,
    @c7 int,
    @c8 bit,
    @c9 datetime,
    @c10 nvarchar(25),
    @c11 datetime,
    @c12 nvarchar(25),
    @c13 nvarchar(32)
as
begin
	insert into [dbo].[cfgRegister] (
		[RegisterID],
		[RegisterDescription],
		[RegisterDescriptionShort],
		[CenterID],
		[HasCashDrawer],
		[CanRunEndOfDay],
		[CashRegisterID],
		[IsActiveFlag],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[IPAddress]
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
