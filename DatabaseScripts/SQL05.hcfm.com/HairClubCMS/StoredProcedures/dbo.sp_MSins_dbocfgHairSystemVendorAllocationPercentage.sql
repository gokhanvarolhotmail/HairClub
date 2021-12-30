/* CreateDate: 05/05/2020 17:42:44.107 , ModifyDate: 05/05/2020 17:42:44.107 */
GO
create procedure [sp_MSins_dbocfgHairSystemVendorAllocationPercentage]
    @c1 int,
    @c2 int,
    @c3 decimal(6,5),
    @c4 bit,
    @c5 datetime,
    @c6 nvarchar(25),
    @c7 datetime,
    @c8 nvarchar(25)
as
begin
	insert into [dbo].[cfgHairSystemVendorAllocationPercentage] (
		[HairSystemVendorAllocationPercentageID],
		[VendorID],
		[AllocationPercent],
		[IsContractPriceActive],
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
