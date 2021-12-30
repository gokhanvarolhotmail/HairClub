/* CreateDate: 05/08/2010 14:23:15.220 , ModifyDate: 05/08/2010 14:46:37.947 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactSalesTransactionTender_DimCenter] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactSalesTransactionTender_DimCenter]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactSalesTransactionTender_DimCenter]()
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
  	SET @DimensionName = N'[bi_ent_dds].[DimCenter]'
	SET @FieldName = N'[CenterKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, CenterKey
		FROM [bi_health].[synHC_DDS_FactSalesTransactionTender]  WITH (NOLOCK)
		WHERE CenterKey NOT
		IN (
				SELECT SRC.CenterKey
				FROM [bi_health].[synHC_DDS_DimCenter] SRC WITH (NOLOCK)
			)

RETURN
END
GO
