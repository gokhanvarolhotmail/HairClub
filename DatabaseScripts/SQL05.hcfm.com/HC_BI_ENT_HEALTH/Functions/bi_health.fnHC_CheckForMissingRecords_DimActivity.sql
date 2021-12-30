/* CreateDate: 05/12/2010 17:58:02.980 , ModifyDate: 12/19/2012 16:34:18.610 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimActivity] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimActivity]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimActivity]()
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
			, @Yesterday        		datetime

 	SET @TableName = N'[bi_mktg_dds].[DimActivity]'
	SET @MissingDate = GETDATE()

	select @Yesterday= convert(date, getdate()-1)


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(src.[activity_id] as varchar(150)) AS RecordID
			, src.[creation_date] AS CreatedDate
			, src.[updated_date] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_MKTG_oncd_activity] SRC WITH (NOLOCK)
		WHERE Convert(date,coalesce(creation_date, @Yesterday)) <=  @Yesterday
		AND src.[activity_id] NOT
		IN (
				SELECT DW.[ActivitySSID]
				FROM [bi_health].[synHC_DDS_DimActivity] DW WITH (NOLOCK)
				)


RETURN
END
GO
