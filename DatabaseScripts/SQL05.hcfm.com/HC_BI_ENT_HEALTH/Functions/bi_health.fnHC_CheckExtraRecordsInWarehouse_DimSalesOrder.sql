/* CreateDate: 05/13/2010 20:14:13.067 , ModifyDate: 05/13/2010 20:14:13.067 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimSalesOrder] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_DimSalesOrder]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimSalesOrder]()
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

 	SET @TableName = N'[bi_cms_dds].[DimSalesOrder]'

	INSERT INTO @tbl
		SELECT @TableName, [SalesOrderKey], [SalesOrderSSID]
		FROM [bi_health].[synHC_DDS_DimSalesOrder] WITH (NOLOCK)
		WHERE [SalesOrderSSID] NOT
		IN (
				SELECT SRC.SalesOrderGUID
				FROM [bi_health].[synHC_SRC_TBL_CMS_datSalesOrder] SRC WITH (NOLOCK)
				)
		AND [SalesOrderKey] <> -1







RETURN
END
GO
