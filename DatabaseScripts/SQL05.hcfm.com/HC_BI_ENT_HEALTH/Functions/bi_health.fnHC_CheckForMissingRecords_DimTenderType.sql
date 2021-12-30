/* CreateDate: 05/12/2010 16:51:23.173 , ModifyDate: 05/13/2010 15:01:17.627 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimTenderType] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimTenderType]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimTenderType]()
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

 	SET @TableName = N'[bi_cms_dds].[DimTenderType]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.[TenderTypeID] as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_lkpTenderType] SRC
		WHERE src.[TenderTypeID] NOT
		IN (
				SELECT DW.[TenderTypeSSID]
				FROM [bi_health].[synHC_DDS_DimTenderType] DW WITH (NOLOCK)
				)


RETURN
END
GO
