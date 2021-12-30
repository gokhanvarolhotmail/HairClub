/* CreateDate: 05/12/2010 17:21:51.803 , ModifyDate: 12/19/2012 16:36:09.633 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_FactActivityResults] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_FactActivityResults]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_FactActivityResults]()
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

 	SET @TableName = N'[bi_mktg_dds].[FactActivityResult]'
	SET @MissingDate = GETDATE()

	select @Yesterday= convert(date, getdate()-1)

	INSERT INTO @tbl
			SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(src.[activity_id] as varchar(150)) AS RecordID
			, src.[creation_date] AS CreatedDate
			, src.[updated_date] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_MKTG_oncd_activity] SRC WITH (NOLOCK)
				WHERE (((SRC.[action_code] IN ('APPOINT', 'INHOUSE', 'BEBACK')) AND ((SRC.[Result_code] NOT IN ( 'RESCHEDULE', 'CANCEL', 'CTREXCPTN' )) OR (SRC.[Result_code] IS NULL) ))
						OR ((SRC.[action_code] IN ('RECOVERY')) AND ((SRC.[Result_code] IS NOT NULL)) AND (SRC.[Result_code] IN ('SHOWSALE','SHOWNOSALE','NOSHOW'))))
		AND (Convert(date,coalesce(creation_date, @Yesterday)) <=  @Yesterday
		AND src.[activity_id] NOT
		IN (
				SELECT dso.[ActivitySSID]
				FROM [bi_health].[synHC_DDS_FactActivity] DW WITH (NOLOCK)
				LEFT OUTER JOIN [bi_health].[synHC_DDS_DimActivity] dso WITH (NOLOCK)
					ON dso.ActivityKey = DW.ActivityKey
				) )




		--SELECT @TableName AS TableName
		--	, @MissingDate AS MissingDate
		--	, CAST(src.[contact_completion_id] as varchar(150)) AS RecordID
		--	, src.[creation_date] AS CreatedDate
		--	, src.[updated_date] AS UpdateDate
		--FROM [bi_health].[synHC_SRC_TBL_MKTG_cstd_contact_completion] SRC
		--WHERE src.[contact_completion_id] NOT
		--IN (
		--		SELECT dso.[ActivityResultSSID]
		--		FROM [bi_health].[synHC_DDS_FactActivityResults] DW WITH (NOLOCK)
		--		LEFT OUTER JOIN [bi_health].[synHC_DDS_DimActivityResult] dso WITH (NOLOCK)
		--			ON dso.ActivityResultKey = DW.ActivityResultKey
		--		)


RETURN
END
GO
