/* CreateDate: 05/05/2020 17:42:46.960 , ModifyDate: 05/05/2020 17:42:46.960 */
GO
create procedure [sp_MSins_dbodatCenterDeclineBatch]
    @c1 uniqueidentifier,
    @c2 uniqueidentifier,
    @c3 datetime,
    @c4 uniqueidentifier,
    @c5 bit,
    @c6 datetime,
    @c7 nvarchar(25),
    @c8 datetime,
    @c9 nvarchar(25),
    @c10 int,
    @c11 int
as
begin
	insert into [dbo].[datCenterDeclineBatch] (
		[CenterDeclineBatchGUID],
		[CenterFeeBatchGUID],
		[RunDate],
		[RunByEmployeeGUID],
		[IsCompletedFlag],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[IsExported],
		[CenterDeclineBatchStatusID]
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
		default,
		@c10,
		@c11	)
end
GO
