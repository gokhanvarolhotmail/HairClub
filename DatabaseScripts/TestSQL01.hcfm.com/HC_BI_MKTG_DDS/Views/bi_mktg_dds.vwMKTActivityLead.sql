/* CreateDate: 02/14/2013 14:16:55.593 , ModifyDate: 02/14/2013 14:55:00.203 */
GO
CREATE VIEW [bi_mktg_dds].[vwMKTActivityLead]
AS
-------------------------------------------------------------------------
-- [vwDimActivity] is used to retrieve a
-- list of Activity
--
--   SELECT * FROM [bi_mktg_dds].[vwMKTActivityLead]]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    02/14/2013  KMurdoch       Initial Creation
-------------------------------------------------------------------------

SELECT		DA.CenterSSID AS ActCenter,
			DA.ActivitySSID AS ActKey,
			DA.ContactSSID AS ActRecordid,
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
			DC.ContactSSID AS LeadRecordID,
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
			--dbo.Lead.Appointment_Date AS LeadApptDate,
			MAX(FL.Shows) AS LeadIsShow,
			--dbo.Lead.Show_Date AS LeadShowDate,
			MAX(FL.Sales) AS LeadIsSale,
			--dbo.Lead.Sale_Date AS LeadSaleDate,
            DC.AdiFlag AS AdiFlag,
			DC.[ContactStatusSSID] AS LeadStatusCode,
			DC.[ContactAffiliateID] AS AffiliateId,
			--dbo.Lead.cst_sessionid AS SessionId,
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
						ON DA.ActivitySSID = DAR.ActivitySSID
				INNER JOIN hc_bi_mktg_dds.bi_mktg_dds.DimEmployee DE
						ON FA.ActivityEmployeeKey = DE.EmployeeKey
				LEFT OUTER JOIN hc_bi_mktg_dds.bi_mktg_dds.DimActivityType DAT
						ON FA.ActivityTypeKey = DAT.ActivityTypeKey
				INNER JOIN hc_bi_ent_dds.bief_dds.DimDate DD
						ON FA.ActivityDateKey = DD.DateKey
				LEFT OUTER JOIN hc_bi_mktg_dds.bi_mktg_dds.DimEmployee CreateDE
						ON FA.StartedByEmployeeKey = CreateDE.EmployeeKey
				LEFT OUTER JOIN hc_bi_mktg_dds.bi_mktg_dds.DimContactAddress DCA
						ON DC.ContactSSID = DCA.ContactSSID
								and DCA.PrimaryFlag = 'Y'
				LEFT OUTER JOIN hc_bi_mktg_dds.bi_mktg_dds.DimContactEmail DCE
						ON DC.ContactSSID = DCE.ContactSSID
							and DCE.PrimaryFlag = 'Y'
				LEFT OUTER JOIN hc_bi_mktg_dds.bi_mktg_dds.DimContactPhone DCP
						ON DC.ContactSSID = DCP.ContactSSID
							and DCE.PrimaryFlag = 'Y'
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
			DA.ActivitySSID,
			DA.ContactSSID,
            DE.EmployeeSSID,
			DA.SourceSSID,
			DA.ActionCodeSSID,
			DA.ResultCodeSSID,
            DA.ActivityTypeSSID,
            CreateDE.EmployeeSSID,
            DAT.[ActivityTypeSSID],
			DC.ContactCenterSSID,
			DC.ContactSSID,
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
GO
