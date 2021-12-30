/* CreateDate: 05/05/2020 17:42:46.807 , ModifyDate: 05/05/2020 17:42:46.807 */
GO
create procedure [sp_MSins_dbolkpCenterFeeBatchStatus]
    @c1 int,
    @c2 int,
    @c3 nvarchar(100),
    @c4 nvarchar(10),
    @c5 bit,
    @c6 datetime,
    @c7 nvarchar(25),
    @c8 datetime,
    @c9 nvarchar(25)
as
begin
	insert into [dbo].[lkpCenterFeeBatchStatus] (
		[CenterFeeBatchStatusID],
		[CenterFeeBatchStatusSortOrder],
		[CenterFeeBatchStatusDescription],
		[CenterFeeBatchStatusDescriptionShort],
		[IsActiveFlag],
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
