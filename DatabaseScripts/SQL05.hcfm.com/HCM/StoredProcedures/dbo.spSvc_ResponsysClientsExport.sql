/* CreateDate: 03/17/2015 12:17:08.253 , ModifyDate: 07/07/2016 16:10:39.827 */
GO
/***********************************************************************
PROCEDURE:				spSvc_ResponsysClientsExport
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HCM
RELATED APPLICATION:	Responsys Export
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		03/17/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_ResponsysClientsExport NULL, NULL
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_ResponsysClientsExport]
(
	@StartDate DATETIME = NULL,
	@EndDate DATETIME = NULL
)
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


/********************************** Create temp table objects *************************************/
DECLARE @Centers TABLE (
	CenterType NVARCHAR(50)
,	RegionName NVARCHAR(50)
,	CenterSSID INT
,	CenterName NVARCHAR(255)
,	CenterAddress1 NVARCHAR(50)
,   CenterAddress2 NVARCHAR(50)
,   State NVARCHAR(10)
,   City NVARCHAR(50)
,   ZipCode NVARCHAR(15)
,   Country NVARCHAR(10)
,	CenterPhoneNumber NVARCHAR(15)
,	ManagingDirector NVARCHAR(102)
,	ManagingDirectorEmail NVARCHAR(50)
,	IsAutoConfirmEnabled INT
,	UNIQUE CLUSTERED (CenterSSID)
)

DECLARE @UpdateClients TABLE ( ClientIdentifier INT )


