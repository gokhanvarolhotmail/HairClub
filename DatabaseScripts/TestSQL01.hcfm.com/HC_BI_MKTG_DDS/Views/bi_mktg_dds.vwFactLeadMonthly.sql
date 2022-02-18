/* CreateDate: 04/27/2021 10:39:13.167 , ModifyDate: 04/27/2021 11:32:56.560 */
GO
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
--  v1.0    04/27/2021  KMurdoch    Initial Creation
--			04/27/2021  KMurdoch    Include only data after 2021

--
CREATE view [bi_mktg_dds].[vwFactLeadMonthly]
as
select		DD.FullDate as PartitionDate
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
		,   isnull(FL.RecentSourceKey,-1) as 'RecentSourceKey'
		,	FL.ShowDiff
		,	FL.SaleDiff
		,	isnull(case when FL.GenderKey = 2 then ST.LTVFemale else ST.LTVMale end , 0) as 'LTValue'
		,	isnull(case when FL.GenderKey = 2 then ST.LTVFemaleYearly else ST.LTVMaleYearly end , 0) as 'LTValueYr'
		,	case when DS.OwnerType = 'Bosley Consult' then 1 else 0 end as 'BOSAppt'
			--BOSREFVAN,BOSREFPORT,BOSREFSALT,BOSREFSTLOU,BOSREFTYCO,BOSREFTWSN
		,	case when FL.SourceKey in (4156) then 1 else 0 end as 'BOSRef'
			--BOSREF
		,	case when FL.SourceKey in (4155,4467,4535) then 1 else 0 end as 'BOSOthRef'
			--BOSDMREF,BOSBIOEMREF,BOSBIODMREF
		,	case when FL.SourceKey in (471,1301,1343,1865,3427,21056,21057,21058,21059,21060,21061,21062) then 1 else 0 end as 'HCRef'
			--CORP REFER,REFERAFRND,STYLEREFER,REGISSTYRFR,NBREFCARD, Refersion source codes = IPREFCLRERECA12476,IPREFCLRERECA12476DC,IPREFCLRERECA12476DF
				--IPREFCLRERECA12476DP,IPREFCLRERECA12476MC,IPREFCLRERECA12476MF,IPREFCLRERECA12476MP
		,	case when isnull(DCA.CAPE_Income_HH_Median_Family, '') <> '' then cast(DCA.CAPE_Income_HH_Median_Family as decimal(10,0)) else 0 end as 'LDHHMedianIncome'
		,	case when DCA.CAPE_Income_HH_Median_Family is not null then 1 else 0 end as 'LDIncomeReptd'
		,	case when FL.Appointments > 0 then 1 end as 'InitialAppointment'
		,	case when FL.Shows > 0 then 1 end as 'InitialShow'
		,	case when FL.Sales > 0 then 1 end as 'InitialSale'
		,	1 as 'FL-Count'

from    bi_mktg_dds.FactLeadMonthly as FL
		inner join bi_mktg_dds.dimsource DS
			on DS.SourceKey = FL.SourceKey
		left outer join [HC_BI_ENT_DDS].bief_dds.DimDate as DD
			on FL.LeadCreationDateKey = DD.DateKey
		left outer join bi_mktg_dds.DimSalesType ST
				on FL.SalesTypeKey = ST.SalesTypeKey
		left outer join bi_mktg_dds.DimContactAppend DCA
			on DCA.ContactKey = FL.ContactKey
where fl.LeadCreationDateKey >= 20210101
GO
