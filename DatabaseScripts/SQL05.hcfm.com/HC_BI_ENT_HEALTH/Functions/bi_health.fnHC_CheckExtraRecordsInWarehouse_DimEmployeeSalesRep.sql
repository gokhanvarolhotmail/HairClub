/* CreateDate: 05/13/2010 17:28:42.277 , ModifyDate: 05/13/2010 17:28:42.277 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimEmployeeSalesRep] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_DimEmployeeSalesRep]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimEmployeeSalesRep]()
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

 	SET @TableName = N'[bi_mktg_dds].[DimEmployee]'

	INSERT INTO @tbl
		SELECT @TableName, [EmployeeKey], [EmployeeSSID]
		FROM [bi_health].[synHC_DDS_DimEmployeeSalesRep] WITH (NOLOCK)
		WHERE [EmployeeSSID] NOT
		IN (
				SELECT SRC.[user_code]
				FROM [bi_health].[synHC_SRC_TBL_MKTG_onca_user] SRC WITH (NOLOCK)
				)
		AND [EmployeeKey] <> -1






RETURN
END
GO
