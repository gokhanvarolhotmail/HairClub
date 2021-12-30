/* CreateDate: 10/25/2011 08:34:16.070 , ModifyDate: 12/12/2012 15:55:14.960 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimHairSystemType] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_DimHairSystemType]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimHairSystemType]()
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

 	SET @TableName = N'[bi_cms_dds].[DimHairSystemType]'

	INSERT INTO @tbl
		SELECT @TableName, HairSystemTypeKey, HairSystemTypeSSID
		FROM [bi_health].[synHC_DDS_DimHairSystemType] WITH (NOLOCK)
		WHERE HairSystemTypeSSID NOT
		IN (
				SELECT SRC.HairSystemID
				FROM [bi_health].[synHC_SRC_TBL_CMS_cfgHairSystem] SRC WITH (NOLOCK)
				)
		AND HairSystemTypeKey <> -1







RETURN
END
GO
