/* CreateDate: 06/27/2014 09:27:22.020 , ModifyDate: 06/30/2014 15:06:18.293 */
GO
/***********************************************************************
PROCEDURE:				spRpt_Traditional995Campaign
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		06/27/2014
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_Traditional995Campaign
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_Traditional995Campaign]
AS
BEGIN

SET NOCOUNT ON;

DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME


SET @StartDate = '6/26/2014'
SET @EndDate = DATEADD(dd, -1, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))


/********************************** Get Traditional Sales *************************************/
SELECT  DC.CenterKey
,       DC.CenterSSID AS 'CenterNumber'
,       DC.CenterDescriptionNumber AS 'CenterName'
,       CLT.ClientKey
,       CLT.ClientIdentifier
,       CONVERT(VARCHAR, CLT.ClientIdentifier) + ' - ' + CLT.ClientFullName AS 'ClientName'
,		CLT.ClientAddress1
,		CLT.ClientAddress2
,		CLT.ClientAddress3
,		CLT.City
,		CLT.StateProvinceDescriptionShort AS 'State'
,		CLT.PostalCode AS 'Zip'
,		CLT.ClientEMailAddress
,       CLT.ClientGenderDescription AS 'Gender'
,       ISNULL(Phone.HomePhone, '') AS 'HomePhone'
,       ISNULL(Phone.WorkPhone, '') AS 'WorkPhone'
,       ISNULL(Phone.CellPhone, '') AS 'CellPhone'
,		DD.FullDate AS 'SaleDate'
,       DM.MembershipKey
,       DM.MembershipDescription AS 'Membership'
,		DCM.ClientMembershipKey
,       DCM.ClientMembershipBeginDate
,       DCM.ClientMembershipEndDate
,		DCM.ClientMembershipContractPrice AS 'ContractPrice'
,		PFR.EmployeeInitials AS 'Consultant'
,		PFR.EmployeeFullName AS 'ConsultantName'
INTO	#Clients
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			ON FST.CenterKey = CTR.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON FST.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
			ON FST.SalesOrderKey = DSO.SalesOrderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD
			ON FST.SalesOrderDetailKey = DSOD.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
			ON DSO.ClientMembershipKey = DCM.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
			ON DCM.MembershipSSID = DM.MembershipSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON DCM.CenterKey = DC.CenterKey
        LEFT OUTER JOIN ( SELECT    ClientKey
                          ,         CASE WHEN ClientPhone1TypeDescriptionShort = 'Home' THEN ClientPhone1
                                         WHEN ClientPhone2TypeDescriptionShort = 'Home' THEN ClientPhone2
                                         WHEN ClientPhone3TypeDescriptionShort = 'Home' THEN ClientPhone3
                                    END AS 'HomePhone'
                          ,         CASE WHEN ClientPhone1TypeDescriptionShort = 'Work' THEN ClientPhone1
                                         WHEN ClientPhone2TypeDescriptionShort = 'Work' THEN ClientPhone2
                                         WHEN ClientPhone3TypeDescriptionShort = 'Work' THEN ClientPhone3
                                    END AS 'WorkPhone'
                          ,         CASE WHEN ClientPhone1TypeDescriptionShort = 'Mobile' THEN ClientPhone1
                                         WHEN ClientPhone2TypeDescriptionShort = 'Mobile' THEN ClientPhone2
                                         WHEN ClientPhone3TypeDescriptionShort = 'Mobile' THEN ClientPhone3
                                    END AS 'CellPhone'
                          FROM      HC_BI_CMS_DDS.bi_cms_dds.DimClient
                          WHERE     ClientPhone1 <> ''
                                    OR ClientPhone2 <> ''
                                    OR clientphone3 <> ''
                        ) Phone
            ON FST.ClientKey = Phone.ClientKey
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee PFR
			ON FST.Employee1Key = PFR.EmployeeKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
        AND DSC.SalesCodeDepartmentSSID IN ( 1010 )
        AND DM.MembershipKey = 63
ORDER BY DSO.OrderDate


/********************************** Get Initial Application Date *************************************/
SELECT	FST.ClientKey
,		MIN(DD.FullDate) AS 'InitialAppDate'
INTO	#InitialAppDate
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN #Clients C
			ON FST.ClientKey = C.ClientKey
				AND FST.ClientMembershipKey = C.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON FST.SalesCodeKey = DSC.SalesCodeKey
WHERE   DSC.SalesCodeSSID IN ( 647, 648 )
GROUP BY FST.ClientKey


/********************************** Get Last Appointment Date *************************************/
SELECT  DA.ClientKey
,		DA.ClientMembershipKey
,       MAX(AppointmentDate) AS 'LastAppointmentDate'
INTO    #LastAppointmentDate
FROM    HC_BI_CMS_DDS.bi_cms_dds.DimAppointment DA
		INNER JOIN #Clients C
			ON DA.ClientKey = C.ClientKey
				AND DA.ClientMembershipKey = C.ClientMembershipKey
