/* CreateDate: 05/05/2020 17:42:48.637 , ModifyDate: 05/05/2020 17:42:48.637 */
GO
create procedure [sp_MSins_dbodatClientAddress]
    @c1 uniqueidentifier,
    @c2 int,
    @c3 uniqueidentifier,
    @c4 int,
    @c5 nvarchar(50),
    @c6 nvarchar(50),
    @c7 nvarchar(50),
    @c8 nvarchar(50),
    @c9 int,
    @c10 nvarchar(10),
    @c11 datetime,
    @c12 nvarchar(25),
    @c13 datetime,
    @c14 nvarchar(25)
as
begin
	insert into [dbo].[datClientAddress] (
		[ClientAddressGUID],
		[ClientAddressTypeID],
		[ClientGUID],
		[CountryID],
		[Address1],
		[Address2],
		[Address3],
		[City],
		[StateID],
		[PostalCode],
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
