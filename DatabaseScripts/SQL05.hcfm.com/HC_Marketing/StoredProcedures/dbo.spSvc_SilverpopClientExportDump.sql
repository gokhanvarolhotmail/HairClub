/* CreateDate: 11/17/2016 13:06:19.100 , ModifyDate: 07/07/2017 14:29:33.490 */
GO
/***********************************************************************
PROCEDURE:				spSvc_SilverpopClientExportDump
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Marketing
RELATED APPLICATION:	Silverpop Export
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		11/16/2016
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_SilverpopClientExportDump 2874
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_SilverpopClientExportDump]
(
	@ExportHeaderID INT
)
AS
BEGIN

TRUNCATE TABLE datClientExport


/********************************** Set Dates *************************************/
DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME


SELECT  @StartDate = EH.ExportStartDate
,		@EndDate = EH.ExportEndDate
FROM    datExportHeader EH
WHERE   EH.ExportHeaderID = @ExportHeaderID


/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
	CenterID INT
,	CenterName NVARCHAR(50)
,	CenterType NVARCHAR(10)
,	RegionID INT
,	RegionName NVARCHAR(100)
,	Address1 NVARCHAR(50)
,   Address2 NVARCHAR(50)
,   City NVARCHAR(50)
,   StateCode NVARCHAR(10)
,   ZipCode NVARCHAR(15)
,   Country NVARCHAR(100)
,	PhoneNumber NVARCHAR(15)
,	ManagingDirector NVARCHAR(102)
,	ManagingDirectorEmail NVARCHAR(100)
)

CREATE TABLE #UpdatedClients ( ClientIdentifier INT )

CREATE TABLE #Clients (
	ExportHeaderID INT
,	RegionSSID INT NULL
,	RegionName VARCHAR(255) NULL
,	CenterSSID INT NULL
,	CenterName VARCHAR(255) NULL
,	CenterType VARCHAR(255) NULL
,	CenterAddress1 VARCHAR(255) NULL
,	CenterAddress2 VARCHAR(255) NULL
,	CenterCity VARCHAR(255) NULL
,	CenterStateCode VARCHAR(255) NULL
,	CenterZipCode VARCHAR(255) NULL
,	CenterCountry VARCHAR(255) NULL
,	CenterPhoneNumber VARCHAR(255) NULL
,	CenterManagingDirector VARCHAR(255) NULL
,	CenterManagingDirectorEmail VARCHAR(255) NULL
,	LeadID VARCHAR(255) NULL
,	ClientIdentifier INT NULL
,	ClientFirstName VARCHAR(255) NULL
,	ClientLastName VARCHAR(255) NULL
,	ClientAddress1 VARCHAR(255) NULL
,	ClientAddress2 VARCHAR(255) NULL
,	ClientCity VARCHAR(255) NULL
,	ClientStateCode VARCHAR(255) NULL
,	ClientZipCode VARCHAR(255) NULL
,	ClientCountry VARCHAR(255) NULL
,	ClientTimezone VARCHAR(255) NULL
,	Phone1 VARCHAR(255) NULL
,	Phone1Type VARCHAR(255) NULL
,	CanConfirmAppointmentByPhone1Text BIT NULL
,	CanContactForPromotionsByPhone1Text BIT NULL
,	Phone2 VARCHAR(255) NULL
,	Phone2Type VARCHAR(255) NULL
,	CanConfirmAppointmentByPhone2Text BIT NULL
,	CanContactForPromotionsByPhone2Text BIT NULL
,	Phone3 VARCHAR(255) NULL
,	Phone3Type VARCHAR(255) NULL
,	CanConfirmAppointmentByPhone3Text BIT NULL
,	CanContactForPromotionsByPhone3Text BIT NULL
,	SMSPhoneNumber NVARCHAR(15)
,	ClientDateOfBirth DATETIME NULL
,	ClientAge INT NULL
,	ClientEmailAddress VARCHAR(255) NULL
,	ClientGender VARCHAR(255) NULL
,	SiebelID VARCHAR(255) NULL
,	EthnicitySSID VARCHAR(255) NULL
,	ClientEthinicityDescription VARCHAR(255) NULL
,	OccupationSSID VARCHAR(255) NULL
,	ClientOccupationDescription VARCHAR(255) NULL
,	MaritalStatusSSID VARCHAR(255) NULL
,	ClientMaritalStatusDescription VARCHAR(255) NULL
,	InitialSaleDate DATETIME NULL
,	NBConsultant VARCHAR(255) NULL
,	NBConsultantName VARCHAR(255) NULL
,	NBConsultantEmail VARCHAR(255) NULL
,	InitialApplicationDate DATETIME NULL
,	ConversionDate DATETIME NULL
,	MembershipAdvisor VARCHAR(255) NULL
,	MembershipAdvisorName VARCHAR(255) NULL
,	MembershipAdvisorEmail VARCHAR(255) NULL
,	FirstAppointmentDate DATETIME NULL
,	LastAppointmentDate DATETIME NULL
,	NextAppointmentGUID UNIQUEIDENTIFIER NULL
,	NextAppointmentCenterID INT NULL
,	NextAppointmentDate DATETIME NULL
,	NextAppointmentTime DATETIME NULL
,	StylistFirstName VARCHAR(255) NULL
,	StylistLastName VARCHAR(255) NULL
,	FirstEXTServiceDate DATETIME NULL
,	FirstXtrandServiceDate DATETIME NULL
,	BIO_Membership VARCHAR(255) NULL
,	BIO_BeginDate DATETIME NULL
,	BIO_EndDate DATETIME NULL
,	BIO_MembershipStatus VARCHAR(255) NULL
,	BIO_MonthlyFee MONEY NULL
,	BIO_ContractPrice MONEY NULL
,	BIO_CancelDate DATETIME NULL
,	BIO_CancelReasonDescription VARCHAR(255) NULL
,	EXT_Membership VARCHAR(255) NULL
,	EXT_BeginDate DATETIME NULL
,	EXT_EndDate DATETIME NULL
,	EXT_MembershipStatus VARCHAR(255) NULL
,	EXT_MonthlyFee MONEY NULL
,	EXT_ContractPrice MONEY NULL
,	EXT_CancelDate DATETIME NULL
,	EXT_CancelReasonDescription VARCHAR(255) NULL
,	XTR_Membership VARCHAR(255) NULL
,	XTR_BeginDate DATETIME NULL
,	XTR_EndDate DATETIME NULL
,	XTR_MembershipStatus VARCHAR(255) NULL
,	XTR_MonthlyFee MONEY NULL
,	XTR_ContractPrice MONEY NULL
,	XTR_CancelDate DATETIME NULL
,	XTR_CancelReasonDescription VARCHAR(255) NULL
,	SUR_Membership VARCHAR(255) NULL
,	SUR_BeginDate DATETIME NULL
,	SUR_EndDate DATETIME NULL
,	SUR_MembershipStatus VARCHAR(255) NULL
,	SUR_MonthlyFee MONEY NULL
,	SUR_ContractPrice MONEY NULL
,	SUR_CancelDate DATETIME NULL
,	SUR_CancelReasonDescription VARCHAR(255) NULL
,	DoNotCallFlag BIT NULL
,	DoNotContactFlag BIT NULL
,	IsAutoConfirmEmail BIT NULL
,	Mosaic_Household VARCHAR(50) NULL
,	Mosaic_Household_Group VARCHAR(255) NULL
,	Mosaic_Household_Type VARCHAR(255) NULL
,	Mosaic_Zip VARCHAR(50) NULL
,	Mosaic_Zip_Group VARCHAR(255) NULL
,	Mosaic_Zip_Type VARCHAR(255) NULL
,	Mosaic_Gender VARCHAR(50) NULL
,	Mosaic_Combined_Age VARCHAR(50) NULL
,	Mosaic_Education_Model VARCHAR(50) NULL
,	Mosaic_Marital_Status VARCHAR(50) NULL
,	Mosaic_Occupation_Group_V2 VARCHAR(50) NULL
,	Mosaic_Latitude VARCHAR(50) NULL
,	Mosaic_Longitude VARCHAR(50) NULL
,	Mosaic_Match_Level_For_Geo_Data VARCHAR(50) NULL
,	Mosaic_Est_Household_Income_V5 VARCHAR(50) NULL
,	Mosaic_NCOA_Move_Update_Code VARCHAR(50) NULL
,	Mosaic_Mail_Responder VARCHAR(50) NULL
,	Mosaic_MOR_Bank_Upscale_Merchandise_Buyer VARCHAR(50) NULL
,	Mosaic_MOR_Bank_Health_And_Fitness_Magazine VARCHAR(50) NULL
,	Mosaic_Cape_Ethnic_Pop_White_Only VARCHAR(50) NULL
,	Mosaic_Cape_Ethnic_Pop_Black_Only VARCHAR(50) NULL
,	Mosaic_Cape_Ethnic_Pop_Asian_Only VARCHAR(50) NULL
,	Mosaic_Cape_Ethnic_Pop_Hispanic VARCHAR(50) NULL
,	Mosaic_Cape_Lang_HH_Spanish_Speaking VARCHAR(50) NULL
,	Mosaic_Cape_INC_HH_Median_Family_Household_Income VARCHAR(50) NULL
,	Mosaic_MatchStatus VARCHAR(50) NULL
,	Mosaic_CE_Selected_Individual_Vendor_Ethnicity_Code VARCHAR(50) NULL
,	Mosaic_CE_Selected_Individual_Vendor_Ethnic_Group_Code VARCHAR(50) NULL
,	Mosaic_CE_Selected_Individual_Vendor_Spoken_Language_Code VARCHAR(50) NULL
,	CreateDate DATETIME NOT NULL
,	CreateUser NVARCHAR(50) NOT NULL
,	LastUpdate DATETIME NOT NULL
,	LastUpdateUser NVARCHAR(50) NOT NULL
)

