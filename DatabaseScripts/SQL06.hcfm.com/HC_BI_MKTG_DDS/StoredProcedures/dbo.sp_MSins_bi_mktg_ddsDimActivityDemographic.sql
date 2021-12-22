/* CreateDate: 09/03/2021 09:37:05.237 , ModifyDate: 09/03/2021 09:37:05.237 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSins_bi_mktg_ddsDimActivityDemographic]
    @c1 int,
    @c2 varchar(10),
    @c3 varchar(10),
    @c4 varchar(10),
    @c5 char(1),
    @c6 varchar(50),
    @c7 varchar(10),
    @c8 varchar(50),
    @c9 varchar(10),
    @c10 varchar(50),
    @c11 varchar(10),
    @c12 varchar(50),
    @c13 date,
    @c14 int,
    @c15 varchar(10),
    @c16 varchar(50),
    @c17 varchar(50),
    @c18 varchar(50),
    @c19 varchar(50),
    @c20 varchar(50),
    @c21 varchar(50),
    @c22 money,
    @c23 varchar(100),
    @c24 varchar(200),
    @c25 date,
    @c26 tinyint,
    @c27 datetime,
    @c28 datetime,
    @c29 varchar(200),
    @c30 tinyint,
    @c31 int,
    @c32 int,
    @c33 nvarchar(10),
    @c34 nvarchar(18),
    @c35 nvarchar(18),
    @c36 nvarchar(18)
as
begin
	insert into [bi_mktg_dds].[DimActivityDemographic] (
		[ActivityDemographicKey],
		[ActivityDemographicSSID],
		[ActivitySSID],
		[ContactSSID],
		[GenderSSID],
		[GenderDescription],
		[EthnicitySSID],
		[EthnicityDescription],
		[OccupationSSID],
		[OccupationDescription],
		[MaritalStatusSSID],
		[MaritalStatusDescription],
		[Birthday],
		[Age],
		[AgeRangeSSID],
		[AgeRangeDescription],
		[HairLossTypeSSID],
		[HairLossTypeDescription],
		[NorwoodSSID],
		[LudwigSSID],
		[Performer],
		[PriceQuoted],
		[SolutionOffered],
		[NoSaleReason],
		[DateSaved],
		[RowIsCurrent],
		[RowStartDate],
		[RowEndDate],
		[RowChangeReason],
		[RowIsInferred],
		[InsertAuditKey],
		[UpdateAuditKey],
		[RowTimeStamp],
		[DiscStyleSSID],
		[SFDC_TaskID],
		[SFDC_LeadID],
		[SFDC_PersonAccountID]
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
		@c18,
		@c19,
		@c20,
		@c21,
		@c22,
		@c23,
		@c24,
		@c25,
		@c26,
		@c27,
		@c28,
		@c29,
		@c30,
		@c31,
		@c32,
		default,
		@c33,
		@c34,
		@c35,
		@c36	)
end
GO
