/* CreateDate: 05/08/2010 14:59:56.343 , ModifyDate: 05/08/2010 14:59:56.343 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactSalesTransaction_DimEmployee_Employee4] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactSalesTransaction_DimEmployee_Employee4]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactSalesTransaction_DimEmployee_Employee4]()
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
		SELECT @TableName, @DimensionName, @FieldName, Employee4Key
		FROM [bi_health].[synHC_DDS_FactSalesTransaction]  WITH (NOLOCK)
		WHERE Employee4Key NOT
		IN (
				SELECT SRC.EmployeeKey
				FROM [bi_health].[synHC_DDS_DimEmployee] SRC WITH (NOLOCK)
			)

RETURN
END
GO
