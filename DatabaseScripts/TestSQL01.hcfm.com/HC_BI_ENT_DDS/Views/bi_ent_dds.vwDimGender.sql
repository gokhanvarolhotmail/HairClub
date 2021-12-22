/* CreateDate: 05/03/2010 12:08:49.250 , ModifyDate: 09/16/2019 09:25:18.207 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
