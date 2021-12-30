/* CreateDate: 05/08/2010 14:52:40.663 , ModifyDate: 05/08/2010 14:52:40.663 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactSales_DimClient] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactSales_DimClient]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactSales_DimClient]()
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
  	SET @DimensionName = N'[bi_cms_dds].[DimClient]'
	SET @FieldName = N'[ClientKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, ClientKey
		FROM [bi_health].[synHC_DDS_FactSales]  WITH (NOLOCK)
		WHERE ClientKey NOT
		IN (
				SELECT SRC.ClientKey
				FROM [bi_health].[synHC_DDS_DimClient] SRC WITH (NOLOCK)
			)

RETURN
END
GO
