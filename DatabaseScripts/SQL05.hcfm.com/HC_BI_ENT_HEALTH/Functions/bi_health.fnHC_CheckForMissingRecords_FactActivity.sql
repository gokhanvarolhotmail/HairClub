/* CreateDate: 05/12/2010 15:23:45.390 , ModifyDate: 12/19/2012 16:16:42.300 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_FactActivity] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_FactActivity]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_FactActivity]()
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

 	SET @TableName = N'[bi_mktg_dds].[FactActivity]'
	SET @MissingDate = GETDATE()

	select @Yesterday = convert(date, getdate()-1)

	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(src.[activity_id] as varchar(150)) AS RecordID
			, src.[creation_date] AS CreatedDate
			, src.[updated_date] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_MKTG_oncd_activity] SRC WITH (NOLOCK)
		WHERE convert(date, coalesce(creation_date, @Yesterday)) <=  @Yesterday -- check up through yesterday
		AND src.[activity_id] NOT
		IN (
				SELECT dso.[ActivitySSID]
				FROM [bi_health].[synHC_DDS_FactActivity] DW WITH (NOLOCK)
				INNER JOIN [bi_health].[synHC_DDS_DimActivity] dso WITH (NOLOCK)
					ON dso.ActivityKey = DW.ActivityKey
				)


RETURN
END
GO
