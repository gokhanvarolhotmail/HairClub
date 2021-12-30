/* CreateDate: 05/03/2010 12:08:49.237 , ModifyDate: 10/03/2019 21:37:25.040 */
GO
CREATE VIEW [bi_ent_dds].[vwDimEthnicity]
AS
-------------------------------------------------------------------------
-- [vwDimEthnicity] is used to retrieve a
-- list of Ethnicity
--
--   SELECT * FROM [bi_ent_dds].[vwDimEthnicity]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    10/12/2009  RLifke       Initial Creation
-------------------------------------------------------------------------

	SELECT	   [EthnicityKey]
			  ,[EthnicitySSID]
			  ,[EthnicityDescription]
			  ,[EthnicityDescriptionShort]
			  ,[RowIsCurrent]
			  ,[RowStartDate]
			  ,[RowEndDate]
	FROM [bi_ent_dds].[DimEthnicity]
GO
