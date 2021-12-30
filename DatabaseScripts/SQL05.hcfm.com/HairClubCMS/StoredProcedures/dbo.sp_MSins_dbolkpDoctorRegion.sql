/* CreateDate: 05/05/2020 17:42:39.260 , ModifyDate: 05/05/2020 17:42:39.260 */
GO
create procedure [sp_MSins_dbolkpDoctorRegion]
    @c1 int,
    @c2 int,
    @c3 nvarchar(100),
    @c4 nvarchar(10),
    @c5 bit,
    @c6 datetime,
    @c7 nvarchar(25),
    @c8 datetime,
    @c9 nvarchar(25),
    @c10 int
as
begin
	insert into [dbo].[lkpDoctorRegion] (
		[DoctorRegionID],
		[DoctorRegionSortOrder],
		[DoctorRegionDescription],
		[DoctorRegionDescriptionShort],
		[IsActiveFlag],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[ExternalSchedulerResourceID]
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
		@c10	)
end
GO
