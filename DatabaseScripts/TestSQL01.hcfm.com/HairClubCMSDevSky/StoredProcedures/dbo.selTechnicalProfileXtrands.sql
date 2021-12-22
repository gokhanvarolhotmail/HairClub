/* CreateDate: 02/27/2017 06:46:35.180 , ModifyDate: 07/08/2020 23:06:31.067 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
	PROCEDURE:				[selTechnicalProfileXtrands]
	DESTINATION SERVER:		SQL01
	DESTINATION DATABASE: 	HairClubCMS
	RELATED APPLICATION:  	CMS
	AUTHOR: 				PRM
	IMPLEMENTOR: 			PRM
	DATE IMPLEMENTED: 		02/06/2017
	LAST REVISION DATE: 	07/19/2019
	--------------------------------------------------------------------------------------------------------
	NOTES: 	Return a single Xtrands Technical Profile - does NOT include Areas of Concern, Hair Strands Color, Placement, Styling Products, or Strand Builder Color records

			02/07/2017 - PRM Created Stored Proc
			02/09/2017 - SAL Modified to return tp.LastUpdateUser
			02/20/2017 - SAL Added Minoxidil fields
			05/23/2017 - SAL Modified to return Strands fields
			07/19/2019 - JLM Modified to return other service duration (TFS #12568)
			06/25/2020 - AP Include LastUpdate (TFS# 14550)

	--------------------------------------------------------------------------------------------------------
	SAMPLE EXECUTION:
	EXEC [selTechnicalProfileXtrands] '7BE39604-BD0F-45E0-B5FF-00000EB1EEC4'
***********************************************************************/
CREATE PROCEDURE [dbo].[selTechnicalProfileXtrands]
	@ClientGuid uniqueidentifier

AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT TOP 1
        tp.TechnicalProfileID, tp.TechnicalProfileDate,tp.LastUpdate, tp.ClientGUID, tp.Notes, tp.LastUpdateUser,
			tp.EmployeeGUID, e.UserLogin,
			tp.SalesOrderGUID, so.InvoiceNumber, soe.EmployeeInitials,
        color.TechnicalProfileColorID,
			color.ColorBrandID, cb.ColorBrandDescription, cb.ColorBrandDescriptionShort,
			color.ColorFormula1, color.ColorFormulaSize1ID, cfs1.ColorFormulaSizeDescription AS ColorFormulaSize1Description, cfs1.ColorFormulaSizeDescriptionShort AS ColorFormulaSize1DescriptionShort,
			color.ColorFormula2, color.ColorFormulaSize2ID, cfs2.ColorFormulaSizeDescription AS ColorFormulaSize2Description, cfs2.ColorFormulaSizeDescriptionShort AS ColorFormulaSize2DescriptionShort,
			color.ColorFormula3, color.ColorFormulaSize3ID, cfs3.ColorFormulaSizeDescription AS ColorFormulaSize3Description, cfs3.ColorFormulaSizeDescriptionShort AS ColorFormulaSize3DescriptionShort,
			color.DeveloperSizeID, ds.DeveloperSizeDescription, ds.DeveloperSizeDescriptionShort,
			color.DeveloperVolumeID, dv.DeveloperVolumeDescription, dv.DeveloperVolumeDescriptionShort,
			color.ColorProcessingTime, color.ColorProcessingTimeUnitID, cptu.TimeUnitDescription AS ColorProcessingTimeUnitDescription, cptu.TimeUnitDescriptionShort AS ColorProcessingTimeUnitDescriptionShort,
		xtrands.TechnicalProfileXtrandsID,
			xtrands.LastTrichoViewDate, xtrands.LastXtrandsServiceDate,
			xtrands.HairStrandGroupID, hsg.HairStrandGroupDescription, hsg.HairStrandGroupDescriptionShort,
			xtrands.HairHealthID, hh.HairHealthDescription, hh.HairHealthDescriptionShort,
			xtrands.LaserDeviceSalesCodeID, ldsc.SalesCodeDescription AS LaserDeviceSalesCodeDescription, ldsc.SalesCodeDescriptionShort AS LaserDeviceSalesCodeDescriptionShort,
			xtrands.ShampooSalesCodeID, ssc.SalesCodeDescription AS ShampooSalesCodeDescription, ssc.SalesCodeDescriptionShort AS ShampooSalesCodeDescriptionShort,
			xtrands.ConditionerSalesCodeID, cosc.SalesCodeDescription AS ConditionerSalesCodeDescription, cosc.SalesCodeDescriptionShort AS ConditionerSalesCodeDescriptionShort,
			xtrands.IsMinoxidilUsed, xtrands.MinoxidilSalesCodeID, msc.SalesCodeDescription AS MinoxidilSalesCodeDescription, msc.SalesCodeDescriptionShort AS MinoxidilSalesCodeDescriptionShort,
			xtrands.Other, xtrands.ServiceDuration,
			xtrands.ServiceTimeUnitID, stu.TimeUnitDescription AS ServiceTimeUnitDescription, stu.TimeUnitDescriptionShort AS ServiceTimeUnitDescriptionShort,
			xtrands.Strands,
			xtrands.OtherServiceDuration, xtrands.OtherServiceTimeUnitID, ostu.TimeUnitDescription AS OtherServiceTimeUnitDescription, ostu.TimeUnitDescriptionShort AS OtherServiceTimeUnitDescriptionShort,
			xtrands.OtherServiceSalesCodeID, ossc.SalesCodeDescription AS OtherServiceSalesCodeDescription, ossc.SalesCodeDescriptionShort AS OtherServiceSalesCodeDescriptionShort
    FROM datTechnicalProfile tp
		INNER JOIN datClient c ON tp.ClientGUID = c.ClientGUID
		LEFT JOIN datEmployee e ON tp.EmployeeGUID = e.EmployeeGUID
		LEFT JOIN datSalesOrder so ON tp.SalesOrderGUID = so.SalesOrderGUID
		LEFT JOIN datEmployee soe ON so.EmployeeGUID = soe.EmployeeGUID
		LEFT JOIN datTechnicalProfileColor color ON tp.TechnicalProfileID = color.TechnicalProfileID
			LEFT JOIN lkpColorBrand cb ON color.ColorBrandID = cb.ColorBrandID
			LEFT JOIN lkpColorFormulaSize cfs1 ON color.ColorFormulaSize1ID = cfs1.ColorFormulaSizeID
			LEFT JOIN lkpColorFormulaSize cfs2 ON color.ColorFormulaSize2ID = cfs2.ColorFormulaSizeID
			LEFT JOIN lkpColorFormulaSize cfs3 ON color.ColorFormulaSize3ID = cfs3.ColorFormulaSizeID
			LEFT JOIN lkpDeveloperSize ds ON color.DeveloperSizeID = ds.DeveloperSizeID
			LEFT JOIN lkpDeveloperVolume dv ON color.DeveloperVolumeID = dv.DeveloperVolumeID
			LEFT JOIN lkpTimeUnit cptu ON color.ColorProcessingTimeUnitID = cptu.TimeUnitID
		INNER JOIN datTechnicalProfileXtrands xtrands ON tp.TechnicalProfileID = xtrands.TechnicalProfileID
			LEFT JOIN lkpHairStrandGroup hsg ON xtrands.HairStrandGroupID = hsg.HairStrandGroupID
			LEFT JOIN lkpHairHealth hh ON xtrands.HairHealthID = hh.HairHealthID
			LEFT JOIN cfgSalesCode ldsc ON xtrands.LaserDeviceSalesCodeID = ldsc.SalesCodeID
			LEFT JOIN cfgSalesCode ssc ON xtrands.ShampooSalesCodeID = ssc.SalesCodeID
			LEFT JOIN cfgSalesCode cosc ON xtrands.ConditionerSalesCodeID = cosc.SalesCodeID
			LEFT JOIN cfgSalesCode msc ON xtrands.MinoxidilSalesCodeID = msc.SalesCodeID
			LEFT JOIN lkpTimeUnit stu ON xtrands.ServiceTimeUnitID = stu.TimeUnitID
			LEFT JOIN lkpTimeUnit ostu ON xtrands.OtherServiceTimeUnitID = ostu.TimeUnitID
			LEFT JOIN cfgSalesCode ossc ON xtrands.OtherServiceSalesCodeID = ossc.SalesCodeID
    WHERE tp.ClientGUID = @ClientGUID
	ORDER BY tp.TechnicalProfileDate DESC

END
GO
