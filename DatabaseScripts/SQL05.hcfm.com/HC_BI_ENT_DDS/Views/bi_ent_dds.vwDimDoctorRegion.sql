/* CreateDate: 05/03/2010 12:08:49.223 , ModifyDate: 10/03/2019 21:37:25.030 */
GO
CREATE VIEW [bi_ent_dds].[vwDimDoctorRegion]
AS
-------------------------------------------------------------------------
-- [vwDimDoctorRegion] is used to retrieve a
-- list of Doctor Regions
--
--   SELECT * FROM [bi_ent_dds].[vwDimDoctorRegion]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/15/2009  RLifke       Initial Creation
-------------------------------------------------------------------------

	SELECT    [DoctorRegionKey]
			, [DoctorRegionSSID]
			, [DoctorRegionDescription]
			, [DoctorRegionDescriptionShort]
			, [Active]
			, [RowIsCurrent]
			, [RowStartDate]
			, [RowEndDate]
	FROM [bi_ent_dds].[DimDoctorRegion]
GO
