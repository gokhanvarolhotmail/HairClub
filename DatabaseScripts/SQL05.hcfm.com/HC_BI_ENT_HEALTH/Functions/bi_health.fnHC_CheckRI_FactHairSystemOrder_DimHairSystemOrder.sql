/* CreateDate: 10/25/2011 09:57:25.150 , ModifyDate: 10/25/2011 09:57:47.593 */
GO
CREATE   FUNCTION [bi_health].[fnHC_CheckRI_FactHairSystemOrder_DimHairSystemOrder] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactHairSystemOrder_DimHairSystemOrder]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactHairSystemOrder_DimHairSystemOrder]()
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0	10-25-11  KMurdoch       Initial Creation
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

 	SET @TableName = N'[bi_cms_dds].[FactHairSystemOrder]'
  	SET @DimensionName = N'[bi_cms_dds].[DimHairSystemOrder]'
	SET @FieldName = N'[ClientKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, HairSystemOrderKey
		FROM [bi_health].[synHC_DDS_FactHairSystemOrder]  WITH (NOLOCK)
		WHERE HairSystemOrderKey NOT
		IN (
				SELECT SRC.HairSystemOrderKey
				FROM [bi_health].[synHC_DDS_DimHairSystemOrder] SRC WITH (NOLOCK)
			)

RETURN
END
GO
