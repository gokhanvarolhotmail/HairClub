/* CreateDate: 05/05/2020 17:42:42.240 , ModifyDate: 05/05/2020 17:42:42.240 */
GO
create procedure [sp_MSins_dbocfgHairSystemAllocationFilterDesignTemplateArea]
    @c1 int,
    @c2 int,
    @c3 decimal(10,4),
    @c4 decimal(10,4),
    @c5 datetime,
    @c6 nvarchar(25),
    @c7 datetime,
    @c8 nvarchar(25)
as
begin
	insert into [dbo].[cfgHairSystemAllocationFilterDesignTemplateArea] (
		[HairSystemAllocationFilterDesignTemplateAreaID],
		[VendorID],
		[TemplateAreaMinimum],
		[TemplateAreaMaximum],
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