/********************************** Set Dates If Parameters are NULL *************************************/
IF ( @StartDate IS NULL OR @EndDate IS NULL )
   BEGIN
		SET @StartDate = DATEADD(dd, -7, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
		SET @EndDate = DATEADD(dd, 0, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
   END


/********************************** Get Center Data *************************************/
INSERT  INTO @Centers
        SELECT  DCT.CenterTypeDescriptionShort AS 'CenterType'
        ,       DR.RegionDescription AS 'RegionName'
        ,       DC.CenterSSID
        ,       DC.CenterDescription AS 'CenterName'
        ,       DC.CenterAddress1
        ,       DC.CenterAddress2
        ,       DC.StateProvinceDescriptionShort AS 'State'
        ,       DC.City
        ,       DC.PostalCode AS 'ZipCode'
        ,       DC.CountryRegionDescriptionShort AS 'Country'
        ,       DC.CenterPhone1
        ,       ISNULL(CMD.ManagingDirector, '') AS 'ManagingDirector'
        ,       ISNULL(CMD.ManagingDirectorEmail, '') AS 'ManagingDirectorEmail'
		,		CCC.IsAutoConfirmEnabled
        FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
                    ON DC.CenterTypeKey = DCT.CenterTypeKey
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
                    ON DC.RegionSSID = DR.RegionKey
				INNER JOIN HairClubCMS.dbo.cfgConfigurationCenter CCC
					ON CCC.CenterID = DC.CenterSSID
                OUTER APPLY ( SELECT TOP 1
                                        DE.CenterID AS 'CenterSSID'
                              ,         DE.FirstName + ' ' + DE.LastName AS 'ManagingDirector'
                              ,         DE.UserLogin + '@hcfm.com' AS 'ManagingDirectorEmail'
                              FROM      HairClubCMS.dbo.datEmployee DE
                                        INNER JOIN HairClubCMS.dbo.cfgEmployeePositionJoin CEPJ
                                            ON CEPJ.EmployeeGUID = DE.EmployeeGUID
                                        INNER JOIN HairClubCMS.dbo.lkpEmployeePosition LEP
                                            ON LEP.EmployeePositionID = CEPJ.EmployeePositionID
                              WHERE     LEP.EmployeePositionID = 6
                                        AND ISNULL(DE.CenterID, 100) <> 100
                                        AND DE.CenterID = DC.CenterSSID
                                        AND DE.FirstName NOT IN ( 'EC', 'Test' )
                                        AND DE.IsActiveFlag = 1
                              ORDER BY  DE.CenterID
                              ,         DE.EmployeePayrollID DESC
                            ) CMD
        WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
                AND DC.Active = 'Y'


INSERT  INTO @Centers
		SELECT  DCT.CenterTypeDescriptionShort AS 'CenterType'
		,       DR.RegionDescription AS 'RegionName'
		,       DC.CenterSSID
		,       DC.CenterDescription AS 'CenterName'
		,       DC.CenterAddress1
		,       DC.CenterAddress2
		,       DC.StateProvinceDescriptionShort AS 'State'
		,       DC.City
		,       DC.PostalCode AS 'ZipCode'
		,       DC.CountryRegionDescriptionShort AS 'Country'
		,       DC.CenterPhone1
		,		ISNULL(CMD.ManagingDirector, '') AS 'ManagingDirector'
		,		ISNULL(CMD.ManagingDirectorEmail, '') AS 'ManagingDirectorEmail'
		,		CCC.IsAutoConfirmEnabled
		FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionKey = DR.RegionKey
				INNER JOIN HairClubCMS.dbo.cfgConfigurationCenter CCC
					ON CCC.CenterID = DC.CenterSSID
                OUTER APPLY ( SELECT TOP 1
                                        DE.CenterID AS 'CenterSSID'
                              ,         DE.FirstName + ' ' + DE.LastName AS 'ManagingDirector'
                              ,         DE.UserLogin + '@hcfm.com' AS 'ManagingDirectorEmail'
                              FROM      HairClubCMS.dbo.datEmployee DE
                                        INNER JOIN HairClubCMS.dbo.cfgEmployeePositionJoin CEPJ
                                            ON CEPJ.EmployeeGUID = DE.EmployeeGUID
                                        INNER JOIN HairClubCMS.dbo.lkpEmployeePosition LEP
                                            ON LEP.EmployeePositionID = CEPJ.EmployeePositionID
                              WHERE     LEP.EmployeePositionID = 6
                                        AND ISNULL(DE.CenterID, 100) <> 100
                                        AND DE.CenterID = DC.CenterSSID
                                        AND DE.FirstName NOT IN ( 'EC', 'Test' )
                                        AND DE.IsActiveFlag = 1
                              ORDER BY  DE.CenterID
                              ,         DE.EmployeePayrollID DESC
                            ) CMD
		WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[78]%'
				AND DC.Active = 'Y'


/********************************** Get Client Data *************************************/
INSERT	INTO @UpdateClients

		-- Clients Updated or Created
		SELECT  DISTINCT
				CLT.ClientIdentifier
		FROM    HairClubCMS.dbo.datClient CLT WITH (NOLOCK)
		WHERE   ( CLT.CreateDate BETWEEN @StartDate AND @EndDate + ' 23:59:59'
				  OR CLT.LastUpdate BETWEEN @StartDate AND @EndDate + ' 23:59:59' )

		UNION

		-- Clients who had a Membership Change, Service or Payment Transaction within the specified period
		SELECT  DISTINCT
				cl.ClientIdentifier
		FROM    HairClubCMS.dbo.datSalesOrderDetail sod WITH (NOLOCK)
				INNER JOIN HairClubCMS.dbo.datSalesOrder so WITH (NOLOCK)
					ON so.SalesOrderGUID = sod.SalesOrderGUID
				INNER JOIN HairClubCMS.dbo.cfgSalesCode sc WITH (NOLOCK)
					ON sc.SalesCodeID = sod.SalesCodeID
				INNER JOIN HairClubCMS.dbo.datClient cl WITH (NOLOCK)
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
				  OR DA.LastUpdate BETWEEN @StartDate AND @EndDate + ' 23:59:59' )


/********************************** Get Export Data *************************************/
;WITH    x_PMT
          AS ( SELECT   FST.ClientKey
               ,        DCM.ClientMembershipSSID
               ,        MIN(DD.FullDate) AS 'FirstPaymentDate'
               ,        MAX(DD.FullDate) AS 'LastPaymentDate'
               ,        SUM(FST.ExtendedPrice) AS 'TotalPayments'
               FROM     HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST WITH ( NOLOCK )
                        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD WITH ( NOLOCK )
                            ON FST.OrderDateKey = DD.DateKey
                        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC WITH ( NOLOCK )
                            ON FST.SalesCodeKey = DSC.SalesCodeKey
                        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO WITH ( NOLOCK )
                            ON FST.SalesOrderKey = DSO.SalesOrderKey
                        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD WITH ( NOLOCK )
                            ON FST.SalesOrderDetailKey = DSOD.SalesOrderDetailKey
                        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM WITH ( NOLOCK )
                            ON DSO.ClientMembershipKey = DCM.ClientMembershipKey
               WHERE    DSC.SalesCodeDepartmentSSID = 2020
               GROUP BY FST.ClientKey
               ,        DCM.ClientMembershipSSID
             ),
        x_Cancel
          AS ( SELECT   ROW_NUMBER() OVER ( PARTITION BY FST.ClientKey, DCM.ClientMembershipSSID ORDER BY DSO.OrderDate DESC ) AS [Row]
               ,        FST.ClientKey
               ,        DCM.ClientMembershipSSID
               ,        DSO.OrderDate AS 'CancelDate'
               ,        DMOR.MembershipOrderReasonDescription AS 'CancelReason'
               FROM     HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST WITH ( NOLOCK )
                        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD WITH ( NOLOCK )
                            ON FST.OrderDateKey = DD.DateKey
                        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC WITH ( NOLOCK )
                            ON FST.SalesCodeKey = DSC.SalesCodeKey
                        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO WITH ( NOLOCK )
                            ON FST.SalesOrderKey = DSO.SalesOrderKey
                        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD WITH ( NOLOCK )
                            ON FST.SalesOrderDetailKey = DSOD.SalesOrderDetailKey
                        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM WITH ( NOLOCK )
                            ON DSO.ClientMembershipKey = DCM.ClientMembershipKey
                        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembershipOrderReason DMOR WITH ( NOLOCK )
                            ON DSOD.MembershipOrderReasonID = DMOR.MembershipOrderReasonID
               WHERE    DSC.SalesCodeDepartmentSSID = 1099
             ),
        ISACNV
          AS ( SELECT   ROW_NUMBER() OVER ( PARTITION BY FST.ClientKey, DSC.SalesCodeDepartmentSSID ORDER BY DSO.OrderDate ASC ) AS [Row]
               ,        FST.ClientKey
               ,        DSC.SalesCodeDepartmentSSID
               ,        DCM.ClientMembershipKey
               ,        DSO.OrderDate AS 'OrderDate'
               ,        DM.MembershipDescription AS 'MembershipDescription'
			   ,        ISNULL(PFR.EmployeeInitials, '') AS 'EmployeeInitials'
               ,        ISNULL(REPLACE(REPLACE(PFR.EmployeeFullName, ',', ''), 'Unknown Unknown', ''), '') AS 'EmployeeFullName'
			   ,		CASE WHEN ISNULL(PFR.EmployeeInitials, '') = '' THEN '' ELSE PFR.UserLogin + '@hcfm.com' END AS 'EmployeeEmail'
               FROM     HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST WITH ( NOLOCK )
                        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD WITH ( NOLOCK )
                            ON DD.DateKey = FST.OrderDateKey
                        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC WITH ( NOLOCK )
                            ON DSC.SalesCodeKey = FST.SalesCodeKey
                        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO WITH ( NOLOCK )
                            ON DSO.SalesOrderKey = FST.SalesOrderKey
                        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM WITH ( NOLOCK )
                            ON DCM.ClientMembershipKey = DSO.ClientMembershipKey
                        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM WITH ( NOLOCK )
                            ON DM.MembershipSSID = DCM.MembershipSSID
                        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee PFR WITH ( NOLOCK )
                            ON PFR.EmployeeKey = FST.Employee1Key
               WHERE    DSC.SalesCodeDepartmentSSID IN ( 1010, 1075 )
						AND DM.MembershipSSID NOT IN ( 57, 58 )
             ),
        SVC_
          AS ( SELECT   ROW_NUMBER() OVER ( PARTITION BY FST.ClientKey, DSC.SalesCodeDepartmentSSID ORDER BY DSO.OrderDate ASC ) AS [Row]
               ,        FST.ClientKey
			   ,		DSC.SalesCodeKey
               ,        DSC.SalesCodeDepartmentSSID
               ,        DCM.ClientMembershipKey
               ,        DSO.OrderDate AS 'OrderDate'
               FROM     HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST WITH ( NOLOCK )
                        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD WITH ( NOLOCK )
                            ON DD.DateKey = FST.OrderDateKey
                        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC WITH ( NOLOCK )
                            ON DSC.SalesCodeKey = FST.SalesCodeKey
                        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO WITH ( NOLOCK )
                            ON DSO.SalesOrderKey = FST.SalesOrderKey
                        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM WITH ( NOLOCK )
                            ON DCM.ClientMembershipKey = DSO.ClientMembershipKey
                        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM WITH ( NOLOCK )
                            ON DM.MembershipSSID = DCM.MembershipSSID
                        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee PFR WITH ( NOLOCK )
                            ON PFR.EmployeeKey = FST.Employee1Key
               WHERE    DSC.SalesCodeDepartmentSSID IN ( 5035, 5037, 5038 )
						AND DSC.SalesCodeKey NOT IN ( 1726, 1727, 1739 )
             ),
        IAP_
          AS ( SELECT   ROW_NUMBER() OVER ( PARTITION BY FST.ClientKey ORDER BY DSO.OrderDate ASC ) AS [Row]
               ,        FST.ClientKey
               ,        DSO.OrderDate AS 'InitialApplicationDate'
               FROM     HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST WITH ( NOLOCK )
                        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD WITH ( NOLOCK )
                            ON FST.OrderDateKey = DD.DateKey
                        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC WITH ( NOLOCK )
                            ON FST.SalesCodeKey = DSC.SalesCodeKey
                        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO WITH ( NOLOCK )
                            ON DSO.SalesOrderKey = FST.SalesOrderKey
               WHERE    DSC.SalesCodeSSID IN ( 648 )
             ),
        FAPLAP_
          AS ( SELECT   DA.ClientKey
               ,        MIN(DA.AppointmentDate) AS 'FirstAppointmentDate'
               ,        MAX(DA.AppointmentDate) AS 'LastAppointmentDate'
               FROM     HC_BI_CMS_DDS.bi_cms_dds.DimAppointment DA WITH ( NOLOCK )
               WHERE    DA.AppointmentDate < GETDATE()
						AND DA.IsDeletedFlag = 1
               GROUP BY DA.ClientKey
             ),
      --  NAP_
      --    AS ( SELECT   ROW_NUMBER() OVER ( PARTITION BY DA.ClientKey ORDER BY DA.AppointmentDate ASC ) AS [Row]
			   --,		DA.ClientKey
      --         ,		DA.AppointmentSSID AS 'AppointmentGUID'
			   --,        DA.AppointmentDate AS 'NextAppointmentDate'
			   --,		DA.AppointmentStartTime
			   --,		DA.ConfirmationTypeSSID AS 'ConfirmationTypeID'
			   --,		DA.AppointmentTypeDescription AS 'AppointmentTypeDescription'
			   --,		DA.IsDeletedFlag
      --         FROM     HC_BI_CMS_DDS.bi_cms_dds.DimAppointment DA WITH ( NOLOCK )
      --         WHERE    DA.AppointmentDate > GETDATE()
      --       )
        NAP_
          AS ( SELECT   DA.ClientKey
               ,		MIN(DA.AppointmentDate) AS 'NextAppointmentDate'
               FROM     HC_BI_CMS_DDS.bi_cms_dds.DimAppointment DA WITH ( NOLOCK )
               WHERE    DA.AppointmentDate > GETDATE()
						AND DA.IsDeletedFlag = 1
			   GROUP BY DA.ClientKey
             )
		SELECT  tmpCTR.CenterType
		,       tmpCTR.RegionName
		,       tmpCTR.CenterSSID
		,       tmpCTR.CenterName
		,       ISNULL(LTRIM(RTRIM(REPLACE(tmpCTR.CenterAddress1, ',', ''))), '') AS 'CenterAddress1'
		,       ISNULL(LTRIM(RTRIM(REPLACE(tmpCTR.CenterAddress2, ',', ''))), '') AS 'CenterAddress2'
		,       tmpCTR.State AS 'CenterStateCode'
		,       ISNULL(LTRIM(RTRIM(REPLACE(tmpCTR.City, ',', ''))), '') AS 'CenterCity'
		,       tmpCTR.ZipCode AS 'CenterZipCode'
		,       tmpCTR.Country AS 'CenterCountry'
		,		tmpCTR.CenterPhoneNumber
		,       LTRIM(RTRIM(REPLACE(tmpCTR.ManagingDirector, ',', ''))) AS 'CenterManagingDirector'
		,       LTRIM(RTRIM(REPLACE(tmpCTR.ManagingDirectorEmail, ',', ''))) AS 'CenterManagingDirectorEmail'
		--,		tmpCTR.IsAutoConfirmEnabled AS 'CenterIsAutoConfirmEnabled'
		,       CASE WHEN CON.ContactSSID = '-2' THEN ''
						ELSE CON.ContactSSID
				END AS 'LeadID'
		,       CLT.ClientIdentifier
		,       REPLACE(CLT.ClientFirstName, ',', '') AS 'ClientFirstName'
		,		REPLACE(CLT.ClientLastName, ',', '') AS 'ClientLastName'
		,       ISNULL(LTRIM(RTRIM(REPLACE(CLT.ClientAddress1, ',', ''))), '') AS 'ClientAddress1'
		,       ISNULL(LTRIM(RTRIM(REPLACE(CLT.ClientAddress2, ',', ''))), '') AS 'ClientAddress2'
		,		CLT.StateProvinceDescriptionShort AS 'ClientStateCode'
		,       ISNULL(LTRIM(RTRIM(REPLACE(CLT.City, ',', ''))), '') AS 'ClientCity'
		,		REPLACE(CLT.PostalCode, '-', '') AS 'ClientZipCode'
		,		CLT.CountryRegionDescriptionShort AS 'ClientCountry'
		,       ISNULL(CASE WHEN ClientPhone1TypeDescriptionShort = 'Home' THEN ClientPhone1
					 WHEN ClientPhone2TypeDescriptionShort = 'Home' THEN ClientPhone2
					 WHEN ClientPhone3TypeDescriptionShort = 'Home' THEN ClientPhone3
				END, '') AS 'HomePhone'
		,       ISNULL(CASE WHEN ClientPhone1TypeDescriptionShort = 'Work' THEN ClientPhone1
					 WHEN ClientPhone2TypeDescriptionShort = 'Work' THEN ClientPhone2
					 WHEN ClientPhone3TypeDescriptionShort = 'Work' THEN ClientPhone3
				END, '') AS 'WorkPhone'
		,       ISNULL(CASE WHEN ClientPhone1TypeDescriptionShort = 'Mobile' THEN ClientPhone1
					 WHEN ClientPhone2TypeDescriptionShort = 'Mobile' THEN ClientPhone2
					 WHEN ClientPhone3TypeDescriptionShort = 'Mobile' THEN ClientPhone3
				END, '') AS 'CellPhone'
		,		CASE WHEN CLT.ClientDateOfBirth IS NULL THEN '' ELSE CONVERT(VARCHAR(11), CLT.ClientDateOfBirth, 101) END AS 'ClientDateOfBirth'
		,		ISNULL(REPLACE(CLT.ClientEMailAddress, ',', '.'), '') AS 'ClientEmailAddress'
		,		CLT.ClientGenderDescription
		,		ISNULL(DC.SiebelID, '') AS 'SiebelID'
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

		--,		NAP.AppointmentGUID AS 'NextAppointmentGUID'
		,		CASE WHEN NAP.NextAppointmentDate IS NULL THEN '' ELSE CONVERT(VARCHAR(11), NAP.NextAppointmentDate, 101) END AS 'NextAppointmentDate'
		--,		NAP.AppointmentStartTime AS 'NextAppointmentStartTime'
		--,		NAP.ConfirmationTypeID AS 'NextAppointmentConfirmationTypeID'
		--,		NAP.AppointmentTypeDescription AS 'NextAppointmentTypeDescription'
		--,		NAP.IsDeletedFlag AS 'NextAppointmentIsDeletedFlag'

		,		CASE WHEN ES.OrderDate IS NULL THEN '' ELSE CONVERT(VARCHAR(11), ES.OrderDate, 101) END AS 'FirstEXTServiceDate'
		,		CASE WHEN XS.OrderDate IS NULL THEN '' ELSE CONVERT(VARCHAR(11), XS.OrderDate, 101) END AS 'FirstXtrandServiceDate'
		,		ISNULL(DM_BIO.MembershipDescription, '') AS 'BIO_Membership'
		,		CASE WHEN DCM_BIO.ClientMembershipBeginDate IS NULL THEN '' ELSE CONVERT(VARCHAR(11), DCM_BIO.ClientMembershipBeginDate, 101) END AS 'BIO_BeginDate'
		,		CASE WHEN DCM_BIO.ClientMembershipEndDate IS NULL THEN '' ELSE CONVERT(VARCHAR(11), DCM_BIO.ClientMembershipEndDate, 101) END AS 'BIO_EndDate'
		,		ISNULL(DCM_BIO.ClientMembershipStatusDescription, '') AS 'BIO_MembershipStatus'
		,		ISNULL(DCM_BIO.ClientMembershipMonthlyFee, 0) AS 'BIO_MonthlyFee'
		,		ISNULL(DCM_BIO.ClientMembershipContractPrice, 0) AS 'BIO_ContractPrice'
		,       CASE WHEN BIO_Cancel.CancelDate IS NULL THEN '' ELSE CONVERT(VARCHAR(11), BIO_Cancel.CancelDate, 101) END AS 'BIO_CancelDate'
		,       ISNULL(BIO_Cancel.CancelReason, '') AS 'BIO_CancelReasonDescription'
		,		ISNULL(DM_EXT.MembershipDescription, '') AS 'EXT_Membership'
		,		CASE WHEN DCM_EXT.ClientMembershipBeginDate IS NULL THEN '' ELSE CONVERT(VARCHAR(11), DCM_EXT.ClientMembershipBeginDate, 101) END AS 'EXT_BeginDate'
		,		CASE WHEN DCM_EXT.ClientMembershipEndDate IS NULL THEN '' ELSE CONVERT(VARCHAR(11), DCM_EXT.ClientMembershipEndDate, 101) END AS 'EXT_EndDate'
		,		ISNULL(DCM_EXT.ClientMembershipStatusDescription, '') AS 'EXT_MembershipStatus'
		,		ISNULL(DCM_EXT.ClientMembershipMonthlyFee, 0) AS 'EXT_MonthlyFee'
		,		ISNULL(DCM_EXT.ClientMembershipContractPrice, 0) AS 'EXT_ContractPrice'
		,       CASE WHEN EXT_Cancel.CancelDate IS NULL THEN '' ELSE CONVERT(VARCHAR(11), EXT_Cancel.CancelDate, 101) END AS 'EXT_CancelDate'
		,       ISNULL(EXT_Cancel.CancelReason, '') AS 'EXT_CancelReasonDescription'
		,		ISNULL(DM_SUR.MembershipDescription, '') AS 'SUR_Membership'
		,		CASE WHEN DCM_SUR.ClientMembershipBeginDate IS NULL THEN '' ELSE CONVERT(VARCHAR(11), DCM_SUR.ClientMembershipBeginDate, 101) END AS 'SUR_BeginDate'
		,		CASE WHEN DCM_SUR.ClientMembershipEndDate IS NULL THEN '' ELSE CONVERT(VARCHAR(11), DCM_SUR.ClientMembershipEndDate, 101) END AS 'SUR_EndDate'
		,		ISNULL(DCM_SUR.ClientMembershipStatusDescription, '') AS 'SUR_MembershipStatus'
		,		ISNULL(DCM_SUR.ClientMembershipMonthlyFee, 0) AS 'SUR_MonthlyFee'
		,		ISNULL(DCM_SUR.ClientMembershipContractPrice, 0) AS 'SUR_ContractPrice'
		,       CASE WHEN SUR_Cancel.CancelDate IS NULL THEN '' ELSE CONVERT(VARCHAR(11), SUR_Cancel.CancelDate, 101) END AS 'SUR_CancelDate'
		,       ISNULL(SUR_Cancel.CancelReason, '') AS 'SUR_CancelReasonDescription'
		,		ISNULL(DM_XTR.MembershipDescription, '') AS 'XTR_Membership'
		,		CASE WHEN DCM_XTR.ClientMembershipBeginDate IS NULL THEN '' ELSE CONVERT(VARCHAR(11), DCM_XTR.ClientMembershipBeginDate, 101) END AS 'XTR_BeginDate'
		,		CASE WHEN DCM_XTR.ClientMembershipEndDate IS NULL THEN '' ELSE CONVERT(VARCHAR(11), DCM_XTR.ClientMembershipEndDate, 101) END AS 'XTR_EndDate'
		,		ISNULL(DCM_XTR.ClientMembershipStatusDescription, '') AS 'XTR_MembershipStatus'
		,		ISNULL(DCM_XTR.ClientMembershipMonthlyFee, 0) AS 'XTR_MonthlyFee'
		,		ISNULL(DCM_XTR.ClientMembershipContractPrice, 0) AS 'XTR_ContractPrice'
		,       CASE WHEN XTR_Cancel.CancelDate IS NULL THEN '' ELSE CONVERT(VARCHAR(11), XTR_Cancel.CancelDate, 101) END AS 'XTR_CancelDate'
		,       ISNULL(XTR_Cancel.CancelReason, '') AS 'XTR_CancelReasonDescription'
		,       CLT.DoNotCallFlag
		,       CLT.DoNotContactFlag
		,		ISNULL(DC.IsAutoConfirmEmail, 0) AS 'IsAutoConfirmEmail'
		FROM	HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
				INNER JOIN @UpdateClients UC
					ON UC.ClientIdentifier = CLT.ClientIdentifier
				INNER JOIN HairClubCMS.dbo.datClient DC WITH ( NOLOCK )
					ON DC.ClientIdentifier = CLT.ClientIdentifier
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR WITH ( NOLOCK )
					ON CTR.CenterSSID = CLT.CenterSSID
				INNER JOIN @Centers tmpCTR
					ON tmpCTR.CenterSSID = CTR.CenterSSID
				LEFT OUTER JOIN HairClubCMS.dbo.datClientDemographic DCD WITH ( NOLOCK )
					ON DCD.ClientIdentifier = CLT.ClientIdentifier
				LEFT OUTER JOIN HairClubCMS.dbo.lkpEthnicity LE WITH ( NOLOCK )
					ON LE.EthnicityID = DCD.EthnicityID
				LEFT OUTER JOIN HairClubCMS.dbo.lkpOccupation LO WITH ( NOLOCK )
					ON LO.OccupationID = DCD.OccupationID
				LEFT OUTER JOIN HairClubCMS.dbo.lkpMaritalStatus LMS WITH ( NOLOCK )
					ON LMS.MaritalStatusID = DCD.MaritalStatusID
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM_BIO WITH ( NOLOCK )
					ON DCM_BIO.ClientMembershipSSID = CLT.CurrentBioMatrixClientMembershipSSID
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM_BIO WITH ( NOLOCK )
					ON DM_BIO.MembershipKey = DCM_BIO.MembershipKey
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM_EXT WITH ( NOLOCK )
					ON DCM_EXT.ClientMembershipSSID = CLT.CurrentExtremeTherapyClientMembershipSSID
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM_EXT WITH ( NOLOCK )
					ON DM_EXT.MembershipKey = DCM_EXT.MembershipKey
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM_SUR WITH ( NOLOCK )
					ON DCM_SUR.ClientMembershipSSID = CLT.CurrentSurgeryClientMembershipSSID
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM_SUR WITH ( NOLOCK )
					ON DM_SUR.MembershipKey = DCM_SUR.MembershipKey
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM_XTR WITH ( NOLOCK )
					ON DCM_XTR.ClientMembershipSSID = CLT.CurrentXtrandsClientMembershipSSID
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM_XTR WITH ( NOLOCK )
					ON DM_XTR.MembershipKey = DCM_XTR.MembershipKey
				LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact CON WITH ( NOLOCK )
					ON CON.ContactKey = CLT.contactkey
				LEFT JOIN x_PMT AS BIO_PMT
					ON BIO_PMT.ClientKey = CLT.ClientKey
						AND BIO_PMT.ClientMembershipSSID = CLT.CurrentBioMatrixClientMembershipSSID
				LEFT JOIN x_PMT AS EXT_PMT
					ON EXT_PMT.ClientKey = CLT.ClientKey
						AND EXT_PMT.ClientMembershipSSID = CLT.CurrentExtremeTherapyClientMembershipSSID
				LEFT JOIN x_PMT AS SUR_PMT
					ON SUR_PMT.ClientKey = CLT.ClientKey
						AND SUR_PMT.ClientMembershipSSID = CLT.CurrentSurgeryClientMembershipSSID
				LEFT JOIN x_PMT AS XTR_PMT
					ON XTR_PMT.ClientKey = CLT.ClientKey
						AND XTR_PMT.ClientMembershipSSID = CLT.CurrentXtrandsClientMembershipSSID
				LEFT JOIN x_Cancel AS BIO_Cancel
					ON BIO_Cancel.ClientKey = CLT.ClientKey
						AND BIO_Cancel.ClientMembershipSSID = CLT.CurrentBioMatrixClientMembershipSSID
						AND BIO_Cancel.[Row] = 1
				LEFT JOIN x_Cancel AS EXT_Cancel
					ON EXT_Cancel.ClientKey = CLT.ClientKey
						AND EXT_Cancel.ClientMembershipSSID = CLT.CurrentExtremeTherapyClientMembershipSSID
						AND EXT_Cancel.[Row] = 1
				LEFT JOIN x_Cancel AS SUR_Cancel
					ON SUR_Cancel.ClientKey = CLT.ClientKey
						AND SUR_Cancel.ClientMembershipSSID = CLT.CurrentSurgeryClientMembershipSSID
						AND SUR_Cancel.[Row] = 1
				LEFT JOIN x_Cancel AS XTR_Cancel
					ON XTR_Cancel.ClientKey = CLT.ClientKey
						AND XTR_Cancel.ClientMembershipSSID = CLT.CurrentXtrandsClientMembershipSSID
						AND XTR_Cancel.[Row] = 1
				LEFT JOIN ISACNV AS ISA
					ON ISA.ClientKey = CLT.ClientKey
						AND ISA.SalesCodeDepartmentSSID = 1010
						AND ISA.[Row] = 1
				LEFT JOIN ISACNV AS CNV
					ON CNV.ClientKey = CLT.ClientKey
						AND CNV.SalesCodeDepartmentSSID = 1075
						AND CNV.[Row] = 1
				LEFT JOIN IAP_ AS IAP
					ON IAP.ClientKey = CLT.ClientKey
						AND IAP.[Row] = 1
				LEFT JOIN FAPLAP_ AS FAPLAP
					ON FAPLAP.ClientKey = CLT.ClientKey
				LEFT JOIN NAP_ AS NAP
					ON NAP.ClientKey = CLT.ClientKey
						--AND NAP.[Row] = 1
				LEFT JOIN SVC_ AS ES
					ON ES.ClientKey = CLT.ClientKey
						AND ES.SalesCodeDepartmentSSID = 5035
						AND ES.[Row] = 1
				LEFT JOIN SVC_ AS XS
					ON XS.ClientKey = CLT.ClientKey
						AND XS.SalesCodeDepartmentSSID <> 5035
						AND XS.[Row] = 1

END
GO
