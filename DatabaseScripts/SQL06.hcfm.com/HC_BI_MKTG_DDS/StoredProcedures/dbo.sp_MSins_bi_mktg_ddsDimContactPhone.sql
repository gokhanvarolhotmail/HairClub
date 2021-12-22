/* CreateDate: 09/03/2021 09:37:05.817 , ModifyDate: 09/03/2021 09:37:05.817 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSins_bi_mktg_ddsDimContactPhone]
    @c1 int,
    @c2 nvarchar(10),
    @c3 nvarchar(10),
    @c4 nvarchar(50),
    @c5 nvarchar(10),
    @c6 nvarchar(50),
    @c7 nvarchar(50),
    @c8 nvarchar(10),
    @c9 nvarchar(50),
    @c10 nchar(1),
    @c11 tinyint,
    @c12 datetime,
    @c13 datetime,
    @c14 varchar(200),
    @c15 tinyint,
    @c16 int,
    @c17 int,
    @c18 nvarchar(18),
    @c19 nvarchar(18),
    @c20 nvarchar(18)
as
begin
	insert into [bi_mktg_dds].[DimContactPhone] (
		[ContactPhoneKey],
		[ContactPhoneSSID],
		[ContactSSID],
		[PhoneTypeCode],
		[CountryCodePrefix],
		[AreaCode],
		[PhoneNumber],
		[Extension],
		[Description],
		[PrimaryFlag],
		[RowIsCurrent],
		[RowStartDate],
		[RowEndDate],
		[RowChangeReason],
		[RowIsInferred],
		[InsertAuditKey],
		[UpdateAuditKey],
		[RowTimeStamp],
		[SFDC_LeadID],
		[SFDC_LeadPhoneID],
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
		default,
		@c18,
		@c19,
		@c20	)
end
GO
