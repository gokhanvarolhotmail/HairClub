-------------------------------------------------------------------------
--[vwFactLead] is used to retrieve a
--list of FactLead
--
--   SELECT * FROM [bi_mktg_dds].[vwFactLead]
--
-----------------------------------------------------------------------
--Change History
-----------------------------------------------------------------------
-- Version  Date        Author       Description
---------  ----------  -----------  ------------------------------------
--  v1.0    10/12/2009  RLifke       Initial Creation
--			06/18/2013  KMurdoch	 Added LT Value
--			03/28/2016  KMurdoch     Added ShowDiff, SaleDiff
--			02/26/2020  KMurdoch     Added Refersion to HCRef
--			04/22/2020	KMurdoch	 Modified BosAppt to refer to 'Bosley Consult' Owner Type
--			06/04/2020	KMurdoch	 Added Count to account for leads with invalid, test, merged status
--			07/09/2020	KMurdoch	 Added Initial Appointment, Shows & Sales
--			08/24/2020  KMurdoch     Added RecentSourceKey
--			04/09/2021  KMurdoch	 Added Revenue Numbers to FactLead
--			04/15/2021  KMurdoch     Broke out NBLaser from NBRevenue
--
CREATE VIEW [bi_mktg_dds].[vwFactLead]
AS
SELECT		DD.FullDate AS PartitionDate
		,	FL.ContactKey
		,	FL.LeadCreationDateKey
		,	FL.LeadCreationTimeKey
		,	FL.CenterKey
		,	FL.SourceKey
		,	FL.GenderKey
		,	FL.OccupationKey
		,   FL.EthnicityKey
		,	FL.MaritalStatusKey
		,	FL.HairLossTypeKey
		,	FL.AgeRangeKey
		,	FL.EmployeeKey
		,	FL.Leads
		,	FL.Appointments
		,	FL.Shows
		,	FL.Sales
		,	FL.Activities
		,   FL.NoShows
		,	FL.NoSales
		,	FL.PromotionCodeKey
		,	FL.SalesTypeKey
		,	FL.AssignedEmployeeKey
		,   ISNULL(FL.RecentSourceKey,-1) AS 'RecentSourceKey'
		,	FL.ShowDiff
		,	FL.SaleDiff
		,	ISNULL(CASE WHEN FL.GenderKey = 2 THEN ST.LTVFemale ELSE ST.LTVMale END , 0) AS 'LTValue'
		,	ISNULL(CASE WHEN FL.GenderKey = 2 THEN ST.LTVFemaleYearly ELSE ST.LTVMaleYearly END , 0) AS 'LTValueYr'
		,	CASE WHEN DS.OwnerType = 'Bosley Consult' THEN 1 ELSE 0 END AS 'BOSAppt'
			--BOSREFVAN,BOSREFPORT,BOSREFSALT,BOSREFSTLOU,BOSREFTYCO,BOSREFTWSN
		,	CASE WHEN FL.SourceKey IN (4156) THEN 1 ELSE 0 END AS 'BOSRef'
			--BOSREF
		,	CASE WHEN FL.SourceKey IN (4155,4467,4535) THEN 1 ELSE 0 END AS 'BOSOthRef'
			--BOSDMREF,BOSBIOEMREF,BOSBIODMREF
		,	CASE WHEN FL.SourceKey IN (471,1301,1343,1865,3427,21056,21057,21058,21059,21060,21061,21062) THEN 1 ELSE 0 END AS 'HCRef'
			--CORP REFER,REFERAFRND,STYLEREFER,REGISSTYRFR,NBREFCARD, Refersion source codes = IPREFCLRERECA12476,IPREFCLRERECA12476DC,IPREFCLRERECA12476DF
				--IPREFCLRERECA12476DP,IPREFCLRERECA12476MC,IPREFCLRERECA12476MF,IPREFCLRERECA12476MP
		,	CASE WHEN ISNULL(DCA.CAPE_Income_HH_Median_Family, '') <> '' THEN CAST(DCA.CAPE_Income_HH_Median_Family AS DECIMAL(10,0)) ELSE 0 END AS 'LDHHMedianIncome'
		,	CASE WHEN DCA.CAPE_Income_HH_Median_Family IS NOT NULL THEN 1 ELSE 0 END AS 'LDIncomeReptd'
		,	CASE WHEN FL.Appointments > 0 THEN 1 END AS 'InitialAppointment'
		,	CASE WHEN FL.Shows > 0 THEN 1 END AS 'InitialShow'
		,	CASE WHEN FL.Sales > 0 THEN 1 END AS 'InitialSale'
		,	ISNULL(fl.NewBusinessRevenue,0) AS 'NewBusinessRevenue'
		,	ISNULL(fl.NBLaserRevenue,0) AS 'NBLaserRevenue'
		,	ISNULL(fl.PCPMemberRevenue,0) AS 'PCPMemberRevenue'
		,	ISNULL(fl.PCPLaserRevenue,0) AS 'PCPLaserRevenue'
		,	ISNULL(fl.ServiceRevenue,0) AS 'ServiceRevenue'
		,	ISNULL(fl.RetailRevenue,0) AS 'RetailRevenue'
		,	ISNULL(fl.NewBusinessRevenue,0) + ISNULL(fl.NBLaserRevenue,0) + ISNULL(fl.PCPMemberRevenue,0) + ISNULL(fl.ServiceRevenue,0) + ISNULL(fl.PCPLaserRevenue,0) + ISNULL(fl.RetailRevenue,0) AS 'TotalRevenue'
		,	1 AS 'FL-Count'

FROM    bi_mktg_dds.FactLead AS FL
		INNER JOIN bi_mktg_dds.dimsource DS
			ON DS.SourceKey = FL.SourceKey
		LEFT OUTER JOIN [HC_BI_ENT_DDS].bief_dds.DimDate AS DD
			ON FL.LeadCreationDateKey = DD.DateKey
		LEFT OUTER JOIN bi_mktg_dds.DimSalesType ST
				ON FL.SalesTypeKey = ST.SalesTypeKey
		LEFT OUTER JOIN bi_mktg_dds.DimContactAppend DCA
			ON DCA.ContactKey = FL.ContactKey
