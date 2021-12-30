/* CreateDate: 05/05/2020 17:42:45.153 , ModifyDate: 05/05/2020 17:42:45.153 */
GO
create procedure [sp_MSins_dbocfgSurgeryGraftPricing]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 int,
    @c5 int,
    @c6 money,
    @c7 datetime,
    @c8 bit,
    @c9 nvarchar(25),
    @c10 datetime,
    @c11 nvarchar(25)
as
begin
	insert into [dbo].[cfgSurgeryGraftPricing] (
		[SurgeryGraftPricingID],
		[SurgeryGraftPricingSortOrder],
		[CenterID],
		[GraftsMinimum],
		[GraftsMaximum],
		[CostPerGraft],
		[CreateDate],
		[IsActive],
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
		@c9,
		@c10,
		@c11,
		default	)
end
GO
