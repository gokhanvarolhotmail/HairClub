/* CreateDate: 05/13/2010 20:00:01.687 , ModifyDate: 12/17/2012 11:39:29.820 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_FactSalesTransactionTender] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_FactSalesTransactionTender]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_FactSalesTransactionTender]()
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

 	SET @TableName = N'[bi_cms_dds].[FactSalesTransactionTender]'

	INSERT INTO @tbl
		SELECT @TableName, DW.[SalesOrderTenderKey], ''
		FROM [bi_health].[synHC_DDS_FactSalesTransactionTender] DW WITH (NOLOCK)
		INNER JOIN [bi_health].[synHC_DDS_DimSalesOrderTender] dso WITH (NOLOCK)
		ON dso.SalesOrderTenderKey = DW.[SalesOrderTenderKey]
		WHERE dso.[SalesOrderTenderSSID] NOT
		IN (
				SELECT SRC.SalesOrderTenderGUID
				FROM [bi_health].[synHC_SRC_TBL_CMS_datSalesOrderTender] SRC WITH (NOLOCK)
				LEFT OUTER JOIN [bi_health].[synHC_SRC_TBL_CMS_datSalesOrder] SRCD  WITH (NOLOCK)
					ON SRC.SalesOrderGUID = SRCD.SalesOrderGUID
				WHERE (CAST(SRCD.IsClosedFlag AS INT) = 1 AND  CAST(SRCD.IsVoidedFlag AS INT) = 0)
			)







RETURN
END
GO
