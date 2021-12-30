/* CreateDate: 10/24/2011 14:23:37.720 , ModifyDate: 10/24/2011 14:23:37.720 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimHairSystemRecession] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_DimHairSystemRecession]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimHairSystemRecession]()
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

 	SET @TableName = N'[bi_cms_dds].[DimHairSystemRecession]'

	INSERT INTO @tbl
		SELECT @TableName, HairSystemRecessionKey, HairSystemRecessionSSID
		FROM [bi_health].[synHC_DDS_DimHairSystemRecession] WITH (NOLOCK)
		WHERE HairSystemRecessionSSID NOT
		IN (
				SELECT SRC.HairSystemRecessionID
				FROM [bi_health].[synHC_SRC_TBL_CMS_lkpHairSystemRecession] SRC WITH (NOLOCK)
				)
		AND HairSystemRecessionKey <> -1







RETURN
END
GO
