/* CreateDate: 05/05/2020 17:42:44.160 , ModifyDate: 05/05/2020 17:42:44.160 */
GO
create procedure [sp_MSins_dbocfgHairSystemVendorContract]
    @c1 int,
    @c2 int,
    @c3 nvarchar(100),
    @c4 datetime,
    @c5 datetime,
    @c6 datetime,
    @c7 bit,
    @c8 datetime,
    @c9 nvarchar(25),
    @c10 datetime,
    @c11 nvarchar(25),
    @c12 bit
as
begin
	insert into [dbo].[cfgHairSystemVendorContract] (
		[HairSystemVendorContractID],
		[VendorID],
		[ContractName],
		[ContractEntryDate],
		[ContractBeginDate],
		[ContractEndDate],
		[IsActiveContract],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[IsRepair]
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
		default,
		@c12	)
end
GO
