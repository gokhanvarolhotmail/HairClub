/* CreateDate: 03/17/2022 11:57:06.347 , ModifyDate: 03/17/2022 11:57:06.347 */
GO
create procedure [sp_MSins_bi_cms_ddsDimHairSystemVendorContract]
    @c1 int,
    @c2 nvarchar(50),
    @c3 nvarchar(50),
    @c4 nvarchar(50),
    @c5 nvarchar(10),
    @c6 datetime,
    @c7 datetime,
    @c8 nchar(1),
    @c9 nchar(1),
    @c10 tinyint,
    @c11 datetime,
    @c12 datetime,
    @c13 varchar(200),
    @c14 tinyint,
    @c15 int,
    @c16 int,
    @c17 uniqueidentifier
as
begin
	insert into [bi_cms_dds].[DimHairSystemVendorContract] (
		[HairSystemVendorContractKey],
		[HairSystemVendorContractSSID],
		[HairSystemVendorContractName],
		[HairSystemVendorDescription],
		[HairSystemVendorDescriptionShort],
		[HairSystemVendorContractBeginDate],
		[HairSystemVendorContractEndDate],
		[IsRepair],
		[IsActiveContract],
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
		default,
		@c17	)
end
GO
