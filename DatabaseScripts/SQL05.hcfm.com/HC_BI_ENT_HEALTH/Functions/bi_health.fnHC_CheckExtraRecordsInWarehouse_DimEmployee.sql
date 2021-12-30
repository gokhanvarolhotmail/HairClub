/* CreateDate: 05/13/2010 20:07:44.253 , ModifyDate: 05/13/2010 20:07:44.253 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimEmployee] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_DimEmployee]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimEmployee]()
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

 	SET @TableName = N'[bi_cms_dds].[DimEmployee]'

	INSERT INTO @tbl
		SELECT @TableName, [EmployeeKey], [EmployeeSSID]
		FROM [bi_health].[synHC_DDS_DimEmployee] WITH (NOLOCK)
		WHERE [EmployeeSSID] NOT
		IN (
				SELECT SRC.EmployeeGUID
				FROM [bi_health].[synHC_SRC_TBL_CMS_datEmployee] SRC WITH (NOLOCK)
				)
		AND [EmployeeKey] <> -1







RETURN
END
GO
