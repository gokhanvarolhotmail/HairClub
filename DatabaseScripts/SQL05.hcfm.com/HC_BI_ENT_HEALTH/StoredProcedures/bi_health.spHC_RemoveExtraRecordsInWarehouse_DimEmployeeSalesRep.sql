/* CreateDate: 05/08/2010 09:39:17.973 , ModifyDate: 05/13/2010 13:57:33.847 */
GO
CREATE PROCEDURE [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimEmployeeSalesRep]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimEmployeeSalesRep]
--
-- EXEC [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimEmployeeSalesRep]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

BEGIN

		DELETE
		FROM [bi_health].[synHC_DDS_DimEmployeeSalesRep]
		--SELECT [EmployeeKey], [EmployeeSSID]
		--FROM [bi_health].[synHC_DDS_DimEmployeeSalesRep] WITH (NOLOCK)
		WHERE [EmployeeSSID] NOT
		IN (
				SELECT SRC.[user_code]
				FROM [bi_health].[synHC_SRC_TBL_MKTG_onca_user] SRC WITH (NOLOCK)
				)
		AND [EmployeeKey] <> -1


END
GO
