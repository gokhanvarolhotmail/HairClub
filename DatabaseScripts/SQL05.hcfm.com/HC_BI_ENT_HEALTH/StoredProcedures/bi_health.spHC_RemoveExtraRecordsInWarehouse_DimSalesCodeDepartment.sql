/* CreateDate: 05/12/2010 09:43:32.187 , ModifyDate: 05/13/2010 13:59:34.767 */
GO
CREATE PROCEDURE [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimSalesCodeDepartment]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimSalesCodeDepartment]
--
-- EXEC [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimSalesCodeDepartment]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

BEGIN

		DELETE
		FROM [bi_health].[synHC_DDS_DimSalesCodeDepartment]
		--SELECT [SalesCodeDepartmentKey], [SalesCodeDepartmentSSID]
		--FROM [bi_health].[synHC_DDS_DimSalesCodeDepartment] WITH (NOLOCK)
		WHERE [SalesCodeDepartmentSSID] NOT
		IN (
				SELECT SRC.SalesCodeDepartmentID
				FROM [bi_health].[synHC_SRC_TBL_CMS_lkpSalesCodeDepartment] SRC WITH (NOLOCK)
				)
		AND [SalesCodeDepartmentKey] <> -1


END
GO
