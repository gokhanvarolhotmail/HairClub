/* CreateDate: 05/12/2010 09:37:58.733 , ModifyDate: 05/13/2010 13:55:41.763 */
GO
CREATE PROCEDURE [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimEmployee]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimEmployee]
--
-- EXEC [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimEmployee]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

BEGIN

		DELETE
		FROM [bi_health].[synHC_DDS_DimEmployee]
		--SELECT [EmployeeKey], [EmployeeSSID]
		--FROM [bi_health].[synHC_DDS_DimEmployee] WITH (NOLOCK)
		WHERE [EmployeeSSID] NOT
		IN (
				SELECT SRC.EmployeeGUID
				FROM [bi_health].[synHC_SRC_TBL_CMS_datEmployee] SRC WITH (NOLOCK)
				)
		AND [EmployeeKey] <> -1


END
GO
