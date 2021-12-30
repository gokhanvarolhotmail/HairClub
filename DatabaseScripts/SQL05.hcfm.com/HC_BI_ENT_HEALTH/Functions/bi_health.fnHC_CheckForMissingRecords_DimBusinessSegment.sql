/* CreateDate: 05/13/2010 12:48:28.750 , ModifyDate: 05/13/2010 15:06:50.800 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimBusinessSegment] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimBusinessSegment]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimBusinessSegment]()
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

 	SET @TableName = N'[bi_ent_dds].[DimBusinessSegment]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.[BusinessSegmentID] as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_lkpBusinessSegment] SRC
		WHERE src.[BusinessSegmentID] NOT
		IN (
				SELECT DW.[BusinessSegmentSSID]
				FROM [bi_health].[synHC_DDS_DimBusinessSegment] DW WITH (NOLOCK)
				)


RETURN
END
GO
