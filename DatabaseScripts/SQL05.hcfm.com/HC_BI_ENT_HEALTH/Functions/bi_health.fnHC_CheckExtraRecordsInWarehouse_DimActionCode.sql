/* CreateDate: 05/13/2010 17:05:40.260 , ModifyDate: 11/29/2012 13:38:34.857 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimActionCode] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_DimActionCode]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimActionCode]()
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

RETURNS @tbl  TABLE ( TableName varchar(150)
					, FieldKey bigint
					, FieldSSID varchar(150)
					)  AS
BEGIN



	DECLARE	 @TableName				varchar(150)	-- Name of table

 	SET @TableName = N'[bi_mktg_dds].[DimActionCode]'

	INSERT INTO @tbl
		SELECT @TableName, [ActionCodeKey], [ActionCodeSSID]
		FROM [bi_health].[synHC_DDS_DimActionCode] WITH (NOLOCK)
		WHERE [ActionCodeSSID] NOT
		IN (
				SELECT SRC.action_code
				FROM [bi_health].[synHC_SRC_TBL_MKTG_onca_action] SRC WITH (NOLOCK)
				)
		AND [ActionCodeKey] <> -1




RETURN
END
GO
