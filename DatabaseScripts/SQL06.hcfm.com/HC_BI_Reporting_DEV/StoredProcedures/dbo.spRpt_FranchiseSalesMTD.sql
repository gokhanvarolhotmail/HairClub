/* CreateDate: 08/21/2012 16:53:52.493 , ModifyDate: 04/19/2016 11:21:05.953 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
-- Procedure Name:			spRpt_FranchiseSalesMTD
-- Created By:             HDu
-- Implemented By:         HDu
-- Last Modified By:       HDu
--
-- Date Created:           8/21/2012
-- Date Implemented:       8/21/2012
-- Date Last Modified:     8/21/2012
--
-- Destination Server:		SQL06
-- Destination Database:	HC_BI_Reporting
-- Related Application:
-- ----------------------------------------------------------------------------------------------
-- Notes:
03/30/2016 - RH - Changed to pull all franchise centers WHERE CenterSSID like '[78]%'
04/19/2016 - RH - Added SUM(t.NB_XtrAmt) to the Revenue for NB1
-- ----------------------------------------------------------------------------------------------
Sample Execution:
EXEC spRpt_FranchiseSalesMTD 2, 2016
================================================================================================*/
CREATE PROCEDURE [dbo].[spRpt_FranchiseSalesMTD]
(
	@Month INT,
	@Year INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/*
		Select NB1, NB2, PCP, Retail and Service transactions for the specified month and year.
	*/
	SELECT  ce.CenterSSID AS 'CenterNumber'
	,		ce.CenterDescriptionNumber AS 'FranchiseName'
	,		LEFT(ISNULL(ct.CenterTypeDescription, ''), 1) AS 'Type'
	,       SUM(t.NB_TradAmt) + SUM(t.NB_ExtAmt) + SUM(t.NB_GradAmt) + SUM(t.NB_XtrAmt) AS 'NB1'
	,       SUM(t.PCP_NB2Amt) - SUM(t.PCP_PCPAmt) AS 'NB2'
	,       SUM(t.PCP_PCPAmt) AS 'PCP'
	,       SUM(t.ServiceAmt) AS 'Service'
	,       SUM(t.RetailAmt) AS 'Retail'
	FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction t
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce
			ON ce.CenterKey = t.CenterKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct
			ON ct.CenterTypeKey = ce.CenterTypeKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
			ON d.DateKey = t.OrderDateKey
	WHERE  d.MonthNumber = @Month
		AND d.YearNumber = @Year
		AND CenterSSID like '[78]%'
	GROUP BY ce.CenterSSID
		,	ce.CenterDescriptionNumber
		,	ct.CenterTypeDescription

END
GO
