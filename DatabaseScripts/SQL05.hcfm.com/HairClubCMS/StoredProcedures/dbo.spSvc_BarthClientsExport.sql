/* CreateDate: 09/13/2018 13:44:46.587 , ModifyDate: 07/26/2021 18:11:05.810 */
GO
/***********************************************************************
PROCEDURE:				spSvc_BarthClientsExport
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HairClubCMS
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		9/13/2018
DESCRIPTION:			9/13/2018
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_BarthClientsExport
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_BarthClientsExport]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


/********************************** Create temp table objects *************************************/
CREATE TABLE #Center (
	CenterID INT
,	CenterNumber INT
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
,	IsAutoConfirmEnabled INT
)

CREATE TABLE #Client (
	ClientGUID UNIQUEIDENTIFIER
)

CREATE TABLE #CreditCardOnFile (
	RowID INT
,	ClientGUID UNIQUEIDENTIFIER
,	HasCreditCardOnFile BIT
)

CREATE TABLE #ClientMembership (
	RowID INT
,	ClientMembershipKey INT
,	ClientMembershipGUID UNIQUEIDENTIFIER
,	ClientMembershipIdentifier NVARCHAR(50)
,	ClientGUID UNIQUEIDENTIFIER
,	MembershipKey INT
,	MembershipSSID INT
,	Membership NVARCHAR(50)
,	MembershipDescriptionShort NVARCHAR(10)
,	BusinessSegment NVARCHAR(100)
,	RevenueGroup NVARCHAR(100)
,	BeginDate DATETIME
,	EndDate DATETIME
,	MembershipStatus NVARCHAR(100)
,	ContractPrice MONEY
,	MonthlyFee MONEY
)

CREATE TABLE #ClientPhone (
	ClientGUID UNIQUEIDENTIFIER
,	PhoneNumber NVARCHAR(15)
,	PhoneType NVARCHAR(100)
,	CanConfirmAppointmentByCall BIT
,	CanConfirmAppointmentByText BIT
,	CanContactForPromotionsByCall BIT
,	CanContactForPromotionsByText BIT
,	ClientPhoneSortOrder INT
)

CREATE TABLE #ClientMembershipAccum (
	ClientMembershipGUID UNIQUEIDENTIFIER
,	SystemsAvailable INT
,	SystemsUsed INT
,	ServicesAvailable INT
,	ServicesUsed INT
,	SolutionsAvailable INT
,	SolutionsUsed INT
,	ProductKitsAvailable INT
,	ProductKitsUsed INT
)

CREATE TABLE #Cancel (
	RowID INT
,	ClientGUID UNIQUEIDENTIFIER
,	CancelDate DATETIME
,	CancelReason NVARCHAR(100)
)

Create table #Lead(
	Id nvarchar(18)
	,[LastName] NVARCHAR(80)
	,[FirstName] NVARCHAR(50)
	,[Street] NVARCHAR(255)
	,[City] NVARCHAR(50)
	,[PostalCode] NVARCHAR(20)
	,[Phone] NVARCHAR(80)
	,[Email] NVARCHAR(105)
	,[ConvertedAccountId] NVARCHAR(18)
	)


