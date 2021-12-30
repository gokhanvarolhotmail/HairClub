/* CreateDate: 05/03/2010 12:26:23.270 , ModifyDate: 05/03/2010 12:26:23.270 */
GO
CREATE PROCEDURE [bi_mktg_stage].[EmptyAllTables]
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

		DELETE FROM bi_mktg_stage.FactLead
		DELETE FROM bi_mktg_stage.FactActivityResults
		DELETE FROM bi_mktg_stage.FactActivity
		DELETE FROM bi_mktg_stage.DimSource
		DELETE FROM bi_mktg_stage.DimSalesType
		DELETE FROM bi_mktg_stage.DimResultCode
		DELETE FROM bi_mktg_stage.DimEmployee
		DELETE FROM bi_mktg_stage.DimContactSource
		DELETE FROM bi_mktg_stage.DimContactPhone
		DELETE FROM bi_mktg_stage.DimContactEmail
		DELETE FROM bi_mktg_stage.DimContactAddress
		DELETE FROM bi_mktg_stage.DimContact
		DELETE FROM bi_mktg_stage.DimActivityResult
		DELETE FROM bi_mktg_stage.DimActivityDemographic
		DELETE FROM bi_mktg_stage.DimActivity
		DELETE FROM bi_mktg_stage.DimActionCode



	UPDATE [bief_stage].[_DataFlow]
	   SET [LSET] = '2007-01-01 12:00:00:000AM'
		  ,[CET] = '2007-01-01 12:00:00:000AM'

END
GO
