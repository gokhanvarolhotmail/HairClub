/* CreateDate: 05/13/2010 12:52:26.710 , ModifyDate: 05/13/2010 15:06:07.740 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimCenter] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimCenter]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimCenter]()
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

 	SET @TableName = N'[bi_ent_dds].[DimCenter]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.[CenterID] as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_cfgCenter] SRC
		WHERE src.[CenterID] NOT
		IN (
				SELECT DW.[CenterSSID]
				FROM [bi_health].[synHC_DDS_DimCenter] DW WITH (NOLOCK)
				)


RETURN
END
GO
