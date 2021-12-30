/* CreateDate: 05/08/2010 14:19:01.993 , ModifyDate: 05/08/2010 15:01:03.823 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactSales_DimCenter] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactSales_DimCenter]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactSales_DimCenter]()
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
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

 	SET @TableName = N'[bi_cms_dds].[FactSales]'
  	SET @DimensionName = N'[bi_ent_dds].[DimCenter]'
	SET @FieldName = N'[CenterKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, CenterKey
		FROM [bi_health].[synHC_DDS_FactSales]  WITH (NOLOCK)
		WHERE CenterKey NOT
		IN (
				SELECT SRC.CenterKey
				FROM [bi_health].[synHC_DDS_DimCenter] SRC WITH (NOLOCK)
			)

RETURN
END
GO
