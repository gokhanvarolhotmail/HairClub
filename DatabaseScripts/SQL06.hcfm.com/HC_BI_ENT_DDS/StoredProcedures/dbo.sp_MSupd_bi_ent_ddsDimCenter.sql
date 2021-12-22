/* CreateDate: 01/08/2021 15:21:53.490 , ModifyDate: 01/08/2021 15:21:53.490 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSupd_bi_ent_ddsDimCenter]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 int = NULL,
		@c4 int = NULL,
		@c5 int = NULL,
		@c6 int = NULL,
		@c7 int = NULL,
		@c8 int = NULL,
		@c9 int = NULL,
		@c10 int = NULL,
		@c11 int = NULL,
		@c12 int = NULL,
		@c13 nvarchar(50) = NULL,
		@c14 nvarchar(50) = NULL,
		@c15 nvarchar(50) = NULL,
		@c16 nvarchar(50) = NULL,
		@c17 nvarchar(50) = NULL,
		@c18 nvarchar(10) = NULL,
		@c19 nvarchar(50) = NULL,
		@c20 nvarchar(10) = NULL,
		@c21 nvarchar(50) = NULL,
		@c22 nvarchar(15) = NULL,
		@c23 nvarchar(15) = NULL,
		@c24 int = NULL,
		@c25 nvarchar(50) = NULL,
		@c26 nvarchar(10) = NULL,
		@c27 nvarchar(15) = NULL,
		@c28 int = NULL,
		@c29 nvarchar(50) = NULL,
		@c30 nvarchar(10) = NULL,
		@c31 nvarchar(15) = NULL,
		@c32 int = NULL,
		@c33 nvarchar(50) = NULL,
		@c34 nvarchar(10) = NULL,
		@c35 nchar(1) = NULL,
		@c36 tinyint = NULL,
		@c37 datetime = NULL,
		@c38 datetime = NULL,
		@c39 varchar(200) = NULL,
		@c40 tinyint = NULL,
		@c41 int = NULL,
		@c42 int = NULL,
		@c43 uniqueidentifier = NULL,
		@c44 int = NULL,
		@c45 int = NULL,
		@c46 bit = NULL,
		@c47 int = NULL,
		@c48 uniqueidentifier = NULL,
		@c49 uniqueidentifier = NULL,
		@c50 uniqueidentifier = NULL,
		@c51 uniqueidentifier = NULL,
		@c52 int = NULL,
		@c53 nvarchar(10) = NULL,
		@c54 nvarchar(10) = NULL,
		@c55 int = NULL,
		@c56 int = NULL,
		@c57 nvarchar(100) = NULL,
		@c58 nvarchar(100) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(8)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [bi_ent_dds].[DimCenter] set
		[CenterSSID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [CenterSSID] end,
		[RegionKey] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [RegionKey] end,
		[RegionSSID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [RegionSSID] end,
		[TimeZoneKey] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [TimeZoneKey] end,
		[TimeZoneSSID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [TimeZoneSSID] end,
		[CenterTypeKey] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CenterTypeKey] end,
		[CenterTypeSSID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [CenterTypeSSID] end,
		[DoctorRegionKey] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [DoctorRegionKey] end,
		[DoctorRegionSSID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [DoctorRegionSSID] end,
		[CenterOwnershipKey] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [CenterOwnershipKey] end,
		[CenterOwnershipSSID] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [CenterOwnershipSSID] end,
		[CenterDescription] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CenterDescription] end,
		[CenterAddress1] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [CenterAddress1] end,
		[CenterAddress2] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [CenterAddress2] end,
		[CenterAddress3] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [CenterAddress3] end,
		[CountryRegionDescription] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [CountryRegionDescription] end,
		[CountryRegionDescriptionShort] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CountryRegionDescriptionShort] end,
		[StateProvinceDescription] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [StateProvinceDescription] end,
		[StateProvinceDescriptionShort] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [StateProvinceDescriptionShort] end,
		[City] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [City] end,
		[PostalCode] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [PostalCode] end,
		[CenterPhone1] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [CenterPhone1] end,
		[Phone1TypeSSID] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [Phone1TypeSSID] end,
		[CenterPhone1TypeDescription] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [CenterPhone1TypeDescription] end,
		[CenterPhone1TypeDescriptionShort] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [CenterPhone1TypeDescriptionShort] end,
		[CenterPhone2] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [CenterPhone2] end,
		[Phone2TypeSSID] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [Phone2TypeSSID] end,
		[CenterPhone2TypeDescription] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [CenterPhone2TypeDescription] end,
		[CenterPhone2TypeDescriptionShort] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [CenterPhone2TypeDescriptionShort] end,
		[CenterPhone3] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [CenterPhone3] end,
		[Phone3TypeSSID] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [Phone3TypeSSID] end,
		[CenterPhone3TypeDescription] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [CenterPhone3TypeDescription] end,
		[CenterPhone3TypeDescriptionShort] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [CenterPhone3TypeDescriptionShort] end,
		[Active] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [Active] end,
		[RowIsCurrent] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [RowIsCurrent] end,
		[RowStartDate] = case substring(@bitmap,5,1) & 16 when 16 then @c37 else [RowStartDate] end,
		[RowEndDate] = case substring(@bitmap,5,1) & 32 when 32 then @c38 else [RowEndDate] end,
		[RowChangeReason] = case substring(@bitmap,5,1) & 64 when 64 then @c39 else [RowChangeReason] end,
		[RowIsInferred] = case substring(@bitmap,5,1) & 128 when 128 then @c40 else [RowIsInferred] end,
		[InsertAuditKey] = case substring(@bitmap,6,1) & 1 when 1 then @c41 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,6,1) & 2 when 2 then @c42 else [UpdateAuditKey] end,
		[msrepl_tran_version] = case substring(@bitmap,6,1) & 4 when 4 then @c43 else [msrepl_tran_version] end,
		[ReportingCenterSSID] = case substring(@bitmap,6,1) & 8 when 8 then @c44 else [ReportingCenterSSID] end,
		[ReportingCenterKey] = case substring(@bitmap,6,1) & 16 when 16 then @c45 else [ReportingCenterKey] end,
		[HasFullAccessFlag] = case substring(@bitmap,6,1) & 32 when 32 then @c46 else [HasFullAccessFlag] end,
		[CenterBusinessTypeID] = case substring(@bitmap,6,1) & 64 when 64 then @c47 else [CenterBusinessTypeID] end,
		[RegionRSMNBConsultantSSID] = case substring(@bitmap,6,1) & 128 when 128 then @c48 else [RegionRSMNBConsultantSSID] end,
		[RegionRSMMembershipAdvisorSSID] = case substring(@bitmap,7,1) & 1 when 1 then @c49 else [RegionRSMMembershipAdvisorSSID] end,
		[RegionRTMTechnicalManagerSSID] = case substring(@bitmap,7,1) & 2 when 2 then @c50 else [RegionRTMTechnicalManagerSSID] end,
		[RegionROMOperationsManagerSSID] = case substring(@bitmap,7,1) & 4 when 4 then @c51 else [RegionROMOperationsManagerSSID] end,
		[CenterManagementAreaSSID] = case substring(@bitmap,7,1) & 8 when 8 then @c52 else [CenterManagementAreaSSID] end,
		[NewBusinessSize] = case substring(@bitmap,7,1) & 16 when 16 then @c53 else [NewBusinessSize] end,
		[RecurringBusinessSize] = case substring(@bitmap,7,1) & 32 when 32 then @c54 else [RecurringBusinessSize] end,
		[CenterNumber] = case substring(@bitmap,7,1) & 64 when 64 then @c55 else [CenterNumber] end,
		[DMACode] = case substring(@bitmap,7,1) & 128 when 128 then @c56 else [DMACode] end,
		[DMADescription] = case substring(@bitmap,8,1) & 1 when 1 then @c57 else [DMADescription] end,
		[DMARegion] = case substring(@bitmap,8,1) & 2 when 2 then @c58 else [DMARegion] end
	where [CenterKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[CenterKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_ent_dds].[DimCenter]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
