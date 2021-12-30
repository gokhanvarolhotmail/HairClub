/* CreateDate: 10/24/2011 14:27:57.740 , ModifyDate: 10/24/2011 14:27:57.740 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimHairSystemStyle] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_DimHairSystemStyle]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimHairSystemStyle]()
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

 	SET @TableName = N'[bi_cms_dds].[DimHairSystemStyle]'

	INSERT INTO @tbl
		SELECT @TableName, HairSystemStyleKey, HairSystemStyleSSID
		FROM [bi_health].[synHC_DDS_DimHairSystemStyle] WITH (NOLOCK)
		WHERE HairSystemStyleSSID NOT
		IN (
				SELECT SRC.HairSystemStyleID
				FROM [bi_health].[synHC_SRC_TBL_CMS_lkpHairSystemStyle] SRC WITH (NOLOCK)
				)
		AND HairSystemStyleKey <> -1







RETURN
END
GO
