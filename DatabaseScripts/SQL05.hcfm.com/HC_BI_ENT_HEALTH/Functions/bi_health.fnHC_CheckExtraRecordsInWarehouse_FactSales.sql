/* CreateDate: 05/13/2010 17:39:55.227 , ModifyDate: 12/01/2012 16:33:51.963 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_FactSales] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_FactSales]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_FactSales]()
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

 	SET @TableName = N'[bi_cms_dds].[FactSales]'

	INSERT INTO @tbl
		SELECT @TableName, DW.[SalesOrderKey], ''
		FROM [bi_health].[synHC_DDS_FactSales] DW WITH (NOLOCK)
		INNER JOIN [bi_health].[synHC_DDS_DimSalesOrder] dso WITH (NOLOCK)
		ON dso.SalesOrderKey = DW.[SalesOrderKey]
		WHERE dso.[SalesOrderSSID] NOT
		IN (
				SELECT SRC.SalesOrderGUID
				FROM [bi_health].[synHC_SRC_TBL_CMS_datSalesOrder] SRC WITH (NOLOCK)
				WHERE (CAST(SRC.IsClosedFlag AS INT) = 1 AND  CAST(SRC.IsVoidedFlag AS INT) = 0)
			)







RETURN
END
GO
