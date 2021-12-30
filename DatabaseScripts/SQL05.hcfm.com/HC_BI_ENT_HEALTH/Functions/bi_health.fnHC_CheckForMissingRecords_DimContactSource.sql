/* CreateDate: 05/12/2010 17:38:55.197 , ModifyDate: 12/19/2012 16:32:10.467 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimContactSource] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimContactSource]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimContactSource]()
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
			, @LSET						datetime
			, @MissingDate				datetime
			, @Yesterday			datetime

 	SET @TableName = N'[bi_mktg_dds].[DimContactSource]'
	SET @MissingDate = GETDATE()

    select @Yesterday= convert(date, getdate()-1)


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(src.[contact_source_id] as varchar(150)) AS RecordID
			, src.[creation_date] AS CreatedDate
			, src.[updated_date] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_MKTG_oncd_contact_source] SRC
		WHERE Convert(date,coalesce(creation_date, @Yesterday)) <=  @Yesterday
		AND src.[contact_source_id] NOT
		IN (
				SELECT DW.[ContactSourceSSID]
				FROM [bi_health].[synHC_DDS_DimContactSource] DW WITH (NOLOCK)
				)


RETURN
END
GO
