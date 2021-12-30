/* CreateDate: 05/12/2010 16:42:20.273 , ModifyDate: 11/29/2012 15:24:32.887 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimSalesOrderDetail] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimSalesOrderDetail]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimSalesOrderDetail]()
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

RETURNS @tbl  TABLE (TableName varchar(150)
					, MissingDate	datetime
					, RecordID varchar(150)
					, CreatedDate datetime
					, UpdateDate datetime
					)  AS
BEGIN



	DECLARE	  @TableName				varchar(150)	-- Name of table
			, @MissingDate				datetime

 	SET @TableName = N'[bi_cms_dds].[DimSalesOrderDetail]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.[SalesOrderDetailGUID] as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_datSalesOrderDetail] SRC WITH (NOLOCK)
		WHERE src.[SalesOrderDetailGUID] NOT
		IN (
				SELECT DW.[SalesOrderDetailSSID]
				FROM [bi_health].[synHC_DDS_DimSalesOrderDetail] DW WITH (NOLOCK)
				)


RETURN
END
GO
