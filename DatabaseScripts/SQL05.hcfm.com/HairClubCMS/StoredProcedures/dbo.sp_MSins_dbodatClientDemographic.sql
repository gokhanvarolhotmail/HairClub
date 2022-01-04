/* CreateDate: 05/05/2020 17:42:49.020 , ModifyDate: 05/05/2020 17:42:49.020 */
GO
create procedure [sp_MSins_dbodatClientDemographic]
    @c1 int,
    @c2 uniqueidentifier,
    @c3 int,
    @c4 int,
    @c5 int,
    @c6 int,
    @c7 int,
    @c8 int,
    @c9 int,
    @c10 int,
    @c11 money,
    @c12 datetime,
    @c13 uniqueidentifier,
    @c14 datetime,
    @c15 nvarchar(25),
    @c16 datetime,
    @c17 nvarchar(25),
    @c18 bit
as
begin
	insert into [dbo].[datClientDemographic] (
		[ClientDemographicID],
		[ClientGUID],
		[ClientIdentifier],
		[EthnicityID],
		[OccupationID],
		[MaritalStatusID],
		[LudwigScaleID],
		[NorwoodScaleID],
		[DISCStyleID],
		[SolutionOfferedID],
		[PriceQuoted],
		[LastConsultationDate],
		[LastConsultantGUID],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[IsPotentialModel]
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
		default,
		@c18	)
end
GO