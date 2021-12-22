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
