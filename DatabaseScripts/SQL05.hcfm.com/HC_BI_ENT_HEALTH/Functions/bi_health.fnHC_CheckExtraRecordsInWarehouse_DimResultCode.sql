/* CreateDate: 05/13/2010 17:30:14.727 , ModifyDate: 05/13/2010 17:30:14.727 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimResultCode] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_DimResultCode]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimResultCode]()
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

 	SET @TableName = N'[bi_mktg_dds].[DimResultCode]'

	INSERT INTO @tbl
		SELECT @TableName, [ResultCodeKey], [ResultCodeSSID]
		FROM [bi_health].[synHC_DDS_DimResultCode] WITH (NOLOCK)
		WHERE [ResultCodeSSID] NOT
		IN (
				SELECT SRC.[result_code]
				FROM [bi_health].[synHC_SRC_TBL_MKTG_onca_result] SRC WITH (NOLOCK)
				)
		AND [ResultCodeKey] <> -1






RETURN
END
GO
