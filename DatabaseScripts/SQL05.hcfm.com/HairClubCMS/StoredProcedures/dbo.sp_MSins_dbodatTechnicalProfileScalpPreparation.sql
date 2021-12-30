/* CreateDate: 05/05/2020 17:42:53.270 , ModifyDate: 05/05/2020 17:42:53.270 */
GO
create procedure [dbo].[sp_MSins_dbodatTechnicalProfileScalpPreparation]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 datetime,
    @c5 nvarchar(25),
    @c6 datetime,
    @c7 nvarchar(25),
    @c8 binary(8)
as
begin
	insert into [dbo].[datTechnicalProfileScalpPreparation] (
		[TechnicalProfileScalpPreparationID],
		[TechnicalProfileID],
		[ScalpPreparationID],
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
		@c8	)
end
GO
