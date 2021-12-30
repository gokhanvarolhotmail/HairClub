/* CreateDate: 05/13/2010 12:47:39.673 , ModifyDate: 05/13/2010 15:06:37.473 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimBusinessUnit] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimBusinessUnit]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimBusinessUnit]()
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

 	SET @TableName = N'[bi_ent_dds].[DimBusinessUnit]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.[BusinessUnitID] as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_lkpBusinessUnit] SRC
		WHERE src.[BusinessUnitID] NOT
		IN (
				SELECT DW.[BusinessUnitSSID]
				FROM [bi_health].[synHC_DDS_DimBusinessUnit] DW WITH (NOLOCK)
				)


RETURN
END
GO