CREATE CLUSTERED INDEX IDX_Centers_CenterID ON #Centers ( CenterID )

CREATE CLUSTERED INDEX IDX_UpdatedClients_ClientIdentifier ON #UpdatedClients ( ClientIdentifier )

CREATE CLUSTERED INDEX IDX_Clients_ClientIdentifier ON #Clients ( ClientIdentifier )


/********************************** Get Center Data *************************************/
INSERT  INTO #Centers
        SELECT  CTR.CenterID
		,       CTR.CenterDescription
		,       CT.CenterTypeDescriptionShort AS 'CenterType'
		,       ISNULL(LR.RegionID, 1) AS 'RegionID'
		,       ISNULL(LR.RegionDescription, 'Corporate') AS 'RegionName'
		,       CTR.Address1
		,       CTR.Address2
		,       CTR.City
		,       LS.StateDescriptionShort AS 'StateCode'
		,       CTR.PostalCode AS 'ZipCode'
		,       LC.CountryDescription AS 'Country'
		,       ISNULL(CTR.Phone1, '') AS 'PhoneNumber'
		,       ISNULL(o_MD.ManagingDirector, '') AS 'ManagingDirector'
		,       ISNULL(o_MD.ManagingDirectorEmail, '') AS 'ManagingDirectorEmail'
		FROM    HairClubCMS.dbo.cfgCenter CTR WITH ( NOLOCK )
				INNER JOIN HairClubCMS.dbo.lkpCenterType CT WITH ( NOLOCK )
					ON CT.CenterTypeID = CTR.CenterTypeID
				INNER JOIN HairClubCMS.dbo.lkpState LS WITH ( NOLOCK )
					ON LS.StateID = CTR.StateID
				INNER JOIN HairClubCMS.dbo.lkpCountry LC WITH ( NOLOCK )
					ON LC.CountryID = CTR.CountryID
				LEFT OUTER JOIN HairClubCMS.dbo.lkpRegion LR WITH ( NOLOCK )
					ON LR.RegionID = CTR.RegionID
				OUTER APPLY ( SELECT TOP 1
										DE.CenterID AS 'CenterSSID'
							  ,         DE.FirstName + ' ' + DE.LastName AS 'ManagingDirector'
							  ,         DE.UserLogin + '@hcfm.com' AS 'ManagingDirectorEmail'
							  FROM      HairClubCMS.dbo.datEmployee DE WITH ( NOLOCK )
										INNER JOIN HairClubCMS.dbo.cfgEmployeePositionJoin EPJ WITH ( NOLOCK )
											ON EPJ.EmployeeGUID = DE.EmployeeGUID
										INNER JOIN HairClubCMS.dbo.lkpEmployeePosition LEP WITH ( NOLOCK )
											ON LEP.EmployeePositionID = EPJ.EmployeePositionID
							  WHERE     LEP.EmployeePositionID = 6
										AND ISNULL(DE.CenterID, 100) <> 100
										AND DE.CenterID = CTR.CenterID
										AND DE.FirstName NOT IN ( 'EC', 'Test' )
										AND DE.IsActiveFlag = 1
							  ORDER BY  DE.CenterID
							  ,         DE.EmployeePayrollID DESC
							) o_MD
		WHERE   CONVERT(VARCHAR, CTR.CenterID) LIKE '[1278]%'
				AND CTR.IsActiveFlag = 1


/********************************** Get Clients who were created or updated during time period *************************************/
INSERT	INTO #UpdatedClients

		-- Clients Created or Updated
		SELECT  DISTINCT
				cl.ClientIdentifier
		FROM    HairClubCMS.dbo.datClient cl WITH ( NOLOCK )
				INNER JOIN HairClubCMS.dbo.datClientDemographic cd WITH ( NOLOCK )
					ON cd.ClientGUID = cl.ClientGUID
		WHERE   cl.CreateDate BETWEEN @StartDate AND @EndDate
				OR cl.LastUpdate BETWEEN @StartDate AND @EndDate
				OR cd.CreateDate BETWEEN @StartDate AND @EndDate
				OR cd.LastUpdate BETWEEN @StartDate AND @EndDate

		UNION

		-- Clients who had a Membership Change or Service Transaction within the specified period
		SELECT  DISTINCT
				cl.ClientIdentifier
		FROM    HairClubCMS.dbo.datSalesOrderDetail sod WITH (NOLOCK)
				INNER JOIN HairClubCMS.dbo.datSalesOrder so WITH (NOLOCK)
					ON so.SalesOrderGUID = sod.SalesOrderGUID
				INNER JOIN HairClubCMS.dbo.cfgSalesCode sc WITH (NOLOCK)
					ON sc.SalesCodeID = sod.SalesCodeID
				INNER JOIN HairClubCMS.dbo.datClient cl WITH (NOLOCK)
					ON cl.ClientGUID = so.ClientGUID
		WHERE   so.OrderDate BETWEEN @StartDate AND @EndDate
				AND sc.SalesCodeDepartmentID IN ( 1010, 1070, 1075, 1080, 1090, 1095, 1099, 5010, 5020, 5030, 5035, 5037, 5038 )
				AND so.IsVoidedFlag = 0

		UNION

		-- Clients who had an Appointment created or updated
		SELECT  DISTINCT
				CLT.ClientIdentifier
		FROM    HairClubCMS.dbo.datAppointment DA
				INNER JOIN HairClubCMS.dbo.datClient CLT WITH ( NOLOCK )
					ON CLT.ClientGUID = DA.ClientGUID
				INNER JOIN HairClubCMS.dbo.datAppointmentEmployee AE WITH ( NOLOCK )
					ON AE.AppointmentGUID = DA.AppointmentGUID
				INNER JOIN HairClubCMS.dbo.datEmployee DE WITH ( NOLOCK )
					ON DE.EmployeeGUID = AE.EmployeeGUID
				LEFT OUTER JOIN HairClubCMS.dbo.lkpAppointmentType LAT WITH ( NOLOCK )
					ON LAT.AppointmentTypeID = DA.AppointmentTypeID
		WHERE   ISNULL(LAT.AppointmentTypeDescriptionShort, '') <> 'BosleyAppt'
				AND DA.OnContactActivityID IS NULL
				--AND DA.AppointmentDate >= '5/4/2017'
				AND ( DA.AppointmentDate BETWEEN @StartDate AND @EndDate
					  OR DA.CreateDate BETWEEN @StartDate AND @EndDate
					  OR DA.LastUpdate BETWEEN @StartDate AND @EndDate
					  OR AE.CreateDate BETWEEN @StartDate AND @EndDate
					  OR AE.LastUpdate BETWEEN @StartDate AND @EndDate )

		UNION

		-- Clients who have had a Mosaic record created or updated within Time Period
		SELECT  DISTINCT
				CA.ClientIdentifier
		FROM    HC_DataAppend.dbo.Client_Append CA WITH ( NOLOCK )
		WHERE   CA.LastUpdate BETWEEN @StartDate AND @EndDate


