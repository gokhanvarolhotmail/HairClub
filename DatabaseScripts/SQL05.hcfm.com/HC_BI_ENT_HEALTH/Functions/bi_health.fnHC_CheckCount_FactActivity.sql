/* CreateDate: 05/03/2010 17:28:42.217 , ModifyDate: 01/08/2013 10:09:58.573 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckCount_FactActivity] ()
-----------------------------------------------------------------------
-- [fnHC_CheckCount_FactActivity]
--
--SELECT * FROM [bi_health].[fnHC_CheckCount_FactActivity]()
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

 	SET @TableName = N'[bi_mktg_dds].[FactActivity]'

	 -- we'll check up through yesterday
     select @Yesterday = convert(date, getdate()-1)

	SELECT @NumRecordsInSource = COUNT(*)
 	FROM [bi_health].[synHC_OLTP_SRC_TBL_MKTG_oncd_activity] WITH (NOLOCK)
	WHERE  convert(date, isnull(creation_date,@Yesterday)) <=  @Yesterday
	--and creation_date >= '01/01/2012'

	SELECT  @NumRecordsInSourceRepl = COUNT(*)
	FROM [bi_health].[synHC_SRC_TBL_MKTG_oncd_activity] WITH (NOLOCK)
    WHERE  convert(date, isnull(creation_date,@Yesterday) ) <=  @Yesterday
	--and creation_date >= '01/01/2012'

	SELECT @NumRecordsInWarehouse = COUNT(*)
	FROM [bi_health].[synHC_DDS_FactActivity] DW WITH (NOLOCK)
	WHERE ActivityDateKey <= CONVERT(char(8),@Yesterday,112)
	--and ActivityDateKey >= 20120101

	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @NumRecordsInSource AS NumRecordsInSource
			, @NumRecordsInSourceRepl  AS NumRecordsInReplSource
			, @NumRecordsInWarehouse  AS NumRecordsInWarehouse


RETURN
END
GO
