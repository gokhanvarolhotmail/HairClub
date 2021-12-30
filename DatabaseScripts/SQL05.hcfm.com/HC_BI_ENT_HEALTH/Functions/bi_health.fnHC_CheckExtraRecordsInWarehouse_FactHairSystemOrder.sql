/* CreateDate: 10/25/2011 14:09:21.677 , ModifyDate: 10/25/2011 14:09:21.677 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_FactHairSystemOrder] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_FactHairSystemOrder]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_FactHairSystemOrder]()
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

 	SET @TableName = N'[bi_mktg_dds].[FactHairSystemOrder]'

	INSERT INTO @tbl
		SELECT @TableName, HSO.HairSystemOrderKey, HSO.HairSystemOrderSSID
		FROM [bi_health].[synHC_DDS_FactHairSystemOrder] HSO WITH (NOLOCK)
		WHERE HSO.HairSystemOrderSSID NOT
		IN (
				SELECT SRC.HairSystemOrderGUID
				FROM bi_health.synHC_SRC_TBL_CMS_datHairSystemOrder SRC WITH (NOLOCK)
			)

RETURN
END
GO
