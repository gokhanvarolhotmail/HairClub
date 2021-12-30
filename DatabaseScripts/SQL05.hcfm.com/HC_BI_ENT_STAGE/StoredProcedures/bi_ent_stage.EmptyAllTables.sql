/* CreateDate: 05/03/2010 12:09:37.817 , ModifyDate: 05/03/2010 12:09:37.817 */
GO
CREATE PROCEDURE [bi_ent_stage].[EmptyAllTables]
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

	DELETE FROM bi_ent_stage.DimTimeZone
	DELETE FROM bi_ent_stage.DimRevenueGroup
	DELETE FROM bi_ent_stage.DimDoctorRegion
	DELETE FROM bi_ent_stage.DimCenter
	DELETE FROM bi_ent_stage.DimCenterType
	DELETE FROM bi_ent_stage.DimCenterOwnership
	DELETE FROM bi_ent_stage.DimBusinessUnit
	DELETE FROM bi_ent_stage.DimBusinessSegment
	DELETE FROM bi_ent_stage.DimBusinessUnitBrand

	UPDATE [bief_stage].[_DataFlow]
	   SET [LSET] = '2009-01-01 12:00:00:000AM'
		  ,[CET] = '2009-01-01 12:00:00:000AM'

END
GO