/********************************** Get Center Data *************************************/
INSERT  INTO #Center
		SELECT  ctr.CenterID
		,		ctr.CenterNumber
		,       ctr.CenterDescription
		,       ct.CenterTypeDescriptionShort AS 'CenterType'
		,       ISNULL(lr.RegionID, 1) AS 'RegionID'
		,       ISNULL(lr.RegionDescription, 'Corporate') AS 'RegionName'
		,       REPLACE(REPLACE(ctr.Address1, CHAR(13),' '), CHAR(10),' ') as Address1
		,       REPLACE(REPLACE(ctr.Address2, CHAR(13),' '), CHAR(10),' ') as Address2
		,       ctr.City
		,       ls.StateDescriptionShort AS 'StateCode'
		,       ctr.PostalCode AS 'ZipCode'
		,       lc.CountryDescription AS 'Country'
		,       ISNULL(ctr.Phone1, '561-361-7600') AS 'PhoneNumber'
		,       ISNULL(o_MD.ManagingDirector, '') AS 'ManagingDirector'
		,       ISNULL(o_MD.ManagingDirectorEmail, '') AS 'ManagingDirectorEmail'
		,		ISNULL(ccc.IsAutoConfirmEnabled, 0) AS 'IsAutoConfirmEnabled'
		FROM    HairClubCMS.dbo.cfgCenter ctr WITH ( NOLOCK )
				INNER JOIN HairClubCMS.dbo.lkpCenterType ct WITH ( NOLOCK )
					ON ct.CenterTypeID = ctr.CenterTypeID
				INNER JOIN HairClubCMS.dbo.lkpState ls WITH ( NOLOCK )
					ON ls.StateID = ctr.StateID
				INNER JOIN HairClubCMS.dbo.lkpCountry lc WITH ( NOLOCK )
					ON lc.CountryID = ctr.CountryID
				LEFT OUTER JOIN HairClubCMS.dbo.lkpRegion lr WITH ( NOLOCK )
					ON lr.RegionID = ctr.RegionID
				LEFT OUTER JOIN HairClubCMS.dbo.cfgConfigurationCenter ccc WITH ( NOLOCK )
					ON ccc.CenterID = ctr.CenterID
				OUTER APPLY ( SELECT TOP 1
										de.CenterID AS 'CenterSSID'
							  ,         de.FirstName + ' ' + de.LastName AS 'ManagingDirector'
							  ,         de.UserLogin + '@hcfm.com' AS 'ManagingDirectorEmail'
							  FROM      HairClubCMS.dbo.datEmployee de WITH ( NOLOCK )
										INNER JOIN HairClubCMS.dbo.cfgEmployeePositionJoin epj WITH ( NOLOCK )
											ON epj.EmployeeGUID = de.EmployeeGUID
										INNER JOIN HairClubCMS.dbo.lkpEmployeePosition lep WITH ( NOLOCK )
											ON lep.EmployeePositionID = epj.EmployeePositionID
							  WHERE     lep.EmployeePositionID = 6
										AND ISNULL(de.CenterID, 100) <> 100
										AND de.CenterID = CTR.CenterID
										AND de.FirstName NOT IN ( 'EC', 'Test' )
										AND de.IsActiveFlag = 1
							  ORDER BY  de.CenterID
							  ,         de.EmployeePayrollID DESC
							) o_MD
		WHERE   lr.RegionDescription = 'Barth'
				AND ctr.IsActiveFlag = 1


CREATE NONCLUSTERED INDEX IDX_Center_CenterID ON #Center ( CenterID );
CREATE NONCLUSTERED INDEX IDX_Center_CenterNumber ON #Center ( CenterNumber);


UPDATE STATISTICS #Center;


/********************************** Get Client Data *************************************/
INSERT	INTO #Client
		SELECT DISTINCT
				clt.ClientGUID
		FROM    HairClubCMS.dbo.datClient clt
				INNER JOIN #Center c
					ON c.CenterID = clt.CenterID


CREATE NONCLUSTERED INDEX IDX_Client_ClientGUID ON #Client ( ClientGUID );


UPDATE STATISTICS #Client;


/********************************** Get Client Credit Card Data *************************************/
INSERT	INTO #CreditCardOnFile
		SELECT  ROW_NUMBER() OVER ( PARTITION BY c.ClientGUID ORDER BY ccc.CreateDate DESC ) AS 'RowID'
		,		c.ClientGUID
		,		CASE WHEN ccc.ClientCreditCardID IS NOT NULL THEN 1 ELSE 0 END
		FROM    HairClubCMS.dbo.datClientCreditCard ccc
				INNER JOIN #Client c
					ON c.ClientGUID = ccc.ClientGUID


CREATE NONCLUSTERED INDEX IDX_CreditCardOnFile_ClientGUID ON #CreditCardOnFile ( ClientGUID );


