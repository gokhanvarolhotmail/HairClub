/* CreateDate: 12/30/2021 08:55:42.033 , ModifyDate: 12/30/2021 12:01:25.243 */
GO
CREATE VIEW [dbo].[vwAppointments_HD_v2]
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
	,	clm.ClientMembershipBeginDate as 'MembershipStartDate'
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
	,	SOD.[MembershipPromotion]
	,	cpm.[MembershipPromotionDescription]
	,   max(CASE WHEN memaccum.AccumulatorSSID IN ( 12 ) THEN memaccum.TotalAccumQuantity
                 ELSE 0
            END) AS 'Grafts'
FROM synHC_CMS_DDS_vwDimAppointment appt
	INNER JOIN synHC_CMS_DDS_vwFactAppointmentDetail apptdet on
		appt.AppointmentKey = apptdet.AppointmentKey
	INNER JOIN synHC_ENT_DDS_vwDimCenter ctr on
		appt.CenterKey = ctr.CenterKey
	INNER JOIN synHC_CMS_DDS_vwDimClient cl on
		appt.ClientKey = cl.ClientKey
	INNER JOIN synHC_ENT_DDS_vwDimCenter clctr on
		cl.CenterSSID = clctr.CenterSSID
	INNER JOIN synHC_ENT_DDS_vwDimRegion reg on
		clctr.RegionKey = reg.RegionKey
	INNER JOIN synHC_CMS_DDS_vwDimClientMembership clm on
		appt.ClientMembershipKey = clm.ClientMembershipKey
	INNER JOIN synHC_CMS_DDS_vwDimMembership mem on
		clm.MembershipKey = mem.MembershipKey
	INNER JOIN synHC_CMS_DDS_vwDimClientMembershipAccum memaccum on
          clm.ClientMembershipKey = memaccum.ClientMembershipKey
             AND memaccum.AccumulatorSSID = 12
	INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.FactActivityResults FAR
		ON CL.contactkey = FAR.ContactKey AND FAR.Consultation = 1
	INNER JOIN HC_BI_CMS_DDS.[bi_cms_dds].[FactSalesTransaction] FST
		ON FST.ClientKey = appt.ClientKey
	INNER JOIN HC_BI_CMS_DDS.[bi_cms_dds].[DimSalesOrderDetail] SOD
		ON SOD.[SalesOrderDetailKey]= FST.[SalesOrderDetailKey]
	LEFT OUTER JOIN [dbo].[synHairclubCMS_cfgMembershipPromotion] cpm on
			SOD.[MembershipPromotion] = cpm.[MembershipPromotionDescriptionShort]
			and cpm.[MembershipPromotionTypeID] = 2
	LEFT OUTER  JOIN synHC_ENT_DDS_vwDimDoctorRegion docreg on
		clctr.DoctorRegionKey = docreg.DoctorRegionKey
	LEFT OUTER JOIN synHC_CMS_DDS_vwDimSalesCode sc on
		apptdet.SalesCodeKey = sc.SalesCodeKey
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
	,	clm.ClientMembershipBeginDate
	,	clm.ClientMembershipEndDate
	,	clm.ClientMembershipContractPaidAmount
	,   clm.ClientMembershipContractPrice
	--,	apptdet.AppointmentDetailSSID --not available
	,	sc.SalesCodeSSID
	,	sc.SalesCodeDescriptionShort
	,	sc.SalesCodeDescription
	,	appt.CheckInTime
	,	appt.CheckOutTime
	,	SOD.[MembershipPromotion]
	,	cpm.[MembershipPromotionDescription]
GO
