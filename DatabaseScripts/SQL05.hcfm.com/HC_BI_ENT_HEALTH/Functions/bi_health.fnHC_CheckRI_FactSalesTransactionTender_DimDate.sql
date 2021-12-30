/* CreateDate: 05/08/2010 14:45:00.743 , ModifyDate: 05/08/2010 14:45:00.743 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactSalesTransactionTender_DimDate] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactSalesTransactionTender_DimDate]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactSalesTransactionTender]()
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
  	SET @DimensionName = N'[bief_dds].[DimDate]'
	SET @FieldName = N'[OrderDateKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, OrderDateKey
		FROM [bi_health].[synHC_DDS_FactSalesTransactionTender]  WITH (NOLOCK)
		WHERE OrderDateKey NOT
		IN (
				SELECT SRC.DateKey
				FROM [bi_health].[synHC_DDS_DimDate] SRC WITH (NOLOCK)
			)

RETURN
END
GO