UPDATE STATISTICS #CreditCardOnFile;


/********************************** Get Client Membership Data *************************************/
INSERT	INTO #ClientMembership
		SELECT	ROW_NUMBER() OVER ( PARTITION BY dcm.ClientGUID ORDER BY dcm.BeginDate DESC, dcm.EndDate DESC ) AS 'RowID'
		,		cm.ClientMembershipKey AS 'ClientMembershipKey'
		,		dcm.ClientMembershipGUID
		,		dcm.ClientMembershipIdentifier
		,		c.ClientGUID
		,		dm.MembershipKey AS 'MembershipKey'
		,		m.MembershipID AS 'MembershipSSID'
		,		m.MembershipDescription AS 'Membership'
		,		m.MembershipDescriptionShort
		,		bs.BusinessSegmentDescription AS 'BusinessSegment'
		,		rg.RevenueGroupDescription AS 'RevenueGroup'
		,		dcm.BeginDate AS 'MembershipBeginDate'
		,		dcm.EndDate AS 'MembershipEndDate'
		,		cms.ClientMembershipStatusDescription AS 'MembershipStatus'
		,		dcm.ContractPrice
		,		dcm.MonthlyFee
		FROM	HairClubCMS.dbo.datClientMembership dcm WITH (NOLOCK)
				INNER JOIN #Client c
					ON c.ClientGUID = dcm.ClientGUID
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
					ON cm.ClientMembershipSSID = dcm.ClientMembershipGUID
				INNER JOIN HairClubCMS.dbo.cfgMembership m WITH (NOLOCK)
					ON m.MembershipID = dcm.MembershipID
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership dm
					ON dm.MembershipSSID = m.MembershipID
				INNER JOIN HairClubCMS.dbo.lkpClientMembershipStatus cms WITH (NOLOCK)
					ON cms.ClientMembershipStatusID = dcm.ClientMembershipStatusID
				INNER JOIN HairClubCMS.dbo.lkpRevenueGroup rg WITH (NOLOCK)
					ON rg.RevenueGroupID = m.RevenueGroupID
				INNER JOIN HairClubCMS.dbo.lkpBusinessSegment bs WITH (NOLOCK)
					ON bs.BusinessSegmentID = m.BusinessSegmentID


CREATE NONCLUSTERED INDEX IDX_ClientMembership_RowID ON #ClientMembership ( RowID );
CREATE NONCLUSTERED INDEX IDX_ClientMembership_ClientGUID ON #ClientMembership ( ClientGUID );
CREATE NONCLUSTERED INDEX IDX_ClientMembership_ClientMembershipGUID ON #ClientMembership ( ClientMembershipGUID );


UPDATE STATISTICS #ClientMembership;


/********************************** Get Client Membership Accum Data *************************************/
INSERT	INTO #ClientMembershipAccum
		SELECT  cm.ClientMembershipGUID
		,		SUM(CASE WHEN cma.AccumulatorID IN ( 8 ) THEN cma.TotalAccumQuantity ELSE 0 END) AS 'SystemsAvailable'
		,       SUM(CASE WHEN cma.AccumulatorID IN ( 8 ) THEN cma.UsedAccumQuantity ELSE 0 END) AS 'SystemsUsed'
		,       SUM(CASE WHEN cma.AccumulatorID IN ( 9 ) THEN cma.TotalAccumQuantity ELSE 0 END) AS 'ServicesAvailable'
		,       SUM(CASE WHEN cma.AccumulatorID IN ( 9 ) THEN cma.UsedAccumQuantity ELSE 0 END) AS 'ServicesUsed'
		,       SUM(CASE WHEN cma.AccumulatorID IN ( 10 ) THEN cma.TotalAccumQuantity ELSE 0 END) AS 'SolutionsAvailable'
		,       SUM(CASE WHEN cma.AccumulatorID IN ( 10 ) THEN cma.UsedAccumQuantity ELSE 0 END) AS 'SolutionsUsed'
		,       SUM(CASE WHEN cma.AccumulatorID IN ( 11 ) THEN cma.TotalAccumQuantity ELSE 0 END) AS 'ProductKitsAvailable'
		,       SUM(CASE WHEN cma.AccumulatorID IN ( 11 ) THEN cma.UsedAccumQuantity ELSE 0 END) AS 'ProductKitsUsed'
		FROM    HairClubCMS.dbo.datClientMembershipAccum cma
				INNER JOIN #ClientMembership cm
					ON cm.ClientMembershipGUID = cma.ClientMembershipGUID
						AND cm.RowID = 1
		GROUP BY cm.ClientMembershipGUID