WHERE   DA.AppointmentDate < GETDATE()
GROUP BY DA.ClientKey
,		DA.ClientMembershipKey


/********************************** Get Initial Conversion Date *************************************/
SELECT	FST.ClientKey
,		MIN(DD.FullDate) AS 'InitialConvDate'
INTO	#InitialConvDate
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN #Clients C
			ON FST.ClientKey = C.ClientKey
				AND FST.ClientMembershipKey = C.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON FST.SalesCodeKey = DSC.SalesCodeKey
WHERE   DSC.SalesCodeSSID IN ( 356 )
GROUP BY FST.ClientKey


/********************************** Get Conversions *************************************/
SELECT	FST.ClientKey
,		DM.MembershipDescription AS 'ConvertedTo'
INTO	#ConvertedClients
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN #Clients C
			ON FST.ClientKey = C.ClientKey
				AND FST.ClientMembershipKey = C.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON FST.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
			ON FST.SalesOrderKey = DSO.SalesOrderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
			ON DSO.ClientMembershipKey = DCM.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
			ON DCM.MembershipKey = DM.MembershipKey
WHERE   DSC.SalesCodeDepartmentSSID IN ( 1075 )


/********************************** Get Payment Dates *************************************/
SELECT	FST.ClientKey
,		FST.ClientMembershipKey
,		MIN(DD.FullDate) AS 'FirstPaymentDate'
,		MAX(DD.FullDate) AS 'LastPaymentDate'
,		SUM(FST.ExtendedPrice) AS 'TotalRevenue'
INTO	#Payments
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN #Clients C
			ON FST.ClientKey = C.ClientKey
				AND FST.ClientMembershipKey = C.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON FST.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment DSCD
			ON DSC.SalesCodeDepartmentKey = DSCD.SalesCodeDepartmentKey
WHERE   DSCD.SalesCodeDepartmentSSID IN ( 2020 )
GROUP BY FST.ClientKey
,		FST.ClientMembershipKey


/********************************** Get Initial Payment *************************************/
SELECT	FST.ClientKey
,		FST.ClientMembershipKey
,		FST.ExtendedPrice AS 'InitialPayment'
,		ROW_NUMBER() OVER(PARTITION BY FST.ClientKey ORDER BY DD.FullDate ASC) AS 'PaymentID'
INTO	#InitialPayment
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN #Clients C
			ON FST.ClientKey = C.ClientKey
				AND FST.ClientMembershipKey = C.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON FST.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment DSCD
			ON DSC.SalesCodeDepartmentKey = DSCD.SalesCodeDepartmentKey
WHERE   DSCD.SalesCodeDepartmentSSID IN ( 2020 )


/********************************** Get NB1 Cancels *************************************/
SELECT	FST.ClientKey
,		FST.ClientMembershipKey
,		MAX(DD.FullDate) AS 'NB1CancelDate'
,		DMOR.MembershipOrderReasonDescription AS 'NB1CancelReason'
INTO	#NB1CancelDate
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN #Clients C
			ON FST.ClientKey = C.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON FST.SalesCodeKey = DSC.SalesCodeKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
            ON FST.SalesOrderKey = DSO.SalesOrderKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD
            ON FST.SalesOrderDetailKey = DSOD.SalesOrderDetailKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
            ON DSO.ClientMembershipKey = DCM.ClientMembershipKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
            ON DCM.MembershipKey = DM.MembershipKey
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembershipOrderReason DMOR
			ON DSOD.MembershipOrderReasonID = DMOR.MembershipOrderReasonID
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
		AND DSC.SalesCodeDepartmentSSID IN ( 1099 )
		AND DM.MembershipKey = 63
        AND DSO.IsGuaranteeFlag = 0
GROUP BY FST.ClientKey
,		FST.ClientMembershipKey
,		DMOR.MembershipOrderReasonDescription


/********************************** Get PCP Cancels *************************************/
SELECT	FST.ClientKey
,		FST.ClientMembershipKey
,		MAX(DD.FullDate) AS 'PCPCancelDate'
,		DMOR.MembershipOrderReasonDescription AS 'PCPCancelReason'
INTO	#PCPCancelDate
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN #Clients C
			ON FST.ClientKey = C.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON FST.SalesCodeKey = DSC.SalesCodeKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
            ON FST.SalesOrderKey = DSO.SalesOrderKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD
            ON FST.SalesOrderDetailKey = DSOD.SalesOrderDetailKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
            ON DSO.ClientMembershipKey = DCM.ClientMembershipKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
            ON DCM.MembershipKey = DM.MembershipKey
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembershipOrderReason DMOR
			ON DSOD.MembershipOrderReasonID = DMOR.MembershipOrderReasonID
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
		AND DSC.SalesCodeDepartmentSSID IN ( 1099 )
		AND DM.RevenueGroupSSID = 2
GROUP BY FST.ClientKey
,		FST.ClientMembershipKey
,		DMOR.MembershipOrderReasonDescription


