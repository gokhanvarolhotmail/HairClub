/* CreateDate: 05/12/2010 18:04:44.760 , ModifyDate: 11/02/2011 10:16:10.050 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimSource] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimSource]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimSource]()
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

 	SET @TableName = N'[bi_mktg_dds].[DimSource]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(src.[SourceCode] as varchar(150)) AS RecordID
			, src.[CreationDate] AS CreatedDate
			, src.[LastUpdateDate] AS UpdateDate
		FROM [bi_health].[synHC_OLTP_SRC_TBL_MKTG_MediaSourceSources] SRC
		WHERE src.[SourceCode] NOT
		IN (
				SELECT DW.[SourceSSID]
				FROM [bi_health].[synHC_DDS_DimSource]DW WITH (NOLOCK)
				)


RETURN
END
GO