CREATE NONCLUSTERED INDEX IDX_ClientMembershipAccum_ClientMembershipGUID ON #ClientMembershipAccum ( ClientMembershipGUID );


UPDATE STATISTICS #ClientMembershipAccum;


/********************************** Get Client Phone Data *************************************/
INSERT	INTO #ClientPhone
		SELECT  dcp.ClientGUID
		,       dcp.PhoneNumber
		,       pt.PhoneTypeDescription AS 'PhoneType'
		,       dcp.CanConfirmAppointmentByCall
		,       dcp.CanConfirmAppointmentByText
		,       dcp.CanContactForPromotionsByCall
		,       dcp.CanContactForPromotionsByText
		,       dcp.ClientPhoneSortOrder
		FROM    HairClubCMS.dbo.datClientPhone dcp WITH ( NOLOCK )
				INNER JOIN #Client c
					ON c.ClientGUID = dcp.ClientGUID
				INNER JOIN HairClubCMS.dbo.lkpPhoneType pt WITH ( NOLOCK )
					ON pt.PhoneTypeID = dcp.PhoneTypeID
		GROUP BY dcp.ClientGUID
		,		dcp.PhoneNumber
		,		pt.PhoneTypeDescription
		,		dcp.CanConfirmAppointmentByCall
		,		dcp.CanConfirmAppointmentByText
		,		dcp.CanContactForPromotionsByCall
		,		dcp.CanContactForPromotionsByText
		,		dcp.ClientPhoneSortOrder


CREATE NONCLUSTERED INDEX IDX_ClientPhone_ClientGUID ON #ClientPhone ( ClientGUID );
CREATE NONCLUSTERED INDEX IDX_ClientPhone_ClientPhoneSortOrder ON #ClientPhone ( ClientPhoneSortOrder );


UPDATE STATISTICS #ClientPhone;


