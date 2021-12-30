/* CreateDate: 10/25/2011 08:38:50.500 , ModifyDate: 10/25/2011 08:39:29.120 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimHairSystemVendorContract] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_DimHairSystemVendorContract]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimHairSystemVendorContract]()
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

 	SET @TableName = N'[bi_cms_dds].[DimHairSystemVendorContract]'

	INSERT INTO @tbl
		SELECT @TableName, HairSystemVendorContractKey, HairSystemVendorContractSSID
		FROM [bi_health].[synHC_DDS_DimHairSystemVendorContract] WITH (NOLOCK)
		WHERE HairSystemVendorContractSSID NOT
		IN (
				SELECT SRC.HairSystemVendorContractID
				FROM [bi_health].[synHC_SRC_TBL_CMS_lkpHairSystemVendorContract] SRC WITH (NOLOCK)
				)
		AND HairSystemVendorContractKey <> -1







RETURN
END
GO
