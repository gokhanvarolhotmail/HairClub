/* CreateDate: 05/13/2010 17:24:19.240 , ModifyDate: 05/13/2010 17:24:19.240 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimContactEmail] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_DimContactEmail]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimContactEmail]()
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

 	SET @TableName = N'[bi_mktg_dds].[DimContactEmail]'

	INSERT INTO @tbl
		SELECT @TableName, [ContactEmailKey], [ContactEmailSSID]
		FROM [bi_health].[synHC_DDS_DimContactEmail] WITH (NOLOCK)
		WHERE [ContactEmailSSID] NOT
		IN (
				SELECT SRC.[contact_email_id]
				FROM [bi_health].[synHC_SRC_TBL_MKTG_oncd_contact_email] SRC WITH (NOLOCK)
				)
		AND [ContactEmailKey] <> -1






RETURN
END
GO
