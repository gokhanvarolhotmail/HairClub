/* CreateDate: 05/03/2010 17:34:53.013 , ModifyDate: 01/08/2013 16:23:47.803 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckCount_FactActivityResults] ()
-----------------------------------------------------------------------
-- [fnHC_CheckCount_FactActivityResults]
--
--SELECT * FROM [bi_health].[fnHC_CheckCount_FactActivityResults]()
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

RETURNS @tbl  TABLE (TableName varchar(150)
					, NumRecordsInSource bigint
					, NumRecordsInReplSource bigint
					, NumRecordsInWarehouse bigint
					)  AS
BEGIN



	DECLARE	  @NumRecordsInSource		bigint
			, @NumRecordsInSourceRepl	bigint
			, @NumRecordsInWarehouse	bigint
			, @TableName				varchar(150)	-- Name of table
			, @Yesterday				datetime

 	SET @TableName = N'[bi_mktg_dds].[FactActivityResults]'

	select @Yesterday = convert(date, getdate()-1)

	SELECT @NumRecordsInSource = COUNT(*)
	FROM [bi_health].[synHC_OLTP_SRC_TBL_MKTG_oncd_activity] oncd_activity WITH (NOLOCK)
	WHERE  convert(date, coalesce(creation_date, @Yesterday)) <=  @Yesterday
	AND (((oncd_activity.[action_code] IN ('APPOINT', 'INHOUSE', 'BEBACK')) AND ((oncd_activity.[Result_code] NOT IN ( 'RESCHEDULE', 'CANCEL', 'CTREXCPTN' )) OR (oncd_activity.[Result_code] IS NULL) ))
			OR ((oncd_activity.[action_code] IN ('RECOVERY')) AND ((oncd_activity.[Result_code] IS NOT NULL)) AND (oncd_activity.[Result_code] IN ('SHOWSALE','SHOWNOSALE','NOSHOW'))))

	SELECT @NumRecordsInSourceRepl = COUNT(*)
	FROM [bi_health].[synHC_SRC_TBL_MKTG_oncd_activity] oncd_activity WITH (NOLOCK)
	WHERE convert(date, coalesce(creation_date, @Yesterday)) <=  @Yesterday
	AND (((oncd_activity.[action_code] IN ('APPOINT', 'INHOUSE', 'BEBACK')) AND ((oncd_activity.[Result_code] NOT IN ( 'RESCHEDULE', 'CANCEL', 'CTREXCPTN' )) OR (oncd_activity.[Result_code] IS NULL) ))
			OR ((oncd_activity.[action_code] IN ('RECOVERY')) AND ((oncd_activity.[Result_code] IS NOT NULL)) AND (oncd_activity.[Result_code] IN ('SHOWSALE','SHOWNOSALE','NOSHOW'))))

	SELECT @NumRecordsInWarehouse = COUNT(*)
	FROM [bi_health].[synHC_DDS_FactActivityResults] DW WITH (NOLOCK)
	WHERE ActivityDateKey <= CONVERT(char(8),@Yesterday,112)

	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @NumRecordsInSource AS NumRecordsInSource
			, @NumRecordsInSourceRepl  AS NumRecordsInReplSource
			, @NumRecordsInWarehouse  AS NumRecordsInWarehouse


RETURN
END
GO
