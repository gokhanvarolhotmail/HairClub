/* CreateDate: 05/12/2010 17:00:08.737 , ModifyDate: 05/13/2010 15:07:07.840 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimAccumulatorActionType] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimAccumulatorActionType]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimAccumulatorActionType]()
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

 	SET @TableName = N'[bi_cms_dds].[DimAccumulatorActionType]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.[AccumulatorActionTypeID] as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_lkpAccumulatorActionType] SRC
		WHERE src.[AccumulatorActionTypeID] NOT
		IN (
				SELECT DW.[AccumulatorActionTypeSSID]
				FROM [bi_health].[synHC_DDS_DimAccumulatorActionType] DW WITH (NOLOCK)
				)


RETURN
END
GO
