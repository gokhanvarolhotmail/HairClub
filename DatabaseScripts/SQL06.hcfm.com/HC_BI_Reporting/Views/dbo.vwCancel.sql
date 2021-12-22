/***********************************************************************
VIEW:					vwCancel
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Marlon Burrell
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:
------------------------------------------------------------------------
NOTES:

10/24/2013 - DL - Created view for Rev (WO# 91933)
------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwCancel
***********************************************************************/
CREATE VIEW vwCancel
AS
  WITH
	Data AS
      (
		SELECT  CNTR.CenterSSID AS 'CenterNumber'
		,       CNTR.CenterDescription
		,       CNTR.CenterPhone1
		,       CLT.ClientIdentifier
		,       CLTM.ClientMembershipKey
		,       CLT.ClientFullName
		,       CLT.ClientEMailAddress
		,       CLT.ClientAddress1
		,       CLT.ClientAddress2
		,       CLT.City
		,       CLT.StateProvinceDescription AS 'State'
		,       CLT.PostalCode AS 'Zip'
		,       MEM.MembershipDescription AS 'CurrentMembership'
		,       DD.FullDate AS 'CancelDate'
		,       CR.CancelReasonDescription
		,       CLTM.ClientMembershipStatusDescription AS 'CurrentMembershipStatus'
		,       CLTM.ClientMembershipBeginDate
		,       CLTM.ClientMembershipEndDate
		,       PrevMem.MembershipDescription AS 'PreviousMembership'
		,       CLT.ClientDateOfBirth
		,       CLT.ClientGenderDescription
		,       CON.ContactLanguageDescription
		,       CON.DoNotSolicitFlag
		,       CON.DoNotEmailFlag
		,       CON.DoNotCallFlag
		,       CON.DoNotMailFlag
		,       CON.DoNotTextFlag
		,       CLT.ClientKey
		FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
					ON FST.OrderDateKey = DD.DateKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
					ON FST.ClientKey = CLT.ClientKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CLTM
					ON FST.ClientMembershipKey = CLTM.ClientMembershipKey
				LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact CON
					ON CLT.contactkey = CON.ContactKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
					ON FST.SalesCodeKey = SC.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership MEM
					ON FST.MembershipKey = MEM.MembershipKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CNTR
					ON FST.CenterKey = CNTR.CenterKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
					ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
				LEFT OUTER JOIN HC_BI_Reporting.dbo.DimCancelReason CR
					ON SOD.CancelReasonID = CR.CancelReasonID
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership PrevCltMem
					ON SOD.PreviousClientMembershipSSID = PrevCltMem.ClientMembershipSSID
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership PrevMem
					ON PrevCltMem.MembershipSSID = PrevMem.MembershipSSID
		WHERE   DD.FullDate BETWEEN '1/1/2010' AND GETDATE()
				AND SC.SalesCodeDepartmentSSID IN ( 1099 )
      ),
	Appt AS
	  (
		SELECT  DA.ClientKey
		,       MAX(DA.AppointmentDate) AS 'LastAppointmentDate'
		FROM    HC_BI_CMS_DDS.bi_cms_dds.DimAppointment DA
		WHERE   DA.AppointmentDate < GETDATE()
		GROUP BY DA.ClientKey
	  )


SELECT  CONVERT(INT, D.CenterNumber) AS 'CenterNumber'
,       D.CenterDescription
,       D.CenterPhone1
,       CONVERT(INT, D.ClientIdentifier) AS 'ClientIdentifier'
,       D.ClientFullName
,       D.ClientEMailAddress
,       D.ClientAddress1
,       D.ClientAddress2
,       D.City
,       D.State
,       D.Zip
,       D.CurrentMembership
,       D.CurrentMembershipStatus
,       D.ClientMembershipBeginDate
,       D.ClientMembershipEndDate
,       D.PreviousMembership
,       A.LastAppointmentDate
,       D.CancelDate
,       D.CancelReasonDescription
,       D.ClientDateOfBirth
,       D.ClientGenderDescription
,       D.ContactLanguageDescription
,       D.DoNotSolicitFlag
,       D.DoNotEmailFlag
,       D.DoNotCallFlag
,       D.DoNotMailFlag
,       D.DoNotTextFlag
FROM    Data D
        LEFT OUTER JOIN Appt A
            ON D.ClientKey = A.ClientKey
WHERE   D.CenterNumber LIKE '[278]%'
