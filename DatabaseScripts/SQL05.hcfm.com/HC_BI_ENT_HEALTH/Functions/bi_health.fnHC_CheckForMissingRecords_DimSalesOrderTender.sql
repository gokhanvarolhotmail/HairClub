/* CreateDate: 05/12/2010 16:40:33.910 , ModifyDate: 11/29/2012 15:24:46.637 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimSalesOrderTender] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimSalesOrderTender]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimSalesOrderTender]()
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

 	SET @TableName = N'[bi_cms_dds].[DimSalesOrderTender]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.[SalesOrderTenderGUID] as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_datSalesOrderTender] SRC WITH (NOLOCK)
		WHERE src.[SalesOrderTenderGUID] NOT
		IN (
				SELECT DW.[SalesOrderTenderSSID]
				FROM [bi_health].[synHC_DDS_DimSalesOrderTender] DW WITH (NOLOCK)
				)


RETURN
END
GO
