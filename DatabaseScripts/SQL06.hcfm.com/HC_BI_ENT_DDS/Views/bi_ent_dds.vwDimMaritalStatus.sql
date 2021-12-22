/* CreateDate: 01/08/2021 15:21:54.450 , ModifyDate: 01/08/2021 15:21:54.450 */
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
