CREATE VIEW [bi_mktg_dds].[vwMKTActivityLead]
AS
/*-------------------------------------------------------------------------
-- [vwDimActivity] is used to retrieve a
-- list of Activity
--
SELECT * FROM [bi_mktg_dds].[vwMKTActivityLead] where ActSource = 'M BROCHURE 2016' and ContactFirstName = 'David' and ContactLastName = 'Burgess' ORDER BY ActDate
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    02/14/2013  KMurdoch       Initial Creation
--  v1.1    08/21/2019  RHut		   Changed ContactSSID to SFDC_LeadID, ActivitySSID to SFDC_TaskID
-------------------------------------------------------------------------*/

SELECT		DA.CenterSSID AS ActCenter,
			DA.SFDC_TaskID AS ActKey,
			DA.SFDC_LeadID AS ActRecordid,
			MAX(DA.ActivityDueDate) AS ActDate,
			MAX(DA.ActivityStartTime) AS ActTime,
            DE.EmployeeSSID AS ActSalesperson,
			DA.SourceSSID AS ActSource,
			DA.ActionCodeSSID AS ActionCode,
			DA.ResultCodeSSID AS Result,
            DA.ActivityTypeSSID AS ActionType,
			MAX(DA.IsAppointment) AS ActIsAppt,
			MAX(DA.IsShow) AS ActIsShow,
			MAX(DA.IsSale) AS ActIsSale,
            MAX(DA.IsBeback) AS ActIsBeback,
			MAX(DA.IsConsultation) AS ActIsConsult,
			MAX(DD.FullDate) AS ActCreateDate,
            CreateDE.EmployeeSSID AS ActCreateBy,
			MAX(DA.ActivityCompletionDate) AS ActCompletionDate,
			MAX(DA.ActivityCompletionTime) AS ActCompletionTime,
            DAT.[ActivityTypeSSID] AS ActCstActivityType,
			DC.ContactCenterSSID LeadCenter,
			DC.SFDC_LeadID AS LeadRecordID,
			DC.ContactFirstName,
            DC.ContactLastName,
			DCA.AddressLine1,
			DCA.AddressLine2,
			DCA.City,
			DCA.StateName,
			DCA.ZipCode,
			DCP.PhoneNumber,
            DC.ContactCenterSSID AS LeadPrimaryCtr,
			DC.ContactAlternateCenter AS LeadAltCtr,
			LeadDE.EmployeeSSID AS LeadSalesperson,
            DC.ContactGender AS ActGender,
			DOcc.[OccupationDescription],
			DEth.EthnicityDescription,
			DC.ContactHairLossDescription,
			DS.SourceSSID AS LeadSource,
			DC.[ContactAgeRangeDescription],
            MAX(LCreateDate.FullDate) AS LeadCreateDate,
			MAX(LCreateTime.Time24) AS LeadCreateTime,
			MAX(FL.Appointments) AS LeadIsAppt,
			MAX(FL.Shows) AS LeadIsShow,
			MAX(FL.Sales) AS LeadIsSale,
            DC.AdiFlag AS AdiFlag,
			DC.[ContactStatusSSID] AS LeadStatusCode,
			DC.[ContactAffiliateID] AS AffiliateId,
            DCE.[Email],
			DC.ContactLanguageDescription AS Language,
			DC.[ContactPromotionDescription] AS PromotionCode