/********************************** Get updated Client Details *************************************/
;
WITH x_Cancels
AS
(	SELECT	ROW_NUMBER() OVER ( PARTITION BY CLT.ClientIdentifier, DCM.ClientMembershipSSID ORDER BY SO.OrderDate DESC ) AS [Row]
	,       CLT.ClientIdentifier
	,       DCM.ClientMembershipSSID AS 'ClientMembershipGUID'
	,       SO.OrderDate AS 'CancelDate'
	,       DMOR.MembershipOrderReasonDescription AS 'CancelReason'
	FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST WITH ( NOLOCK )
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD WITH ( NOLOCK )
				ON DD.DateKey = FST.OrderDateKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT WITH ( NOLOCK )
				ON CLT.ClientKey = FST.ClientKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC WITH ( NOLOCK )
				ON DSC.SalesCodeKey = FST.SalesCodeKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO WITH ( NOLOCK )
				ON SO.SalesOrderKey = FST.SalesOrderKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD WITH ( NOLOCK )
				ON SOD.SalesOrderDetailKey = FST.SalesOrderDetailKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM WITH ( NOLOCK )
				ON DCM.ClientMembershipKey = SO.ClientMembershipKey
			LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembershipOrderReason DMOR WITH ( NOLOCK )
				ON SOD.MembershipOrderReasonID = DMOR.MembershipOrderReasonID
	WHERE    DSC.SalesCodeDepartmentSSID = 1099
),
x_IAC
AS
(	SELECT	ROW_NUMBER() OVER ( PARTITION BY CLT.ClientIdentifier, DSC.SalesCodeDepartmentSSID ORDER BY SO.OrderDate ASC ) AS [Row]
	,       CLT.ClientIdentifier
	,       DSC.SalesCodeDepartmentSSID
	,       SO.OrderDate AS 'OrderDate'
	,       ISNULL(PFR.EmployeeInitials, '') AS 'EmployeeInitials'
	,       ISNULL(REPLACE(REPLACE(PFR.EmployeeFullName, ',', ''), 'Unknown Unknown', ''), '') AS 'EmployeeFullName'
	,		CASE WHEN ISNULL(PFR.EmployeeInitials, '') = '' THEN '' ELSE PFR.UserLogin + '@hcfm.com' END AS 'EmployeeEmail'
	FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST WITH ( NOLOCK )
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD WITH ( NOLOCK )
				ON DD.DateKey = FST.OrderDateKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT WITH ( NOLOCK )
				ON CLT.ClientKey = FST.ClientKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC WITH ( NOLOCK )
				ON DSC.SalesCodeKey = FST.SalesCodeKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO WITH ( NOLOCK )
				ON SO.SalesOrderKey = FST.SalesOrderKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD WITH ( NOLOCK )
				ON SOD.SalesOrderDetailKey = FST.SalesOrderDetailKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM WITH ( NOLOCK )
				ON DCM.ClientMembershipKey = SO.ClientMembershipKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM WITH ( NOLOCK )
				ON DM.MembershipSSID = DCM.MembershipSSID
			LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee PFR WITH ( NOLOCK )
				ON PFR.EmployeeKey = FST.Employee1Key
	WHERE   DSC.SalesCodeDepartmentSSID IN ( 1010, 1075 )
			AND DM.MembershipSSID NOT IN ( 57, 58 )
),
x_Services
AS
(	SELECT  ROW_NUMBER() OVER ( PARTITION BY CLT.ClientIdentifier, DSC.SalesCodeDepartmentSSID ORDER BY SO.OrderDate ASC ) AS [Row]
	,       CLT.ClientIdentifier
	,       DSC.SalesCodeDepartmentSSID
	,       SO.OrderDate AS 'OrderDate'
	FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST WITH ( NOLOCK )
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD WITH ( NOLOCK )
				ON DD.DateKey = FST.OrderDateKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT WITH ( NOLOCK )
				ON CLT.ClientKey = FST.ClientKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC WITH ( NOLOCK )
				ON DSC.SalesCodeKey = FST.SalesCodeKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO WITH ( NOLOCK )
				ON SO.SalesOrderKey = FST.SalesOrderKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD WITH ( NOLOCK )
				ON SOD.SalesOrderDetailKey = FST.SalesOrderDetailKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM WITH ( NOLOCK )
				ON DCM.ClientMembershipKey = SO.ClientMembershipKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM WITH ( NOLOCK )
				ON DM.MembershipSSID = DCM.MembershipSSID
			LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee PFR WITH ( NOLOCK )
				ON PFR.EmployeeKey = FST.Employee1Key
	WHERE   DSC.SalesCodeDepartmentSSID IN ( 5035, 5037 )
			AND DSC.SalesCodeKey NOT IN ( 1726, 1727, 1739 )
),
x_IA
AS
(	SELECT  ROW_NUMBER() OVER ( PARTITION BY CLT.ClientIdentifier ORDER BY SO.OrderDate ASC ) AS [Row]
	,       CLT.ClientIdentifier
	,       SO.OrderDate AS 'InitialApplicationDate'
	FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST WITH ( NOLOCK )
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD WITH ( NOLOCK )
				ON DD.DateKey = FST.OrderDateKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT WITH ( NOLOCK )
				ON CLT.ClientKey = FST.ClientKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC WITH ( NOLOCK )
				ON DSC.SalesCodeKey = FST.SalesCodeKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO WITH ( NOLOCK )
				ON SO.SalesOrderKey = FST.SalesOrderKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD WITH ( NOLOCK )
				ON SOD.SalesOrderDetailKey = FST.SalesOrderDetailKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM WITH ( NOLOCK )
				ON DCM.ClientMembershipKey = SO.ClientMembershipKey
	WHERE   DSC.SalesCodeSSID IN ( 648 )
),
x_Appointments
AS
(	SELECT  CLT.ClientIdentifier
	,       MIN(DA.AppointmentDate) AS 'FirstAppointmentDate'
	,       MAX(DA.AppointmentDate) AS 'LastAppointmentDate'
	FROM    HC_BI_CMS_DDS.bi_cms_dds.DimAppointment DA WITH ( NOLOCK )
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT WITH ( NOLOCK )
				ON CLT.ClientKey = DA.ClientKey
	WHERE   DA.AppointmentDate < GETDATE()
			AND DA.IsDeletedFlag = 0
	GROUP BY CLT.ClientIdentifier
),
x_Phone
AS
(	SELECT   ROW_NUMBER() OVER ( PARTITION BY dcp.ClientGUID ORDER BY dcp.ClientPhoneSortOrder ASC ) AS 'RowID'
    ,        dcp.ClientGUID
    ,        dcp.PhoneNumber
    ,        pt.PhoneTypeDescription AS 'PhoneType'
    ,        dcp.CanConfirmAppointmentByCall
    ,        dcp.CanConfirmAppointmentByText
    ,        dcp.CanContactForPromotionsByCall
    ,        dcp.CanContactForPromotionsByText
    FROM     HairClubCMS.dbo.datClientPhone dcp WITH ( NOLOCK )
			 INNER JOIN HairClubCMS.dbo.lkpPhoneType pt WITH ( NOLOCK )
				ON pt.PhoneTypeID = dcp.PhoneTypeID
)
INSERT	INTO #Clients
		SELECT  @ExportHeaderID AS 'ExportHeaderID'
		,		C.RegionID
		,       C.RegionName
		,       C.CenterID
		,       C.CenterName
		,		C.CenterType
		,       ISNULL(LTRIM(RTRIM(REPLACE(C.Address1, ',', ''))), '') AS 'CenterAddress1'
		,       ISNULL(LTRIM(RTRIM(REPLACE(C.Address2, ',', ''))), '') AS 'CenterAddress2'
		,       C.StateCode AS 'CenterStateCode'
		,       ISNULL(LTRIM(RTRIM(REPLACE(C.City, ',', ''))), '') AS 'CenterCity'
		,       C.ZipCode AS 'CenterZipCode'
		,       C.Country AS 'CenterCountry'
		,		C.PhoneNumber AS 'CenterPhoneNumber'
		,       LTRIM(RTRIM(REPLACE(C.ManagingDirector, ',', ''))) AS 'CenterManagingDirector'
		,       LTRIM(RTRIM(REPLACE(C.ManagingDirectorEmail, ',', ''))) AS 'CenterManagingDirectorEmail'
		,       ISNULL(CLT.ContactID, '') AS 'LeadID'
		,       CLT.ClientIdentifier
		,       REPLACE(CLT.FirstName, ',', '') AS 'ClientFirstName'
		,		REPLACE(CLT.LastName, ',', '') AS 'ClientLastName'
		,       ISNULL(LTRIM(RTRIM(REPLACE(CLT.Address1, ',', ''))), '') AS 'ClientAddress1'
		,       ISNULL(LTRIM(RTRIM(REPLACE(CLT.Address2, ',', ''))), '') AS 'ClientAddress2'
		,       ISNULL(LTRIM(RTRIM(REPLACE(CLT.City, ',', ''))), '') AS 'ClientCity'
		,		ISNULL(LS.StateDescriptionShort, '') AS 'ClientStateCode'
		,		ISNULL(REPLACE(CLT.PostalCode, '-', ''), '') AS 'ClientZipCode'
		,		LC.CountryDescriptionShort AS 'ClientCountry'
		,		TZ.TimeZoneDescriptionShort AS 'ClientTimezone'
		,		ISNULL(P1.PhoneNumber, '') AS 'Phone1'
		,		ISNULL(P1.PhoneType, '') AS 'Phone1Type'
		,		ISNULL(P1.CanConfirmAppointmentByText, 0) AS 'CanConfirmAppointmentByPhone1Text'
		,		ISNULL(P1.CanContactForPromotionsByText, 0) AS 'CanContactForPromotionsByPhone1Text'
		,		ISNULL(P2.PhoneNumber, '') AS 'Phone2'
		,		ISNULL(P2.PhoneType, '') AS 'Phone2Type'
		,		ISNULL(P2.CanConfirmAppointmentByText, 0) AS 'CanConfirmAppointmentByPhone2Text'
		,		ISNULL(P2.CanContactForPromotionsByText, 0) AS 'CanContactForPromotionsByPhone2Text'
		,		ISNULL(P3.PhoneNumber, '') AS 'Phone3'
		,		ISNULL(P3.PhoneType, '') AS 'Phone3Type'
		,		ISNULL(P3.CanConfirmAppointmentByText, 0) AS 'CanConfirmAppointmentByPhone3Text'
		,		ISNULL(P3.CanContactForPromotionsByText, 0) AS 'CanContactForPromotionsByPhone3Text'
		,		CASE WHEN ISNULL(P1.CanConfirmAppointmentByText, 0) = 1 THEN P1.PhoneNumber ELSE CASE WHEN ISNULL(P2.CanConfirmAppointmentByText, 0) = 1 THEN P2.PhoneNumber ELSE CASE WHEN ISNULL(P3.CanConfirmAppointmentByText, 0) = 1 THEN P3.PhoneNumber ELSE '' END END END AS 'SMSPhoneNumber'
		,		CASE WHEN CLT.DateOfBirth IS NULL THEN '' ELSE CONVERT(VARCHAR(11), CLT.DateOfBirth, 101) END AS 'ClientDateOfBirth'
		,		ISNULL(CLT.AgeCalc, '') AS 'ClientAge'
		,		ISNULL(REPLACE(CLT.EMailAddress, ',', '.'), '') AS 'ClientEmailAddress'
		,		CASE WHEN ISNULL(CLT.GenderID, 1) = 1 THEN 'Male' ELSE 'Female' END AS 'ClientGender'
		,		ISNULL(CLT.SiebelID, '') AS 'SiebelID'
		,		CASE WHEN DCD.EthnicityID IS NULL THEN '' ELSE CONVERT(VARCHAR, DCD.EthnicityID) END AS 'EthnicitySSID'
		,		ISNULL(LE.EthnicityDescription, '') AS 'ClientEthinicityDescription'
		,		CASE WHEN DCD.OccupationID IS NULL THEN '' ELSE CONVERT(VARCHAR, DCD.OccupationID) END AS 'OccupationSSID'
		,		ISNULL(LO.OccupationDescription, '') AS 'ClientOccupationDescription'
		,		CASE WHEN DCD.MaritalStatusID IS NULL THEN '' ELSE CONVERT(VARCHAR, DCD.MaritalStatusID) END AS 'MaritalStatusSSID'
		,		ISNULL(LMS.MaritalStatusDescription, '') AS 'ClientMaritalStatusDescription'
		,		CASE WHEN ISA.OrderDate IS NULL THEN '' ELSE CONVERT(VARCHAR(11), ISA.OrderDate, 101) END AS 'InitialSaleDate'
		,		ISNULL(ISA.EmployeeInitials, '') AS 'NBConsultant'
		,		ISNULL(ISA.EmployeeFullName, '') AS 'NBConsultantName'
		,		ISNULL(ISA.EmployeeEmail, '') AS 'NBConsultantEmail'
		,		CASE WHEN IAP.InitialApplicationDate IS NULL THEN '' ELSE CONVERT(VARCHAR(11), IAP.InitialApplicationDate, 101) END AS 'InitialApplicationDate'
		,		CASE WHEN CNV.OrderDate IS NULL THEN '' ELSE CONVERT(VARCHAR(11), CNV.OrderDate, 101) END AS 'ConversionDate'
		,		ISNULL(CNV.EmployeeInitials, '') AS 'MembershipAdvisor'
		,		ISNULL(CNV.EmployeeFullName, '') AS 'MembershipAdvisorName'
		,		ISNULL(CNV.EmployeeEmail, '') AS 'MembershipAdvisorEmail'
		,		CASE WHEN FAPLAP.FirstAppointmentDate IS NULL THEN '' ELSE CONVERT(VARCHAR(11), FAPLAP.FirstAppointmentDate, 101) END AS 'FirstAppointmentDate'
		,		CASE WHEN FAPLAP.LastAppointmentDate IS NULL THEN '' ELSE CONVERT(VARCHAR(11), FAPLAP.LastAppointmentDate, 101) END AS 'LastAppointmentDate'
		,		NAP.NextAppointmentGUID
		,		NAP.NextAppointmentCenterID
		,		CASE WHEN NAP.NextAppointmentDate IS NULL THEN '' ELSE CONVERT(VARCHAR(11), NAP.NextAppointmentDate, 101) END AS 'NextAppointmentDate'
		,		CASE WHEN NAP.NextAppointmentTime IS NULL THEN '' ELSE NAP.NextAppointmentTime END AS 'NextAppointmentTime'
		,		CASE WHEN NAP.StylistFirstName IS NULL THEN '' ELSE NAP.StylistFirstName END AS 'StylistFirstName'
		,		CASE WHEN NAP.StylistLastName IS NULL THEN '' ELSE NAP.StylistLastName END AS 'StylistLastName'
		,		CASE WHEN ES.OrderDate IS NULL THEN '' ELSE CONVERT(VARCHAR(11), ES.OrderDate, 101) END AS 'FirstEXTServiceDate'
		,		CASE WHEN XS.OrderDate IS NULL THEN '' ELSE CONVERT(VARCHAR(11), XS.OrderDate, 101) END AS 'FirstXtrandServiceDate'
		,		ISNULL(CM_BIO.MembershipDescription, '') AS 'BIO_Membership'
		,		CASE WHEN DCM_BIO.BeginDate IS NULL THEN '' ELSE CONVERT(VARCHAR(11), DCM_BIO.BeginDate, 101) END AS 'BIO_BeginDate'
		,		CASE WHEN DCM_BIO.EndDate IS NULL THEN '' ELSE CONVERT(VARCHAR(11), DCM_BIO.EndDate, 101) END AS 'BIO_EndDate'
		,		ISNULL(CMS_BIO.ClientMembershipStatusDescription, '') AS 'BIO_MembershipStatus'
		,		ISNULL(DCM_BIO.MonthlyFee, 0) AS 'BIO_MonthlyFee'
		,		ISNULL(DCM_BIO.ContractPrice, 0) AS 'BIO_ContractPrice'
		,       CASE WHEN BIO_Cancel.CancelDate IS NULL THEN '' ELSE CONVERT(VARCHAR(11), BIO_Cancel.CancelDate, 101) END AS 'BIO_CancelDate'
		,       ISNULL(REPLACE(BIO_Cancel.CancelReason, ',', ''), '') AS 'BIO_CancelReasonDescription'
		,		ISNULL(CM_EXT.MembershipDescription, '') AS 'EXT_Membership'
		,		CASE WHEN DCM_EXT.BeginDate IS NULL THEN '' ELSE CONVERT(VARCHAR(11), DCM_EXT.BeginDate, 101) END AS 'EXT_BeginDate'
		,		CASE WHEN DCM_EXT.EndDate IS NULL THEN '' ELSE CONVERT(VARCHAR(11), DCM_EXT.EndDate, 101) END AS 'EXT_EndDate'
		,		ISNULL(CMS_EXT.ClientMembershipStatusDescription, '') AS 'EXT_MembershipStatus'
		,		ISNULL(DCM_EXT.MonthlyFee, 0) AS 'EXT_MonthlyFee'
		,		ISNULL(DCM_EXT.ContractPrice, 0) AS 'EXT_ContractPrice'
		,       CASE WHEN EXT_Cancel.CancelDate IS NULL THEN '' ELSE CONVERT(VARCHAR(11), EXT_Cancel.CancelDate, 101) END AS 'EXT_CancelDate'
		,       ISNULL(REPLACE(EXT_Cancel.CancelReason, ',', ''), '') AS 'EXT_CancelReasonDescription'
		,		ISNULL(CM_XTR.MembershipDescription, '') AS 'XTR_Membership'
		,		CASE WHEN DCM_XTR.BeginDate IS NULL THEN '' ELSE CONVERT(VARCHAR(11), DCM_XTR.BeginDate, 101) END AS 'XTR_BeginDate'
		,		CASE WHEN DCM_XTR.EndDate IS NULL THEN '' ELSE CONVERT(VARCHAR(11), DCM_XTR.EndDate, 101) END AS 'XTR_EndDate'
		,		ISNULL(CMS_XTR.ClientMembershipStatusDescription, '') AS 'XTR_MembershipStatus'
		,		ISNULL(DCM_XTR.MonthlyFee, 0) AS 'XTR_MonthlyFee'
		,		ISNULL(DCM_XTR.ContractPrice, 0) AS 'XTR_ContractPrice'
		,       CASE WHEN XTR_Cancel.CancelDate IS NULL THEN '' ELSE CONVERT(VARCHAR(11), XTR_Cancel.CancelDate, 101) END AS 'XTR_CancelDate'
		,       ISNULL(REPLACE(XTR_Cancel.CancelReason, ',', ''), '') AS 'XTR_CancelReasonDescription'
		,		ISNULL(CM_SUR.MembershipDescription, '') AS 'SUR_Membership'
		,		CASE WHEN DCM_SUR.BeginDate IS NULL THEN '' ELSE CONVERT(VARCHAR(11), DCM_SUR.BeginDate, 101) END AS 'SUR_BeginDate'
		,		CASE WHEN DCM_SUR.EndDate IS NULL THEN '' ELSE CONVERT(VARCHAR(11), DCM_SUR.EndDate, 101) END AS 'SUR_EndDate'
		,		ISNULL(CMS_SUR.ClientMembershipStatusDescription, '') AS 'SUR_MembershipStatus'
		,		ISNULL(DCM_SUR.MonthlyFee, 0) AS 'SUR_MonthlyFee'
		,		ISNULL(DCM_SUR.ContractPrice, 0) AS 'SUR_ContractPrice'
		,       CASE WHEN SUR_Cancel.CancelDate IS NULL THEN '' ELSE CONVERT(VARCHAR(11), SUR_Cancel.CancelDate, 101) END AS 'SUR_CancelDate'
		,       ISNULL(REPLACE(SUR_Cancel.CancelReason, ',', ''), '') AS 'SUR_CancelReasonDescription'
		,       CLT.DoNotCallFlag
		,       CLT.DoNotContactFlag
		,		ISNULL(CLT.IsAutoConfirmEmail, 0) AS 'IsAutoConfirmEmail'
		,		ISNULL(REPLACE(CA.[MOSAIC HOUSEHOLD], '""', ''), '') AS 'Mosaic_Household'
		,		ISNULL(MG_H.MosaicGroupID + ' - ' + MG_H.MosaicGroupDescription, '') AS 'Mosaic_Household_Group'
		,		ISNULL(MT_H.MosaicTypeID + ' - ' + MT_H.MosaicTypeDescription, '') AS 'Mosaic_Household_Type'
		,		ISNULL(REPLACE(CA.ZIP_4, '""', ''), '') AS 'Mosaic_Zip'
		,		ISNULL(MG_Z.MosaicGroupID + ' - ' + MG_Z.MosaicGroupDescription, '') AS 'Mosaic_Zip_Group'
		,		ISNULL(MT_Z.MosaicTypeID + ' - ' + MT_Z.MosaicTypeDescription, '') AS 'Mosaic_Zip_Type'
		,		ISNULL(REPLACE(CA.GENDER, '""', ''), '') AS 'Mosaic_Gender'
		,		ISNULL(REPLACE(CA.[COMBINED AGE], '""', ''), '') AS 'Mosaic_Combined_Age'
		,		ISNULL(REPLACE(CA.[EDUCATION MODEL], '""', ''), '') AS 'Mosaic_Education_Model'
		,		ISNULL(REPLACE(CA.[MARITAL STATUS], '""', ''), '') AS 'Mosaic_Marital_Status'
		,		ISNULL(REPLACE(CA.[OCCUPATION GROUP V2], '""', ''), '') AS 'Mosaic_Occupation_Group_V2'
		,		ISNULL(REPLACE(CA.LATITUDE, '""', ''), '') AS 'Mosaic_Latitude'
		,		ISNULL(REPLACE(CA.LONGITUDE, '""', ''), '') AS 'Mosaic_Longitude'
		,		ISNULL(REPLACE(CA.[MATCH LEVEL FOR GEO DATA], '""', ''), '') AS 'Mosaic_Match_Level_For_Geo_Data'
		,		ISNULL(REPLACE(CA.[EST HOUSEHOLD INCOME V5], '""', ''), '') AS 'Mosaic_Est_Household_Income_V5'
		,		ISNULL(REPLACE(CA.[NCOA MOVE UPDATE CODE], '""', ''), '') AS 'Mosaic_NCOA_Move_Update_Code'
		,		ISNULL(REPLACE(CA.[MAIL RESPONDER], '""', ''), '') AS 'Mosaic_Mail_Responder'
		,		ISNULL(REPLACE(CA.[MOR BANK_ UPSCALE MERCHANDISE BUYER], '""', ''), '') AS 'Mosaic_MOR_Bank_Upscale_Merchandise_Buyer'
		,		ISNULL(REPLACE(CA.[MOR BANK_ HEALTH AND FITNESS MAGAZINE], '""', ''), '') AS 'Mosaic_MOR_Bank_Health_And_Fitness_Magazine'
		,		ISNULL(REPLACE(CA.[CAPE_ ETHNIC_ POP_ _ WHITE ONLY], '""', ''), '') AS 'Mosaic_Cape_Ethnic_Pop_White_Only'
		,		ISNULL(REPLACE(CA.[CAPE_ ETHNIC_ POP_ _ BLACK ONLY], '""', ''), '') AS 'Mosaic_Cape_Ethnic_Pop_Black_Only'
		,		ISNULL(REPLACE(CA.[CAPE_ ETHNIC_ POP_ _ ASIAN ONLY], '""', ''), '') AS 'Mosaic_Cape_Ethnic_Pop_Asian_Only'
		,		ISNULL(REPLACE(CA.[CAPE_ ETHNIC_ POP_ _ HISPANIC], '""', ''), '') AS 'Mosaic_Cape_Ethnic_Pop_Hispanic'
		,		ISNULL(REPLACE(CA.[CAPE_ LANG_ HH_ _ SPANISH SPEAKING], '""', ''), '') AS 'Mosaic_Cape_Lang_HH_Spanish_Speaking'
		,		ISNULL(REPLACE(CA.[CAPE_ INC_ HH_ MEDIAN FAMILY HOUSEHOLD INCOME], '""', ''), '') AS 'Mosaic_Cape_INC_HH_Median_Family_Household_Income'
		,		ISNULL(REPLACE(CA.MatchStatus, '""', ''), '') AS 'Mosaic_MatchStatus'
		,		ISNULL(REPLACE(CA.CE_Selected_Individual_Vendor_Ethnicity_Code, '""', ''), '') AS 'Mosaic_CE_Selected_Individual_Vendor_Ethnicity_Code'
		,		ISNULL(REPLACE(CA.CE_Selected_Individual_Vendor_Ethnic_Group_Code, '""', ''), '') AS 'Mosaic_CE_Selected_Individual_Vendor_Ethnic_Group_Code'
		,		ISNULL(REPLACE(CA.CE_Selected_Individual_Vendor_Spoken_Language_Code, '""', ''), '') AS 'Mosaic_CE_Selected_Individual_Vendor_Spoken_Language_Code'
		,		CLT.CreateDate AS 'CreateDate'
		,		'CL-Export' AS 'CreateUser'
		,		CLT.LastUpdate AS 'LastUpdate'
		,		'CL-Export' AS 'LastUpdateUser'
		FROM    #UpdatedClients UC
				INNER JOIN HairClubCMS.dbo.datClient CLT WITH ( NOLOCK )
					ON CLT.ClientIdentifier = UC.ClientIdentifier
				INNER JOIN HairClubCMS.dbo.cfgCenter CTR WITH ( NOLOCK )
					ON CTR.CenterID = CLT.CenterID
				INNER JOIN #Centers C
					ON C.CenterID = CTR.CenterID
				LEFT OUTER JOIN HairClubCMS.dbo.lkpState LS WITH ( NOLOCK )
					ON LS.StateID = CLT.StateID
				LEFT OUTER JOIN HairClubCMS.dbo.lkpCountry LC WITH ( NOLOCK )
					ON LC.CountryID = CLT.CountryID
				LEFT OUTER JOIN HairClubCMS.dbo.lkpTimeZone TZ WITH ( NOLOCK )
					ON TZ.TimeZoneID = CTR.TimeZoneID
				LEFT OUTER JOIN HairClubCMS.dbo.lkpPhoneType PT1 WITH ( NOLOCK )
					ON PT1.PhoneTypeID = CLT.Phone1TypeID
				LEFT OUTER JOIN HairClubCMS.dbo.lkpPhoneType PT2 WITH ( NOLOCK )
					ON PT2.PhoneTypeID = CLT.Phone2TypeID
				LEFT OUTER JOIN HairClubCMS.dbo.lkpPhoneType PT3 WITH ( NOLOCK )
					ON PT3.PhoneTypeID = CLT.Phone3TypeID
				LEFT OUTER JOIN HairClubCMS.dbo.datClientDemographic DCD WITH ( NOLOCK )
					ON DCD.ClientIdentifier = CLT.ClientIdentifier
				LEFT OUTER JOIN HairClubCMS.dbo.lkpEthnicity LE WITH ( NOLOCK )
					ON LE.EthnicityID = DCD.EthnicityID
				LEFT OUTER JOIN HairClubCMS.dbo.lkpOccupation LO WITH ( NOLOCK )
					ON LO.OccupationID = DCD.OccupationID
				LEFT OUTER JOIN HairClubCMS.dbo.lkpMaritalStatus LMS WITH ( NOLOCK )
					ON LMS.MaritalStatusID = DCD.MaritalStatusID
				LEFT OUTER JOIN HairClubCMS.dbo.datClientMembership DCM_BIO WITH ( NOLOCK )
					ON DCM_BIO.ClientMembershipGUID = CLT.CurrentBioMatrixClientMembershipGUID
				LEFT OUTER JOIN HairClubCMS.dbo.cfgMembership CM_BIO WITH ( NOLOCK )
					ON CM_BIO.MembershipID = DCM_BIO.MembershipID
				LEFT OUTER JOIN HairClubCMS.dbo.lkpClientMembershipStatus CMS_BIO WITH ( NOLOCK )
					ON CMS_BIO.ClientMembershipStatusID = DCM_BIO.ClientMembershipStatusID
				LEFT OUTER JOIN HairClubCMS.dbo.datClientMembership DCM_EXT WITH ( NOLOCK )
					ON DCM_EXT.ClientMembershipGUID = CLT.CurrentExtremeTherapyClientMembershipGUID
				LEFT OUTER JOIN HairClubCMS.dbo.cfgMembership CM_EXT WITH ( NOLOCK )
					ON CM_EXT.MembershipID = DCM_EXT.MembershipID
				LEFT OUTER JOIN HairClubCMS.dbo.lkpClientMembershipStatus CMS_EXT WITH ( NOLOCK )
					ON CMS_EXT.ClientMembershipStatusID = DCM_EXT.ClientMembershipStatusID
				LEFT OUTER JOIN HairClubCMS.dbo.datClientMembership DCM_XTR WITH ( NOLOCK )
					ON DCM_XTR.ClientMembershipGUID = CLT.CurrentXtrandsClientMembershipGUID
				LEFT OUTER JOIN HairClubCMS.dbo.cfgMembership CM_XTR WITH ( NOLOCK )
					ON CM_XTR.MembershipID = DCM_XTR.MembershipID
				LEFT OUTER JOIN HairClubCMS.dbo.lkpClientMembershipStatus CMS_XTR WITH ( NOLOCK )
					ON CMS_XTR.ClientMembershipStatusID = DCM_XTR.ClientMembershipStatusID
				LEFT OUTER JOIN HairClubCMS.dbo.datClientMembership DCM_SUR WITH ( NOLOCK )
					ON DCM_SUR.ClientMembershipGUID = CLT.CurrentSurgeryClientMembershipGUID
				LEFT OUTER JOIN HairClubCMS.dbo.cfgMembership CM_SUR WITH ( NOLOCK )
					ON CM_SUR.MembershipID = DCM_SUR.MembershipID
				LEFT OUTER JOIN HairClubCMS.dbo.lkpClientMembershipStatus CMS_SUR WITH ( NOLOCK )
					ON CMS_SUR.ClientMembershipStatusID = DCM_SUR.ClientMembershipStatusID
				LEFT OUTER JOIN HC_DataAppend.dbo.Client_Append CA WITH ( NOLOCK )
					ON CA.ClientIdentifier = CLT.ClientIdentifier
				LEFT OUTER JOIN HC_DataAppend.dbo.lkpMosaicType MT_H WITH ( NOLOCK )
					ON MT_H.MosaicTypeID = CA.[MOSAIC HOUSEHOLD]
				LEFT OUTER JOIN HC_DataAppend.dbo.lkpMosaicGroup MG_H WITH ( NOLOCK )
					ON MG_H.MosaicGroupID = MT_H.MosaicGroupID
				LEFT OUTER JOIN HC_DataAppend.dbo.lkpMosaicType MT_Z WITH ( NOLOCK )
					ON MT_Z.MosaicTypeID = CA.[MOSAIC ZIP4]
				LEFT OUTER JOIN HC_DataAppend.dbo.lkpMosaicGroup MG_Z WITH ( NOLOCK )
					ON MG_Z.MosaicGroupID = MT_Z.MosaicGroupID
				LEFT JOIN x_Cancels BIO_Cancel
					ON BIO_Cancel.ClientIdentifier = CLT.ClientIdentifier
					   AND BIO_Cancel.ClientMembershipGUID = CLT.CurrentBioMatrixClientMembershipGUID
					   AND BIO_Cancel.Row = 1
				LEFT JOIN x_Cancels EXT_Cancel
					ON EXT_Cancel.ClientIdentifier = CLT.ClientIdentifier
					   AND EXT_Cancel.ClientMembershipGUID = CLT.CurrentExtremeTherapyClientMembershipGUID
					   AND EXT_Cancel.Row = 1
				LEFT JOIN x_Cancels SUR_Cancel
					ON SUR_Cancel.ClientIdentifier = CLT.ClientIdentifier
					   AND SUR_Cancel.ClientMembershipGUID = CLT.CurrentSurgeryClientMembershipGUID
					   AND SUR_Cancel.Row = 1
				LEFT JOIN x_Cancels XTR_Cancel
					ON XTR_Cancel.ClientIdentifier = CLT.ClientIdentifier
					   AND XTR_Cancel.ClientMembershipGUID = CLT.CurrentXtrandsClientMembershipGUID
					   AND XTR_Cancel.Row = 1
				LEFT JOIN x_IAC ISA
					ON ISA.ClientIdentifier = CLT.ClientIdentifier
					   AND ISA.SalesCodeDepartmentSSID = 1010
					   AND ISA.Row = 1
				LEFT JOIN x_IAC CNV
					ON CNV.ClientIdentifier = CLT.ClientIdentifier
					   AND CNV.SalesCodeDepartmentSSID = 1075
					   AND CNV.Row = 1
				LEFT JOIN x_IA IAP
					ON IAP.ClientIdentifier = CLT.ClientIdentifier
					   AND IAP.Row = 1
				LEFT JOIN x_Appointments FAPLAP
					ON FAPLAP.ClientIdentifier = CLT.ClientIdentifier
				LEFT JOIN x_Services ES
					ON ES.ClientIdentifier = CLT.ClientIdentifier
					   AND ES.SalesCodeDepartmentSSID = 5035
					   AND ES.Row = 1
				LEFT JOIN x_Services XS
					ON XS.ClientIdentifier = CLT.ClientIdentifier
					   AND XS.SalesCodeDepartmentSSID = 5037
					   AND XS.Row = 1
				LEFT JOIN x_Phone P1
					ON P1.ClientGUID = CLT.ClientGUID
					   AND P1.RowID = 1
				LEFT JOIN x_Phone P2
					ON P2.ClientGUID = CLT.ClientGUID
					   AND P2.RowID = 2
				LEFT JOIN x_Phone P3
					ON P3.ClientGUID = CLT.ClientGUID
					   AND P3.RowID = 3
				OUTER APPLY ( SELECT TOP 1
										CLT_NA.ClientIdentifier
							  ,			DA_NA.AppointmentGUID AS 'NextAppointmentGUID'
							  ,			DA_NA.CenterID AS 'NextAppointmentCenterID'
							  ,         DA_NA.AppointmentDate AS 'NextAppointmentDate'
							  ,         DA_NA.StartTime AS 'NextAppointmentTime'
							  ,			DE_NA.FirstName AS 'StylistFirstName'
							  ,			DE_NA.LastName AS 'StylistLastName'
							  FROM      HairClubCMS.dbo.datAppointment DA_NA WITH ( NOLOCK )
										INNER JOIN HairClubCMS.dbo.datClient CLT_NA WITH ( NOLOCK )
											ON CLT_NA.ClientGUID = DA_NA.ClientGUID
										INNER JOIN HairClubCMS.dbo.cfgConfigurationCenter CC_NA
											ON DA_NA.CenterID = CC_NA.CenterID
										INNER JOIN HairClubCMS.dbo.datAppointmentEmployee AE_NA WITH ( NOLOCK )
											ON AE_NA.AppointmentGUID = DA_NA.AppointmentGUID
										INNER JOIN HairClubCMS.dbo.datEmployee DE_NA WITH ( NOLOCK )
											ON DE_NA.EmployeeGUID = AE_NA.EmployeeGUID
										LEFT OUTER JOIN HairClubCMS.dbo.lkpAppointmentType LAT_NA WITH ( NOLOCK )
											ON LAT_NA.AppointmentTypeID = DA_NA.AppointmentTypeID
							  WHERE     DA_NA.AppointmentDate > GETDATE()
										AND ISNULL(LAT_NA.AppointmentTypeDescriptionShort, '') <> 'BosleyAppt'
										AND DA_NA.OnContactActivityID IS NULL
										AND DA_NA.IsDeletedFlag = 0
										AND CLT_NA.ClientIdentifier = CLT.ClientIdentifier
							  ORDER BY  DA_NA.AppointmentDate ASC
							) NAP


