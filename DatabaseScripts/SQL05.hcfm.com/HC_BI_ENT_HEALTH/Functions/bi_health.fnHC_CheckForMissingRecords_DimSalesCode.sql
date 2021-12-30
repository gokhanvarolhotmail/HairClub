/* CreateDate: 05/12/2010 16:46:53.420 , ModifyDate: 05/13/2010 15:03:29.680 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimSalesCode] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimSalesCode]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimSalesCode]()
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

 	SET @TableName = N'[bi_cms_dds].[DimSalesCode]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.[SalesCodeID] as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_cfgSalesCode] SRC
		WHERE src.[SalesCodeID] NOT
		IN (
				SELECT DW.[SalesCodeSSID]
				FROM [bi_health].[synHC_DDS_DimSalesCode] DW WITH (NOLOCK)
				)


RETURN
END
GO
