/* CreateDate: 05/05/2020 17:42:38.490 , ModifyDate: 05/05/2020 17:42:38.490 */
GO
create procedure [dbo].[sp_MSins_dbolkpAddOnType]
    @c1 int,
    @c2 int,
    @c3 nvarchar(100),
    @c4 nvarchar(10),
    @c5 bit,
    @c6 datetime,
    @c7 nvarchar(25),
    @c8 datetime,
    @c9 nvarchar(25),
    @c10 binary(8),
    @c11 nvarchar(100),
    @c12 bit
as
begin
	insert into [dbo].[lkpAddOnType] (
		[AddOnTypeID],
		[AddOnTypeSortOrder],
		[AddOnTypeDescription],
		[AddOnTypeDescriptionShort],
		[IsActiveFlag],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[DescriptionResourceKey],
		[IsMonthlyAddOnType]
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
		@c12	)
end
GO
