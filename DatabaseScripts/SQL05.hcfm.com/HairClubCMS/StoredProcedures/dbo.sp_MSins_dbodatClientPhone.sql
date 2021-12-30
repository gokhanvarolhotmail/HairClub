/* CreateDate: 05/05/2020 17:42:49.360 , ModifyDate: 05/05/2020 17:42:49.360 */
GO
create procedure [dbo].[sp_MSins_dbodatClientPhone]
    @c1 int,
    @c2 uniqueidentifier,
    @c3 int,
    @c4 nvarchar(15),
    @c5 bit,
    @c6 bit,
    @c7 bit,
    @c8 bit,
    @c9 int,
    @c10 datetime,
    @c11 nvarchar(25),
    @c12 datetime,
    @c13 nvarchar(25),
    @c14 binary(8)
as
begin
	insert into [dbo].[datClientPhone] (
		[ClientPhoneID],
		[ClientGUID],
		[PhoneTypeID],
		[PhoneNumber],
		[CanConfirmAppointmentByCall],
		[CanConfirmAppointmentByText],
		[CanContactForPromotionsByCall],
		[CanContactForPromotionsByText],
		[ClientPhoneSortOrder],
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
		@c14	)
end
GO
