/* CreateDate: 05/05/2020 17:42:48.687 , ModifyDate: 05/05/2020 17:42:48.687 */
GO
create procedure [dbo].[sp_MSins_dbodatClientCreditCard]
    @c1 int,
    @c2 uniqueidentifier,
    @c3 int,
    @c4 nvarchar(4),
    @c5 date,
    @c6 nvarchar(50),
    @c7 nvarchar(50),
    @c8 bit,
    @c9 datetime,
    @c10 nvarchar(25),
    @c11 datetime,
    @c12 nvarchar(25),
    @c13 binary(8)
as
begin
	insert into [dbo].[datClientCreditCard] (
		[ClientCreditCardID],
		[ClientGUID],
		[CreditCardTypeID],
		[AccountNumberLast4Digits],
		[AccountExpiration],
		[CardHolderName],
		[Token],
		[IsTokenValidFlag],
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
		@c13	)
end
GO
