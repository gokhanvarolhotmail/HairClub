/* CreateDate: 05/05/2020 17:42:47.387 , ModifyDate: 05/05/2020 17:42:47.387 */
GO
create procedure [sp_MSins_dbodatEndOfDay]
    @c1 uniqueidentifier,
    @c2 datetime,
    @c3 int,
    @c4 int,
    @c5 varchar(25),
    @c6 uniqueidentifier,
    @c7 datetime,
    @c8 bit,
    @c9 text,
    @c10 datetime,
    @c11 nvarchar(25),
    @c12 datetime,
    @c13 nvarchar(25)
as
begin
	insert into [dbo].[datEndOfDay] (
		[EndOfDayGUID],
		[EndOfDayDate],
		[CenterID],
		[DepositID_Temp],
		[DepositNumber],
		[EmployeeGUID],
		[CloseDate],
		[IsExportedToQuickBooks],
		[CloseNote],
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
		default	)
end
GO
