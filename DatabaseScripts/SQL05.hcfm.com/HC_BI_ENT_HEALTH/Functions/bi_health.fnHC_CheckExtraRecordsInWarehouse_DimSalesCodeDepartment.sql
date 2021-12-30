/* CreateDate: 05/13/2010 20:12:11.300 , ModifyDate: 05/13/2010 20:12:11.300 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimSalesCodeDepartment] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_DimSalesCodeDepartment]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimSalesCodeDepartment]()
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



	DECLARE	 @TableName				varchar(150)	-- Name of table

 	SET @TableName = N'[bi_cms_dds].[DimSalesCodeDepartment]'

	INSERT INTO @tbl
		SELECT @TableName, [SalesCodeDepartmentKey], [SalesCodeDepartmentSSID]
		FROM [bi_health].[synHC_DDS_DimSalesCodeDepartment] WITH (NOLOCK)
		WHERE [SalesCodeDepartmentSSID] NOT
		IN (
				SELECT SRC.SalesCodeDepartmentID
				FROM [bi_health].[synHC_SRC_TBL_CMS_lkpSalesCodeDepartment] SRC WITH (NOLOCK)
				)
		AND [SalesCodeDepartmentKey] <> -1







RETURN
END
GO
