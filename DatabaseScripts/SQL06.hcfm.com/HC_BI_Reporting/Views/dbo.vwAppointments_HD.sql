/* CreateDate: 09/14/2011 13:08:44.783 , ModifyDate: 09/15/2011 11:43:20.347 */
GO
CREATE VIEW [dbo].[vwAppointments_HD]
AS
-------------------------------------------------------------------------
-- [vwDimRegion] is used to retrieve a
-- list of Regions
--
--   SELECT * FROM [bi_cms_dds].[vw_Appointments]
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
	,	reg.RegionSortOrder as 'RegionSortOrder'
	,	docreg.DoctorRegionSSID as 'DoctorRegionID'
	,	docreg.DoctorRegionDescription as 'DoctorRegionDescription'
	,	docreg.DoctorRegionDescriptionShort
	,	cl.ClientSSID as 'ClientGUID'
	,	cl.ClientFirstName as 'FirstName'
	,	cl.ClientLastName as 'LastName'
	,	cl.ClientFullName as 'ClientFullNameAltCalc'
	,	'(' + LEFT(cl.clientPhone1, 3) + ') ' + SUBSTRING(cl.clientPhone1, 1, 3) + '-' + RIGHT(cl.clientPhone1, 4) AS 'Phone'
	,	mem.MembershipSSID as 'MembershipID'
	,	mem.MembershipDescription as 'MembershipDescription'
	,	clm.ClientMembershipEndDate as 'MembershipExpirationDate'
	,	clm.ClientMembershipContractPrice AS 'ContractAmount'
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
	,   max(CASE WHEN memaccum.AccumulatorSSID IN ( 12 ) THEN memaccum.TotalAccumQuantity
                 ELSE 0
            END) AS 'Grafts'
FROM synHC_CMS_DDS_vwDimAppointment appt
	LEFT OUTER JOIN synHC_CMS_DDS_vwFactAppointmentDetail apptdet on
		appt.AppointmentKey = apptdet.AppointmentKey
	LEFT OUTER JOIN synHC_ENT_DDS_vwDimCenter ctr on
		appt.CenterKey = ctr.CenterKey
	LEFT OUTER JOIN synHC_CMS_DDS_vwDimClient cl on
		appt.ClientKey = cl.ClientKey
	LEFT OUTER JOIN synHC_ENT_DDS_vwDimCenter clctr on
		cl.CenterSSID = clctr.CenterSSID
	LEFT OUTER JOIN synHC_ENT_DDS_vwDimRegion reg on
		clctr.RegionKey = reg.RegionKey
	LEFT OUTER JOIN synHC_ENT_DDS_vwDimDoctorRegion docreg on
		clctr.DoctorRegionKey = docreg.DoctorRegionKey
	LEFT OUTER JOIN synHC_CMS_DDS_vwDimClientMembership clm on
		appt.ClientMembershipKey = clm.ClientMembershipKey
	LEFT OUTER JOIN synHC_CMS_DDS_vwDimMembership mem on
		clm.MembershipKey = mem.MembershipKey
	LEFT OUTER JOIN synHC_CMS_DDS_vwDimSalesCode sc on
		apptdet.SalesCodeKey = sc.SalesCodeKey
	LEFT OUTER JOIN synHC_CMS_DDS_vwDimClientMembershipAccum memaccum on
          clm.ClientMembershipKey = memaccum.ClientMembershipKey
             AND memaccum.AccumulatorSSID = 12
WHERE isnull(appt.IsDeletedFlag,0) = 0
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
	,	reg.RegionSortOrder
	,	docreg.DoctorRegionSSID
	,	docreg.DoctorRegionDescription
	,	docreg.DoctorRegionDescriptionShort
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
GO
