/* CreateDate: 05/03/2010 17:32:05.647 , ModifyDate: 12/19/2012 16:00:22.593 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckCount_FactLead] ()
-----------------------------------------------------------------------
-- [fnHC_CheckCount_FactLead]
--
--SELECT * FROM [bi_health].[fnHC_CheckCount_FactLead]()
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			               Initial Creation
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

 	SET @TableName = N'[bi_mktg_dds].[FactLead]'

	select @Yesterday = convert(date, getdate()-1)

	SELECT @NumRecordsInSource = COUNT(*)
	FROM [bi_health].[synHC_OLTP_SRC_TBL_MKTG_oncd_contact] WITH (NOLOCK)
	WHERE  convert(date, coalesce(creation_date, @Yesterday)) <=  @Yesterday

	SELECT @NumRecordsInSourceRepl = COUNT(*)
	FROM [bi_health].[synHC_SRC_TBL_MKTG_oncd_contact] WITH (NOLOCK)
	WHERE  convert(date, coalesce(creation_date, @Yesterday)) <=  @Yesterday

	SELECT @NumRecordsInWarehouse = COUNT(*)
	FROM [bi_health].[synHC_DDS_FactLead] DW WITH (NOLOCK)
	WHERE LeadCreationDateKey <= CONVERT(char(8),@Yesterday,112)

	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @NumRecordsInSource AS NumRecordsInSource
			, @NumRecordsInSourceRepl  AS NumRecordsInReplSource
			, @NumRecordsInWarehouse  AS NumRecordsInWarehouse


RETURN
END
GO
