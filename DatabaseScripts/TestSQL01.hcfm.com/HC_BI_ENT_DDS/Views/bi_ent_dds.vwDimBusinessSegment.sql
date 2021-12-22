/* CreateDate: 05/03/2010 12:08:49.110 , ModifyDate: 09/16/2019 09:25:18.197 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [bi_ent_dds].[vwDimBusinessSegment]
AS
-------------------------------------------------------------------------
-- [vwDimBusinessSegment] is used to retrieve a
-- list of Business Segments
--
--   SELECT * FROM [bi_ent_dds].[vwDimBusinessSegment]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/15/2009  RLifke       Initial Creation
-------------------------------------------------------------------------


	SELECT		  BusinessSegmentKey
				, BusinessSegmentSSID
				, BusinessSegmentDescription
				, BusinessSegmentDescriptionShort
				, BusinessUnitKey
				, BusinessUnitSSID
				, RowIsCurrent
				, RowStartDate
				, RowEndDate
	FROM         bi_ent_dds.DimBusinessSegment
GO
