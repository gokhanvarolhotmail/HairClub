/* CreateDate: 05/03/2010 12:08:49.307 , ModifyDate: 10/03/2019 21:37:25.100 */
GO
CREATE VIEW [bi_ent_dds].[vwDimMaritalStatus]
AS
-------------------------------------------------------------------------
-- [vwDimMaritalStatus] is used to retrieve a
-- list of MaritalStatus
--
--   SELECT * FROM [bi_ent_dds].[vwDimMaritalStatus]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    10/12/2009  RLifke       Initial Creation
-------------------------------------------------------------------------

	SELECT	   [MaritalStatusKey]
			  ,[MaritalStatusSSID]
			  ,[MaritalStatusDescription]
			  ,[MaritalStatusDescriptionShort]
			  ,[RowIsCurrent]
			  ,[RowStartDate]
			  ,[RowEndDate]
	FROM [bi_ent_dds].[DimMaritalStatus]
GO
