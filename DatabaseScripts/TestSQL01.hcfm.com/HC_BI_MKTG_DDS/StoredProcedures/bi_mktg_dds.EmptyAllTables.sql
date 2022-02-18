/* CreateDate: 05/03/2010 12:21:12.007 , ModifyDate: 05/03/2010 12:21:12.007 */
GO
CREATE PROCEDURE [bi_mktg_dds].[EmptyAllTables]
AS

-----------------------------------------------------------------------
--
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

BEGIN

		DELETE FROM bi_mktg_dds.FactLead
		DELETE FROM bi_mktg_dds.FactActivityResults
		DELETE FROM bi_mktg_dds.FactActivity
		DELETE FROM bi_mktg_dds.DimSource
		DELETE FROM bi_mktg_dds.DimSalesType
		DELETE FROM bi_mktg_dds.DimResultCode
		DELETE FROM bi_mktg_dds.DimEmployee
		DELETE FROM bi_mktg_dds.DimContactSource
		DELETE FROM bi_mktg_dds.DimContactPhone
		DELETE FROM bi_mktg_dds.DimContactEmail
		DELETE FROM bi_mktg_dds.DimContactAddress
		DELETE FROM bi_mktg_dds.DimContact
		DELETE FROM bi_mktg_dds.DimActivityResult
		DELETE FROM bi_mktg_dds.DimActivityDemographic
		DELETE FROM bi_mktg_dds.DimActivity
		DELETE FROM bi_mktg_dds.DimActionCode

		DBCC CHECKIDENT ("bi_mktg_dds.DimSource", RESEED, 1)
		DBCC CHECKIDENT ("bi_mktg_dds.DimSalesType", RESEED, 1)
		DBCC CHECKIDENT ("bi_mktg_dds.DimResultCode", RESEED, 1)
		DBCC CHECKIDENT ("bi_mktg_dds.DimEmployee", RESEED, 1)
		DBCC CHECKIDENT ("bi_mktg_dds.DimContactSource", RESEED, 1)
		DBCC CHECKIDENT ("bi_mktg_dds.DimContactPhone", RESEED, 1)
		DBCC CHECKIDENT ("bi_mktg_dds.DimContactEmail", RESEED, 1)
		DBCC CHECKIDENT ("bi_mktg_dds.DimContactAddress", RESEED, 1)
		DBCC CHECKIDENT ("bi_mktg_dds.DimContact", RESEED, 1)
		DBCC CHECKIDENT ("bi_mktg_dds.DimActivityResult", RESEED, 1)
		DBCC CHECKIDENT ("bi_mktg_dds.DimActivityDemographic", RESEED, 1)
		DBCC CHECKIDENT ("bi_mktg_dds.DimActivity", RESEED, 1)
		DBCC CHECKIDENT ("bi_mktg_dds.DimActionCode", RESEED, 1)


END
GO
