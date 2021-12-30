/* CreateDate: 05/13/2010 17:38:28.590 , ModifyDate: 05/13/2010 17:38:28.590 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_FactLead] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_FactLead]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_FactLead]()
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

 	SET @TableName = N'[bi_mktg_dds].[FactLead]'

	INSERT INTO @tbl
		SELECT @TableName, DW.[ContactKey], ''
		FROM [bi_health].[synHC_DDS_FactLead] DW WITH (NOLOCK)
		LEFT OUTER JOIN [bi_health].[synHC_DDS_DimContact] da WITH (NOLOCK)
		ON da.ContactKey = DW.[ContactKey]
		WHERE da.[ContactSSID] NOT
		IN (
				SELECT SRC.contact_id
				FROM [bi_health].[synHC_SRC_TBL_MKTG_oncd_contact] SRC WITH (NOLOCK)
			)







RETURN
END
GO
