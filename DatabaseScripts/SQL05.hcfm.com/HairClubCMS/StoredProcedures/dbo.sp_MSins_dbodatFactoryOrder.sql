/* CreateDate: 05/05/2020 17:42:47.337 , ModifyDate: 05/05/2020 17:42:47.337 */
GO
create procedure [sp_MSins_dbodatFactoryOrder]
    @c1 uniqueidentifier,
    @c2 uniqueidentifier,
    @c3 int,
    @c4 int,
    @c5 uniqueidentifier,
    @c6 datetime,
    @c7 bit,
    @c8 datetime,
    @c9 nvarchar(25),
    @c10 datetime,
    @c11 nvarchar(25)
as
begin
	insert into [dbo].[datFactoryOrder] (
		[FactoryOrderGUID],
		[ClientGUID],
		[FactoryOrderStatusID],
		[HairSystemTypeID],
		[UsedByClientGUID],
		[UsedDate],
		[IsHS4Flag],
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
		default	)
end
GO
