/* CreateDate: 01/08/2021 15:21:54.260 , ModifyDate: 01/08/2021 15:21:54.260 */
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
