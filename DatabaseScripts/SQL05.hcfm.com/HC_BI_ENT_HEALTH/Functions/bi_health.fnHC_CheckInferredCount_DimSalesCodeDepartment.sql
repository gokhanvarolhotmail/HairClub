/* CreateDate: 05/12/2010 11:13:40.833 , ModifyDate: 05/13/2010 14:52:17.310 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimSalesCodeDepartment] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimSalesCodeDepartment]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimSalesCodeDepartment]()
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

RETURNS @tbl  TABLE (TableName varchar(150)
					, FieldKey bigint
					, FieldSSID varchar(150)
					)  AS
BEGIN



	DECLARE	  @TableName				varchar(150)	-- Name of table

 	SET @TableName = N'[bi_cms_dds].[DimSalesCodeDepartment]'


	INSERT INTO @tbl
		SELECT @TableName, SalesCodeDepartmentKey, CAST(SalesCodeDepartmentSSID as varchar(150))
		FROM [bi_health].[synHC_DDS_DimSalesCodeDepartment] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimSalesCodeDepartment] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
