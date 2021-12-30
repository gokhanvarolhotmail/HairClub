/* CreateDate: 05/08/2010 14:42:08.250 , ModifyDate: 05/08/2010 14:42:08.250 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactSalesTransactionTender_DimSalesOrderTender] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactSalesTransactionTender_DimSalesOrderTender]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactSalesTransactionTender_DimSalesOrderTender]()
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
  	SET @DimensionName = N'[bief_dds].[DimSalesOrderTender]'
	SET @FieldName = N'[SalesOrderTenderKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, SalesOrderTenderKey
		FROM [bi_health].[synHC_DDS_FactSalesTransactionTender]  WITH (NOLOCK)
		WHERE SalesOrderTenderKey NOT
		IN (
				SELECT SRC.SalesOrderTenderKey
				FROM [bi_health].[synHC_DDS_DimSalesOrderTender] SRC WITH (NOLOCK)
			)

RETURN
END
GO
