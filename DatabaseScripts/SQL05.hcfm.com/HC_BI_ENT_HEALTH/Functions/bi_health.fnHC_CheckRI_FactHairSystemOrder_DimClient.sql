/* CreateDate: 10/25/2011 09:54:46.123 , ModifyDate: 10/25/2011 10:16:27.413 */
GO
CREATE   FUNCTION [bi_health].[fnHC_CheckRI_FactHairSystemOrder_DimClient] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactHairSystemOrder_DimClient]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactHairSystemOrder_DimClient]()
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
  	SET @DimensionName = N'[bi_cms_dds].[DimClient]'
	SET @FieldName = N'[ClientKey]'


	INSERT INTO @tbl
		SELECT
			@TableName
		,	@DimensionName
		,	@FieldName
		,	ClientKey
		FROM [bi_health].[synHC_DDS_FactHairSystemOrder]  WITH (NOLOCK)
		GROUP BY
			ClientKey
		HAVING ClientKey NOT
		IN (
				SELECT SRC.ClientKey
				FROM [bi_health].[synHC_DDS_DimClient] SRC WITH (NOLOCK)
			)
RETURN
END
GO
