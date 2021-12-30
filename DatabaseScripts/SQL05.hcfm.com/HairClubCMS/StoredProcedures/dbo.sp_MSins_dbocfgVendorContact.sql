/* CreateDate: 05/05/2020 17:42:45.407 , ModifyDate: 05/05/2020 17:42:45.407 */
GO
create procedure [sp_MSins_dbocfgVendorContact]
    @c1 int,
    @c2 int,
    @c3 nvarchar(50),
    @c4 nvarchar(50),
    @c5 nvarchar(100),
    @c6 nvarchar(100),
    @c7 nvarchar(25),
    @c8 nvarchar(25),
    @c9 nvarchar(25),
    @c10 bit,
    @c11 datetime,
    @c12 nvarchar(25),
    @c13 datetime,
    @c14 nvarchar(25)
as
begin
	insert into [dbo].[cfgVendorContact] (
		[VendorContactID],
		[VendorID],
		[FirstName],
		[LastName],
		[EmailMain],
		[EmailAlternative],
		[ContactPhone],
		[ContactMobile],
		[ContactFax],
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
		@c13,
		@c14,
		default	)
end
GO