FROM         hc_bi_mktg_dds.bi_mktg_dds.FactActivity FA
				INNER JOIN hc_bi_mktg_dds.bi_mktg_dds.DimContact DC
						 ON FA.ContactKey = DC.ContactKey
				INNER JOIN hc_bi_mktg_dds.bi_mktg_dds.DimActivity DA
						ON FA.ActivityKey = DA.ActivityKey
				LEFT OUTER JOIN hc_bi_mktg_dds.bi_mktg_dds.FactActivityResults FAR
						ON FA.ActivityKey = FAR.ActivityKey
				LEFT OUTER JOIN hc_bi_mktg_dds.bi_mktg_dds.DimActivityResult DAR
						ON DA.SFDC_TaskID = DAR.SFDC_TaskID
				INNER JOIN hc_bi_mktg_dds.bi_mktg_dds.DimEmployee DE
						ON FA.ActivityEmployeeKey = DE.EmployeeKey
				LEFT OUTER JOIN hc_bi_mktg_dds.bi_mktg_dds.DimActivityType DAT
						ON FA.ActivityTypeKey = DAT.ActivityTypeKey
				INNER JOIN hc_bi_ent_dds.bief_dds.DimDate DD
						ON FA.ActivityDateKey = DD.DateKey
				LEFT OUTER JOIN hc_bi_mktg_dds.bi_mktg_dds.DimEmployee CreateDE
						ON FA.StartedByEmployeeKey = CreateDE.EmployeeKey
				LEFT OUTER JOIN hc_bi_mktg_dds.bi_mktg_dds.DimContactAddress DCA
						ON DC.SFDC_LeadID = DCA.SFDC_LeadID
								AND DCA.PrimaryFlag = 'Y'
				LEFT OUTER JOIN hc_bi_mktg_dds.bi_mktg_dds.DimContactEmail DCE
						ON DC.SFDC_LeadID = DCE.SFDC_LeadID
							AND DCE.PrimaryFlag = 'Y'
				LEFT OUTER JOIN hc_bi_mktg_dds.bi_mktg_dds.DimContactPhone DCP
						ON DC.SFDC_LeadID = DCP.SFDC_LeadID
							AND DCE.PrimaryFlag = 'Y'
				LEFT OUTER JOIN hc_bi_mktg_dds.bi_mktg_dds.FactLead FL
						ON DC.ContactKey = FL.ContactKey
				LEFT OUTER JOIN hc_bi_mktg_dds.bi_mktg_dds.DimEmployee LeadDE
						ON FL.AssignedEmployeeKey = LeadDE.EmployeeKey
				LEFT OUTER JOIN hc_bi_mktg_dds.bi_mktg_dds.DimSource DS
						ON FL.SourceKey = DS.SourceKey
				LEFT OUTER JOIN hc_bi_ent_dds.bi_ent_dds.[DimEthnicity] DEth
						ON FL.EthnicityKey = DEth.EthnicityKey
				LEFT OUTER JOIN hc_bi_ent_dds.bi_ent_dds.[DimOccupation] DOcc
						ON FL.OccupationKey = DOcc.OccupationKey
				LEFT OUTER JOIN hc_bi_ent_dds.bief_dds.DimDate LCreateDate
						ON FL.LeadCreationDateKey = LCreateDate.DateKey
				LEFT OUTER JOIN hc_bi_ent_dds.bief_dds.DimTimeOfDay LCreateTime
						ON FL.[LeadCreationTimeKey] = LCreateTime.TimeofDayKey

GROUP BY
			DA.CenterSSID,
			DA.SFDC_TaskID,
			DA.SFDC_LeadID,
            DE.EmployeeSSID,
			DA.SourceSSID,
			DA.ActionCodeSSID,
			DA.ResultCodeSSID,
            DA.ActivityTypeSSID,
            CreateDE.EmployeeSSID,
            DAT.[ActivityTypeSSID],
			DC.ContactCenterSSID,
			DC.SFDC_LeadID,
			DC.ContactFirstName,
            DC.ContactLastName,
			DCA.AddressLine1,
			DCA.AddressLine2,
			DCA.City,
			DCA.StateName,
			DCA.ZipCode,
			DCP.PhoneNumber,
            DC.ContactCenterSSID,
			DC.ContactAlternateCenter,
			LeadDE.EmployeeSSID,
            DC.ContactGender,
			DOcc.[OccupationDescription],
			DEth.EthnicityDescription,
			DC.ContactHairLossDescription,
			DS.SourceSSID,
			DC.[ContactAgeRangeDescription],
            DC.AdiFlag,
			DC.[ContactStatusSSID],
			DC.[ContactAffiliateID],
            DCE.[Email],
			DC.ContactLanguageDescription,
			DC.[ContactPromotionDescription]
