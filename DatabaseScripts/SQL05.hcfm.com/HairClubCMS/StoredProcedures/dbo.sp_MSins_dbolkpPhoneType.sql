/* CreateDate: 05/05/2020 17:42:39.750 , ModifyDate: 05/05/2020 17:42:39.750 */
GO
create procedure [sp_MSins_dbolkpPhoneType]
    @c1 int,
    @c2 int,
    @c3 nvarchar(100),
    @c4 nvarchar(10),
    @c5 bit,
    @c6 datetime,
    @c7 nvarchar(25),
    @c8 datetime,
    @c9 nvarchar(25),
    @c10 bit,
    @c11 int,
    @c12 nvarchar(100)
as
begin
	insert into [dbo].[lkpPhoneType] (
		[PhoneTypeID],
		[PhoneTypeSortOrder],
		[PhoneTypeDescription],
		[PhoneTypeDescriptionShort],
		[IsActiveFlag],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[CanTextMessageFlag],
		[PhoneSegmentId],
		[DescriptionResourceKey]
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
		@c11,
		@c12	)
end
GO
