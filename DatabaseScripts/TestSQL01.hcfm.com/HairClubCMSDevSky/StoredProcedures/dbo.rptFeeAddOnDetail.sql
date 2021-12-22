/* CreateDate: 05/20/2019 11:41:26.970 , ModifyDate: 05/21/2019 10:30:16.680 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				rptFeeAddOnDetail
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	HairclubCMS
RELATED REPORT:
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:
------------------------------------------------------------------------
NOTES:
This provides the Add-On detail for the summary report
------------------------------------------------------------------------
CHANGE HISTORY:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC rptFeeAddOnDetail 292, 112677
***********************************************************************/
CREATE PROCEDURE [dbo].[rptFeeAddOnDetail]
(
		@centerId INT
	,	@ClientIdentifier INT
)
AS
BEGIN

	SET FMTONLY OFF;

SELECT CM.CenterID
,	CTR.CenterDescriptionFullCalc
,	CLT.ClientIdentifier
,	CLT.ClientFullNameCalc
,	CLT.ClientGUID
,	ADDON.AddOnDescription
,   ISNULL(CMAO.MonthlyFee,0) AS AddOnMonthlyFee
,	AOT.AddOnTypeDescription
,	STAT.ClientMembershipAddOnStatusDescription
FROM dbo.datClientMembershipAddOn CMAO
INNER JOIN dbo.cfgAddOn ADDON
	ON ADDON.AddOnID = CMAO.AddOnID
INNER JOIN dbo.datClientMembership CM
	ON CM.ClientMembershipGUID = CMAO.ClientMembershipGUID
INNER JOIN dbo.datClient CLT
	ON CLT.ClientGUID = CM.ClientGUID
INNER JOIN dbo.lkpAddOnType AOT
	ON AOT.AddOnTypeID = ADDON.AddOnTypeID
INNER JOIN dbo.lkpClientMembershipAddOnStatus STAT
	ON STAT.ClientMembershipAddOnStatusID = CMAO.ClientMembershipAddOnStatusID
INNER JOIN dbo.cfgCenter CTR
	ON CTR.CenterID = CLT.CenterID
WHERE  CMAO.ClientMembershipAddOnStatusID = 1 --Active
AND CLT.ClientIdentifier = @ClientIdentifier
AND CMAO.MonthlyFee IS NOT NULL
AND CM.CenterID = @centerId
AND AOT.IsMonthlyAddOnType = 1

END
GO
