/* CreateDate: 05/13/2010 17:45:47.230 , ModifyDate: 01/08/2013 16:53:24.740 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_FactSalesTransaction] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_FactSalesTransaction]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_FactSalesTransaction]()
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

 	SET @TableName = N'[bi_cms_dds].[FactSalesTransaction]'

	INSERT INTO @tbl
		SELECT @TableName, DW.[SalesOrderDetailKey], dso.[SalesOrderDetailSSID]
		FROM [bi_health].[synHC_DDS_FactSalesTransaction] DW WITH (NOLOCK)
		INNER JOIN [bi_health].[synHC_DDS_DimSalesOrderDetail] dso WITH (NOLOCK)
		ON dso.SalesOrderDetailKey = DW.[SalesOrderDetailKey]
		WHERE dso.[SalesOrderDetailSSID] NOT
		IN (
				SELECT SRC.SalesOrderDetailGUID
				FROM [bi_health].[synHC_SRC_TBL_CMS_datSalesOrderDetail] SRC WITH (NOLOCK)
				INNER JOIN [bi_health].[synHC_SRC_TBL_CMS_datSalesOrder] SRCD  WITH (NOLOCK)
					ON SRC.SalesOrderGUID = SRCD.SalesOrderGUID
				WHERE (CAST(SRCD.IsClosedFlag AS INT) = 1 AND  CAST(SRCD.IsVoidedFlag AS INT) = 0)
			)





RETURN
END
GO
