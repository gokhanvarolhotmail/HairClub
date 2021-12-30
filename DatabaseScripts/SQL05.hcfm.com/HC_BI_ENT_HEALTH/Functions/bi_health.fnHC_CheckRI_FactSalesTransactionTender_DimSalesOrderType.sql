/* CreateDate: 05/08/2010 14:41:45.900 , ModifyDate: 05/08/2010 14:41:45.900 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactSalesTransactionTender_DimSalesOrderType] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactSalesTransactionTender_DimSalesOrderType]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactSalesTransactionTender_DimSalesOrderType]()
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

 	SET @TableName = N'[bi_cms_dds].[FactSalesTransactionTender]'
  	SET @DimensionName = N'[bief_dds].[DimSalesOrderType]'
	SET @FieldName = N'[SalesOrderTypeKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, SalesOrderTypeKey
		FROM [bi_health].[synHC_DDS_FactSalesTransactionTender]  WITH (NOLOCK)
		WHERE SalesOrderTypeKey NOT
		IN (
				SELECT SRC.SalesOrderTypeKey
				FROM [bi_health].[synHC_DDS_DimSalesOrderType] SRC WITH (NOLOCK)
			)

RETURN
END
GO
