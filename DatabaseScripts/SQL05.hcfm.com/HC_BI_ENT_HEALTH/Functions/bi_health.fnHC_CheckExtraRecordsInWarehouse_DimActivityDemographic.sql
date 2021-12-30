/* CreateDate: 05/13/2010 17:16:53.443 , ModifyDate: 05/13/2010 17:16:53.443 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimActivityDemographic] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_DimActivityDemographic]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimActivityDemographic]()
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

RETURNS @tbl  TABLE (TableName varchar(150)
					, FieldKey bigint
					, FieldSSID varchar(150)
					)  AS
BEGIN



	DECLARE	 @TableName				varchar(150)	-- Name of table

 	SET @TableName = N'[bi_mktg_dds].[DimActivityDemographic]'

	INSERT INTO @tbl
		SELECT @TableName, [ActivityDemographicKey], [ActivityDemographicSSID]
		FROM [bi_health].[synHC_DDS_DimActivityDemographic] WITH (NOLOCK)
		WHERE [ActivityDemographicSSID] NOT
		IN (
				SELECT SRC.[activity_demographic_id]
				FROM [bi_health].[synHC_SRC_TBL_MKTG_cstd_activity_demographic] SRC WITH (NOLOCK)
				)
		AND [ActivityDemographicKey] <> -1





RETURN
END
GO
