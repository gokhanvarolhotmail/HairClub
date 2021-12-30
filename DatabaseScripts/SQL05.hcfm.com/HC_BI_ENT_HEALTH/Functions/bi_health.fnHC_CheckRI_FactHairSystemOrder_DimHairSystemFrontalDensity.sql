/* CreateDate: 10/25/2011 10:06:15.427 , ModifyDate: 10/25/2011 10:06:15.427 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactHairSystemOrder_DimHairSystemFrontalDensity] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactHairSystemOrder_DimHairSystemFrontalDensity]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactHairSystemOrder_DimHairSystemFrontalDensity]()
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
  	SET @DimensionName = N'[bi_ent_dds].[DimHairSystemFrontalDensity]'
	SET @FieldName = N'[HairSystemFrontalDensityKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, HairSystemFrontalDensityKey
		FROM [bi_health].[synHC_DDS_FactHairSystemOrder]  WITH (NOLOCK)
		WHERE HairSystemFrontalDensityKey NOT
		IN (
				SELECT SRC.HairSystemFrontalDensityKey
				FROM [bi_health].[synHC_DDS_DimHairSystemFrontalDensity] SRC WITH (NOLOCK)
			)

RETURN
END
GO
