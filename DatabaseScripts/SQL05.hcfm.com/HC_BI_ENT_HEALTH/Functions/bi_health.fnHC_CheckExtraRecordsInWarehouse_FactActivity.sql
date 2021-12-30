/* CreateDate: 05/13/2010 17:33:44.323 , ModifyDate: 05/13/2010 17:33:44.323 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_FactActivity] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_FactActivity]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_FactActivity]()
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

 	SET @TableName = N'[bi_mktg_dds].[FactActivity]'

	INSERT INTO @tbl
		SELECT @TableName, DW.[ActivityKey], ''
		FROM [bi_health].[synHC_DDS_FactActivity] DW WITH (NOLOCK)
		LEFT OUTER JOIN [bi_health].[synHC_DDS_DimActivity] da WITH (NOLOCK)
		ON da.ActivityKey = DW.[ActivityKey]
		WHERE da.[ActivitySSID] NOT
		IN (
				SELECT SRC.activity_id
				FROM [bi_health].[synHC_SRC_TBL_MKTG_oncd_activity] SRC WITH (NOLOCK)
			)






RETURN
END
GO
