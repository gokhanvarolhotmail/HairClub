/* CreateDate: 05/13/2010 20:15:14.397 , ModifyDate: 05/13/2010 20:17:07.977 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimSalesOrderDetail] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_DimSalesOrderDetail]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimSalesOrderDetail]()
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

 	SET @TableName = N'[bi_cms_dds].[DimSalesOrderDetail]'

	INSERT INTO @tbl
		SELECT @TableName, [SalesOrderDetailKey], [SalesOrderDetailSSID]
		FROM [bi_health].[synHC_DDS_DimSalesOrderDetail] WITH (NOLOCK)
		WHERE [SalesOrderDetailSSID] NOT
		IN (
				SELECT SRC.SalesOrderDetailGUID
				FROM [bi_health].[synHC_SRC_TBL_CMS_datSalesOrderDetail] SRC WITH (NOLOCK)
				)
		AND [SalesOrderDetailKey] <> -1







RETURN
END
GO
