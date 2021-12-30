/* CreateDate: 07/22/2015 10:04:57.857 , ModifyDate: 01/03/2019 18:32:10.027 */
GO
/***********************************************************************
PROCEDURE:				spSvc_PopulateClients
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Accounting
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		07/22/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_PopulateClients
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_PopulateClients]
AS
BEGIN


DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME


SET @StartDate = DATEADD(dd, -1, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
SET @EndDate = DATEADD(dd, -1, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))


DECLARE @UpdateClients TABLE (
	ClientIdentifier INT PRIMARY KEY
)


-- Get Client Records that changed
INSERT  INTO @UpdateClients
		-- Updated Clients
        SELECT DISTINCT
                CLT.ClientIdentifier
        FROM    HairClubCMS.dbo.datClient CLT WITH ( NOLOCK )
                LEFT OUTER JOIN HC_Accounting.dbo.dbaClient C
                    ON C.ClientIdentifier = CLT.ClientIdentifier
        WHERE   C.ClientID IS NULL
                OR CLT.LastUpdate > C.RecordLastUpdate

		UNION

		-- Clients who had a Membership Change, Service or Payment Transaction within the specified period
		SELECT  DISTINCT
				cl.ClientIdentifier
		FROM    HairClubCMS.dbo.datSalesOrderDetail sod
				INNER JOIN HairClubCMS.dbo.datSalesOrder so
					ON so.SalesOrderGUID = sod.SalesOrderGUID
				INNER JOIN HairClubCMS.dbo.cfgSalesCode sc
					ON sc.SalesCodeID = sod.SalesCodeID
				INNER JOIN HairClubCMS.dbo.datClient cl
					ON cl.ClientGUID = so.ClientGUID
		WHERE   so.OrderDate BETWEEN @StartDate AND @EndDate + ' 23:59:59'
				AND sc.SalesCodeDepartmentID IN ( 1010, 1070, 1075, 1080, 1090, 1095, 1099, 5010, 5020, 5030, 5035, 5037, 5038, 2020, 2025 )
				AND so.IsVoidedFlag <> 1

		UNION

		-- Clients who had an Appointment created or updated
        SELECT	DISTINCT
				CLT.ClientIdentifier
        FROM    HairClubCMS.dbo.datAppointment DA WITH (NOLOCK)
				INNER JOIN HairClubCMS.dbo.datClient CLT WITH (NOLOCK)
					ON CLT.ClientGUID = DA.ClientGUID
		WHERE	( DA.CreateDate BETWEEN @StartDate AND @EndDate + ' 23:59:59'
				  OR DA.LastUpdate BETWEEN @StartDate AND @EndDate + ' 23:59:59' );


-- Update Clients
WITH
x_PMT AS
(
	SELECT  FST.ClientKey
	,       DCM.ClientMembershipSSID
	,       MIN(DD.FullDate) AS 'FirstPaymentDate'
	,       MAX(DD.FullDate) AS 'LastPaymentDate'
	,       SUM(FST.ExtendedPrice) AS 'TotalPayments'
	FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST WITH (NOLOCK)
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD WITH (NOLOCK)
				ON FST.OrderDateKey = DD.DateKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC WITH (NOLOCK)
				ON FST.SalesCodeKey = DSC.SalesCodeKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO WITH (NOLOCK)
				ON FST.SalesOrderKey = DSO.SalesOrderKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD WITH (NOLOCK)
				ON FST.SalesOrderDetailKey = DSOD.SalesOrderDetailKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM WITH (NOLOCK)
				ON DSO.ClientMembershipKey = DCM.ClientMembershipKey
	WHERE   DSC.SalesCodeDepartmentSSID = 2020
			AND DSOD.IsVoidedFlag = 0
	GROUP BY  FST.ClientKey
	,       DCM.ClientMembershipSSID
),
x_Cancel AS
(
	SELECT ROW_NUMBER() OVER (PARTITION BY FST.ClientKey, DCM.ClientMembershipSSID ORDER BY DSO.OrderDate DESC) AS [Row],
		FST.ClientKey,
		DCM.ClientMembershipSSID,
		DSO.OrderDate AS 'CancelDate',
		DMOR.MembershipOrderReasonDescription AS 'CancelReason'
	FROM
		HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST WITH (NOLOCK)
	INNER JOIN
		HC_BI_ENT_DDS.bief_dds.DimDate DD WITH (NOLOCK) ON FST.OrderDateKey = DD.DateKey
	INNER JOIN
		HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC WITH (NOLOCK) ON FST.SalesCodeKey = DSC.SalesCodeKey
	INNER JOIN
		HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO WITH (NOLOCK) ON FST.SalesOrderKey = DSO.SalesOrderKey
	INNER JOIN
		HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD WITH (NOLOCK) ON FST.SalesOrderDetailKey = DSOD.SalesOrderDetailKey
	INNER JOIN
		HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM WITH (NOLOCK) ON DSO.ClientMembershipKey = DCM.ClientMembershipKey
	LEFT OUTER JOIN
		HC_BI_CMS_DDS.bi_cms_dds.DimMembershipOrderReason DMOR WITH (NOLOCK) ON DSOD.MembershipOrderReasonID = DMOR.MembershipOrderReasonID
	WHERE
		DSC.SalesCodeDepartmentSSID = 1099
		AND DSOD.IsVoidedFlag = 0
),
ISACNV AS
(
	SELECT
		ROW_NUMBER() OVER (PARTITION BY FST.ClientKey, DSC.SalesCodeDepartmentSSID ORDER BY DSO.OrderDate ASC) AS [Row],
		FST.ClientKey,
		DSC.SalesCodeDepartmentSSID,
		DCM.ClientMembershipKey,
		DSO.OrderDate AS 'OrderDate',
		DM.MembershipDescription AS 'MembershipDescription',
		ISNULL(REPLACE(REPLACE(PFR.EmployeeFullName, ',', ''), 'Unknown Unknown', ''), '') AS 'EmployeeFullName'
	FROM
		HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST WITH (NOLOCK)
	INNER JOIN
		HC_BI_ENT_DDS.bief_dds.DimDate DD WITH (NOLOCK) ON DD.DateKey = FST.OrderDateKey
	INNER JOIN
		HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC WITH (NOLOCK) ON DSC.SalesCodeKey = FST.SalesCodeKey
	INNER JOIN
		HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO WITH (NOLOCK) ON DSO.SalesOrderKey = FST.SalesOrderKey
	INNER JOIN
		HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD WITH (NOLOCK) ON FST.SalesOrderDetailKey = DSOD.SalesOrderDetailKey
	INNER JOIN
		HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM WITH (NOLOCK) ON DCM.ClientMembershipKey = DSO.ClientMembershipKey
	INNER JOIN
		HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM WITH (NOLOCK) ON DM.MembershipSSID = DCM.MembershipSSID
	LEFT OUTER JOIN
		HC_BI_CMS_DDS.bi_cms_dds.DimEmployee PFR WITH (NOLOCK) ON PFR.EmployeeKey = FST.Employee1Key
	WHERE DSC.SalesCodeDepartmentSSID IN ( 1010, 1075 )
		AND DM.MembershipSSID NOT IN ( 57, 58 )
		AND DSOD.IsVoidedFlag = 0
),
IAP_ AS
(
	SELECT
		ROW_NUMBER() OVER (PARTITION BY FST.ClientKey ORDER BY DSO.OrderDate ASC) AS [Row],
		FST.ClientKey,
		DSO.OrderDate AS 'InitialApplicationDate'
	FROM
		HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST WITH (NOLOCK)
	INNER JOIN
		HC_BI_ENT_DDS.bief_dds.DimDate DD WITH (NOLOCK) ON FST.OrderDateKey = DD.DateKey
	INNER JOIN
		HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC WITH (NOLOCK) ON FST.SalesCodeKey = DSC.SalesCodeKey
	INNER JOIN
		HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO WITH (NOLOCK) ON DSO.SalesOrderKey = FST.SalesOrderKey
	INNER JOIN
		HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD WITH (NOLOCK) ON FST.SalesOrderDetailKey = DSOD.SalesOrderDetailKey
	WHERE
		DSC.SalesCodeSSID IN ( 648 )
		AND DSOD.IsVoidedFlag = 0
),
FAPLAP_ AS
(
SELECT    DA.ClientKey
                      ,         MIN(DA.AppointmentDate) AS 'FirstAppointmentDate',
					  MAX(DA.AppointmentDate) AS 'LastAppointmentDate'
                      FROM      HC_BI_CMS_DDS.bi_cms_dds.DimAppointment DA WITH (NOLOCK)
                      WHERE     DA.AppointmentDate < GETDATE()
                                AND DA.IsDeletedFlag = 0
                      GROUP BY  DA.ClientKey
),
NAP_ AS
(
SELECT    DA.ClientKey
                      ,         MAX(DA.AppointmentDate) AS 'NextAppointmentDate'
                      FROM      HC_BI_CMS_DDS.bi_cms_dds.DimAppointment DA WITH (NOLOCK)
                      WHERE     DA.AppointmentDate > GETDATE()
                                AND DA.IsDeletedFlag = 0
                      GROUP BY  DA.ClientKey
)
UPDATE  C
SET     CenterID = CTR.CenterSSID
,       CenterDescription = CTR.CenterDescriptionNumber
,       LeadID = CASE WHEN CON.ContactSSID = '-2' THEN ''
                      ELSE CON.ContactSSID
                 END
,       FirstName = CLT.ClientFirstName
,       LastName = CLT.ClientLastName
,       FullName = CLT.ClientFullName
,       Address1 = CLT.ClientAddress1
,       Address2 = CLT.ClientAddress2
,       State = CLT.StateProvinceDescriptionShort
,       City = CLT.City
,       ZipCode = CLT.PostalCode
,       Country = CLT.CountryRegionDescriptionShort
,       HomePhone = ISNULL(CASE WHEN CLT.ClientPhone1TypeDescriptionShort = 'Home' THEN CLT.ClientPhone1
                                WHEN CLT.ClientPhone2TypeDescriptionShort = 'Home' THEN CLT.ClientPhone2
                                WHEN CLT.ClientPhone3TypeDescriptionShort = 'Home' THEN CLT.ClientPhone3
                           END, '')
,       WorkPhone = ISNULL(CASE WHEN CLT.ClientPhone1TypeDescriptionShort = 'Work' THEN CLT.ClientPhone1
                                WHEN CLT.ClientPhone2TypeDescriptionShort = 'Work' THEN CLT.ClientPhone2
                                WHEN CLT.ClientPhone3TypeDescriptionShort = 'Work' THEN CLT.ClientPhone3
                           END, '')
,       CellPhone = ISNULL(CASE WHEN CLT.ClientPhone1TypeDescriptionShort = 'Mobile' THEN CLT.ClientPhone1
                                WHEN CLT.ClientPhone2TypeDescriptionShort = 'Mobile' THEN CLT.ClientPhone2
                                WHEN CLT.ClientPhone3TypeDescriptionShort = 'Mobile' THEN CLT.ClientPhone3
                           END, '')
,       EmailAddress = ISNULL(CLT.ClientEMailAddress, '')
,       SiebelID = ISNULL(CLT.BosleySiebelID, '')
,       Age = FLOOR(DATEDIFF(WEEK, ClientDateOfBirth, GETDATE()) / ( 52 ))
,       Ethinicity = ISNULL(LE.EthnicityDescription, '')
,       Occupation = ISNULL(LO.OccupationDescription, '')
,       MaritalStatus = ISNULL(LMS.MaritalStatusDescription, '')
,       ARBalance = CLT.ClientARBalance
,       InitialSaleDate = ISA.OrderDate
,       MembershipSold = ISA.MembershipDescription
,       SoldBy = ISA.EmployeeFullName
,       InitialApplicationDate = IAP.InitialApplicationDate
,       ConversionDate = CNV.OrderDate
,       ConvertedTo = CNV.MembershipDescription
,       ConvertedBy = CNV.EmployeeFullName
,       FirstAppointmentDate = FAPLAP.FirstAppointmentDate
,       LastAppointmentDate = FAPLAP.LastAppointmentDate
,       NextAppointmentDate = NAP.NextAppointmentDate
,       BIO_RevenueGroupSSID = DM_BIO.RevenueGroupSSID
,       BIO_Membership = ISNULL(DM_BIO.MembershipDescription, '')
,       BIO_BeginDate = DCM_BIO.ClientMembershipBeginDate
,       BIO_EndDate = DCM_BIO.ClientMembershipEndDate
,       BIO_MembershipStatus = ISNULL(DCM_BIO.ClientMembershipStatusDescription, '')
,       BIO_MonthlyFee = ISNULL(DCM_BIO.ClientMembershipMonthlyFee, 0)
,       BIO_ContractPrice = ISNULL(DCM_BIO.ClientMembershipContractPrice, 0)
,       BIO_FirstPaymentDate = BIO_PMT.FirstPaymentDate
,       BIO_LastPaymentDate = BIO_PMT.LastPaymentDate
,       BIO_TotalPayments = ISNULL(BIO_PMT.TotalPayments, 0)
,       BIO_CancelDate = BIO_Cancel.CancelDate
,       BIO_CancelReason = ISNULL(BIO_Cancel.CancelReason, '')
,       EXT_RevenueGroupSSID = DM_EXT.RevenueGroupSSID
,       EXT_Membership = ISNULL(DM_EXT.MembershipDescription, '')
,       EXT_BeginDate = DCM_EXT.ClientMembershipBeginDate
,       EXT_EndDate = DCM_EXT.ClientMembershipEndDate
,       EXT_MembershipStatus = ISNULL(DCM_EXT.ClientMembershipStatusDescription, '')
,       EXT_MonthlyFee = ISNULL(DCM_EXT.ClientMembershipMonthlyFee, 0)
,       EXT_ContractPrice = ISNULL(DCM_EXT.ClientMembershipContractPrice, 0)
,       EXT_FirstPaymentDate = EXT_PMT.FirstPaymentDate
,       EXT_LastPaymentDate = EXT_PMT.LastPaymentDate
,       EXT_TotalPayments = ISNULL(EXT_PMT.TotalPayments, 0)
,       EXT_CancelDate = EXT_Cancel.CancelDate
,       EXT_CancelReason = ISNULL(EXT_Cancel.CancelReason, '')
,       SUR_RevenueGroupSSID = DM_SUR.RevenueGroupSSID
,       SUR_Membership = ISNULL(DM_SUR.MembershipDescription, '')
,       SUR_BeginDate = DCM_SUR.ClientMembershipBeginDate
,       SUR_EndDate = DCM_SUR.ClientMembershipEndDate
,       SUR_MembershipStatus = ISNULL(DCM_SUR.ClientMembershipStatusDescription, '')
,       SUR_MonthlyFee = ISNULL(DCM_SUR.ClientMembershipMonthlyFee, 0)
,       SUR_ContractPrice = ISNULL(DCM_SUR.ClientMembershipContractPrice, 0)
,       SUR_FirstPaymentDate = SUR_PMT.FirstPaymentDate
,       SUR_LastPaymentDate = SUR_PMT.LastPaymentDate
,       SUR_TotalPayments = ISNULL(SUR_PMT.TotalPayments, 0)
,       SUR_CancelDate = SUR_Cancel.CancelDate
,       SUR_CancelReason = ISNULL(SUR_Cancel.CancelReason, '')
,       XTR_RevenueGroupSSID = DM_XTR.RevenueGroupSSID
,       XTR_Membership = ISNULL(DM_XTR.MembershipDescription, '')
,       XTR_BeginDate = DCM_XTR.ClientMembershipBeginDate
,       XTR_EndDate = DCM_XTR.ClientMembershipEndDate
,       XTR_MembershipStatus = ISNULL(DCM_XTR.ClientMembershipStatusDescription, '')
,       XTR_MonthlyFee = ISNULL(DCM_XTR.ClientMembershipMonthlyFee, 0)
,       XTR_ContractPrice = ISNULL(DCM_XTR.ClientMembershipContractPrice, 0)
,       XTR_FirstPaymentDate = XTR_PMT.FirstPaymentDate
,       XTR_LastPaymentDate = XTR_PMT.LastPaymentDate
,       XTR_TotalPayments = ISNULL(XTR_PMT.TotalPayments, 0)
,       XTR_CancelDate = XTR_Cancel.CancelDate
,       XTR_CancelReason = ISNULL(XTR_Cancel.CancelReason, '')
,       DoNotCallFlag = CLT.DoNotCallFlag
,       DoNotContactFlag = CLT.DoNotContactFlag
,       RecordLastUpdate = DC.LastUpdate
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = 'dbaClient-Update'
FROM    HC_Accounting.dbo.dbaClient C
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT WITH (NOLOCK)
            ON CLT.ClientIdentifier = C.ClientIdentifier
        INNER JOIN HairClubCMS.dbo.datClient DC WITH (NOLOCK)
            ON DC.ClientIdentifier = CLT.ClientIdentifier
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR WITH (NOLOCK)
            ON CTR.CenterSSID = CLT.CenterSSID
        LEFT OUTER JOIN HairClubCMS.dbo.datClientDemographic DCD WITH (NOLOCK)
            ON DCD.ClientIdentifier = CLT.ClientIdentifier
        LEFT OUTER JOIN HairClubCMS.dbo.lkpEthnicity LE WITH (NOLOCK)
            ON LE.EthnicityID = DCD.EthnicityID
        LEFT OUTER JOIN HairClubCMS.dbo.lkpOccupation LO WITH (NOLOCK)
            ON LO.OccupationID = DCD.OccupationID
        LEFT OUTER JOIN HairClubCMS.dbo.lkpMaritalStatus LMS WITH (NOLOCK)
            ON LMS.MaritalStatusID = DCD.MaritalStatusID
        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM_BIO WITH (NOLOCK)
            ON DCM_BIO.ClientMembershipSSID = CLT.CurrentBioMatrixClientMembershipSSID
        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM_BIO WITH (NOLOCK)
            ON DM_BIO.MembershipKey = DCM_BIO.MembershipKey
        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM_EXT WITH (NOLOCK)
            ON DCM_EXT.ClientMembershipSSID = CLT.CurrentExtremeTherapyClientMembershipSSID
        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM_EXT WITH (NOLOCK)
            ON DM_EXT.MembershipKey = DCM_EXT.MembershipKey
        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM_SUR WITH (NOLOCK)
            ON DCM_SUR.ClientMembershipSSID = CLT.CurrentSurgeryClientMembershipSSID
        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM_SUR WITH (NOLOCK)
            ON DM_SUR.MembershipKey = DCM_SUR.MembershipKey
        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM_XTR WITH (NOLOCK)
            ON DCM_XTR.ClientMembershipSSID = CLT.CurrentXtrandsClientMembershipSSID
        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM_XTR WITH (NOLOCK)
            ON DM_XTR.MembershipKey = DCM_XTR.MembershipKey
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact CON WITH (NOLOCK)
            ON CON.ContactKey = CLT.contactkey
        LEFT JOIN @UpdateClients UC
            ON UC.ClientIdentifier = C.ClientIdentifier
		LEFT JOIN x_PMT AS BIO_PMT ON BIO_PMT.ClientKey = CLT.ClientKey AND BIO_PMT.ClientMembershipSSID = CLT.CurrentBioMatrixClientMembershipSSID
		LEFT JOIN x_PMT AS EXT_PMT ON EXT_PMT.ClientKey = CLT.ClientKey AND EXT_PMT.ClientMembershipSSID = CLT.CurrentExtremeTherapyClientMembershipSSID
		LEFT JOIN x_PMT AS SUR_PMT ON SUR_PMT.ClientKey = CLT.ClientKey AND SUR_PMT.ClientMembershipSSID = CLT.CurrentSurgeryClientMembershipSSID
		LEFT JOIN x_PMT AS XTR_PMT ON XTR_PMT.ClientKey = CLT.ClientKey AND XTR_PMT.ClientMembershipSSID = CLT.CurrentXtrandsClientMembershipSSID
		LEFT JOIN x_Cancel AS BIO_Cancel ON BIO_Cancel.ClientKey = CLT.ClientKey AND BIO_Cancel.ClientMembershipSSID = CLT.CurrentBioMatrixClientMembershipSSID AND BIO_Cancel.[Row] = 1
		LEFT JOIN x_Cancel AS EXT_Cancel ON EXT_Cancel.ClientKey = CLT.ClientKey AND EXT_Cancel.ClientMembershipSSID = CLT.CurrentExtremeTherapyClientMembershipSSID AND EXT_Cancel.[Row] = 1
		LEFT JOIN x_Cancel AS SUR_Cancel ON SUR_Cancel.ClientKey = CLT.ClientKey AND SUR_Cancel.ClientMembershipSSID = CLT.CurrentSurgeryClientMembershipSSID AND SUR_Cancel.[Row] = 1
		LEFT JOIN x_Cancel AS XTR_Cancel ON XTR_Cancel.ClientKey = CLT.ClientKey AND XTR_Cancel.ClientMembershipSSID = CLT.CurrentXtrandsClientMembershipSSID AND XTR_Cancel.[Row] = 1
		LEFT JOIN ISACNV AS ISA ON ISA.ClientKey = CLT.ClientKey AND ISA.SalesCodeDepartmentSSID = 1010 AND ISA.[Row] = 1
		LEFT JOIN ISACNV AS CNV ON CNV.ClientKey = CLT.ClientKey AND CNV.SalesCodeDepartmentSSID = 1075 AND CNV.[Row] = 1
		LEFT JOIN IAP_ AS IAP ON IAP.ClientKey = CLT.ClientKey AND IAP.[Row] = 1
		LEFT JOIN FAPLAP_ AS FAPLAP ON FAPLAP.ClientKey = CLT.ClientKey
		LEFT JOIN NAP_ AS NAP ON NAP.ClientKey = CLT.ClientKey

WHERE   DC.LastUpdate > C.RecordLastUpdate
        OR UC.ClientIdentifier IS NOT NULL;


-- Insert Client Records
WITH
x_PMT AS
(
	SELECT
			  FST.ClientKey
	,         DCM.ClientMembershipSSID
	,         MIN(DD.FullDate) AS 'FirstPaymentDate'
	,         MAX(DD.FullDate) AS 'LastPaymentDate'
	,         SUM(FST.ExtendedPrice) AS 'TotalPayments'
	FROM      HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST WITH (NOLOCK)
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD WITH (NOLOCK)
				ON FST.OrderDateKey = DD.DateKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC WITH (NOLOCK)
				ON FST.SalesCodeKey = DSC.SalesCodeKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO WITH (NOLOCK)
				ON FST.SalesOrderKey = DSO.SalesOrderKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD WITH (NOLOCK)
				ON FST.SalesOrderDetailKey = DSOD.SalesOrderDetailKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM WITH (NOLOCK)
				ON DSO.ClientMembershipKey = DCM.ClientMembershipKey
	WHERE     DSC.SalesCodeDepartmentSSID = 2020
			AND DSOD.IsVoidedFlag = 0
	GROUP BY  FST.ClientKey
	,         DCM.ClientMembershipSSID
),
x_Cancel AS
(
	SELECT
		ROW_NUMBER() OVER (PARTITION BY FST.ClientKey, DCM.ClientMembershipSSID ORDER BY DSO.OrderDate DESC) AS [Row],
		FST.ClientKey,
		DCM.ClientMembershipSSID,
		DSO.OrderDate AS 'CancelDate',
		DMOR.MembershipOrderReasonDescription AS 'CancelReason'
	FROM
		HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST WITH (NOLOCK)
	INNER JOIN
		HC_BI_ENT_DDS.bief_dds.DimDate DD WITH (NOLOCK) ON FST.OrderDateKey = DD.DateKey
	INNER JOIN
		HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC WITH (NOLOCK) ON FST.SalesCodeKey = DSC.SalesCodeKey
	INNER JOIN
		HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO WITH (NOLOCK) ON FST.SalesOrderKey = DSO.SalesOrderKey
	INNER JOIN
		HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD WITH (NOLOCK) ON FST.SalesOrderDetailKey = DSOD.SalesOrderDetailKey
	INNER JOIN
		HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM WITH (NOLOCK) ON DSO.ClientMembershipKey = DCM.ClientMembershipKey
	LEFT OUTER JOIN
		HC_BI_CMS_DDS.bi_cms_dds.DimMembershipOrderReason DMOR WITH (NOLOCK) ON DSOD.MembershipOrderReasonID = DMOR.MembershipOrderReasonID
	WHERE
		DSC.SalesCodeDepartmentSSID = 1099
		AND DSOD.IsVoidedFlag = 0
),
ISACNV AS
(
	SELECT
		ROW_NUMBER() OVER (PARTITION BY FST.ClientKey, DSC.SalesCodeDepartmentSSID ORDER BY DSO.OrderDate ASC) AS [Row],
		FST.ClientKey,
		DSC.SalesCodeDepartmentSSID,
		DCM.ClientMembershipKey,
		DSO.OrderDate AS 'OrderDate',
		DM.MembershipDescription AS 'MembershipDescription',
		ISNULL(REPLACE(REPLACE(PFR.EmployeeFullName, ',', ''), 'Unknown Unknown', ''), '') AS 'EmployeeFullName'
	FROM
		HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST WITH (NOLOCK)
	INNER JOIN
		HC_BI_ENT_DDS.bief_dds.DimDate DD WITH (NOLOCK) ON DD.DateKey = FST.OrderDateKey
	INNER JOIN
		HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC WITH (NOLOCK) ON DSC.SalesCodeKey = FST.SalesCodeKey
	INNER JOIN
		HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO WITH (NOLOCK) ON DSO.SalesOrderKey = FST.SalesOrderKey
	INNER JOIN
		HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM WITH (NOLOCK) ON DCM.ClientMembershipKey = DSO.ClientMembershipKey
	INNER JOIN
		HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD WITH (NOLOCK) ON FST.SalesOrderDetailKey = DSOD.SalesOrderDetailKey
	INNER JOIN
		HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM WITH (NOLOCK) ON DM.MembershipSSID = DCM.MembershipSSID
	LEFT OUTER JOIN
		HC_BI_CMS_DDS.bi_cms_dds.DimEmployee PFR WITH (NOLOCK) ON PFR.EmployeeKey = FST.Employee1Key
	WHERE DSC.SalesCodeDepartmentSSID IN ( 1010, 1075 )
		AND DM.MembershipSSID NOT IN ( 57, 58 )
		AND DSOD.IsVoidedFlag = 0
),
IAP_ AS
(
	SELECT
		ROW_NUMBER() OVER (PARTITION BY FST.ClientKey ORDER BY DSO.OrderDate ASC) AS [Row],
		FST.ClientKey,
		DSO.OrderDate AS 'InitialApplicationDate'
	FROM
		HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST WITH (NOLOCK)
	INNER JOIN
		HC_BI_ENT_DDS.bief_dds.DimDate DD WITH (NOLOCK) ON FST.OrderDateKey = DD.DateKey
	INNER JOIN
		HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC WITH (NOLOCK) ON FST.SalesCodeKey = DSC.SalesCodeKey
	INNER JOIN
		HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO WITH (NOLOCK) ON DSO.SalesOrderKey = FST.SalesOrderKey
	INNER JOIN
		HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD WITH (NOLOCK) ON FST.SalesOrderDetailKey = DSOD.SalesOrderDetailKey
	WHERE
		DSC.SalesCodeSSID IN ( 648 )
		AND DSOD.IsVoidedFlag = 0
),
FAPLAP_ AS
(
SELECT    DA.ClientKey
                      ,         MIN(DA.AppointmentDate) AS 'FirstAppointmentDate',
					  MAX(DA.AppointmentDate) AS 'LastAppointmentDate'
                      FROM      HC_BI_CMS_DDS.bi_cms_dds.DimAppointment DA WITH (NOLOCK)
                      WHERE     DA.AppointmentDate < GETDATE()
                                AND DA.IsDeletedFlag = 0
                      GROUP BY  DA.ClientKey
),
NAP_ AS
(
SELECT    DA.ClientKey
                      ,         MAX(DA.AppointmentDate) AS 'NextAppointmentDate'
                      FROM      HC_BI_CMS_DDS.bi_cms_dds.DimAppointment DA WITH (NOLOCK)
                      WHERE     DA.AppointmentDate > GETDATE()
                                AND DA.IsDeletedFlag = 0
                      GROUP BY  DA.ClientKey
)
INSERT  INTO dbaClient (
			CenterID
        ,	CenterDescription
        ,	LeadID
        ,	ClientSSID
        ,	ClientKey
        ,	ClientIdentifier
        ,	CMSClientIdentifier
        ,	FirstName
        ,	LastName
        ,	FullName
        ,	Address1
        ,	Address2
        ,	State
        ,	City
        ,	ZipCode
        ,	Country
        ,	HomePhone
        ,	WorkPhone
        ,	CellPhone
        ,	DateOfBirth
        ,	EmailAddress
        ,	SiebelID
        ,	Gender
        ,	Age
        ,	Ethinicity
        ,	Occupation
        ,	MaritalStatus
        ,	ARBalance
        ,	InitialSaleDate
        ,	MembershipSold
        ,	SoldBy
        ,	InitialApplicationDate
        ,	ConversionDate
        ,	ConvertedTo
        ,	ConvertedBy
        ,	FirstAppointmentDate
        ,	LastAppointmentDate
        ,	NextAppointmentDate
        ,	BIO_RevenueGroupSSID
        ,	BIO_Membership
        ,	BIO_BeginDate
        ,	BIO_EndDate
        ,	BIO_MembershipStatus
        ,	BIO_MonthlyFee
        ,	BIO_ContractPrice
        ,	BIO_FirstPaymentDate
        ,	BIO_LastPaymentDate
        ,	BIO_TotalPayments
        ,	BIO_CancelDate
        ,	BIO_CancelReason
        ,	EXT_RevenueGroupSSID
        ,	EXT_Membership
        ,	EXT_BeginDate
        ,	EXT_EndDate
        ,	EXT_MembershipStatus
        ,	EXT_MonthlyFee
        ,	EXT_ContractPrice
        ,	EXT_FirstPaymentDate
        ,	EXT_LastPaymentDate
        ,	EXT_TotalPayments
        ,	EXT_CancelDate
        ,	EXT_CancelReason
        ,	SUR_RevenueGroupSSID
        ,	SUR_Membership
        ,	SUR_BeginDate
        ,	SUR_EndDate
        ,	SUR_MembershipStatus
        ,	SUR_MonthlyFee
        ,	SUR_ContractPrice
        ,	SUR_FirstPaymentDate
        ,	SUR_LastPaymentDate
        ,	SUR_TotalPayments
        ,	SUR_CancelDate
        ,	SUR_CancelReason
        ,	XTR_RevenueGroupSSID
        ,	XTR_Membership
        ,	XTR_BeginDate
        ,	XTR_EndDate
        ,	XTR_MembershipStatus
        ,	XTR_MonthlyFee
        ,	XTR_ContractPrice
        ,	XTR_FirstPaymentDate
        ,	XTR_LastPaymentDate
        ,	XTR_TotalPayments
        ,	XTR_CancelDate
        ,	XTR_CancelReason
        ,	DoNotCallFlag
        ,	DoNotContactFlag
        ,	RecordLastUpdate
        ,	CreateDate
        ,	CreateUser
        ,	LastUpdate
        ,	LastUpdateUser
		)
		SELECT  CTR.CenterSSID AS 'CenterID'
		,       CTR.CenterDescriptionNumber AS 'CenterDescription'
		,       CASE WHEN CON.ContactSSID = '-2' THEN ''
					 ELSE CON.ContactSSID
				END AS 'LeadID'
		,       CLT.ClientSSID
		,       CLT.ClientKey
		,       CLT.ClientIdentifier
		,       CLT.ClientNumber_Temp AS 'CMSClientIdentifier'
		,       CLT.ClientFirstName AS 'FirstName'
		,       CLT.ClientLastName AS 'LastName'
		,       CLT.ClientFullName AS 'FullName'
		,       CLT.ClientAddress1 AS 'Address1'
		,       CLT.ClientAddress2 AS 'Address2'
		,       CLT.StateProvinceDescriptionShort AS 'State'
		,       CLT.City AS 'City'
		,       CLT.PostalCode AS 'ZipCode'
		,       CLT.CountryRegionDescriptionShort AS 'Country'
		,       ISNULL(CASE WHEN CLT.ClientPhone1TypeDescriptionShort = 'Home' THEN CLT.ClientPhone1
							WHEN CLT.ClientPhone2TypeDescriptionShort = 'Home' THEN CLT.ClientPhone2
							WHEN CLT.ClientPhone3TypeDescriptionShort = 'Home' THEN CLT.ClientPhone3
					   END, '') AS 'HomePhone'
		,       ISNULL(CASE WHEN CLT.ClientPhone1TypeDescriptionShort = 'Work' THEN CLT.ClientPhone1
							WHEN CLT.ClientPhone2TypeDescriptionShort = 'Work' THEN CLT.ClientPhone2
							WHEN CLT.ClientPhone3TypeDescriptionShort = 'Work' THEN CLT.ClientPhone3
					   END, '') AS 'WorkPhone'
		,       ISNULL(CASE WHEN CLT.ClientPhone1TypeDescriptionShort = 'Mobile' THEN CLT.ClientPhone1
							WHEN CLT.ClientPhone2TypeDescriptionShort = 'Mobile' THEN CLT.ClientPhone2
							WHEN CLT.ClientPhone3TypeDescriptionShort = 'Mobile' THEN CLT.ClientPhone3
					   END, '') AS 'CellPhone'
		,       CLT.ClientDateOfBirth AS 'DateOfBirth'
		,       ISNULL(CLT.ClientEMailAddress, '') AS 'EmailAddress'
		,       ISNULL(CLT.BosleySiebelID, '') AS 'SiebelID'
		,       CLT.ClientGenderDescription AS 'Gender'
		,       FLOOR(DATEDIFF(WEEK, ClientDateOfBirth, GETDATE()) / ( 52 )) AS 'Age'
		,       ISNULL(LE.EthnicityDescription, '') AS 'Ethinicity'
		,       ISNULL(LO.OccupationDescription, '') AS 'Occupation'
		,       ISNULL(LMS.MaritalStatusDescription, '') AS 'MaritalStatus'
		,       CLT.ClientARBalance AS 'ARBalance'
		,       ISA.OrderDate
		,       ISA.MembershipDescription
		,       ISA.EmployeeFullName
		,       IAP.InitialApplicationDate
		,       CNV.OrderDate
		,		CNV.MembershipDescription
		,       CNV.EmployeeFullName
		,       FAPLAP.FirstAppointmentDate
		,       FAPLAP.LastAppointmentDate
		,       NAP.NextAppointmentDate
		,		DM_BIO.RevenueGroupSSID AS 'BIO_RevenueGroupSSID'
		,       ISNULL(DM_BIO.MembershipDescription, '') AS 'BIO_Membership'
		,       DCM_BIO.ClientMembershipBeginDate AS 'BIO_BeginDate'
		,       DCM_BIO.ClientMembershipEndDate AS 'BIO_EndDate'
		,       ISNULL(DCM_BIO.ClientMembershipStatusDescription, '') AS 'BIO_MembershipStatus'
		,       ISNULL(DCM_BIO.ClientMembershipMonthlyFee, 0) AS 'BIO_MonthlyFee'
		,       ISNULL(DCM_BIO.ClientMembershipContractPrice, 0) AS 'BIO_ContractPrice'
		,       BIO_PMT.FirstPaymentDate AS 'BIO_FirstPaymentDate'
		,       BIO_PMT.LastPaymentDate AS 'BIO_LastPaymentDate'
		,       ISNULL(BIO_PMT.TotalPayments, 0) AS 'BIO_TotalPayments'
		,       BIO_Cancel.CancelDate AS 'BIO_CancelDate'
		,       ISNULL(BIO_Cancel.CancelReason, '') AS 'BIO_CancelReason'
		,		DM_EXT.RevenueGroupSSID AS 'EXT_RevenueGroupSSID'
		,       ISNULL(DM_EXT.MembershipDescription, '') AS 'EXT_Membership'
		,       DCM_EXT.ClientMembershipBeginDate AS 'EXT_BeginDate'
		,       DCM_EXT.ClientMembershipEndDate AS 'EXT_EndDate'
		,       ISNULL(DCM_EXT.ClientMembershipStatusDescription, '') AS 'EXT_MembershipStatus'
		,       ISNULL(DCM_EXT.ClientMembershipMonthlyFee, 0) AS 'EXT_MonthlyFee'
		,       ISNULL(DCM_EXT.ClientMembershipContractPrice, 0) AS 'EXT_ContractPrice'
		,       EXT_PMT.FirstPaymentDate AS 'EXT_FirstPaymentDate'
		,       EXT_PMT.LastPaymentDate AS 'EXT_LastPaymentDate'
		,       ISNULL(EXT_PMT.TotalPayments, 0) AS 'EXT_TotalPayments'
		,       EXT_Cancel.CancelDate AS 'EXT_CancelDate'
		,       ISNULL(EXT_Cancel.CancelReason, '') AS 'EXT_CancelReason'
		,		DM_SUR.RevenueGroupSSID AS 'SUR_RevenueGroupSSID'
		,       ISNULL(DM_SUR.MembershipDescription, '') AS 'SUR_Membership'
		,       DCM_SUR.ClientMembershipBeginDate AS 'SUR_BeginDate'
		,       DCM_SUR.ClientMembershipEndDate AS 'SUR_EndDate'
		,       ISNULL(DCM_SUR.ClientMembershipStatusDescription, '') AS 'SUR_MembershipStatus'
		,       ISNULL(DCM_SUR.ClientMembershipMonthlyFee, 0) AS 'SUR_MonthlyFee'
		,       ISNULL(DCM_SUR.ClientMembershipContractPrice, 0) AS 'SUR_ContractPrice'
		,       SUR_PMT.FirstPaymentDate AS 'SUR_FirstPaymentDate'
		,       SUR_PMT.LastPaymentDate AS 'SUR_LastPaymentDate'
		,       ISNULL(SUR_PMT.TotalPayments, 0) AS 'SUR_TotalPayments'
		,       SUR_Cancel.CancelDate AS 'SUR_CancelDate'
		,       ISNULL(SUR_Cancel.CancelReason, '') AS 'SUR_CancelReason'
		,		DM_XTR.RevenueGroupSSID AS 'XTR_RevenueGroupSSID'
		,       ISNULL(DM_XTR.MembershipDescription, '') AS 'XTR_Membership'
		,       DCM_XTR.ClientMembershipBeginDate AS 'XTR_BeginDate'
		,       DCM_XTR.ClientMembershipEndDate AS 'XTR_EndDate'
		,       ISNULL(DCM_XTR.ClientMembershipStatusDescription, '') AS 'XTR_MembershipStatus'
		,       ISNULL(DCM_XTR.ClientMembershipMonthlyFee, 0) AS 'XTR_MonthlyFee'
		,       ISNULL(DCM_XTR.ClientMembershipContractPrice, 0) AS 'XTR_ContractPrice'
		,       XTR_PMT.FirstPaymentDate AS 'XTR_FirstPaymentDate'
		,       XTR_PMT.LastPaymentDate AS 'XTR_LastPaymentDate'
		,       ISNULL(XTR_PMT.TotalPayments, 0) AS 'XTR_TotalPayments'
		,       XTR_Cancel.CancelDate AS 'XTR_CancelDate'
		,       ISNULL(XTR_Cancel.CancelReason, '') AS 'XTR_CancelReason'
		,       CLT.DoNotCallFlag
		,       CLT.DoNotContactFlag
		,		DC.LastUpdate
		,		GETUTCDATE()
		,		'dbaClient-Insert'
		,		GETUTCDATE()
		,		'dbaClient-Insert'
		FROM    HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
				INNER JOIN HairClubCMS.dbo.datClient DC WITH (NOLOCK)
					ON DC.ClientIdentifier = CLT.ClientIdentifier
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR WITH (NOLOCK)
					ON CTR.CenterSSID = CLT.CenterSSID
				LEFT OUTER JOIN HairClubCMS.dbo.datClientDemographic DCD WITH (NOLOCK)
					ON DCD.ClientIdentifier = CLT.ClientIdentifier
				LEFT OUTER JOIN HairClubCMS.dbo.lkpEthnicity LE WITH (NOLOCK)
					ON LE.EthnicityID = DCD.EthnicityID
				LEFT OUTER JOIN HairClubCMS.dbo.lkpOccupation LO WITH (NOLOCK)
					ON LO.OccupationID = DCD.OccupationID
				LEFT OUTER JOIN HairClubCMS.dbo.lkpMaritalStatus LMS WITH (NOLOCK)
					ON LMS.MaritalStatusID = DCD.MaritalStatusID
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM_BIO WITH (NOLOCK)
					ON DCM_BIO.ClientMembershipSSID = CLT.CurrentBioMatrixClientMembershipSSID
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM_BIO WITH (NOLOCK)
					ON DM_BIO.MembershipKey = DCM_BIO.MembershipKey
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM_EXT WITH (NOLOCK)
					ON DCM_EXT.ClientMembershipSSID = CLT.CurrentExtremeTherapyClientMembershipSSID
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM_EXT WITH (NOLOCK)
					ON DM_EXT.MembershipKey = DCM_EXT.MembershipKey
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM_SUR WITH (NOLOCK)
					ON DCM_SUR.ClientMembershipSSID = CLT.CurrentSurgeryClientMembershipSSID
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM_SUR WITH (NOLOCK)
					ON DM_SUR.MembershipKey = DCM_SUR.MembershipKey
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM_XTR WITH (NOLOCK)
					ON DCM_XTR.ClientMembershipSSID = CLT.CurrentXtrandsClientMembershipSSID
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM_XTR WITH (NOLOCK)
					ON DM_XTR.MembershipKey = DCM_XTR.MembershipKey
				LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact CON WITH (NOLOCK)
					ON CON.ContactKey = CLT.contactkey
				LEFT JOIN dbaClient C
					ON C.ClientIdentifier = DC.ClientIdentifier
				LEFT JOIN x_PMT AS BIO_PMT ON BIO_PMT.ClientKey = CLT.ClientKey AND BIO_PMT.ClientMembershipSSID = CLT.CurrentBioMatrixClientMembershipSSID
				LEFT JOIN x_PMT AS EXT_PMT ON EXT_PMT.ClientKey = CLT.ClientKey AND EXT_PMT.ClientMembershipSSID = CLT.CurrentExtremeTherapyClientMembershipSSID
				LEFT JOIN x_PMT AS SUR_PMT ON SUR_PMT.ClientKey = CLT.ClientKey AND SUR_PMT.ClientMembershipSSID = CLT.CurrentSurgeryClientMembershipSSID
				LEFT JOIN x_PMT AS XTR_PMT ON XTR_PMT.ClientKey = CLT.ClientKey AND XTR_PMT.ClientMembershipSSID = CLT.CurrentXtrandsClientMembershipSSID
				LEFT JOIN x_Cancel AS BIO_Cancel ON BIO_Cancel.ClientKey = CLT.ClientKey AND BIO_Cancel.ClientMembershipSSID = CLT.CurrentBioMatrixClientMembershipSSID AND BIO_Cancel.[Row] = 1
				LEFT JOIN x_Cancel AS EXT_Cancel ON EXT_Cancel.ClientKey = CLT.ClientKey AND EXT_Cancel.ClientMembershipSSID = CLT.CurrentExtremeTherapyClientMembershipSSID AND EXT_Cancel.[Row] = 1
				LEFT JOIN x_Cancel AS SUR_Cancel ON SUR_Cancel.ClientKey = CLT.ClientKey AND SUR_Cancel.ClientMembershipSSID = CLT.CurrentSurgeryClientMembershipSSID AND SUR_Cancel.[Row] = 1
				LEFT JOIN x_Cancel AS XTR_Cancel ON XTR_Cancel.ClientKey = CLT.ClientKey AND XTR_Cancel.ClientMembershipSSID = CLT.CurrentXtrandsClientMembershipSSID AND XTR_Cancel.[Row] = 1
				LEFT JOIN ISACNV AS ISA ON ISA.ClientKey = CLT.ClientKey AND ISA.SalesCodeDepartmentSSID = 1010 AND ISA.[Row] = 1
				LEFT JOIN ISACNV AS CNV ON CNV.ClientKey = CLT.ClientKey AND CNV.SalesCodeDepartmentSSID = 1075 AND CNV.[Row] = 1
				LEFT JOIN IAP_ AS IAP ON IAP.ClientKey = CLT.ClientKey AND IAP.[Row] = 1
				LEFT JOIN FAPLAP_ AS FAPLAP ON FAPLAP.ClientKey = CLT.ClientKey
				LEFT JOIN NAP_ AS NAP ON NAP.ClientKey = CLT.ClientKey
		WHERE	C.ClientID IS NULL;


UPDATE	dc
SET		SalesforceContactID = clt.SalesforceContactID
,		CanConfirmAppointmentByEmail = ISNULL(clt.CanConfirmAppointmentByEmail, 0)
,		CanContactForPromotionsByEmail = ISNULL(clt.CanContactForPromotionsByEmail, 0)
FROM    dbaClient dc
		INNER JOIN @UpdateClients uc
			ON uc.ClientIdentifier = dc.ClientIdentifier
		INNER JOIN HairClubCMS.dbo.datClient clt
			ON clt.ClientIdentifier = dc.ClientIdentifier

END
GO
