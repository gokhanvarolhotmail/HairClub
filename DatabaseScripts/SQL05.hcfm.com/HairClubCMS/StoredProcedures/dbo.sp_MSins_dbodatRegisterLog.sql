/* CreateDate: 05/05/2020 17:42:51.790 , ModifyDate: 05/05/2020 17:42:51.790 */
GO
create procedure [sp_MSins_dbodatRegisterLog]
    @c1 uniqueidentifier,
    @c2 int,
    @c3 uniqueidentifier,
    @c4 uniqueidentifier,
    @c5 money,
    @c6 datetime,
    @c7 nvarchar(25),
    @c8 datetime,
    @c9 nvarchar(25)
as
begin
	insert into [dbo].[datRegisterLog] (
		[RegisterLogGUID],
		[RegisterID],
		[EndOfDayGUID],
		[EmployeeGUID],
		[OpeningBalance],
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
