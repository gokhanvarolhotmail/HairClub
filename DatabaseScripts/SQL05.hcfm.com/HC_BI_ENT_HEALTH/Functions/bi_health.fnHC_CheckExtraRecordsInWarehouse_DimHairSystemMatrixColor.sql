/* CreateDate: 10/24/2011 14:14:33.623 , ModifyDate: 10/24/2011 14:16:50.457 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimHairSystemMatrixColor] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_DimHairSystemMatrixColor]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimHairSystemMatrixColor]()
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

 	SET @TableName = N'[bi_cms_dds].[DimHairSystemMatrixColor]'

	INSERT INTO @tbl
		SELECT @TableName, HairSystemMatrixColorkey, HairSystemMatrixColorSSID
		FROM [bi_health].[synHC_DDS_DimHairSystemMatrixColor] WITH (NOLOCK)
		WHERE HairSystemMatrixColorSSID NOT
		IN (
				SELECT SRC.HairSystemMatrixColorID
				FROM [bi_health].[synHC_SRC_TBL_CMS_lkpHairSystemMatrixColor] SRC WITH (NOLOCK)
				)
		AND HairSystemMatrixColorkey <> -1







RETURN
END
GO
