/* CreateDate: 05/05/2020 17:42:52.963 , ModifyDate: 05/05/2020 17:42:52.963 */
GO
create procedure [sp_MSins_dbolkpRelaxerBrand]
    @c1 int,
    @c2 int,
    @c3 nvarchar(100),
    @c4 nvarchar(10),
    @c5 bit,
    @c6 datetime,
    @c7 nvarchar(25),
    @c8 datetime,
    @c9 nvarchar(25)
as
begin
	insert into [dbo].[lkpRelaxerBrand] (
		[RelaxerBrandID],
		[RelaxerBrandSortOrder],
		[RelaxerBrandDescription],
		[RelaxerBrandDescriptionShort],
		[IsActiveFlag],
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
		@c9,
		default	)
end
GO
