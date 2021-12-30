/* CreateDate: 10/24/2011 14:02:59.553 , ModifyDate: 10/24/2011 14:02:59.553 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimHairSystemHairColor] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_DimHairSystemHairColor]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimHairSystemHairColor]()
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

 	SET @TableName = N'[bi_cms_dds].[DimHairSystemHairColor]'

	INSERT INTO @tbl
		SELECT @TableName, HairSystemHairColorKey, HairSystemHairColorSSID
		FROM [bi_health].[synHC_DDS_DimHairSystemHairColor] WITH (NOLOCK)
		WHERE HairSystemHairColorSSID NOT
		IN (
				SELECT SRC.HairSystemHairColorID
				FROM [bi_health].[synHC_SRC_TBL_CMS_lkpHairSystemHairColor] SRC WITH (NOLOCK)
				)
		AND HairSystemHairColorKey <> -1







RETURN
END
GO
