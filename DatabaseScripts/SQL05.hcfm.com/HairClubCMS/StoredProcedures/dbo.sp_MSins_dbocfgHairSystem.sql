/* CreateDate: 05/05/2020 17:42:37.583 , ModifyDate: 05/05/2020 17:42:37.583 */
GO
create procedure [sp_MSins_dbocfgHairSystem]
    @c1 int,
    @c2 int,
    @c3 nvarchar(100),
    @c4 nvarchar(10),
    @c5 int,
    @c6 bit,
    @c7 datetime,
    @c8 nvarchar(25),
    @c9 datetime,
    @c10 nvarchar(25),
    @c11 bit,
    @c12 bit,
    @c13 int,
    @c14 bit,
    @c15 bit
as
begin
	insert into [dbo].[cfgHairSystem] (
		[HairSystemID],
		[HairSystemSortOrder],
		[HairSystemDescription],
		[HairSystemDescriptionShort],
		[HairSystemTypeID],
		[IsActiveFlag],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[UseHairSystemFrontalLaceLengthFlag],
		[AllowFashionHairlineHighlightsFlag],
		[HairSystemGroupID],
		[AllowSignatureHairlineFlag],
		[AllowCuticleIntactHairFlag]
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
		@c15	)
end
GO
