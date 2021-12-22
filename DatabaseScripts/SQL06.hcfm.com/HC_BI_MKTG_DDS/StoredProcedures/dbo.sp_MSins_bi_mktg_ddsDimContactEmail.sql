/* CreateDate: 09/03/2021 09:37:05.737 , ModifyDate: 09/03/2021 09:37:05.737 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSins_bi_mktg_ddsDimContactEmail]
    @c1 int,
    @c2 nvarchar(10),
    @c3 nvarchar(10),
    @c4 nvarchar(10),
    @c5 nvarchar(100),
    @c6 nvarchar(50),
    @c7 nchar(1),
    @c8 tinyint,
    @c9 datetime,
    @c10 datetime,
    @c11 varchar(200),
    @c12 tinyint,
    @c13 int,
    @c14 int,
    @c15 nvarchar(18),
    @c16 nvarchar(18),
    @c17 varbinary(128),
    @c18 nvarchar(18)
as
begin
	insert into [bi_mktg_dds].[DimContactEmail] (
		[ContactEmailKey],
		[ContactEmailSSID],
		[ContactSSID],
		[EmailTypeCode],
		[Email],
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
		[SFDC_LeadEmailID],
		[ContactEmailHashed],
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
		default,
		@c15,
		@c16,
		@c17,
		@c18	)
end
GO
