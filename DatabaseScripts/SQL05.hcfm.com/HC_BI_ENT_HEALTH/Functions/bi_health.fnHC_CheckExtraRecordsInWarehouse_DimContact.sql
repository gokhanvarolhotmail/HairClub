/* CreateDate: 05/13/2010 17:21:23.113 , ModifyDate: 05/13/2010 17:21:23.113 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimContact] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_DimContact]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimContact]()
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

 	SET @TableName = N'[bi_mktg_dds].[DimContact]'

	INSERT INTO @tbl
		SELECT @TableName, [ContactKey], [ContactSSID]
		FROM [bi_health].[synHC_DDS_DimContact] WITH (NOLOCK)
		WHERE [ContactSSID] NOT
		IN (
				SELECT SRC.[contact_id]
				FROM [bi_health].[synHC_SRC_TBL_MKTG_oncd_contact] SRC WITH (NOLOCK)
				)
		AND [ContactKey] <> -1





RETURN
END
GO
