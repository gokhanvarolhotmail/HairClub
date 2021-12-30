/* CreateDate: 05/08/2010 14:53:47.663 , ModifyDate: 05/08/2010 14:53:47.663 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactSales_DimDate] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactSales_DimDate]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactSales]()
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
  	SET @DimensionName = N'[bief_dds].[DimDate]'
	SET @FieldName = N'[OrderDateKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, OrderDateKey
		FROM [bi_health].[synHC_DDS_FactSales]  WITH (NOLOCK)
		WHERE OrderDateKey NOT
		IN (
				SELECT SRC.DateKey
				FROM [bi_health].[synHC_DDS_DimDate] SRC WITH (NOLOCK)
			)

RETURN
END
GO
