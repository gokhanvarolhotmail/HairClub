/* CreateDate: 05/08/2010 15:05:30.630 , ModifyDate: 05/08/2010 15:05:30.630 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactSalesTransaction_DimSalesOrderDetail] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactSalesTransaction_DimSalesOrderDetail]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactSalesTransaction_DimSalesOrderDetail]()
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
  	SET @DimensionName = N'[bi_cms_dds].[DimSalesOrderDetail]'
	SET @FieldName = N'[SalesOrderDetailKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, SalesOrderDetailKey
		FROM [bi_health].[synHC_DDS_FactSalesTransaction]  WITH (NOLOCK)
		WHERE SalesOrderDetailKey NOT
		IN (
				SELECT SRC.SalesOrderDetailKey
				FROM [bi_health].[synHC_DDS_DimSalesOrderDetail] SRC WITH (NOLOCK)
			)

RETURN
END
GO
