/* CreateDate: 05/13/2010 17:25:45.307 , ModifyDate: 05/13/2010 17:25:45.307 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimContactPhone] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_DimContactPhone]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimContactPhone]()
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

 	SET @TableName = N'[bi_mktg_dds].[DimContactPhone]'

	INSERT INTO @tbl
		SELECT @TableName, [ContactPhoneKey], [ContactPhoneSSID]
		FROM [bi_health].[synHC_DDS_DimContactPhone] WITH (NOLOCK)
		WHERE [ContactPhoneSSID] NOT
		IN (
				SELECT SRC.[contact_phone_id]
				FROM [bi_health].[synHC_SRC_TBL_MKTG_oncd_contact_phone] SRC WITH (NOLOCK)
				)
		AND [ContactPhoneKey] <> -1






RETURN
END
GO
