/* CreateDate: 05/08/2010 14:59:32.963 , ModifyDate: 05/08/2010 14:59:32.963 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactSalesTransaction_DimEmployee_Employee2] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactSalesTransaction_DimEmployee_Employee2]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactSalesTransaction_DimEmployee_Employee2]()
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
  	SET @DimensionName = N'[bi_ent_dds].[DimEmployee]'
	SET @FieldName = N'[EmployeeKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, Employee2Key
		FROM [bi_health].[synHC_DDS_FactSalesTransaction]  WITH (NOLOCK)
		WHERE Employee2Key NOT
		IN (
				SELECT SRC.EmployeeKey
				FROM [bi_health].[synHC_DDS_DimEmployee] SRC WITH (NOLOCK)
			)

RETURN
END
GO
