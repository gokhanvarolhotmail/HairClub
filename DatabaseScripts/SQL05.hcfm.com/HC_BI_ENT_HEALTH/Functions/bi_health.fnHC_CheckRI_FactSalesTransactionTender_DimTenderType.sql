/* CreateDate: 05/08/2010 14:40:56.967 , ModifyDate: 05/08/2010 14:40:56.967 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactSalesTransactionTender_DimTenderType] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactSalesTransactionTender_DimTenderType]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactSalesTransactionTender_DimTenderType]()
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
  	SET @DimensionName = N'[bief_dds].[DimTenderType]'
	SET @FieldName = N'[TenderTypeKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, TenderTypeKey
		FROM [bi_health].[synHC_DDS_FactSalesTransactionTender]  WITH (NOLOCK)
		WHERE TenderTypeKey NOT
		IN (
				SELECT SRC.TenderTypeKey
				FROM [bi_health].[synHC_DDS_DimTenderType] SRC WITH (NOLOCK)
			)

RETURN
END
GO
