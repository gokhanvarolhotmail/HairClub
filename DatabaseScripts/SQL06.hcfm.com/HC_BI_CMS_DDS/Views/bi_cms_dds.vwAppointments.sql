create VIEW [bi_cms_dds].[vwAppointments]
AS
-------------------------------------------------------------------------
-- [vwDimRegion] is used to retrieve a
-- list of Regions
--
--   SELECT * FROM [bi_cms_dds].[vwAppointments]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/28/2011  KMurdoch     Initial Creation
-------------------------------------------------------------------------

SELECT
		appt.AppointmentSSID as 'AppointmentGUID'
	,	appt.AppointmentDate as 'AppointmentDate'
	,	appt.AppointmentStartTime as 'StartTime'
	,	appt.AppointmentEndTime as 'EndTime'
	,	appt.CenterSSID as 'CenterID'
	,	ctr.CenterDescriptionNumber as 'CenterDescriptionFullCalc'
	,	ctr.CenterDescription as 'CenterDescription'
	,	cl.CenterSSID as 'ClientHomeCenterID'
	,	clctr.CenterDescriptionNumber as 'ClientHomeCenterDescriptionFullCalc'
	,	clctr.CenterDescription as 'ClientHomeCenterDescription'
	,	reg.RegionSSID as 'RegionID'
	,	reg.RegionDescription as 'RegionDescription'
	--,	reg.RegionSortOrder as 'RegionSortOrder'
	,	docreg.DoctorRegionSSID as 'DoctorRegionID'
	,	docreg.DoctorRegionDescription as 'DoctorRegionDescription'
	,	cl.ClientSSID as 'ClientGUID'
	,	cl.ClientFirstName as 'FirstName'
	,	cl.ClientLastName as 'LastName'
	,	cl.ClientFullName as 'ClientFullNameAltCalc'
	,	'(' + LEFT(cl.clientPhone1, 3) + ') ' + SUBSTRING(cl.clientPhone1, 1, 3) + '-' + RIGHT(cl.clientPhone1, 4) AS 'Phone'
	,	mem.MembershipSSID as 'MembershipID'
	,	mem.MembershipDescription as 'MembershipDescription'
	,	clm.ClientMembershipEndDate as 'MembershipExpirationDate'
	,	clm.ClientMembershipContractPaidAmount as 'ContractPaidAmount'
	,   CONVERT(NUMERIC(15, 2), ISNULL(clm.ClientMembershipContractPrice - clm.ClientMembershipContractPaidAmount, 0)) AS 'Balance'
	--,	apptdet.AppointmentDetailSSID --not available
	,	sc.SalesCodeSSID as 'SalesCodeID'
	,	sc.SalesCodeDescriptionShort as 'SalescodeDescriptionShort'
	,	sc.SalesCodeDescription as 'SalesCodeDescription'
	,	DATEDIFF(MINUTE, CONVERT(VARCHAR, appt.AppointmentStartTime, 108), CONVERT(VARCHAR, appt.AppointmentEndTime, 108)) AS 'Duration'
	,	appt.CheckInTime as 'CheckInTime'
	,	appt.CheckOutTime as 'CheckOutTime'
	--	AppointmentDurationCalc
	--	CreateDate
	--	CreateUser
	,   SUM(CASE WHEN memaccum.AccumulatorSSID IN ( 12 ) THEN memaccum.TotalAccumQuantity
                 ELSE 0
            END) AS 'Grafts'
FROM bi_cms_dds.DimAppointment appt
	LEFT OUTER JOIN bi_cms_dds.FactAppointmentDetail apptdet on
		appt.AppointmentKey = apptdet.AppointmentKey
	LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter ctr on
		appt.CenterKey = ctr.CenterKey
	LEFT OUTER JOIN bi_cms_dds.vwDimClient cl on
		appt.ClientKey = cl.ClientKey
	LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter clctr on
		cl.CenterSSID = clctr.CenterSSID
	LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimRegion reg on
		clctr.RegionKey = reg.RegionKey
	LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimDoctorRegion docreg on
		clctr.DoctorRegionKey = docreg.DoctorRegionKey
	LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.vwDimClientMembership clm on
		appt.ClientMembershipKey = clm.ClientMembershipKey
	LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.vwDimMembership mem on
		clm.MembershipKey = mem.MembershipKey
	LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.vwDimSalesCode sc on
		apptdet.SalesCodeKey = sc.SalesCodeKey
	LEFT OUTER JOIN bi_cms_dds.DimClientMembershipAccum memaccum on
          clm.ClientMembershipKey = memaccum.ClientMembershipKey
             AND memaccum.AccumulatorSSID = 12
group by
		appt.AppointmentSSID
	,	appt.AppointmentDate
	,	appt.AppointmentStartTime
	,	appt.AppointmentEndTime
	,	appt.CenterSSID
	,	ctr.CenterDescriptionNumber
	,	ctr.CenterDescription
	,	cl.CenterSSID
	,	clctr.CenterDescriptionNumber
	,	clctr.CenterDescription
	,	reg.RegionSSID
	,	reg.RegionDescription
	--,	reg.RegionSortOrder
	,	docreg.DoctorRegionSSID
	,	docreg.DoctorRegionDescription
	,	cl.ClientSSID
	,	cl.ClientFirstName
	,	cl.ClientLastName
	,	cl.ClientFullName
	,	cl.clientphone1
	,	mem.MembershipSSID
	,	mem.MembershipDescription
	,	clm.ClientMembershipEndDate
	,	clm.ClientMembershipContractPaidAmount
	,   clm.ClientMembershipContractPrice
	--,	apptdet.AppointmentDetailSSID --not available
	,	sc.SalesCodeSSID
	,	sc.SalesCodeDescriptionShort
	,	sc.SalesCodeDescription
	,	appt.CheckInTime
	,	appt.CheckOutTime
