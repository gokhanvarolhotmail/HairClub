/* CreateDate: 05/05/2020 17:42:55.380 , ModifyDate: 05/05/2020 17:42:55.380 */
GO
create procedure [sp_MSins_dbolkpWaitingListPriority]
    @c1 int,
    @c2 int,
    @c3 nvarchar(100),
    @c4 nvarchar(10),
    @c5 bit,
    @c6 datetime,
    @c7 nchar(10),
    @c8 datetime,
    @c9 nchar(10)
as
begin
	insert into [dbo].[lkpWaitingListPriority] (
		[WaitingListPriorityID],
		[WaitingListPrioritySortOrder],
		[WaitingListPriorityDescription],
		[WaitingListPriorityDescriptionShort],
		[IsActiveFlag],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9	)
end
GO
