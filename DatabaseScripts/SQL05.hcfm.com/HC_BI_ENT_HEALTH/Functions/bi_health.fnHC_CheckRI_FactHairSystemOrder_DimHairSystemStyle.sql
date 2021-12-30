/* CreateDate: 10/25/2011 10:19:14.650 , ModifyDate: 10/25/2011 10:19:14.650 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactHairSystemOrder_DimHairSystemStyle] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactHairSystemOrder_DimHairSystemStyle]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactHairSystemOrder_DimHairSystemStyle]()
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
  	SET @DimensionName = N'[bi_ent_dds].[DimHairSystemStyle]'
	SET @FieldName = N'[HairSystemStyleKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, HairSystemStyleKey
		FROM [bi_health].[synHC_DDS_FactHairSystemOrder]  WITH (NOLOCK)
		WHERE HairSystemStyleKey NOT
		IN (
				SELECT SRC.HairSystemStyleKey
				FROM [bi_health].[synHC_DDS_DimHairSystemStyle] SRC WITH (NOLOCK)
			)

RETURN
END
GO
