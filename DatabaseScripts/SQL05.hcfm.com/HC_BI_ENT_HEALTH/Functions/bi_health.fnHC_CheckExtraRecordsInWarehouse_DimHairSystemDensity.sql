/* CreateDate: 10/24/2011 13:34:35.460 , ModifyDate: 10/24/2011 13:34:35.460 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimHairSystemDensity] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_DimHairSystemDensity]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimHairSystemDensity]()
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

RETURNS @tbl  TABLE (TableName varchar(150)
					, FieldKey bigint
					, FieldSSID varchar(150)
					)  AS
BEGIN



	DECLARE	 @TableName				varchar(150)	-- Name of table

 	SET @TableName = N'[bi_cms_dds].[DimHairSystemDensity]'

	INSERT INTO @tbl
		SELECT @TableName, HairSystemDensityKey, HairSystemDensitySSID
		FROM [bi_health].[synHC_DDS_DimHairSystemDensity] WITH (NOLOCK)
		WHERE HairSystemDensitySSID NOT
		IN (
				SELECT SRC.HairSystemDensityID
				FROM [bi_health].[synHC_SRC_TBL_CMS_lkpHairSystemDensity] SRC WITH (NOLOCK)
				)
		AND HairSystemDensityKey <> -1







RETURN
END
GO
