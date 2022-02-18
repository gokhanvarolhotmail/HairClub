/* CreateDate: 02/04/2011 15:27:00.880 , ModifyDate: 01/27/2022 09:18:11.497 */
GO
CREATE VIEW [bi_mktg_dds].[vwDimPromotionCode] as

	SELECT
	PromotionCodeKey,
	PromotionCodeSSID,
	LEFT(PromotionCodeDescription, 40) AS PromotionCodeDescription,
	Active,
	RowIsCurrent,
	RowStartDate,
	RowEndDate
	From bi_mktg_dds.DimPromotionCode
GO
