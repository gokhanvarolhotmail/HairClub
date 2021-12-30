/* CreateDate: 05/08/2010 11:25:45.270 , ModifyDate: 05/08/2010 15:16:17.683 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactActivity_DimEmployee_CompletedByEmployee] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactActivity_DimEmployee_CompletedByEmployee]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivity_DimEmployee_CompletedByEmployee]()
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

 	SET @TableName = N'[bi_mktg_dds].[FactActivity]'
  	SET @DimensionName = N'[bi_mktg_dds].[DimEmployee]'
	SET @FieldName = N'[CompletedByEmployeeKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, CompletedByEmployeeKey
		FROM [bi_health].[synHC_DDS_FactActivity]  WITH (NOLOCK)
		WHERE CompletedByEmployeeKey NOT
		IN (
				SELECT SRC.EmployeeKey
				FROM [bi_health].[synHC_DDS_DimEmployeeSalesRep] SRC WITH (NOLOCK)
			)

RETURN
END
GO