/********************************** Combine Data *************************************/
SELECT  C.CenterKey
,       C.CenterNumber
,       C.CenterName
,       C.ClientKey
,       C.ClientIdentifier
,       C.ClientName
,		C.ClientAddress1
,		C.ClientAddress2
,		C.ClientAddress3
,		C.City
,		C.State
,		C.Zip
,		C.ClientEmailAddress
,       C.Gender
,		C.HomePhone
,		C.WorkPhone
,		C.CellPhone
,       C.SaleDate
,       C.MembershipKey
,       C.Membership
,       C.ClientMembershipKey
,       C.ClientMembershipBeginDate
,       C.ClientMembershipEndDate
,		C.ContractPrice
,       C.Consultant
,       C.ConsultantName
,		MIN(IAD.InitialAppDate) AS 'InitialAppDate'
,		MAX(LAD.LastAppointmentDate) AS 'LastAppointmentDate'
,		MIN(ICD.InitialConvDate) AS 'InitialConvDate'
,		CC.ConvertedTo
,       MIN(P.FirstPaymentDate) AS 'InitialPaymentDate'
,		SUM(IP.InitialPayment) AS 'InitialPayment'
,       MAX(P.LastPaymentDate) AS 'LastPaymentDate'
,       SUM(P.TotalRevenue) AS 'TotalRevenue'
,		MAX(NCD.NB1CancelDate) AS 'NB1CancelDate'
,		NCD.NB1CancelReason
,		MAX(PCD.PCPCancelDate) AS 'PCPCancelDate'
,		PCD.PCPCancelReason
,		dbo.GetCurrentClientMembershipKey(C.ClientKey) AS 'CurrentClientMembershipKey'
INTO	#Results
FROM    #Clients C
        LEFT OUTER JOIN #InitialAppDate IAD
            ON C.ClientKey = IAD.ClientKey
        LEFT OUTER JOIN #LastAppointmentDate LAD
            ON C.ClientKey = LAD.ClientKey
        LEFT OUTER JOIN #InitialConvDate ICD
            ON C.ClientKey = ICD.ClientKey
		LEFT OUTER JOIN #ConvertedClients CC
			ON C.ClientKey = CC.ClientKey
        LEFT OUTER JOIN #Payments P
            ON C.ClientKey = P.ClientKey
        LEFT OUTER JOIN #InitialPayment IP
            ON C.ClientKey = IP.ClientKey
				AND IP.PaymentID = 1
        LEFT OUTER JOIN #NB1CancelDate NCD
            ON C.ClientKey = NCD.ClientKey
        LEFT OUTER JOIN #PCPCancelDate PCD
            ON C.ClientKey = PCD.ClientKey
WHERE   C.CenterNumber LIKE '[2]%'
GROUP BY C.CenterKey
,       C.CenterNumber
,       C.CenterName
,       C.ClientKey
,       C.ClientIdentifier
,       C.ClientName
,		C.ClientAddress1
,		C.ClientAddress2
,		C.ClientAddress3
,		C.City
,		C.State
,		C.Zip
,		C.ClientEmailAddress
,       C.Gender
,		C.HomePhone
,		C.WorkPhone
,		C.CellPhone
,       C.SaleDate
,       C.MembershipKey
,       C.Membership
,       C.ClientMembershipKey
,       C.ClientMembershipBeginDate
,       C.ClientMembershipEndDate
,		C.ContractPrice
,       C.Consultant
,       C.ConsultantName
,		CC.ConvertedTo
,		NCD.NB1CancelReason
,		PCD.PCPCancelReason


/********************************** Display Data *************************************/
SELECT  R.CenterName
,       R.ClientName
,		R.ClientAddress1
,		R.ClientAddress2
,		R.City
,		R.State
,		R.Zip
,		R.ClientEmailAddress
,       R.Gender
,		R.HomePhone
,		R.WorkPhone
,		R.CellPhone
,       R.SaleDate
,       R.Membership
,       R.ClientMembershipBeginDate AS 'MembershipBeginDate'
,       R.ClientMembershipEndDate AS 'MembershipEndDate'
,		R.ContractPrice
,       R.Consultant
,       R.ConsultantName
,		R.InitialAppDate
,		R.LastAppointmentDate
,		R.InitialConvDate
,		R.ConvertedTo
,       R.InitialPaymentDate
,		R.InitialPayment
,       R.LastPaymentDate
,       R.TotalRevenue
,		R.NB1CancelDate
,		R.NB1CancelReason
,		R.PCPCancelDate
,		R.PCPCancelReason
,		DM.MembershipDescription AS 'CurrentMembership'
,		DCM.ClientMembershipBeginDate AS 'CurrentMembershipBeginDate'
,		DCM.ClientMembershipEndDate AS 'CurrentMembershipEndDate'
,		DCM.ClientMembershipStatusDescription AS 'CurrentMembershipStatus'
FROM    #Results R
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
			ON R.CurrentClientMembershipKey = DCM.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
			ON DCM.MembershipKey = DM.MembershipKey

END
GO
