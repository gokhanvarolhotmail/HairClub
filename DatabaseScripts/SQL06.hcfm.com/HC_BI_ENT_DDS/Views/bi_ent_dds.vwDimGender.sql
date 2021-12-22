/* CreateDate: 01/08/2021 15:21:54.383 , ModifyDate: 01/08/2021 15:21:54.383 */
GO
CREATE VIEW [bi_ent_dds].[vwDimGender]
AS
-------------------------------------------------------------------------
-- [vwDimGender] is used to retrieve a
-- list of Gender
--
--   SELECT * FROM [bi_ent_dds].[vwDimGender]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    10/12/2009  RLifke       Initial Creation
-------------------------------------------------------------------------

	SELECT	   [GenderKey]
			  ,[GenderSSID]
			  ,[GenderDescription]
			  ,[GenderDescriptionShort]
			  ,[RowIsCurrent]
			  ,[RowStartDate]
			  ,[RowEndDate]
	FROM [bi_ent_dds].[DimGender]
GO
