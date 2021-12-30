/* CreateDate: 10/25/2011 09:53:58.043 , ModifyDate: 10/25/2011 09:53:58.043 */
GO
create    FUNCTION [bi_health].[fnHC_CheckRI_FactHairSystemOrder_DimCenter] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactHairSystemOrder_DimCenter]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactHairSystemOrder_DimCenter]()
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
  	SET @DimensionName = N'[bi_ent_dds].[DimCenter]'
	SET @FieldName = N'[CenterKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, CenterKey
		FROM [bi_health].[synHC_DDS_FactHairSystemOrder]  WITH (NOLOCK)
		WHERE CenterKey NOT
		IN (
				SELECT SRC.CenterKey
				FROM [bi_health].[synHC_DDS_DimCenter] SRC WITH (NOLOCK)
			)

RETURN
END
GO
