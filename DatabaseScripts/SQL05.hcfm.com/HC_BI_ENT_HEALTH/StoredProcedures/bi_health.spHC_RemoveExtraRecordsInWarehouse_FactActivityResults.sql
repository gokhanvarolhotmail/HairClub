/* CreateDate: 05/12/2010 10:04:14.420 , ModifyDate: 05/13/2010 13:50:02.507 */
GO
CREATE PROCEDURE [bi_health].[spHC_RemoveExtraRecordsInWarehouse_FactActivityResults]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_RemoveExtraRecordsInWarehouse_FactActivityResults]
--
-- EXEC [bi_health].[spHC_RemoveExtraRecordsInWarehouse_FactActivityResults]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

BEGIN

		DELETE
		FROM [bi_health].[synHC_DDS_FactActivityResults]
		WHERE  ActivityKey IN (
				SELECT DW.[ActivityKey]
				FROM [bi_health].[synHC_DDS_FactActivityResults] DW WITH (NOLOCK)
				LEFT OUTER JOIN [bi_health].[synHC_DDS_DimActivity] da WITH (NOLOCK)
				ON da.ActivityKey = DW.[ActivityKey]
				WHERE da.[ActivitySSID] NOT
				IN (
						SELECT SRC.activity_id
						FROM [bi_health].[synHC_SRC_TBL_MKTG_oncd_activity] SRC WITH (NOLOCK)
						WHERE (((SRC.[action_code] IN ('APPOINT', 'INHOUSE', 'BEBACK')) AND ((SRC.[Result_code] NOT IN ( 'RESCHEDULE', 'CANCEL', 'CTREXCPTN' )) OR (SRC.[Result_code] IS NULL) ))
								OR ((SRC.[action_code] IN ('RECOVERY')) AND ((SRC.[Result_code] IS NOT NULL)) AND (SRC.[Result_code] IN ('SHOWSALE','SHOWNOSALE','NOSHOW'))))
					)
				)

END
GO
