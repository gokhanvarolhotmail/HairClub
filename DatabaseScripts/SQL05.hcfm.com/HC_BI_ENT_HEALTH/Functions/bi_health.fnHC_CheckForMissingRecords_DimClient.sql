/* CreateDate: 05/12/2010 16:43:04.983 , ModifyDate: 11/29/2012 15:20:00.140 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimClient] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimClient]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimClient]()
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

 	SET @TableName = N'[bi_cms_dds].[DimClient]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.[ClientGUID] as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_datClient] SRC WITH (NOLOCK)
		WHERE src.[ClientGUID] NOT
		IN (
				SELECT DW.[ClientSSID]
				FROM [bi_health].[synHC_DDS_DimClient] DW WITH (NOLOCK)
				)


RETURN
END
GO
