/* CreateDate: 05/05/2020 17:42:52.593 , ModifyDate: 05/05/2020 17:42:52.593 */
GO
create procedure [sp_MSins_dbodatTechnicalProfileColor]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 nvarchar(50),
    @c5 int,
    @c6 nvarchar(50),
    @c7 int,
    @c8 nvarchar(50),
    @c9 int,
    @c10 int,
    @c11 int,
    @c12 int,
    @c13 int,
    @c14 datetime,
    @c15 nvarchar(25),
    @c16 datetime,
    @c17 nvarchar(25)
as
begin
	insert into [dbo].[datTechnicalProfileColor] (
		[TechnicalProfileColorID],
		[TechnicalProfileID],
		[ColorBrandID],
		[ColorFormula1],
		[ColorFormulaSize1ID],
		[ColorFormula2],
		[ColorFormulaSize2ID],
		[ColorFormula3],
		[ColorFormulaSize3ID],
		[DeveloperSizeID],
		[DeveloperVolumeID],
		[ColorProcessingTime],
		[ColorProcessingTimeUnitID],
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
		@c15,
		@c16,
		@c17,
		default	)
end
GO
