/* CreateDate: 05/13/2010 20:29:06.947 , ModifyDate: 05/13/2010 20:29:06.947 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimAccumulatorActionType] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_DimAccumulatorActionType]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimAccumulatorActionType]()
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

 	SET @TableName = N'[bi_cms_dds].[DimAccumulatorActionType]'

	INSERT INTO @tbl
		SELECT @TableName, [AccumulatorActionTypeKey], [AccumulatorActionTypeSSID]
		FROM [bi_health].[synHC_DDS_DimAccumulatorActionType] WITH (NOLOCK)
		WHERE [AccumulatorActionTypeSSID] NOT
		IN (
				SELECT SRC.AccumulatorActionTypeID
				FROM [bi_health].[synHC_SRC_TBL_CMS_lkpAccumulatorActionType] SRC WITH (NOLOCK)
				)
		AND [AccumulatorActionTypeKey] <> -1







RETURN
END
GO
