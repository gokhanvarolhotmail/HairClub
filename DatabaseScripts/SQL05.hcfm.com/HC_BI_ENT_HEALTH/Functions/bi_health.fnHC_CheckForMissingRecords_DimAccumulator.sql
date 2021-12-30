/* CreateDate: 05/12/2010 16:58:32.467 , ModifyDate: 11/29/2012 15:07:21.903 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimAccumulator] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimAccumulator]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimAccumulator]()
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

 	SET @TableName = N'[bi_cms_dds].[DimAccumulator]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.[AccumulatorID] as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_cfgAccumulator] SRC  WITH (NOLOCK)
		WHERE src.[AccumulatorID] NOT
		IN (
				SELECT DW.[AccumulatorSSID]
				FROM [bi_health].[synHC_DDS_DimAccumulator] DW WITH (NOLOCK)
				)


RETURN
END
GO
