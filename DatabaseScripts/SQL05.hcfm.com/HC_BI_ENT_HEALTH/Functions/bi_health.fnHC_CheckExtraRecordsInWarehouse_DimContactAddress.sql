/* CreateDate: 05/13/2010 17:22:44.907 , ModifyDate: 05/13/2010 17:22:44.907 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimContactAddress] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_DimContactAddress]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimContactAddress]()
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

 	SET @TableName = N'[bi_mktg_dds].[DimContactAddress]'

	INSERT INTO @tbl
		SELECT @TableName, [ContactAddressKey], [ContactAddressSSID]
		FROM [bi_health].[synHC_DDS_DimContactAddress] WITH (NOLOCK)
		WHERE [ContactAddressSSID] NOT
		IN (
				SELECT SRC.[contact_address_id]
				FROM [bi_health].[synHC_SRC_TBL_MKTG_oncd_contact_address] SRC WITH (NOLOCK)
				)
		AND [ContactAddressKey] <> -1






RETURN
END
GO
