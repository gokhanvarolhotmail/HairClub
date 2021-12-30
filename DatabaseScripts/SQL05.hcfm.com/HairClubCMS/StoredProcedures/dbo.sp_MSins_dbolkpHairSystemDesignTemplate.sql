/* CreateDate: 05/05/2020 17:42:42.120 , ModifyDate: 05/05/2020 17:42:42.120 */
GO
create procedure [sp_MSins_dbolkpHairSystemDesignTemplate]
    @c1 int,
    @c2 int,
    @c3 nvarchar(100),
    @c4 nvarchar(10),
    @c5 bit,
    @c6 bit,
    @c7 decimal(10,4),
    @c8 decimal(10,4),
    @c9 decimal(10,4),
    @c10 bit,
    @c11 datetime,
    @c12 nvarchar(25),
    @c13 datetime,
    @c14 nvarchar(25)
as
begin
	insert into [dbo].[lkpHairSystemDesignTemplate] (
		[HairSystemDesignTemplateID],
		[HairSystemDesignTemplateSortOrder],
		[HairSystemDesignTemplateDescription],
		[HairSystemDesignTemplateDescriptionShort],
		[IsManualTemplateFlag],
		[IsMeasurementFlag],
		[HairSystemWidth],
		[HairSystemLength],
		[AdjustmentRange],
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
		@c12,
		@c13,
		@c14,
		default	)
end
GO
