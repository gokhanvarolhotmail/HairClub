/* CreateDate: 05/08/2010 14:54:58.970 , ModifyDate: 05/08/2010 14:54:58.970 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactSales_DimSalesOrder] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactSales_DimSalesOrder]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactSales_DimSalesOrder]()
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
  	SET @DimensionName = N'[bi_cms_dds].[DimSalesOrder]'
	SET @FieldName = N'[SalesOrderKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, SalesOrderKey
		FROM [bi_health].[synHC_DDS_FactSales]  WITH (NOLOCK)
		WHERE SalesOrderKey NOT
		IN (
				SELECT SRC.SalesOrderKey
				FROM [bi_health].[synHC_DDS_DimSalesOrder] SRC WITH (NOLOCK)
			)

RETURN
END
GO
