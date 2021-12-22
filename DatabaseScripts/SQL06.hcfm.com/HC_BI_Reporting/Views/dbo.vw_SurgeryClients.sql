/* CreateDate: 07/12/2011 08:04:12.217 , ModifyDate: 07/12/2011 16:04:42.517 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_SurgeryClients]
AS
-------------------------------------------------------------------------
-- [vw_Clients] is used to retrieve a
-- list of Clients
--
--   SELECT * FROM [bi_cms_dds].[vw_Clients]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    07/08/2011  KMurdoch     Initial Creation
-------------------------------------------------------------------------

SELECT
		CL.CenterSSID as 'CenterID'  --NEED to Change to CL.CenterSSID
	,	CTR.CenterDescription as 'CenterDescription'
	,	CTR.CenterDescriptionNumber as 'CenterDescriptionFullCalc'
	,	REG.RegionSSID as 'RegionID'
	,	REG.RegionDescription as 'RegionDescription'
	,	REG.RegionDescriptionShort as 'RegionDescriptionShort'
	,	REG.RegionSortOrder as 'RegionSortOrder'
	,	DR.DoctorRegionDescription as 'DoctorRegionDescription'
	,	DR.DoctorRegionDescriptionShort as 'DoctorRegionDescriptionShort'
	,	DR.DoctorRegionSSID as 'DoctorRegionID'
	,	CL.ClientIdentifier as 'ClientIdentifier'
	,	CL.ClientKey as 'ClientKey'
	,	CL.ClientNumber_Temp as 'ClientNumber_Temp'
	,	CL.ClientSSID as 'ClientGUID'
	,	CL.ClientFirstName as 'FirstName'
	,	CL.ClientLastName as 'LastName'
	,	CL.ClientFullName as 'ClientName'
	,	CL.GenderSSID as 'GenderID'
	,	GENDER.GenderDescription as 'GenderDescription'
	,	GENDER.GenderSSID as 'GenderDescriptionShort'
	,	CL.ClientDateOfBirth as 'DateOfBirth'
	,	(floor(datediff(week,[ClientDateOfBirth],getdate())/(52))) as 'Age'
	,	CL.ClientAddress1 as 'Address1'
	,	CL.ClientAddress2 as 'Address2'
	,	CL.City as 'City'
	,	CL.StateProvinceDescriptionShort as 'State'
	,	CL.PostalCode as 'Zip'
	,	CL.CountryRegionDescription as 'Country'
	,	CL.CountryRegionDescriptionShort as 'CountryDesriptionShort'
	,   '(' + LEFT(CL.[CLIENTPhone1], 3) + ') ' + SUBSTRING(CL.[ClientPhone1], 1, 3) + '-' + RIGHT(CL.[ClientPhone1], 4) AS 'HomePhone'
	,   '(' + LEFT(CL.[ClientPhone2], 3) + ') ' + SUBSTRING(CL.[ClientPhone2], 4, 3) + '-' + RIGHT(CL.[ClientPhone2], 4) AS 'WorkPhone'
	,	CL.ClientPhone1 as 'HomePhoneUnformatted'
	,	CL.ClientPhone2 as 'WorkPhoneUnformatted'
	,	LEFT(CL.ClientPhone1,3) as 'HPhoneAC'
	,	CL.ClientEMailAddress as 'EmailAddress'
	,	MEM.MembershipDescription as 'Membership'
	,	MEM.MembershipDescriptionShort as 'MembershipShort'
	,	CLM.ClientMembershipBeginDate as 'MembershipStartDate'
	,	CLM.ClientMembershipEndDate as 'MembershipEndDate'
	,	CLM.ClientMembershipContractPrice as 'ContractPrice'
	,	CLM.ClientMembershipContractPaidAmount as 'ContractPaid'
	,	CL.DoNotCallFlag as 'DoNotCallFlag'
	,	CL.DoNotContactFlag as 'DoNotContactFlag'
	,	CL.IsTaxExemptFlag as 'IsTaxExemptFlag'
	,	CLM.ClientMembershipStatusDescription
	,	CL.ClientARBalance	as 'ARBalance'
	,	MAX(DEPDT.FULLDATE) as 'DepositDate'
	,	MAX(CASE WHEN MEMACCUM.ACCUMULATORSSID = 12 THEN MEMACCUM.TotalAccumQuantity END) AS 'TotalGrafts'
	,	MAX(CASE WHEN MEMACCUM.ACCUMULATORSSID = 12 THEN MEMACCUM.UsedAccumQuantity END) AS 'UsedGrafts'
	,	MAX(CASE WHEN MEMACCUM.ACCUMULATORSSID = 13 THEN MEMACCUM.ACCUMDATE END) AS 'LastApplicationDate'
	,	MAX(CASE WHEN MEMACCUM.ACCUMULATORSSID = 15 THEN MEMACCUM.ACCUMDATE END) AS 'LastCheckUpDate'
	,	MAX(CASE WHEN MEMACCUM.ACCUMULATORSSID = 16 THEN MEMACCUM.ACCUMDATE END) AS 'LastServiceDate'
	,	MAX(CASE WHEN MEMACCUM.ACCUMULATORSSID = 7 THEN MEMACCUM.ACCUMDATE END) AS 'LastPaymentDate'
	,	MAX(CASE WHEN MEMACCUM.ACCUMULATORSSID = 6 THEN MEMACCUM.ACCUMDATE END) AS 'NextAppointmentDate'
	,	MAX(CASE WHEN MEMACCUM.ACCUMULATORSSID = 28 THEN MEMACCUM.ACCUMDATE END) AS 'SurgeryDate'

FROM dbo.synHC_CMS_DDS_DimClient CL
	LEFT OUTER JOIN dbo.synHC_CMS_DDS_vwDimClientMembership CLM on
		CL.CurrentSurgeryClientMembershipSSID = CLM.clientmembershipssid  ---THIS NEEDS TO CHANGE TO BE CurrentSurgeryClientMembershipGUID
	INNER JOIN dbo.synHC_ENT_DDS_vwDimCenter CTR on
		CLM.CenterSSID = CTR.centerssid
	INNER JOIN dbo.synHC_ENT_DDS_vwDimRegion REG on
		CTR.RegionKey = REG.RegionKey
	INNER JOIN dbo.synHC_ENT_DDS_vwDimGender GENDER on
		CL.GenderSSID = GENDER.genderkey
	INNER JOIN dbo.synHC_CMS_DDS_vwDimMembership MEM on
		CLM.MembershipKey = MEM.MembershipKey
	LEFT OUTER JOIN dbo.synHC_CMS_DDS_vwDimClientMembershipAccum MEMACCUM on
		CLM.ClientMembershipKey = MEMACCUM.ClientMembershipKey
	LEFT OUTER JOIN dbo.synHC_CMS_DDS_vwFactSalesFirstSurgeryInfo DrDEP on
		CL.ClientKey = DrDEP.ClientKey
			and DrDEP.SalesCodeKey = 502
				and DrDEP.[SF-Price] = 500.00
	LEFT OUTER JOIN dbo.synHC_ENT_DDS_vwDimDate DEPDT on
		DrDEP.OrderDateKey = DEPDT.DateKey
	LEFT OUTER JOIN dbo.synHC_ENT_DDS_vwDimDoctorRegion DR on
		CTR.DoctorRegionKey = DR.DoctorRegionKey

group by
		CL.CenterSSID
	,	CTR.CenterDescription
	,	CTR.CenterDescriptionNumber
	,	REG.RegionSSID
	,	REG.RegionDescription
	,	REG.RegionDescriptionShort
	,	REG.RegionSortOrder
	,	DR.DoctorRegionDescription
	,	DR.DoctorRegionDescriptionShort
	,	DR.DoctorRegionSSID
	,	CL.ClientIdentifier
	,	CL.ClientKey
	,	CL.ClientNumber_Temp
	,	CL.ClientSSID
	,	CL.ClientFirstName
	,	CL.ClientLastName
	,	CL.ClientFullName
	,	CL.GenderSSID
	,	GENDER.GenderDescription
	,	GENDER.GenderSSID
	,	CL.ClientDateOfBirth
	--,	CL.AgeCalc as 'Age'
	,	CL.ClientAddress1
	,	CL.ClientAddress2
	,	CL.City
	,	CL.StateProvinceDescriptionShort
	,	CL.PostalCode
	,	CL.CountryRegionDescription
	,	CL.CountryRegionDescriptionShort
	,   [CLIENTPhone1]
	,   [ClientPhone2]
	,	CL.ClientPhone1
	,	CL.ClientPhone2
	,	LEFT(CL.ClientPhone1,3)
	,	CL.ClientEMailAddress
	,	MEM.MembershipDescription
	,	MEM.MembershipDescriptionShort
	,	CLM.ClientMembershipBeginDate
	,	CLM.ClientMembershipEndDate
	,	CLM.ClientMembershipContractPrice
	,	CLM.ClientMembershipContractPaidAmount
	,	CL.DoNotCallFlag
	,	CL.DoNotContactFlag
	,	CL.IsTaxExemptFlag
	,	CLM.ClientMembershipStatusDescription
	,	CL.ClientARBalance
GO
