/* CreateDate: 05/13/2010 17:12:35.483 , ModifyDate: 05/13/2010 17:12:35.483 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimActivity] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_DimActivity]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimActivity]()
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

 	SET @TableName = N'[bi_mktg_dds].[DimActivity]'

	INSERT INTO @tbl
		SELECT @TableName, [ActivityKey], [ActivitySSID]
		FROM [bi_health].[synHC_DDS_DimActivity] WITH (NOLOCK)
		WHERE [ActivitySSID] NOT
		IN (
				SELECT SRC.[activity_id]
				FROM [bi_health].[synHC_SRC_TBL_MKTG_oncd_activity] SRC WITH (NOLOCK)
				)
		AND [ActivityKey] <> -1




RETURN
END
GO
