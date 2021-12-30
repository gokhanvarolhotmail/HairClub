/* CreateDate: 05/13/2010 20:13:10.660 , ModifyDate: 05/13/2010 20:13:10.660 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimSalesCodeDivision] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_DimSalesCodeDivision]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimSalesCodeDivision]()
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

 	SET @TableName = N'[bi_cms_dds].[DimSalesCodeDivision]'

	INSERT INTO @tbl
		SELECT @TableName, [SalesCodeDivisionKey], [SalesCodeDivisionSSID]
		FROM [bi_health].[synHC_DDS_DimSalesCodeDivision] WITH (NOLOCK)
		WHERE [SalesCodeDivisionSSID] NOT
		IN (
				SELECT SRC.SalesCodeDivisionID
				FROM [bi_health].[synHC_SRC_TBL_CMS_lkpSalesCodeDivision] SRC WITH (NOLOCK)
				)
		AND [SalesCodeDivisionKey] <> -1







RETURN
END
GO
