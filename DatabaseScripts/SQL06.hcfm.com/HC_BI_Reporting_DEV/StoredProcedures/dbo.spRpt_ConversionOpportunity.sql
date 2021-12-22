/* CreateDate: 11/30/2018 11:50:41.350 , ModifyDate: 12/04/2018 13:38:54.787 */
GO
/***********************************************************************
PROCEDURE:				spRpt_ConversionOpportunity
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting_DEV
RELATED REPORT:			spRpt_ConversionOpportunity
AUTHOR:					Mauricio Hurtado
DATE IMPLEMENTED:
------------------------------------------------------------------------
NOTES:


------------------------------------------------------------------------

EXEC spRpt_ConversionOpportunity
***********************************************************************/

CREATE PROCEDURE spRpt_ConversionOpportunity


AS
BEGIN

DECLARE @StartDate DATETIME
DECLARE @EndDate   DATETIME


SET @StartDate = DATETIMEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1, 0, 0, 0, 0)
SET @EndDate = DATEADD(DAY,-1,DATEADD(MONTH,1,@StartDate)) + '23:59:000'


PRINT @StartDate
PRINT @EndDate


/********************************** Get list of centers *************************************/
;WITH Centers as (
		SELECT  CMA.CenterManagementAreaSSID
		,		CMA.CenterManagementAreaDescription
		,		CMA.CenterManagementAreaSortOrder
		,		CenterNumber
		,		DC.CenterSSID
		,		CenterDescription
		,		DC.CenterDescriptionNumber

		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
							ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
		WHERE  DCT.CenterTypeDescriptionShort = 'c'
				AND DC.Active = 'Y'

)

/********************************** Populate #Potential Table *************************************/

	   SELECT	C.CenterManagementAreaSSID
	   ,		C.CenterManagementAreaDescription
	   ,		C.CenterNumber
	   ,		C.CenterDescriptionNumber
	   ,		CLT.ClientIdentifier
	   ,		CLT.ClientFirstName
	   ,		CLT.ClientLastName
	   ,		CLT.ExpectedConversionDate
	   ,		DM.RevenueGroupSSID
	   ,		DM.RevenueGroupDescription
	   ,		DM.BusinessSegmentSSID
	   ,		DM.BusinessSegmentDescription
	   ,		DM.MembershipDescription

	   FROM		Centers C
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
					ON C.CenterSSID = CLT.CenterSSID
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
					ON ( DCM.ClientMembershipSSID = CLT.CurrentBioMatrixClientMembershipSSID
										  OR DCM.ClientMembershipSSID = CLT.CurrentExtremeTherapyClientMembershipSSID
										  OR DCM.ClientMembershipSSID = CLT.CurrentXtrandsClientMembershipSSID )
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
					ON DCM.MembershipKey = DM.MembershipKey
		WHERE ExpectedConversionDate BETWEEN @StartDate AND @EndDate
				AND BusinessSegmentSSID IN (1,2,6)
				AND RevenueGroupSSID = 1

END
GO
