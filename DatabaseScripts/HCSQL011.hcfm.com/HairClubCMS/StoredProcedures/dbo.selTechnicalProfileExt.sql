/* CreateDate: 02/27/2017 06:46:11.343 , ModifyDate: 07/08/2020 23:06:56.910 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
	PROCEDURE:				[selTechnicalProfileExt]
	DESTINATION SERVER:		SQL01
	DESTINATION DATABASE: 	HairClubCMS
	RELATED APPLICATION:  	CMS
	AUTHOR: 				PRM
	IMPLEMENTOR: 			PRM
	DATE IMPLEMENTED: 		02/06/2017
	LAST REVISION DATE: 	02/06/2017
	--------------------------------------------------------------------------------------------------------
	NOTES: 	Return a single EXT Technical Profile - does NOT include Areas of Concern, Styling Products, or Strand Builder Color records

			02/07/2017 - PRM Created Stored Proc
			02/09/2017 - SAL Modified to return tp.LastUpdateUser
			05/23/2017 - SAL Modified to return IsSurgeryClient, GraftCount, and LastSurgeryDate
			07/19/2019 - JLM Modified to return other service duration fields (TFS #12568)
			06/25/2020 - AP Include LastUpdate (TFS# 14550)

	--------------------------------------------------------------------------------------------------------
	SAMPLE EXECUTION:
	EXEC [selTechnicalProfileExt] '7BE39604-BD0F-45E0-B5FF-00000EB1EEC4'
***********************************************************************/
CREATE PROCEDURE [dbo].[selTechnicalProfileExt]
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
		ext.TechnicalProfileExtID,
			ext.LastTrichoViewDate, ext.LastExtServiceDate, ext.ElixirFormulation,
			ext.HairHealthID, hh.HairHealthDescription, hh.HairHealthDescriptionShort,
			ext.ScalpHealthID, sh.ScalpHealthDescription, sh.ScalpHealthDescriptionShort,
			ext.CleanserUsedSalesCodeID, cusc.SalesCodeDescription AS CleanserUsedSalesCodeDescription, cusc.SalesCodeDescriptionShort AS CleanserUsedSalesCodeDescriptionShort,
			ext.MassagePressureID, mp.MassagePressureDescription, mp.MassagePressureDescriptionShort,
			ext.LaserDeviceSalesCodeID, ldsc.SalesCodeDescription AS LaserDeviceSalesCodeDescription, ldsc.SalesCodeDescriptionShort AS LaserDeviceSalesCodeDescriptionShort,
			ext.CleanserSalesCodeID, csc.SalesCodeDescription AS CleanserSalesCodeDescription, csc.SalesCodeDescriptionShort AS CleanserSalesCodeDescriptionShort,
			ext.ConditionerSalesCodeID, cosc.SalesCodeDescription AS ConditionerSalesCodeDescription, cosc.SalesCodeDescriptionShort AS ConditionerSalesCodeDescriptionShort,
			ext.IsMinoxidilUsed, ext.MinoxidilSalesCodeID, msc.SalesCodeDescription AS MinoxidilSalesCodeDescription, msc.SalesCodeDescriptionShort AS MinoxidilSalesCodeDescriptionShort,
			ext.IsScalpEnzymeCleanserUsed, ext.Other, ext.ServiceDuration,
			ext.ServiceTimeUnitID, stu.TimeUnitDescription AS ServiceTimeUnitDescription, stu.TimeUnitDescriptionShort AS ServiceTimeUnitDescriptionShort,
			ext.IsSurgeryClient, ext.GraftCount, ext.LastSurgeryDate,
			ext.OtherServiceDuration, ext.OtherServiceTimeUnitID, ostu.TimeUnitDescription AS OtherServiceTimeUnitDescription, ostu.TimeUnitDescriptionShort AS OtherServiceTimeUnitDescriptionShort,
			ext.OtherServiceSalesCodeID, ossc.SalesCodeDescription AS OtherServiceSalesCodeDescription, ossc.SalesCodeDescriptionShort AS OtherServiceSalesCodeDescriptionShort

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
		INNER JOIN datTechnicalProfileExt ext ON tp.TechnicalProfileID = ext.TechnicalProfileID
			LEFT JOIN lkpHairHealth hh ON ext.HairHealthID = hh.HairHealthID
			LEFT JOIN lkpScalpHealth sh ON ext.ScalpHealthID = sh.ScalpHealthID
			LEFT JOIN cfgSalesCode cusc ON ext.CleanserUsedSalesCodeID = cusc.SalesCodeID
			LEFT JOIN lkpMassagePressure mp ON ext.MassagePressureID = mp.MassagePressureID
			LEFT JOIN cfgSalesCode ldsc ON ext.LaserDeviceSalesCodeID = ldsc.SalesCodeID
			LEFT JOIN cfgSalesCode csc ON ext.CleanserSalesCodeID = csc.SalesCodeID
			LEFT JOIN cfgSalesCode cosc ON ext.ConditionerSalesCodeID = cosc.SalesCodeID
			LEFT JOIN cfgSalesCode msc ON ext.MinoxidilSalesCodeID = msc.SalesCodeID
			LEFT JOIN lkpTimeUnit stu ON ext.ServiceTimeUnitID = stu.TimeUnitID
			LEFT JOIN lkpTimeUnit ostu ON ext.OtherServiceTimeUnitID = ostu.TimeUnitID
			LEFT JOIN cfgSalesCode ossc ON ext.OtherServiceSalesCodeID = ossc.SalesCodeID
    WHERE tp.ClientGUID = @ClientGUID
	ORDER BY tp.TechnicalProfileDate DESC

END
GO
