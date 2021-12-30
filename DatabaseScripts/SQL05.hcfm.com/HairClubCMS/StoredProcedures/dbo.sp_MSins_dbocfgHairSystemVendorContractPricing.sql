/* CreateDate: 05/05/2020 17:42:45.640 , ModifyDate: 05/05/2020 17:42:45.640 */
GO
create procedure [dbo].[sp_MSins_dbocfgHairSystemVendorContractPricing]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 int,
    @c5 decimal(23,8),
    @c6 decimal(23,8),
    @c7 money,
    @c8 datetime,
    @c9 nvarchar(25),
    @c10 datetime,
    @c11 nvarchar(25),
    @c12 binary(8),
    @c13 bit,
    @c14 money,
    @c15 money,
    @c16 money,
    @c17 money,
    @c18 money
as
begin
	insert into [dbo].[cfgHairSystemVendorContractPricing] (
		[HairSystemVendorContractPricingID],
		[HairSystemVendorContractID],
		[HairSystemHairLengthID],
		[HairSystemHairCapID],
		[HairSystemAreaRangeBegin],
		[HairSystemAreaRangeEnd],
		[HairSystemCost],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[IsContractPriceInActive],
		[AddOnSignatureHairlineCost],
		[AddOnExtendedLaceCost],
		[AddOnOmbreCost],
		[AddOnCuticleIntactHairCost],
		[AddOnRootShadowCost]
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
		@c18	)
end
GO
