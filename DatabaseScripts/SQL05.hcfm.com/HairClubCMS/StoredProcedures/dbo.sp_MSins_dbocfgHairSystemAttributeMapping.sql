/* CreateDate: 05/05/2020 17:42:42.473 , ModifyDate: 05/05/2020 17:42:42.473 */
GO
create procedure [sp_MSins_dbocfgHairSystemAttributeMapping]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 datetime,
    @c5 nvarchar(25),
    @c6 datetime,
    @c7 nvarchar(25),
    @c8 bit
as
begin
	insert into [dbo].[cfgHairSystemAttributeMapping] (
		[HairSystemAttributeMappingID],
		[HairSystemCurlID],
		[HairSystemHairMaterialID],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[IsBaseColorFlag]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		default,
		@c8	)
end
GO
