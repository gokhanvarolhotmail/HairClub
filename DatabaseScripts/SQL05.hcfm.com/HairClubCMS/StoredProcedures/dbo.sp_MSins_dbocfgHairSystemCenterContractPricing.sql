/* CreateDate: 05/05/2020 17:42:42.577 , ModifyDate: 05/05/2020 17:42:42.577 */
GO
create procedure [sp_MSins_dbocfgHairSystemCenterContractPricing]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 int,
    @c5 money,
    @c6 bit,
    @c7 datetime,
    @c8 nvarchar(25),
    @c9 datetime,
    @c10 nvarchar(25),
    @c11 int,
    @c12 int,
    @c13 money,
    @c14 money,
    @c15 money,
    @c16 money,
    @c17 money
as
begin
	insert into [dbo].[cfgHairSystemCenterContractPricing] (
		[HairSystemCenterContractPricingID],
		[HairSystemCenterContractID],
		[HairSystemID],
		[HairSystemHairLengthID],
		[HairSystemPrice],
		[IsContractPriceInActive],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[HairSystemAreaRangeBegin],
		[HairSystemAreaRangeEnd],
		[AddOnSignatureHairlinePrice],
		[AddOnExtendedLacePrice],
		[AddOnOmbrePrice],
		[AddOnCuticleIntactHairPrice],
		[AddOnRootShadowingPrice]
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
		default,
		@c11,
		@c12,
		@c13,
		@c14,
		@c15,
		@c16,
		@c17	)
end
GO
