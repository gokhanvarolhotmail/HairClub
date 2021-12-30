/* CreateDate: 05/13/2010 17:36:08.853 , ModifyDate: 12/03/2012 13:58:11.943 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_FactActivityResults] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_FactActivityResults]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_FactActivityResults]()
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

 	SET @TableName = N'[bi_mktg_dds].[FactActivityResults]'

	INSERT INTO @tbl
		SELECT @TableName, DW.[ActivityKey], ''
		FROM [bi_health].[synHC_DDS_FactActivityResults] DW WITH (NOLOCK)
		INNER JOIN [bi_health].[synHC_DDS_DimActivity] da WITH (NOLOCK)
		ON da.ActivityKey = DW.[ActivityKey]
		WHERE da.[ActivitySSID] NOT
		IN (
				SELECT SRC.activity_id
				FROM [bi_health].[synHC_SRC_TBL_MKTG_oncd_activity] SRC WITH (NOLOCK)
				WHERE (((SRC.[action_code] IN ('APPOINT', 'INHOUSE', 'BEBACK')) AND ((SRC.[Result_code] NOT IN ( 'RESCHEDULE', 'CANCEL', 'CTREXCPTN' )) OR (SRC.[Result_code] IS NULL) ))
						OR ((SRC.[action_code] IN ('RECOVERY')) AND ((SRC.[Result_code] IS NOT NULL)) AND (SRC.[Result_code] IN ('SHOWSALE','SHOWNOSALE','NOSHOW'))))
			)







RETURN
END
GO
