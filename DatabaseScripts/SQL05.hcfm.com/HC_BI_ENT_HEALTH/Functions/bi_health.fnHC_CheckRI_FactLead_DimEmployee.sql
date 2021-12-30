/* CreateDate: 05/08/2010 12:43:32.133 , ModifyDate: 05/08/2010 14:48:19.023 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactLead_DimEmployee] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactLead_DimEmployee_CompletedByEmployee]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactLead_DimEmployee]()
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

 	SET @TableName = N'[bi_mktg_dds].[FactLead]'
  	SET @DimensionName = N'[bi_mktg_dds].[DimEmployee]'
	SET @FieldName = N'[EmployeeKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, EmployeeKey
		FROM [bi_health].[synHC_DDS_FactLead]  WITH (NOLOCK)
		WHERE EmployeeKey NOT
		IN (
				SELECT SRC.EmployeeKey
				FROM [bi_health].[synHC_DDS_DimEmployeeSalesRep] SRC WITH (NOLOCK)
			)

RETURN
END
GO
