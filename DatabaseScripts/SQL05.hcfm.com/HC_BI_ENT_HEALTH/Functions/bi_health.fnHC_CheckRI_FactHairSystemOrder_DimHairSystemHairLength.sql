/* CreateDate: 10/25/2011 10:14:36.240 , ModifyDate: 10/25/2011 10:14:36.240 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactHairSystemOrder_DimHairSystemHairLength] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactHairSystemOrder_DimHairSystemHairLength]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactHairSystemOrder_DimHairSystemHairLength]()
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
  	SET @DimensionName = N'[bi_ent_dds].[DimHairSystemHairLength]'
	SET @FieldName = N'[HairSystemHairLengthKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, HairSystemHairLengthKey
		FROM [bi_health].[synHC_DDS_FactHairSystemOrder]  WITH (NOLOCK)
		WHERE HairSystemHairLengthKey NOT
		IN (
				SELECT SRC.HairSystemHairLengthKey
				FROM [bi_health].[synHC_DDS_DimHairSystemHairLength] SRC WITH (NOLOCK)
			)

RETURN
END
GO
