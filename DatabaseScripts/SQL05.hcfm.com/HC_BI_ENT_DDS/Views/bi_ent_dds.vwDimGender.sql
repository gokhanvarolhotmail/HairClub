/* CreateDate: 05/03/2010 12:08:49.250 , ModifyDate: 10/03/2019 21:37:25.053 */
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
