/* CreateDate: 05/13/2010 17:27:03.943 , ModifyDate: 05/13/2010 17:27:03.943 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimContactSource] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_DimContactSource]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimContactSource]()
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

 	SET @TableName = N'[bi_mktg_dds].[DimContactSource]'

	INSERT INTO @tbl
		SELECT @TableName, [ContactSourceKey], [ContactSourceSSID]
		FROM [bi_health].[synHC_DDS_DimContactSource] WITH (NOLOCK)
		WHERE [ContactSourceSSID] NOT
		IN (
				SELECT SRC.[contact_source_id]
				FROM [bi_health].[synHC_SRC_TBL_MKTG_oncd_contact_source] SRC WITH (NOLOCK)
				)
		AND [ContactSourceKey] <> -1






RETURN
END
GO
