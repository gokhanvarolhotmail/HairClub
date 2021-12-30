/* CreateDate: 05/08/2010 14:52:23.053 , ModifyDate: 05/08/2010 14:52:23.053 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactSalesTransaction_DimClient] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactSalesTransaction_DimClient]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactSalesTransaction_DimClient]()
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

 	SET @TableName = N'[bi_cms_dds].[FactSalesTransaction]'
  	SET @DimensionName = N'[bi_cms_dds].[DimClient]'
	SET @FieldName = N'[ClientKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, ClientKey
		FROM [bi_health].[synHC_DDS_FactSalesTransaction]  WITH (NOLOCK)
		WHERE ClientKey NOT
		IN (
				SELECT SRC.ClientKey
				FROM [bi_health].[synHC_DDS_DimClient] SRC WITH (NOLOCK)
			)

RETURN
END
GO
