/* CreateDate: 10/03/2019 22:32:12.353 , ModifyDate: 10/03/2019 22:32:12.353 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSins_dboFactAccounting]
    @c1 int,
    @c2 int,
    @c3 datetime,
    @c4 int,
    @c5 real,
    @c6 real,
    @c7 real,
    @c8 real,
    @c9 real,
    @c10 real,
    @c11 datetime,
    @c12 int
as
begin
	insert into [dbo].[FactAccounting] (
		[CenterID],
		[DateKey],
		[PartitionDate],
		[AccountID],
		[Budget],
		[Actual],
		[Forecast],
		[Flash],
		[FlashReporting],
		[Drivers],
		[Timestamp],
		[DoctorEntityID]
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
