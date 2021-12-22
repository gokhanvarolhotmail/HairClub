/* CreateDate: 09/03/2021 09:37:08.180 , ModifyDate: 09/03/2021 09:37:08.180 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
