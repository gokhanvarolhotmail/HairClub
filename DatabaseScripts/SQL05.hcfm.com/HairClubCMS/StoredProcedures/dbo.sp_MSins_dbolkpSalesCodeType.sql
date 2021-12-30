/* CreateDate: 05/05/2020 17:42:37.957 , ModifyDate: 05/05/2020 17:42:37.957 */
GO
create procedure [sp_MSins_dbolkpSalesCodeType]
    @c1 int,
    @c2 int,
    @c3 nvarchar(100),
    @c4 nvarchar(10),
    @c5 bit,
    @c6 bit,
    @c7 bit,
    @c8 bit,
    @c9 datetime,
    @c10 nvarchar(25),
    @c11 datetime,
    @c12 nvarchar(25)
as
begin
	insert into [dbo].[lkpSalesCodeType] (
		[SalesCodeTypeID],
		[SalesCodeTypeSortOrder],
		[SalesCodeTypeDescription],
		[SalesCodeTypeDescriptionShort],
		[IsInventory],
		[IsSerialized],
		[IsHairSystem],
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
		@c10,
		@c11,
		@c12,
		default	)
end
GO
