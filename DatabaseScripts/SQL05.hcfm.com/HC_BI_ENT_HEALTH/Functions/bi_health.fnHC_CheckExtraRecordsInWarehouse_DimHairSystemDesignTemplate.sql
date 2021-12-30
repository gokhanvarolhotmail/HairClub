/* CreateDate: 10/24/2011 13:55:07.470 , ModifyDate: 10/24/2011 13:55:07.470 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimHairSystemDesignTemplate] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_DimHairSystemDesignTemplate]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimHairSystemDesignTemplate]()
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

 	SET @TableName = N'[bi_cms_dds].[DimHairSystemDesignTemplate]'

	INSERT INTO @tbl
		SELECT @TableName, HairSystemDesignTemplateKey, HairSystemDesignTemplateSSID
		FROM [bi_health].[synHC_DDS_DimHairSystemDesignTemplate] WITH (NOLOCK)
		WHERE HairSystemDesignTemplateSSID NOT
		IN (
				SELECT SRC.HairSystemDesignTemplateID
				FROM [bi_health].[synHC_SRC_TBL_CMS_lkpHairSystemDesignTemplate] SRC WITH (NOLOCK)
				)
		AND HairSystemDesignTemplateKey <> -1







RETURN
END
GO
