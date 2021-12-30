/* CreateDate: 05/05/2020 17:42:41.127 , ModifyDate: 05/05/2020 17:42:41.127 */
GO
create procedure [sp_MSins_dbocfgCenterTaxRate]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 decimal(6,5),
    @c5 bit,
    @c6 datetime,
    @c7 nvarchar(25),
    @c8 datetime,
    @c9 nvarchar(25),
    @c10 nvarchar(20)
as
begin
	insert into [dbo].[cfgCenterTaxRate] (
		[CenterTaxRateID],
		[CenterID],
		[TaxTypeID],
		[TaxRate],
		[IsActiveFlag],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[TaxIdNumber]
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
		default,
		@c10	)
end
GO
