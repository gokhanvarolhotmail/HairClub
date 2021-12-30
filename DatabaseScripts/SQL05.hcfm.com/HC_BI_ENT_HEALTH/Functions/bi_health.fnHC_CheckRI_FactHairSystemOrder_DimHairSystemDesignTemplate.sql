/* CreateDate: 10/25/2011 10:05:35.030 , ModifyDate: 10/25/2011 10:05:35.030 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactHairSystemOrder_DimHairSystemDesignTemplate] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactHairSystemOrder_DimHairSystemDesignTemplate]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactHairSystemOrder_DimHairSystemDesignTemplate]()
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0	10-25-11  KMurdoch      Initial Creation
-----------------------------------------------------------------------

RETURNS @tbl  TABLE (TableName varchar(150)
					, DimensionName varchar(150)
					, FieldName varchar(150)
					, FieldKey bigint
					)  AS
BEGIN



	DECLARE	  @TableName				varchar(150)	-- Name of table
			, @DimensionName			varchar(150)	-- Name of field
			, @FieldName				varchar(150)	-- Name of field

 	SET @TableName = N'[bi_mktg_dds].[FactHairSystemOrder]'
  	SET @DimensionName = N'[bi_ent_dds].[DimHairSystemDesignTemplate]'
	SET @FieldName = N'[HairSystemDesignTemplateKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, HairSystemDesignTemplateKey
		FROM [bi_health].[synHC_DDS_FactHairSystemOrder]  WITH (NOLOCK)
		WHERE HairSystemDesignTemplateKey NOT
		IN (
				SELECT SRC.HairSystemDesignTemplateKey
				FROM [bi_health].[synHC_DDS_DimHairSystemDesignTemplate] SRC WITH (NOLOCK)
			)

RETURN
END
GO
