/* CreateDate: 05/03/2010 12:08:53.453 , ModifyDate: 09/24/2014 11:41:44.703 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [bi_ent_dds].[EmptyAllTables]
AS

-----------------------------------------------------------------------
--
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

BEGIN

	DELETE FROM bi_ent_dds.DimRevenueGroup WHERE RevenueGroupKey > 0
	DELETE FROM bi_ent_dds.DimCenter WHERE CenterKey > 0
	DELETE FROM bi_ent_dds.DimCenterType WHERE CenterTypeKey > 0
	DELETE FROM bi_ent_dds.DimCenterOwnership WHERE CenterOwnershipKey > 0
	DELETE FROM bi_ent_dds.DimBusinessSegment WHERE BusinessSegmentKey > 0
	DELETE FROM bi_ent_dds.DimBusinessUnit WHERE BusinessUnitKey > 0
	DELETE FROM bi_ent_dds.DimBusinessUnitBrand WHERE BusinessUnitBrandKey > 0
	DELETE FROM bi_ent_dds.DimTimeZone WHERE TimeZoneKey > 0
	DELETE FROM bi_ent_dds.DimRegion WHERE RegionKey > 0
	DELETE FROM bi_ent_dds.DimGeography WHERE GeographyKey > 0
	DELETE FROM bi_ent_dds.DimDoctorRegion WHERE DoctorRegionKey > 0


	DBCC CHECKIDENT ("bi_ent_dds.DimBusinessUnitBrand", RESEED, 1)
	DBCC CHECKIDENT ("bi_ent_dds.DimBusinessSegment", RESEED, 1)
	DBCC CHECKIDENT ("bi_ent_dds.DimBusinessUnit", RESEED, 1)
	DBCC CHECKIDENT ("bi_ent_dds.DimCenterOwnership", RESEED, 1)
	DBCC CHECKIDENT ("bi_ent_dds.DimCenterType", RESEED, 1)
	DBCC CHECKIDENT ("bi_ent_dds.DimCenter", RESEED, 1)
	DBCC CHECKIDENT ("bi_ent_dds.DimDoctorRegion", RESEED, 1)
	DBCC CHECKIDENT ("bi_ent_dds.DimGeography", RESEED, 1)
	DBCC CHECKIDENT ("bi_ent_dds.DimRegion", RESEED, 1)
	DBCC CHECKIDENT ("bi_ent_dds.DimRevenueGroup", RESEED, 1)
	DBCC CHECKIDENT ("bi_ent_dds.DimTimeZone", RESEED, 1)


END
GO
