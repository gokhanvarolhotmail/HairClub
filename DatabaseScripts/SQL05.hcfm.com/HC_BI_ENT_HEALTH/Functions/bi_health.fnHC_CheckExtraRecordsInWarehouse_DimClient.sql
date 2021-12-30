/* CreateDate: 05/13/2010 20:02:17.283 , ModifyDate: 05/13/2010 20:02:17.283 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimClient] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_DimClient]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimClient]()
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

 	SET @TableName = N'[bi_cms_dds].[DimClient]'

	INSERT INTO @tbl
		SELECT @TableName, [ClientKey], [ClientSSID]
		FROM [bi_health].[synHC_DDS_DimClient] WITH (NOLOCK)
		WHERE [ClientSSID] NOT
		IN (
				SELECT SRC.ClientGUID
				FROM [bi_health].[synHC_SRC_TBL_CMS_datClient] SRC WITH (NOLOCK)
				)
		AND [ClientKey] <> -1







RETURN
END
GO
