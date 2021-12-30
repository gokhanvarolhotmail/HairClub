/* CreateDate: 10/25/2011 14:14:16.873 , ModifyDate: 10/25/2011 14:14:16.873 */
GO
create    FUNCTION [bi_health].[fnHC_CheckAbandoned_MKT_DimActivityDemographic] (@FromDate datetime, @ToDate DateTime)
-----------------------------------------------------------------------
-- [fnHC_CheckAbandoned_MKT_DimActivityDemographic]
--
--SELECT * FROM [bi_health].[fnHC_CheckAbandoned_MKT_DimActivityDemographic]('01/01/00',getdate()-1)
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0	10-25-11  KMurdoch       Initial Creation
-----------------------------------------------------------------------

RETURNS @tbl  TABLE (TableName varchar(150)
					, DataPkgKey int
					, ProcessDate varchar(30)
					, NumRecordsInTable bigint
					, NumRecordsWExceptions bigint
					, [Status] varchar(50)
					)  AS
BEGIN

	DECLARE	 @TableName				varchar(150)	-- Name of table

 	SET @TableName = N'[bi_mktg_stage].[DimActivityDemographic]'

	INSERT INTO @tbl
	SELECT  @TableName
	,	stg.DataPkgKey
	,	meta.ExecStartDt
    ,	COUNT(*)
	,	SUM(CASE WHEN ISNULL(stg.IsException,0)=1 THEN 1 ELSE 0 END)
	,   meta.[Status]
	FROM [bi_health].[synHC_STG_TBL_MKTG_DimActivityDemographic] stg WITH (NOLOCK)
		LEFT JOIN [bi_health].[synHC_META_TBL_MKTG_AuditDataPkg] meta WITH (NOLOCK)
			ON stg.DataPkgKey = meta.DataPkgKey
	WHERE
		meta.ExecStartDT IS NULL -- in case of programmer testing
		OR meta.ExecStartDt BETWEEN @FromDate AND @ToDate
	GROUP BY
		stg.DataPkgKey,
		meta.ExecStartDt,
		meta.Status


RETURN
END
GO
