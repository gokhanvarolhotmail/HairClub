/* CreateDate: 10/24/2011 13:58:20.087 , ModifyDate: 10/24/2011 13:58:20.087 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimHairSystemFrontalDensity] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_DimHairSystemFrontalDensity]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimHairSystemFrontalDensity]()
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

 	SET @TableName = N'[bi_cms_dds].[DimHairSystemFrontalDensity]'

	INSERT INTO @tbl
		SELECT @TableName, HairSystemFrontalDensityKey, HairSystemFrontalDensitySSID
		FROM [bi_health].[synHC_DDS_DimHairSystemFrontalDensity] WITH (NOLOCK)
		WHERE HairSystemFrontalDensitySSID NOT
		IN (
				SELECT SRC.HairSystemFrontalDensityID
				FROM [bi_health].[synHC_SRC_TBL_CMS_lkpHairSystemFrontalDensity] SRC WITH (NOLOCK)
				)
		AND HairSystemFrontalDensityKey <> -1







RETURN
END
GO
