/* CreateDate: 05/08/2010 14:57:41.217 , ModifyDate: 05/08/2010 14:57:41.217 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactSales_DimEmployee] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactSales_DimEmployee]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactSales_DimEmployee]()
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
  	SET @DimensionName = N'[bief_dds].[DimEmployee]'
	SET @FieldName = N'[EmployeeKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, EmployeeKey
		FROM [bi_health].[synHC_DDS_FactSales]  WITH (NOLOCK)
		WHERE EmployeeKey NOT
		IN (
				SELECT SRC.EmployeeKey
				FROM [bi_health].[synHC_DDS_DimEmployee] SRC WITH (NOLOCK)
			)

RETURN
END
GO
