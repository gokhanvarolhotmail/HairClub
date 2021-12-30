/* CreateDate: 05/12/2010 17:53:43.677 , ModifyDate: 12/19/2012 16:34:56.107 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimActivityResult] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimActivityResult]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimActivityResult]()
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
			, @Yesterday				datetime

 	SET @TableName = N'[bi_mktg_dds].[DimActivityResult]'
	SET @MissingDate = GETDATE()

	select @Yesterday= convert(date, getdate()-1)


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(src.[contact_completion_id] as varchar(150)) AS RecordID
			, src.[creation_date] AS CreatedDate
			, src.[updated_date] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_MKTG_cstd_contact_completion] SRC WITH (NOLOCK)
		WHERE Convert(date,coalesce(creation_date, @Yesterday)) <=  @Yesterday
		AND src.[contact_completion_id] NOT
		IN (
				SELECT DW.[ActivityResultSSID]
				FROM [bi_health].[synHC_DDS_DimActivityResult] DW WITH (NOLOCK)
				)


RETURN
END
GO
