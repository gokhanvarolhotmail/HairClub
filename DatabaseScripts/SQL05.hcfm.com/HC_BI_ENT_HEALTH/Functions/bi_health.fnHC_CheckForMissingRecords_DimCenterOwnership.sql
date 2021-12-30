/* CreateDate: 05/13/2010 12:49:36.200 , ModifyDate: 05/13/2010 15:05:54.280 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimCenterOwnership] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimCenterOwnership]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimCenterOwnership]()
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

 	SET @TableName = N'[bi_ent_dds].[DimCenterOwnership]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.[CenterOwnershipID] as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_lkpCenterOwnership] SRC
		WHERE src.[CenterOwnershipID] NOT
		IN (
				SELECT DW.[CenterOwnershipSSID]
				FROM [bi_health].[synHC_DDS_DimCenterOwnership] DW WITH (NOLOCK)
				)


RETURN
END
GO
