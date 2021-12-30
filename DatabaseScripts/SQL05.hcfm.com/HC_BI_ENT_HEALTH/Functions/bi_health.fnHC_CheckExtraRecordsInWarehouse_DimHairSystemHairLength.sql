/* CreateDate: 10/24/2011 14:09:41.453 , ModifyDate: 10/24/2011 14:09:41.453 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimHairSystemHairLength] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_DimHairSystemHairLength]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimHairSystemHairLength]()
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

 	SET @TableName = N'[bi_cms_dds].[DimHairSystemHairLength]'

	INSERT INTO @tbl
		SELECT @TableName, HairSystemHairLengthKey, HairSystemHairLengthSSID
		FROM [bi_health].[synHC_DDS_DimHairSystemHairLength] WITH (NOLOCK)
		WHERE HairSystemHairLengthSSID NOT
		IN (
				SELECT SRC.HairSystemHairLengthID
				FROM [bi_health].[synHC_SRC_TBL_CMS_lkpHairSystemHairLength] SRC WITH (NOLOCK)
				)
		AND HairSystemHairLengthKey <> -1







RETURN
END
GO
