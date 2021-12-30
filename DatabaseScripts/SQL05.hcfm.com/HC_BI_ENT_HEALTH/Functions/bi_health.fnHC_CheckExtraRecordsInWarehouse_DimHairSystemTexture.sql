/* CreateDate: 10/24/2011 14:30:27.137 , ModifyDate: 10/24/2011 16:43:31.217 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimHairSystemTexture] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_DimHairSystemTexture]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimHairSystemTexture]()
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

 	SET @TableName = N'[bi_cms_dds].[DimHairSystemTexture]'

	INSERT INTO @tbl
		SELECT @TableName, HairSystemTextureKey, HairSystemTextureSSID
		FROM [bi_health].[synHC_DDS_DimHairSystemTexture] WITH (NOLOCK)
		WHERE HairSystemTextureSSID NOT
		IN (
				SELECT SRC.HairSystemCurlID
				FROM [bi_health].[synHC_SRC_TBL_CMS_lkpHairSystemTexture] SRC WITH (NOLOCK)
				)
		AND HairSystemTextureKey <> -1







RETURN
END
GO
