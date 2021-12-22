/* CreateDate: 09/23/2019 12:25:23.313 , ModifyDate: 05/31/2020 14:35:16.617 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================
PROCEDURE:				selSalesConsultationSolutions

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Jeremy Miller

IMPLEMENTOR: 			Jeremy Miller

DATE IMPLEMENTED: 		 08/29/2019

LAST REVISION DATE: 	 08/29/2019

==============================================================================
DESCRIPTION:	Interface with OnContact database
==============================================================================
NOTES:
		* 08/29/2019 JLM - Created. Copied from extOnContactGetSolutionsList (TFS 12897)
		* 05/11/2020 AP - Modify. Fix XTR BusinessSegmentDescriptionShort case (TFS 14447)
		* 05/11/2020 AP - Modify selSalesConsultationSolutions Store procedure to incluce Surgery - HW(TFS 14448)
		* 05/25/2020 AP - Modify selSalesConsultationSolutions Store procedure to incluce Surgery from Canada - HC(TFS 14491)

==============================================================================
SAMPLE EXECUTION:
EXEC selSalesConsultationSolutions 244
==============================================================================
*/

CREATE PROCEDURE [dbo].[selSalesConsultationSolutions]
(
	@CenterID INT
)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @HWBrandDescriptionShort NVARCHAR(10) = 'HW'

	------ Include surgery to cONEctCorp that has IsHWIntegrationEnabled = 1
	SELECT BusinessSegmentDescriptionShort,BusinessSegmentDescription +'-HW' as BusinessSegmentDescription
	FROM cfgBusinessUnitBrandBusinessSegment bubbs
    INNER JOIN lkpBusinessUnitBrand bub ON bubbs.BusinessUnitBrandID = bub.BusinessUnitBrandID
    INNER JOIN lkpBusinessSegment bs ON bubbs.BusinessSegmentID = bs.BusinessSegmentID
	INNER JOIN cfgCenter c ON bub.BusinessUnitBrandID = c.BusinessUnitBrandID
    INNER JOIN cfgConfigurationCenter cc ON c.CenterID = cc.CenterID
    INNER JOIN lkpCenterBusinessType cbt ON cc.CenterBusinessTypeID = cbt.CenterBusinessTypeID
	WHERE c.CenterID = @CenterID
		AND (
				cc.IsLiveWithBosley = 0 AND
				cbt.CenterBusinessTypeDescriptionShort = 'cONEctCorp' AND
				bs.BusinessSegmentDescriptionShort = 'SUR' AND
				IsHWIntegrationEnabled = 1
				OR (cc.IsLiveWithBosley = 1 AND
				    (cbt.CenterBusinessTypeDescriptionShort = 'cONEctCorp'
					 AND bs.BusinessSegmentDescriptionShort = 'SUR' AND IsHWIntegrationEnabled = 1))
			)
    UNION ALL
	------ Include surgery to Canada centers MemberShip
	SELECT BusinessSegmentDescriptionShort,BusinessSegmentDescription +'-HC' as BusinessSegmentDescription
	FROM cfgBusinessUnitBrandBusinessSegment bubbs
    INNER JOIN lkpBusinessUnitBrand bub ON bubbs.BusinessUnitBrandID = bub.BusinessUnitBrandID
    INNER JOIN lkpBusinessSegment bs ON bubbs.BusinessSegmentID = bs.BusinessSegmentID
	INNER JOIN cfgCenter c ON bub.BusinessUnitBrandID = c.BusinessUnitBrandID
	INNER JOIN lkpCountry co ON co.CountryId = c.CountryId
    INNER JOIN cfgConfigurationCenter cc ON c.CenterID = cc.CenterID
    INNER JOIN lkpCenterBusinessType cbt ON cc.CenterBusinessTypeID = cbt.CenterBusinessTypeID
	WHERE c.CenterID = @CenterID
	     AND    cbt.CenterBusinessTypeDescriptionShort = 'cONEctCorp'
		 AND		bs.BusinessSegmentDescriptionShort = 'SUR'
		 AND    co.CountryDescription = 'Canada'
		 AND c.CenterTypeId = 1

    UNION ALL

	SELECT  bs.BusinessSegmentDescriptionShort,
			CASE bub.BusinessUnitBrandDescriptionShort
			WHEN @HWBrandDescriptionShort THEN
				CASE bs.BusinessSegmentDescriptionShort
				WHEN 'BIO' THEN
					'Hair'
				WHEN 'EXT' THEN
					'Restorative'
				WHEN 'SUR' THEN
					'Surgery'
				WHEN 'XTR' THEN
					'Micropoint'
				END
			ELSE
				    bs.BusinessSegmentDescription
			END as BusinessSegmentDescription
	FROM cfgBusinessUnitBrandBusinessSegment bubbs
    INNER JOIN lkpBusinessUnitBrand bub ON bubbs.BusinessUnitBrandID = bub.BusinessUnitBrandID
    INNER JOIN lkpBusinessSegment bs ON bubbs.BusinessSegmentID = bs.BusinessSegmentID
	INNER JOIN cfgCenter c ON bub.BusinessUnitBrandID = c.BusinessUnitBrandID
    INNER JOIN cfgConfigurationCenter cc ON c.CenterID = cc.CenterID
    INNER JOIN lkpCenterBusinessType cbt ON cc.CenterBusinessTypeID = cbt.CenterBusinessTypeID
	WHERE c.CenterID = @CenterID
		AND (
				cc.IsLiveWithBosley = 0
				OR (cc.IsLiveWithBosley = 1 AND (cbt.CenterBusinessTypeDescriptionShort = 'cONEctCorp' OR bs.BusinessSegmentDescriptionShort <> 'SUR'))
			)
	ORDER BY bs.BusinessSegmentDescriptionShort

END
GO
