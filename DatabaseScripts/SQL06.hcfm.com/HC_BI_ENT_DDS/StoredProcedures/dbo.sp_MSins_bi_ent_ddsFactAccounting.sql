/* CreateDate: 01/08/2021 15:21:54.150 , ModifyDate: 01/08/2021 15:21:54.150 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSins_bi_ent_ddsFactAccounting]
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
	insert into [bi_ent_dds].[FactAccounting] (
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
