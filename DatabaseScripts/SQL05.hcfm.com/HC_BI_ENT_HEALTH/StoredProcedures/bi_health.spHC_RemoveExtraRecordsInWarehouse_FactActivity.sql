/* CreateDate: 05/12/2010 10:02:42.047 , ModifyDate: 05/13/2010 13:48:51.887 */
GO
CREATE PROCEDURE [bi_health].[spHC_RemoveExtraRecordsInWarehouse_FactActivity]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_RemoveExtraRecordsInWarehouse_FactActivity]
--
-- EXEC [bi_health].[spHC_RemoveExtraRecordsInWarehouse_FactActivity]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

BEGIN

		DELETE
		FROM [bi_health].[synHC_DDS_FactActivity]
		WHERE  ActivityKey IN (
				SELECT DW.[ActivityKey]
				FROM [bi_health].[synHC_DDS_FactActivity] DW WITH (NOLOCK)
				LEFT OUTER JOIN [bi_health].[synHC_DDS_DimActivity] da WITH (NOLOCK)
				ON da.ActivityKey = DW.[ActivityKey]
				WHERE da.[ActivitySSID] NOT
				IN (
						SELECT SRC.activity_id
						FROM [bi_health].[synHC_SRC_TBL_MKTG_oncd_activity] SRC WITH (NOLOCK)
					)
				)

END
GO
