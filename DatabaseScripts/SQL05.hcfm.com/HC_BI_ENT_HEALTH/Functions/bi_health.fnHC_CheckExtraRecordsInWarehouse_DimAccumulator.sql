/* CreateDate: 05/13/2010 20:31:45.460 , ModifyDate: 05/13/2010 20:31:45.460 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimAccumulator] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_DimAccumulator]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimAccumulator]()
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

 	SET @TableName = N'[bi_cms_dds].[DimAccumulator]'

	INSERT INTO @tbl
		SELECT @TableName, [AccumulatorKey], [AccumulatorSSID]
		FROM [bi_health].[synHC_DDS_DimAccumulator] WITH (NOLOCK)
		WHERE [AccumulatorSSID] NOT
		IN (
				SELECT SRC.AccumulatorID
				FROM [bi_health].[synHC_SRC_TBL_CMS_cfgAccumulator] SRC WITH (NOLOCK)
				)
		AND [AccumulatorKey] <> -1







RETURN
END
GO
