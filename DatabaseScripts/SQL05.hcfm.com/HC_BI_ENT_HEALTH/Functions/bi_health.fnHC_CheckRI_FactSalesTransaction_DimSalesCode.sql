/* CreateDate: 05/08/2010 15:06:05.910 , ModifyDate: 05/08/2010 15:06:05.910 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactSalesTransaction_DimSalesCode] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactSalesTransaction_DimSalesCode]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactSalesTransaction_DimSalesCode]()
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
  	SET @DimensionName = N'[bi_cms_dds].[DimSalesCode]'
	SET @FieldName = N'[SalesCodeKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, SalesCodeKey
		FROM [bi_health].[synHC_DDS_FactSalesTransaction]  WITH (NOLOCK)
		WHERE SalesCodeKey NOT
		IN (
				SELECT SRC.SalesCodeKey
				FROM [bi_health].[synHC_DDS_DimSalesCode] SRC WITH (NOLOCK)
			)

RETURN
END
GO
