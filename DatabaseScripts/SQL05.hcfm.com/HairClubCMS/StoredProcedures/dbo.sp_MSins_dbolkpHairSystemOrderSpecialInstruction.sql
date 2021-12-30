/* CreateDate: 05/05/2020 17:42:46.180 , ModifyDate: 05/05/2020 17:42:46.180 */
GO
create procedure [sp_MSins_dbolkpHairSystemOrderSpecialInstruction]
    @c1 int,
    @c2 int,
    @c3 nvarchar(100),
    @c4 nvarchar(10),
    @c5 bit,
    @c6 bit,
    @c7 bit,
    @c8 datetime,
    @c9 nvarchar(25),
    @c10 datetime,
    @c11 nvarchar(25)
as
begin
	insert into [dbo].[lkpHairSystemOrderSpecialInstruction] (
		[HairSystemOrderSpecialInstructionID],
		[HairSystemOrderSpecialInstructionSortOrder],
		[HairSystemOrderSpecialInstructionDescription],
		[HairSystemOrderSpecialInstructionDescriptionShort],
		[IsShippingFlag],
		[IsReceivingFlag],
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
		@c10,
		@c11,
		default	)
end
GO
