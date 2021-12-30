/* CreateDate: 02/04/2011 15:27:00.880 , ModifyDate: 10/03/2019 21:54:30.430 */
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
