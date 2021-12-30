/* CreateDate: 12/11/2012 14:57:24.447 , ModifyDate: 12/11/2012 14:57:24.447 */
GO
/***********************************************************************

PROCEDURE:				dbaInsertTechnicalProfiles

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Kevin Murdoch

IMPLEMENTOR: 			Kevin Murdoch

DATE IMPLEMENTED: 		 09/18/2012

/LAST REVISION DATE: 	 09/18/2012

--------------------------------------------------------------------------------------------------------
NOTES:  This script is used to import Technical Profiles into CMS.
		* 09/18/2012 KRM - Created stored proc


--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [dbaInsertTechnicalProfiles]
***********************************************************************/
CREATE PROCEDURE [dbo].[dbaInsertTechnicalProfiles] AS
BEGIN

	SET NOCOUNT ON


		DELETE FROM datTechnicalProfileHistory

		INSERT INTO [datTechnicalProfileHistory]
				   ([TechnicalProfileHistoryGUID]
				   --,[TechnicalProfileDate]
				   ,[ClientGUID]
				   ,[HairSystemID]
				   ,[AdhesiveFrontID]
				   ,[AdhesiveFront2ID]
				   ,[AdhesivePerimeterID]
				   ,[AdhesivePerimeter2ID]
				   ,[AdhesivePerimeter3ID]
				   ,[RemovalProcessID]
				   ,[AdhesiveSolventID]
				   ,[ServiceVisitDurationID]
				   ,[RelaxerBrandID]
				   ,[RelaxerStrengthID]
				   ,[RelaxerProcessingTime]
				   ,[RelaxerProcessingTimeUnitID]
				   ,[ColorBrandID]
				   ,[ColorFormula]
				   ,[ColorFormulaSizeID]
				   ,[ColorFormula2]
				   ,[ColorFormulaSize2ID]
				   ,[ColorFormula3]
				   ,[ColorFormulaSize3ID]
				   ,[DeveloperSizeID]
				   ,[DeveloperVolumeID]
				   ,[ColorProcessingTime]
				   ,[ColorProcessingTimeUnitID]
				   ,[PermBrandID]
				   ,[PermBrandSystemID]
				   ,[PermRodColorID]
				   ,[PermRodColorSystemID]
				   ,[PermRodColor2ID]
				   ,[PermRodColor2SystemID]
				   ,[PermProcessingTime]
				   ,[PermProcessingTimeUnitID]
				   ,[PermProcessingTimeSystem]
				   ,[PermProcessingTimeUnitSystemID]
				   ,[PermTechniqueID]
				   ,[PermTechniqueSystemID]
				   ,[ClientUsingOwnHairline]
				   ,[DistanceHairlineToNose]
				   ,[ServiceVisitDurationApp]
				   ,[ServiceVisitDurationAppTimeUnitID]
				   ,[ServiceVisitDurationFull]
				   ,[ServiceVisitDurationFullTimeUnitID]
				   ,[ServiceVisitDurationOther]
				   ,[ServiceVisitDurationOtherTimeUnitID]
				   ,[Notes]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser])


			SELECT
					NEWID() as 'TechnicalProfileGUID'
				,	cl.ClientGUID as 'ClientGUID'
				,	CASE WHEN tp.system_type is NULL then NULL ELSE hs.hairsystemid END as 'LastSystemType'
				,	CASE WHEN tp.Adhesive_Front is NULL then NULL ELSE af1.LookupID END as 'AdhesiveFrontID'
				,	CASE WHEN tp.Adhesive_Front_Second is NULL then NULL ELSE af2.LookupID END as 'AdhesiveFront2ID'
				,	CASE WHEN tp.Adhesive_Perimeter is NULL then NULL ELSE ap1.LookupID END as 'AdhesivePerimeterID'
				,	CASE WHEN tp.Adhesive_Perimeter_Second is NULL then NULL ELSE ap2.LookupID END as 'AdhesivePerimeter2ID'
				,	CASE WHEN tp.Adhesive_Perimeter_Third is NULL then NULL ELSE ap3.LookupID END as 'AdhesivePerimeter3ID'
				,	CASE WHEN tp.Removal_Process is NULL then NULL ELSE rp.LookupID END as 'RemovalProcessID'
				,	CASE WHEN tp.Adhesive_Solvent is NULL then NULL ELSE aslv.LookupID END as 'AdhesiveSolventID'
				,	NULL AS 'ServiceVisitDurationID'
				,	CASE WHEN tp.Relaxer_Brand is NULL then NULL ELSE rb.LookupID END as 'RelaxerBrandID'
				,	CASE WHEN tp.Relaxer_Strength is NULL then NULL ELSE rs.RelaxerStrengthID END as 'RelaxerStrengthID'
				,	NULL as 'RelaxerProcessingTimeID'
				,	NULL AS 'RelaxerProcessingTimeUnitID'
				,	CASE WHEN tp.Color_Brand is NULL then NULL ELSE cb.LookupID END as 'ColorBrandID'
				,	tp.Color_Formula1 as 'ColorFormulaID'
				,	CASE WHEN tp.Color_Formula1_Size is NULL then NULL ELSE cfs1.LookupID END as 'ColorFormulaSizeID'
				,	tp.Color_Formula2 as 'ColorFormula2ID'
				,	CASE WHEN tp.Color_Formula2_Size is NULL then NULL ELSE cfs2.LookupID END as 'ColorFormulaSize2ID'
				,	tp.Color_Formula3 as 'ColorFormula3ID'
				,	CASE WHEN tp.Color_Formula3_Size is NULL then NULL ELSE cfs3.LookupID END as 'ColorFormulaSize3ID'
				,	CASE WHEN tp.Developer_Size is NULL then NULL ELSE ds.LookupID END as 'DeveloperSizeID'
				,	CASE WHEN tp.Developer_Volume is NULL then NULL ELSE dv.LookupID END as 'DeveloperVolumeID'
				,	CAST(REPLACE(tp.Color_Processing_Time, 'min', '')as int) as 'ColorProcessingTime'
				,	NULL as ColorProcessingTimeUnitID
				,	CASE WHEN tp.Perm_Brand is NULL then NULL ELSE pb.LookupID END as 'PermBrandID'
				,	CASE WHEN tp.Perm_Brand_System is NULL then NULL ELSE pbs.LookupID END as 'PermBrandID'
				,	CASE WHEN tp.Perm_RodColor1 is NULL then NULL ELSE pr1.PermOwnHairRodsID END as 'PermRodColorID'
				,	CASE WHEN tp.Perm_RodColor1_System is NULL then NULL ELSE prs1.PermRodColorID END as 'PermRodColorSystemID'
				,	CASE WHEN tp.Perm_RodColor2 is NULL then NULL ELSE pr2.PermOwnHairRodsID END as 'PermRodColor2ID'
				,	CASE WHEN tp.Perm_RodColor2_System is NULL then NULL ELSE prs2.PermRodColorID END as 'PermRodColorSystem2ID'
				,	CAST(REPLACE(tp.Perm_Processing_Time, 'min', '')as int) as 'PermProcessingTime'
				,	NULL as 'PermProcessingTimeUnitID'
				,	CAST(REPLACE(tp.Perm_Processing_Time_System, 'min', '')as int) as 'PermProcessingTimeSystem'
				,	NULL as 'PermProcessingTimeUnitSystemID'
				,	CASE WHEN tp.Perm_Technique is NULL then NULL ELSE pt.LookupID END as 'PermTechniqueID'
				,	CASE WHEN tp.Perm_Technique_System is NULL then NULL ELSE pts.LookupID END as 'PermTechniqueSystemID'
				,	CASE WHEN tp.Client_Using_Own_Hairline is NULL then NULL ELSE case when tp.Client_Using_Own_Hairline = 'No' then 0 else 1 end END as 'ClientUsingOwnHairline'
				,	tp.Distance_To_Hairline_From_Nose as 'DistanceHairLineToNose'
				,	CAST(REPLACE(tp.Service_Visit_Duration_Application, 'min', '')as int) as 'PermProcessingTimeSystem'
				,	NULL as 'ServiceVisitDurationAppTimeUnitID'
				,	CAST(REPLACE(tp.Service_Visit_Duration_Full_Service, 'min', '')as int) as 'PermProcessingTimeSystem'
				,	NULL as 'ServiceVisitDurationFullTimeUnitID'
				,	CAST(REPLACE(tp.Service_Visit_Duration_Other, 'min', '')as int) as 'PermProcessingTimeSystem'
				,	NULL as 'ServiceVisitDurationOtherTimeUnitID'
				,	tp.Notes
				,	CMSCreateDate
				,	CMSCreateID
				,	GETUTCDATE()
				,	'sa'

			FROM [HCSQL2\SQL2005].Infostore.dbo.Technical_Profile tp
				INNER JOIN datClient cl
					on tp.center = cl.centerid
						and tp.client_no = cl.ClientNumber_Temp
				LEFT OUTER JOIN cfgHairSystem hs
					on tp.System_Type = hs.HairSystemDescriptionShort
				LEFT OUTER JOIN [HCSQL2\SQL2005].Infostore.dbo.lkup_adhesiveFront af1
					on tp.Adhesive_Front = af1.[Description]
				LEFT OUTER JOIN [HCSQL2\SQL2005].Infostore.dbo.lkup_adhesiveFront af2
					on tp.Adhesive_Front_Second = af2.[Description]
				LEFT OUTER JOIN [HCSQL2\SQL2005].Infostore.dbo.lkup_adhesivePerimeter ap1
					on tp.Adhesive_Perimeter = ap1.[Description]
				LEFT OUTER JOIN [HCSQL2\SQL2005].Infostore.dbo.lkup_adhesivePerimeter ap2
					on tp.Adhesive_Perimeter_Second = ap2.[Description]
				LEFT OUTER JOIN [HCSQL2\SQL2005].Infostore.dbo.lkup_adhesivePerimeter ap3
					on tp.Adhesive_Perimeter_Third = ap3.[Description]
				LEFT OUTER JOIN [HCSQL2\SQL2005].Infostore.dbo.lkup_RemovalProcess rp
					on tp.Removal_Process = rp.[Description]
				LEFT OUTER JOIN [HCSQL2\SQL2005].Infostore.dbo.lkup_adhesiveSolvent aslv
					on tp.Adhesive_Solvent = aslv.[Description]
				LEFT OUTER JOIN [HCSQL2\SQL2005].Infostore.dbo.lkup_RelaxerBrand rb
					on tp.Relaxer_Brand = rb.[Description]
				LEFT OUTER JOIN lkpRelaxerStrength rs
					on tp.Relaxer_Strength = rs.RelaxerStrengthDescriptionShort
				LEFT OUTER JOIN [HCSQL2\SQL2005].Infostore.dbo.lkup_ColorBrand cb
					on tp.Color_Brand = cb.[Description] and cb.IsActive = 1
				LEFT OUTER JOIN [HCSQL2\SQL2005].Infostore.dbo.lkup_colorformulasize cfs1
					on tp.Color_Formula1_Size = cfs1.[Description] and cfs1.IsActive = 1
				LEFT OUTER JOIN [HCSQL2\SQL2005].Infostore.dbo.lkup_colorformulasize cfs2
					on tp.Color_Formula2_Size = cfs2.[Description] and cfs2.IsActive = 1
				LEFT OUTER JOIN [HCSQL2\SQL2005].Infostore.dbo.lkup_colorformulasize cfs3
					on tp.Color_Formula3_Size = cfs3.[Description] and cfs3.IsActive = 1
				LEFT OUTER JOIN [HCSQL2\SQL2005].Infostore.dbo.lkup_developersize ds
					on tp.Developer_Size = ds.[Description] and ds.IsActive = 1
				LEFT OUTER JOIN [HCSQL2\SQL2005].Infostore.dbo.lkup_developerVolume dv
					on tp.Developer_Volume = dv.[Description] and dv.IsActive = 1
				LEFT OUTER JOIN [HCSQL2\SQL2005].Infostore.dbo.lkup_PermBrand pb
					on tp.Perm_Brand = pb.[Description]
				LEFT OUTER JOIN [HCSQL2\SQL2005].Infostore.dbo.lkup_PermBrand pbs
					on tp.Perm_Brand_System = pbs.[Description]
				LEFT OUTER JOIN lkpPermOwnHairRods pr1
					on tp.Perm_RodColor1 = pr1.PermOwnHairRodsDescription and pr1.IsActiveFlag = 1
				LEFT OUTER JOIN lkpPermRodColor prs1
					on tp.Perm_RodColor1_System = prs1.PermRodColorDescription
				LEFT OUTER JOIN lkpPermOwnHairRods pr2
					on tp.Perm_RodColor2 = pr2.PermOwnHairRodsDescription and pr2.IsActiveFlag = 1
				LEFT OUTER JOIN lkpPermRodColor prs2
					on tp.Perm_RodColor2_System = prs2.PermRodColorDescription
				LEFT OUTER JOIN [HCSQL2\SQL2005].Infostore.dbo.lkup_permTechnique pt
					on tp.Perm_Technique = pt.[Description]
				LEFT OUTER JOIN [HCSQL2\SQL2005].Infostore.dbo.lkup_permTechnique pts
					on tp.Perm_Technique_System = pts.[Description]

		IF OBJECT_ID('tempdb..#APPTS') IS NOT NULL
			DROP TABLE #APPTS
		--
		select center, clientnbr,MAX(DATE) as ApptDate
		into #Appts
		from [hcsql2\sql2005].Infostore.dbo.appointment
		where DATE < GETDATE()
		group by center, clientnbr

		update tph
		set tph.TechnicalProfileDate = #appts.apptdate
		from datTechnicalProfileHistory tph
				INNER JOIN datClient cl
					on tph.ClientGUID = cl.ClientGUID
				inner join #appts
					on cl.CenterID = #appts.center
						and cl.ClientNumber_Temp = #appts.clientnbr

END
GO
