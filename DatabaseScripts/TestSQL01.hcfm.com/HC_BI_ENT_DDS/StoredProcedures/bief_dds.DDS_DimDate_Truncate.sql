/* CreateDate: 05/03/2010 12:08:53.287 , ModifyDate: 09/24/2014 11:41:44.760 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [bief_dds].[DDS_DimDate_Truncate]


AS
-------------------------------------------------------------------------
-- [DDS_DimDate_Truncate] is used to cleanup all tables
-- before loading.
--
--
--   EXEC [bief_dds].[DDS_DimDate_Truncate]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0                RLifke       Initial Creation
-------------------------------------------------------------------------
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--DELETE FROM [bief_dds].[DimDate]
	--DBCC CHECKIDENT ('[bief_dds].[DimDate]', RESEED, 0)
	TRUNCATE TABLE [bief_dds].[DimDate]


	-- Cleanup
	-- Reset SET NOCOUNT to OFF.
	SET NOCOUNT OFF

	-- Cleanup temp tables

	-- Return success
	RETURN 0

END
GO