/********************************** Get Client Cancellation Data *************************************/
INSERT	INTO #Cancel
		SELECT  ROW_NUMBER() OVER ( PARTITION BY c.ClientGUID ORDER BY so.OrderDate DESC ) AS 'RowID'
		,		c.ClientGUID
		,		CAST(so.OrderDate AS DATE) AS 'CancelDate'
		,		ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(mor.MembershipOrderReasonDescription, CHAR(9), ''), CHAR(10), ''), CHAR(13), ''), '''', ''), '{', ''), '}', ''), ',', ''), '') AS 'CancelReason'
		FROM    HairClubCMS.dbo.datSalesOrderDetail sod
				INNER JOIN HairClubCMS.dbo.datSalesOrder so
					ON so.SalesOrderGUID = sod.SalesOrderGUID
				INNER JOIN HairClubCMS.dbo.cfgSalesCode sc
					ON sc.SalesCodeID = sod.SalesCodeID
				INNER JOIN #Client c
					ON c.ClientGUID = so.ClientGUID
				LEFT OUTER JOIN HairClubCMS.dbo.lkpMembershipOrderReason mor
					ON mor.MembershipOrderReasonID = sod.MembershipOrderReasonID
		WHERE   sc.SalesCodeDepartmentID = 1099
				AND so.IsVoidedFlag = 0


CREATE NONCLUSTERED INDEX IDX_Cancel_RowID ON #Cancel ( RowID );
CREATE NONCLUSTERED INDEX IDX_Cancel_ClientGUID ON #Cancel ( ClientGUID );


UPDATE STATISTICS #Cancel;

/****************************Return Lead Data (SQL06) ***************************************/

INSERT INTO #Lead
SELECT Id
	,[LastName]
	,[FirstName]
	,[Street]
	,[City]
	,[PostalCode]
	,[Phone]
	,[Email]
	,[ConvertedAccountId]
FROM SQL06.HC_BI_SFDC.dbo.Lead
WHERE IsDeleted = 0 AND [isValid] = 1

CREATE NONCLUSTERED INDEX IDX_leadId ON #Lead ( Id );
CREATE NONCLUSTERED INDEX IDX_ConvertdAccountId ON #Lead ([ConvertedAccountId] );

UPDATE STATISTICS #Lead;

/********************************** Return Client Data *************************************/
IF OBJECT_ID('tempdb..#Final') IS NOT NULL
   DROP TABLE #Final

SELECT ctr.RegionID AS 'RegionSSID'
,       ctr.RegionName AS 'RegionDescription'
,       ctr.CenterID AS 'CenterSSID'
,       ctr.CenterName AS 'CenterDescription'
,       ctr.CenterType
,       l.Id AS 'LeadID'--ISNULL(clt.ContactID, l.ContactID__c) AS 'LeadID'
,       dc.ClientKey
,       clt.ClientIdentifier
,       ISNULL(CONVERT(VARCHAR, clt.ClientNumber_Temp), '') AS 'CMSClientIdentifier'
,		REPLACE(coalesce(l.LastName,la.lastname,clt.LastName), ',', '') AS 'LastName'
,		REPLACE(coalesce(l.FirstName,la.FirstName,clt.FirstName), ',', '') AS 'FirstName'
,       ISNULL(REPLACE(REPLACE(REPLACE(coalesce(l.Street,la.Street,clt.Address1), CHAR(13),' '), CHAR(10),' '), ',', ' '), '') AS 'Address1'--
,       ISNULL(REPLACE(REPLACE(REPLACE(clt.Address2, CHAR(13),' '), CHAR(10),' '), ',', ' '), '') AS 'Address2'--
,       ISNULL(REPLACE(coalesce(l.City,la.City,clt.City), ',', ' '), '') AS 'CityCode'--
,       ISNULL(ls.StateDescriptionShort, '') AS 'StateCode'
,       ISNULL(coalesce(l.[PostalCode],la.PostalCode,clt.PostalCode), '') AS 'ZipCode'--
,       ISNULL(coalesce(l.Phone,la.Phone,clt.Phone1), '') AS 'HomePhoneNumber'--
,       ISNULL(cp2.PhoneNumber, '') AS 'WorkPhoneNumber'
,       ISNULL(coalesce(l.email,la.Email,clt.EmailAddress), '') AS 'EmailAddress'--
,		ISNULL(clt.IsAutoConfirmEmail, 0) AS 'IsAutoConfirmEmail'
,		ISNULL(ccf.HasCreditCardOnFile, 0) AS 'HasCreditCardOnFile'
,		ISNULL(ll.LanguageDescription, '') AS 'Language'
,       ISNULL(lg.GenderDescriptionShort, '') AS 'GenderSSID'
,		ISNULL(le.EthnicityDescription, '') AS 'Ethnicity'
,       ISNULL(CONVERT(VARCHAR(11), clt.DateOfBirth, 101), '') AS 'Birthday'
,       ISNULL(CONVERT(VARCHAR, cm.MembershipKey), '') AS 'MembershipKey'
,       ISNULL(CONVERT(VARCHAR, cm.MembershipSSID), '') AS 'MembershipSSID'
,       ISNULL(cm.Membership, '') AS 'Membership'
,       ISNULL(cm.MembershipDescriptionShort, '') AS 'MembershipDescriptionShort'
,       ISNULL(CONVERT(VARCHAR, cm.ClientMembershipKey), '') AS 'ClientMembershipKey'
,       ISNULL(cm.ClientMembershipIdentifier, '') AS 'ClientMembershipIdentifier'
,       ISNULL(CONVERT(VARCHAR(11), cm.BeginDate, 101), '') AS 'MembershipBeginDate'
,       ISNULL(CONVERT(VARCHAR(11), cm.EndDate, 101), '') AS 'MembershipEndDate'
,       ISNULL(cm.ContractPrice, 0) AS 'ContractPrice'
,       ISNULL(cm.MonthlyFee, 0) AS 'MonthlyFee'
,       ISNULL(cm.MembershipStatus, '') AS 'MembershipStatus'
,       ISNULL(CONVERT(VARCHAR(11), cnl.CancelDate, 101), '') AS 'CancelDate'
,		ISNULL(cnl.CancelReason, '') AS 'CancelReason'
,       ISNULL(clt.ARBalance, 0) AS 'ARBalance'
,		ISNULL(cma.SystemsAvailable, 0) AS 'SystemsAvailable'
,       ISNULL(cma.SystemsUsed, 0) AS 'SystemsUsed'
,       ISNULL(cma.ServicesAvailable, 0) AS 'ServicesAvailable'
,       ISNULL(cma.ServicesUsed, 0) AS 'ServicesUsed'
,       ISNULL(cma.SolutionsAvailable, 0) AS 'SolutionsAvailable'
,       ISNULL(cma.SolutionsUsed, 0) AS 'SolutionsUsed'
,       ISNULL(cma.ProductKitsAvailable, 0) AS 'ProductKitsAvailable'
,       ISNULL(cma.ProductKitsUsed, 0) AS 'ProductKitsUsed'
,		ISNULL(clt.SalesforceContactID, '') AS 'SFDC_LeadID'
FROM    #Client c
		INNER JOIN HairClubCMS.dbo.datClient clt
			ON clt.ClientGUID = c.ClientGUID
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient dc
			ON dc.ClientIdentifier = clt.ClientIdentifier and dc.clientIdentifier <> 110960
		INNER JOIN #Center ctr
			ON ctr.CenterID = clt.CenterID
		LEFT OUTER JOIN #Lead l
			ON l.Id = clt.SalesforceContactID
		LEFT OUTER JOIN #Lead la
			ON la.ConvertedAccountId = clt.SalesforceContactID
		LEFT OUTER JOIN HairClubCMS.dbo.lkpLanguage ll
			ON ll.LanguageID = clt.LanguageID
		LEFT OUTER JOIN HairClubCMS.dbo.lkpState ls
			ON ls.StateID = clt.StateID
        LEFT OUTER JOIN HairClubCMS.dbo.lkpGender lg
			ON lg.GenderID = clt.GenderID
		LEFT OUTER JOIN HairClubCMS.dbo.datClientDemographic dcd
			ON dcd.ClientGUID = clt.ClientGUID
		LEFT OUTER JOIN HairClubCMS.dbo.lkpEthnicity le
			ON le.EthnicityID = dcd.EthnicityID
		LEFT OUTER JOIN #CreditCardOnFile ccf
			ON ccf.ClientGUID = clt.ClientGUID
				AND ccf.RowID = 1
		LEFT OUTER JOIN #ClientMembership cm
			ON cm.ClientGUID = clt.ClientGUID
				AND cm.RowID = 1
		LEFT OUTER JOIN #ClientMembershipAccum cma
			ON cma.ClientMembershipGUID = cm.ClientMembershipGUID
		LEFT OUTER JOIN #ClientPhone cp1
			ON cp1.ClientGUID = clt.ClientGUID
				AND cp1.ClientPhoneSortOrder = 1
		LEFT OUTER JOIN #ClientPhone cp2
			ON cp2.ClientGUID = clt.ClientGUID
				AND cp2.ClientPhoneSortOrder = 2
		LEFT OUTER JOIN #Cancel cnl
			ON cnl.ClientGUID = c.ClientGUID
				AND cnl.RowID = 1

END


--SELECT * FROM HairClubCMS.dbo.datClient
--group by left(SalesforceContactID,4)
--order by CreateDate desc
GO
