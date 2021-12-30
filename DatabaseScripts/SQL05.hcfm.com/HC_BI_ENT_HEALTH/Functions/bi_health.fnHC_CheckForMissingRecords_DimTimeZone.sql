/* CreateDate: 05/13/2010 12:51:30.070 , ModifyDate: 05/13/2010 15:01:03.683 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimTimeZone] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimTimeZone]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimTimeZone]()
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

 	SET @TableName = N'[bi_ent_dds].[DimTimeZone]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.[TimeZoneID] as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_lkpTimeZone] SRC
		WHERE src.[TimeZoneID] NOT
		IN (
				SELECT DW.[TimeZoneSSID]
				FROM [bi_health].[synHC_DDS_DimTimeZone] DW WITH (NOLOCK)
				)


RETURN
END
GO
