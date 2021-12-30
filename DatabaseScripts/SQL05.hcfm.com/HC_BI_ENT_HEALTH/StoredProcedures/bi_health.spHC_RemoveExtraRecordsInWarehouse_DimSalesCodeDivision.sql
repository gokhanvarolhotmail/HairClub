/* CreateDate: 05/12/2010 09:43:07.193 , ModifyDate: 05/13/2010 14:00:19.963 */
GO
CREATE PROCEDURE [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimSalesCodeDivision]

AS

-----------------------------------------------------------------------
-- [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimSalesCodeDivision]
--
-- EXEC [bi_health].[spHC_RemoveExtraRecordsInWarehouse_DimSalesCodeDivision]
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

BEGIN

		DELETE
		FROM [bi_health].[synHC_DDS_DimSalesCodeDivision]
		--SELECT [SalesCodeDivisionKey], [SalesCodeDivisionSSID]
		--FROM [bi_health].[synHC_DDS_DimSalesCodeDivision] WITH (NOLOCK)
		WHERE [SalesCodeDivisionSSID] NOT
		IN (
				SELECT SRC.SalesCodeDivisionID
				FROM [bi_health].[synHC_SRC_TBL_CMS_lkpSalesCodeDivision] SRC WITH (NOLOCK)
				)
		AND [SalesCodeDivisionKey] <> -1


END
GO
