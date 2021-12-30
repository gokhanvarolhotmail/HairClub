/* CreateDate: 05/08/2010 15:55:07.327 , ModifyDate: 05/13/2010 16:11:22.893 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckCount_DimEmployee] ()
-----------------------------------------------------------------------
-- [fnHC_CheckCount_DimEmployee]
--
-- SELECT * FROM [bi_health].[fnHC_CheckCount_DimEmployee]()
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

 	SET @TableName = N'[bi_cms_dds].[DimEmployee]'

	SELECT @NumRecordsInSource = COUNT(*)
	FROM [bi_health].[synHC_OLTP_SRC_TBL_CMS_datEmployee] WITH (NOLOCK)

	SELECT @NumRecordsInSourceRepl = COUNT(*)
	FROM [bi_health].[synHC_SRC_TBL_CMS_datEmployee] WITH (NOLOCK)

	SELECT @NumRecordsInWarehouse = COUNT(*)
	FROM [bi_health].[synHC_DDS_DimEmployee] DW WITH (NOLOCK)
	WHERE DW.[EmployeeKey] <> -1

	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @NumRecordsInSource AS NumRecordsInSource
			, @NumRecordsInSourceRepl  AS NumRecordsInReplSource
			, @NumRecordsInWarehouse  AS NumRecordsInWarehouse


RETURN
END
GO
