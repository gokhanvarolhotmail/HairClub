/* CreateDate: 05/13/2010 12:57:05.453 , ModifyDate: 05/13/2010 12:57:05.453 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimCenterType] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimCenterType]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimCenterType]()
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

 	SET @TableName = N'[bi_ent_dds].[DimCenterType]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.[CenterTypeID] as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM HairClubCMS.dbo.lkpCenterType SRC
		WHERE src.[CenterTypeID] NOT
		IN (
				SELECT DW.[CenterTypeSSID]
				FROM HC_BI_ENT_DDS.[bi_ent_dds].DimCenterType DW WITH (NOLOCK)
				)


RETURN
END
GO
