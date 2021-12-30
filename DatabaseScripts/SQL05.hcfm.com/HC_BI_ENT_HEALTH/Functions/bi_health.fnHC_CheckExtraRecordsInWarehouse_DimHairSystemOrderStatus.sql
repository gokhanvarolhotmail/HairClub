/* CreateDate: 10/24/2011 14:19:42.630 , ModifyDate: 10/24/2011 14:19:42.630 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimHairSystemOrderStatus] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_DimHairSystemOrderStatus]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimHairSystemOrderStatus]()
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

 	SET @TableName = N'[bi_cms_dds].[DimHairSystemOrderStatus]'

	INSERT INTO @tbl
		SELECT @TableName, HairSystemOrderStatusKey, HairSystemOrderStatusSSID
		FROM [bi_health].[synHC_DDS_DimHairSystemOrderStatus] WITH (NOLOCK)
		WHERE HairSystemOrderStatusSSID NOT
		IN (
				SELECT SRC.HairSystemOrderStatusID
				FROM [bi_health].[synHC_SRC_TBL_CMS_lkpHairSystemOrderStatus] SRC WITH (NOLOCK)
				)
		AND HairSystemOrderStatusKey <> -1







RETURN
END
GO
