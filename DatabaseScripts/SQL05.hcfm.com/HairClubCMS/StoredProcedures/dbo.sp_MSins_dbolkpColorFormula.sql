/* CreateDate: 05/05/2020 17:42:53.650 , ModifyDate: 05/05/2020 17:42:53.650 */
GO
create procedure [sp_MSins_dbolkpColorFormula]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 nvarchar(100),
    @c5 nvarchar(10),
    @c6 bit,
    @c7 datetime,
    @c8 nvarchar(25),
    @c9 datetime,
    @c10 nvarchar(25)
as
begin
	insert into [dbo].[lkpColorFormula] (
		[ColorFormulaID],
		[ColorBrandID],
		[ColorFormulaSortOrder],
		[ColorFormulaDescription],
		[ColorFormulaDescriptionShort],
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
		default	)
end
GO
