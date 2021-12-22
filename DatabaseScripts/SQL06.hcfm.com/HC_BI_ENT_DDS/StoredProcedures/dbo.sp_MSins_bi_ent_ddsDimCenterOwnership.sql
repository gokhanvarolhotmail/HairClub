/* CreateDate: 01/08/2021 15:21:53.557 , ModifyDate: 01/08/2021 15:21:53.557 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSins_bi_ent_ddsDimCenterOwnership]
    @c1 int,
    @c2 int,
    @c3 nvarchar(50),
    @c4 nvarchar(10),
    @c5 nvarchar(50),
    @c6 nvarchar(50),
    @c7 nvarchar(50),
    @c8 nvarchar(50),
    @c9 nvarchar(50),
    @c10 nvarchar(50),
    @c11 nvarchar(10),
    @c12 nvarchar(50),
    @c13 nvarchar(10),
    @c14 nvarchar(50),
    @c15 nvarchar(15),
    @c16 tinyint,
    @c17 datetime,
    @c18 datetime,
    @c19 varchar(200),
    @c20 tinyint,
    @c21 int,
    @c22 int,
    @c23 uniqueidentifier
as
begin
	insert into [bi_ent_dds].[DimCenterOwnership] (
		[CenterOwnershipKey],
		[CenterOwnershipSSID],
		[CenterOwnershipDescription],
		[CenterOwnershipDescriptionShort],
		[OwnerLastName],
		[OwnerFirstName],
		[CorporateName],
		[CenterAddress1],
		[CenterAddress2],
		[CountryRegionDescription],
		[CountryRegionDescriptionShort],
		[StateProvinceDescription],
		[StateProvinceDescriptionShort],
		[City],
		[PostalCode],
		[RowIsCurrent],
		[RowStartDate],
		[RowEndDate],
		[RowChangeReason],
		[RowIsInferred],
		[InsertAuditKey],
		[UpdateAuditKey],
		[RowTimeStamp],
		[msrepl_tran_version]
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
		default,
		@c23	)
end
GO
