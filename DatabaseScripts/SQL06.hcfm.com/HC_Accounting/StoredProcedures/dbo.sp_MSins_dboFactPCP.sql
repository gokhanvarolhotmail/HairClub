/* CreateDate: 10/03/2019 22:32:12.407 , ModifyDate: 10/03/2019 22:32:12.407 */
GO
create procedure [sp_MSins_dboFactPCP]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 int,
    @c5 int,
    @c6 int,
    @c7 datetime,
    @c8 int,
    @c9 int,
    @c10 int,
    @c11 int,
    @c12 int
as
begin
	insert into [dbo].[FactPCP] (
		[CenterID],
		[GenderID],
		[MembershipID],
		[DateKey],
		[PCP],
		[EXTREME],
		[Timestamp],
		[CorporateAdjustmentID],
		[ID],
		[CenterKey],
		[GenderKey],
		[XTR]
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
