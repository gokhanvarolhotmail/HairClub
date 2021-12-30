/* CreateDate: 05/05/2020 17:42:42.523 , ModifyDate: 05/05/2020 17:42:42.523 */
GO
create procedure [sp_MSins_dbocfgHairSystemCenterContract]
    @c1 int,
    @c2 int,
    @c3 datetime,
    @c4 datetime,
    @c5 datetime,
    @c6 bit,
    @c7 datetime,
    @c8 nvarchar(25),
    @c9 datetime,
    @c10 nvarchar(25),
    @c11 bit,
    @c12 bit
as
begin
	insert into [dbo].[cfgHairSystemCenterContract] (
		[HairSystemCenterContractID],
		[CenterID],
		[ContractEntryDate],
		[ContractBeginDate],
		[ContractEndDate],
		[IsActiveContract],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[IsRepair],
		[IsPriorityContract]
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
		@c12	)
end
GO
