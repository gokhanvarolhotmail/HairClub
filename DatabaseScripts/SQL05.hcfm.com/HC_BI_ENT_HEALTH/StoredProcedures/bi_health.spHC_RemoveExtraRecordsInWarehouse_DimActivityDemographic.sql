/* CreateDate: 05/07/2010 15:07:34.760 , ModifyDate: 05/13/2010 13:39:28.013 */
GO
CREATE PROCEDURE [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimActivityDemographic]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimActivityDemographic]
--
-- EXEC [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimActivityDemographic]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

BEGIN

		DELETE
		FROM [bi_health].[synHC_DDS_DimActivityDemographic]
		--SELECT [ActivityDemographicKey], [ActivityDemographicSSID]
		--FROM [bi_health].[synHC_DDS_DimActivityDemographic] WITH (NOLOCK)
		WHERE [ActivityDemographicSSID] NOT
		IN (
				SELECT SRC.[activity_demographic_id]
				FROM [bi_health].[synHC_SRC_TBL_MKTG_cstd_activity_demographic] SRC WITH (NOLOCK)
				)
		AND [ActivityDemographicKey] <> -1


END
GO
