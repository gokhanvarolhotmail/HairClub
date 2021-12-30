/* CreateDate: 05/13/2010 20:09:53.110 , ModifyDate: 05/13/2010 20:09:53.110 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimSalesCode] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_DimSalesCode]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimSalesCode]()
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

 	SET @TableName = N'[bi_cms_dds].[DimSalesCode]'

	INSERT INTO @tbl
		SELECT @TableName, [SalesCodeKey], [SalesCodeSSID]
		FROM [bi_health].[synHC_DDS_DimSalesCode] WITH (NOLOCK)
		WHERE [SalesCodeSSID] NOT
		IN (
				SELECT SRC.SalesCodeID
				FROM [bi_health].[synHC_SRC_TBL_CMS_cfgSalesCode] SRC WITH (NOLOCK)
				)
		AND [SalesCodeKey] <> -1







RETURN
END
GO
