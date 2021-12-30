/* CreateDate: 05/03/2010 17:19:02.447 , ModifyDate: 05/13/2010 16:01:39.587 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckCount_DimActivityResult] ()
-----------------------------------------------------------------------
-- [fnHC_CheckCount_DimActivityResult]
--
--SELECT * FROM [bi_health].[fnHC_CheckCount_DimActivityResult]()
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

 	SET @TableName = N'[bi_mktg_dds].[DimActivityResult]'

	SELECT @NumRecordsInSource = COUNT(*)
	FROM [bi_health].[synHC_OLTP_SRC_TBL_MKTG_cstd_contact_completion] WITH (NOLOCK)

	SELECT @NumRecordsInSourceRepl = COUNT(*)
	FROM [bi_health].[synHC_SRC_TBL_MKTG_cstd_contact_completion] WITH (NOLOCK)

	SELECT @NumRecordsInWarehouse = COUNT(*)
	FROM [bi_health].[synHC_DDS_DimActivityResult] DW WITH (NOLOCK)
	WHERE DW.[ActivityResultKey] <> -1

	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @NumRecordsInSource AS NumRecordsInSource
			, @NumRecordsInSourceRepl  AS NumRecordsInReplSource
			, @NumRecordsInWarehouse  AS NumRecordsInWarehouse


RETURN
END
GO