/********************************** Insert Client Details *************************************/
INSERT  INTO datClientExport (
			ExportHeaderID
		,	RegionSSID
        ,	RegionName
        ,	CenterSSID
        ,	CenterName
        ,	CenterType
        ,	CenterAddress1
        ,	CenterAddress2
        ,	CenterCity
        ,	CenterStateCode
        ,	CenterZipCode
        ,	CenterCountry
        ,	CenterPhoneNumber
        ,	CenterManagingDirector
        ,	CenterManagingDirectorEmail
        ,	LeadID
        ,	ClientIdentifier
        ,	ClientFirstName
        ,	ClientLastName
        ,	ClientAddress1
        ,	ClientAddress2
        ,	ClientCity
		,	ClientStateCode
        ,	ClientZipCode
        ,	ClientCountry
        ,	ClientTimezone
        ,	Phone1
        ,	Phone1Type
		,	CanConfirmAppointmentByPhone1Text
		,	CanContactForPromotionsByPhone1Text
        ,	Phone2
        ,	Phone2Type
		,	CanConfirmAppointmentByPhone2Text
		,	CanContactForPromotionsByPhone2Text
        ,	Phone3
        ,	Phone3Type
		,	CanConfirmAppointmentByPhone3Text
		,	CanContactForPromotionsByPhone3Text
		,	SMSPhoneNumber
        ,	ClientDateOfBirth
        ,	ClientAge
        ,	ClientEmailAddress
        ,	ClientGender
        ,	SiebelID
        ,	EthnicitySSID
        ,	ClientEthinicityDescription
        ,	OccupationSSID
        ,	ClientOccupationDescription
        ,	MaritalStatusSSID
        ,	ClientMaritalStatusDescription
        ,	InitialSaleDate
        ,	NBConsultant
        ,	NBConsultantName
        ,	NBConsultantEmail
        ,	InitialApplicationDate
        ,	ConversionDate
        ,	MembershipAdvisor
        ,	MembershipAdvisorName
        ,	MembershipAdvisorEmail
        ,	FirstAppointmentDate
        ,	LastAppointmentDate
        ,	NextAppointmentGUID
		,	NextAppointmentCenterID
		,	NextAppointmentDate
		,	NextAppointmentTime
		,	StylistFirstName
		,	StylistLastName
        ,	FirstEXTServiceDate
        ,	FirstXtrandServiceDate
        ,	BIO_Membership
        ,	BIO_BeginDate
        ,	BIO_EndDate
        ,	BIO_MembershipStatus
        ,	BIO_MonthlyFee
        ,	BIO_ContractPrice
        ,	BIO_CancelDate
        ,	BIO_CancelReasonDescription
        ,	EXT_Membership
        ,	EXT_BeginDate
        ,	EXT_EndDate
        ,	EXT_MembershipStatus
        ,	EXT_MonthlyFee
        ,	EXT_ContractPrice
        ,	EXT_CancelDate
        ,	EXT_CancelReasonDescription
        ,	XTR_Membership
        ,	XTR_BeginDate
        ,	XTR_EndDate
        ,	XTR_MembershipStatus
        ,	XTR_MonthlyFee
        ,	XTR_ContractPrice
        ,	XTR_CancelDate
        ,	XTR_CancelReasonDescription
        ,	SUR_Membership
        ,	SUR_BeginDate
        ,	SUR_EndDate
        ,	SUR_MembershipStatus
        ,	SUR_MonthlyFee
        ,	SUR_ContractPrice
        ,	SUR_CancelDate
        ,	SUR_CancelReasonDescription
        ,	DoNotCallFlag
        ,	DoNotContactFlag
        ,	IsAutoConfirmEmail
        ,	Mosaic_Household
        ,	Mosaic_Household_Group
        ,	Mosaic_Household_Type
        ,	Mosaic_Zip
        ,	Mosaic_Zip_Group
        ,	Mosaic_Zip_Type
        ,	Mosaic_Gender
        ,	Mosaic_Combined_Age
        ,	Mosaic_Education_Model
        ,	Mosaic_Marital_Status
        ,	Mosaic_Occupation_Group_V2
        ,	Mosaic_Latitude
        ,	Mosaic_Longitude
        ,	Mosaic_Match_Level_For_Geo_Data
        ,	Mosaic_Est_Household_Income_V5
        ,	Mosaic_NCOA_Move_Update_Code
        ,	Mosaic_Mail_Responder
        ,	Mosaic_MOR_Bank_Upscale_Merchandise_Buyer
        ,	Mosaic_MOR_Bank_Health_And_Fitness_Magazine
        ,	Mosaic_Cape_Ethnic_Pop_White_Only
        ,	Mosaic_Cape_Ethnic_Pop_Black_Only
        ,	Mosaic_Cape_Ethnic_Pop_Asian_Only
        ,	Mosaic_Cape_Ethnic_Pop_Hispanic
        ,	Mosaic_Cape_Lang_HH_Spanish_Speaking
        ,	Mosaic_Cape_INC_HH_Median_Family_Household_Income
        ,	Mosaic_MatchStatus
        ,	Mosaic_CE_Selected_Individual_Vendor_Ethnicity_Code
        ,	Mosaic_CE_Selected_Individual_Vendor_Ethnic_Group_Code
        ,	Mosaic_CE_Selected_Individual_Vendor_Spoken_Language_Code
        ,	CreateDate
        ,	CreateUser
        ,	LastUpdate
        ,	LastUpdateUser
		)
        SELECT  C.ExportHeaderID
		,		C.RegionSSID
        ,		C.RegionName
        ,		C.CenterSSID
        ,		C.CenterName
        ,		C.CenterType
        ,		C.CenterAddress1
        ,		C.CenterAddress2
        ,		C.CenterStateCode
        ,		C.CenterCity
        ,		C.CenterZipCode
        ,		C.CenterCountry
        ,		C.CenterPhoneNumber
        ,		C.CenterManagingDirector
        ,		C.CenterManagingDirectorEmail
        ,		C.LeadID
        ,		C.ClientIdentifier
        ,		C.ClientFirstName
        ,		C.ClientLastName
        ,		C.ClientAddress1
        ,		C.ClientAddress2
        ,		C.ClientCity
		,		C.ClientStateCode
        ,		C.ClientZipCode
        ,		C.ClientCountry
        ,		C.ClientTimezone
        ,		C.Phone1
        ,		C.Phone1Type
		,		C.CanConfirmAppointmentByPhone1Text
		,		C.CanContactForPromotionsByPhone1Text
        ,		C.Phone2
        ,		C.Phone2Type
		,		C.CanConfirmAppointmentByPhone2Text
		,		C.CanContactForPromotionsByPhone2Text
        ,		C.Phone3
        ,		C.Phone3Type
		,		C.CanConfirmAppointmentByPhone3Text
		,		C.CanContactForPromotionsByPhone3Text
		,		C.SMSPhoneNumber
        ,		C.ClientDateOfBirth
        ,		C.ClientAge
        ,		C.ClientEmailAddress
        ,		C.ClientGender
        ,		C.SiebelID
        ,		C.EthnicitySSID
        ,		C.ClientEthinicityDescription
        ,		C.OccupationSSID
        ,		C.ClientOccupationDescription
        ,		C.MaritalStatusSSID
        ,		C.ClientMaritalStatusDescription
        ,		C.InitialSaleDate
        ,		C.NBConsultant
        ,		C.NBConsultantName
        ,		C.NBConsultantEmail
        ,		C.InitialApplicationDate
        ,		C.ConversionDate
        ,		C.MembershipAdvisor
        ,		C.MembershipAdvisorName
        ,		C.MembershipAdvisorEmail
        ,		C.FirstAppointmentDate
        ,		C.LastAppointmentDate
        ,		C.NextAppointmentGUID
		,		C.NextAppointmentCenterID
		,		C.NextAppointmentDate
		,		C.NextAppointmentTime
		,		C.StylistFirstName
		,		C.StylistLastName
        ,		C.FirstEXTServiceDate
        ,		C.FirstXtrandServiceDate
        ,		C.BIO_Membership
        ,		C.BIO_BeginDate
        ,		C.BIO_EndDate
        ,		C.BIO_MembershipStatus
        ,		C.BIO_MonthlyFee
        ,		C.BIO_ContractPrice
        ,		C.BIO_CancelDate
        ,		C.BIO_CancelReasonDescription
        ,		C.EXT_Membership
        ,		C.EXT_BeginDate
        ,		C.EXT_EndDate
        ,		C.EXT_MembershipStatus
        ,		C.EXT_MonthlyFee
        ,		C.EXT_ContractPrice
        ,		C.EXT_CancelDate
        ,		C.EXT_CancelReasonDescription
        ,		C.XTR_Membership
        ,		C.XTR_BeginDate
        ,		C.XTR_EndDate
        ,		C.XTR_MembershipStatus
        ,		C.XTR_MonthlyFee
        ,		C.XTR_ContractPrice
        ,		C.XTR_CancelDate
        ,		C.XTR_CancelReasonDescription
        ,		C.SUR_Membership
        ,		C.SUR_BeginDate
        ,		C.SUR_EndDate
        ,		C.SUR_MembershipStatus
        ,		C.SUR_MonthlyFee
        ,		C.SUR_ContractPrice
        ,		C.SUR_CancelDate
        ,		C.SUR_CancelReasonDescription
        ,		C.DoNotCallFlag
        ,		C.DoNotContactFlag
        ,		C.IsAutoConfirmEmail
        ,		C.Mosaic_Household
        ,		C.Mosaic_Household_Group
        ,		C.Mosaic_Household_Type
        ,		C.Mosaic_Zip
        ,		C.Mosaic_Zip_Group
        ,		C.Mosaic_Zip_Type
        ,		C.Mosaic_Gender
        ,		C.Mosaic_Combined_Age
        ,		C.Mosaic_Education_Model
        ,		C.Mosaic_Marital_Status
        ,		C.Mosaic_Occupation_Group_V2
        ,		C.Mosaic_Latitude
        ,		C.Mosaic_Longitude
        ,		C.Mosaic_Match_Level_For_Geo_Data
        ,		C.Mosaic_Est_Household_Income_V5
        ,		C.Mosaic_NCOA_Move_Update_Code
        ,		C.Mosaic_Mail_Responder
        ,		C.Mosaic_MOR_Bank_Upscale_Merchandise_Buyer
        ,		C.Mosaic_MOR_Bank_Health_And_Fitness_Magazine
        ,		C.Mosaic_Cape_Ethnic_Pop_White_Only
        ,		C.Mosaic_Cape_Ethnic_Pop_Black_Only
        ,		C.Mosaic_Cape_Ethnic_Pop_Asian_Only
        ,		C.Mosaic_Cape_Ethnic_Pop_Hispanic
        ,		C.Mosaic_Cape_Lang_HH_Spanish_Speaking
        ,		C.Mosaic_Cape_INC_HH_Median_Family_Household_Income
        ,		C.Mosaic_MatchStatus
        ,		C.Mosaic_CE_Selected_Individual_Vendor_Ethnicity_Code
        ,		C.Mosaic_CE_Selected_Individual_Vendor_Ethnic_Group_Code
        ,		C.Mosaic_CE_Selected_Individual_Vendor_Spoken_Language_Code
		,		C.CreateDate
        ,		C.CreateUser
        ,		C.LastUpdate
        ,		C.LastUpdateUser
        FROM    #Clients C

END
GO
