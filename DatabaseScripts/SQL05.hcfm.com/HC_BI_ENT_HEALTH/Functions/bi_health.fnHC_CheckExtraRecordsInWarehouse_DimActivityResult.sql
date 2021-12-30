/* CreateDate: 05/13/2010 17:18:42.977 , ModifyDate: 05/13/2010 17:18:42.977 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimActivityResult] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_DimActivityResult]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimActivityResult]()
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

 	SET @TableName = N'[bi_mktg_dds].[DimActivityResult]'

	INSERT INTO @tbl
		SELECT @TableName, [ActivityResultKey], [ActivityResultSSID]
		FROM [bi_health].[synHC_DDS_DimActivityResult] WITH (NOLOCK)
		WHERE [ActivityResultSSID] NOT
		IN (
				SELECT SRC.[contact_completion_id]
				FROM [bi_health].[synHC_SRC_TBL_MKTG_cstd_contact_completion] SRC WITH (NOLOCK)
				)
		AND [ActivityResultKey] <> -1





RETURN
END
GO
