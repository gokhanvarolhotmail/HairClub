/* CreateDate: 10/25/2017 18:03:41.273 , ModifyDate: 10/26/2017 09:54:37.690 */
GO
/*
==============================================================================
PROCEDURE:				oncd_contact_salesforce_leads

AUTHOR: 				Daniel Polania

IMPLEMENTOR: 			Daniel Polania

DATE IMPLEMENTED: 		08/24/2017


==============================================================================
DESCRIPTION:	Gathers all the data for the Salesforce account object for clients
==============================================================================
NOTES:
		* 09/25/2017 DP - Created proc

==============================================================================
SAMPLE EXECUTION:
EXEC dbo.oncd_contact_salesforce_leads
==============================================================================
*/
CREATE PROCEDURE [dbo].[oncd_contact_salesforce_clients]
AS
BEGIN

    SET NOCOUNT ON;

    -- Clear temp tables.
    IF OBJECT_ID('tempdb..#ClientMemberships') IS NOT NULL
        DROP TABLE #ClientMemberships;
    IF OBJECT_ID('tempdb..#UTCDates') IS NOT NULL
        DROP TABLE #UTCDates;
    IF OBJECT_ID('tempdb..#ClientTransactions') IS NOT NULL
        DROP TABLE #ClientTransactions;
    IF OBJECT_ID('tempdb..#Clients') IS NOT NULL
        DROP TABLE #Clients;


    -- Set date range.
    DECLARE @StartDate DATETIME;
    DECLARE @EndDate DATETIME;


    SET @StartDate = '9/1/2015';
    SET @EndDate = GETDATE();


    -- Create temp tables.
    CREATE TABLE #Clients
    (
        ClientIdentifier INT
    );


    -- Clients with a Membership within the specified time period.
    SELECT DISTINCT
        clt.ClientIdentifier
    INTO #ClientMemberships
    FROM HairClubCMS.dbo.datClientMembership dcm
        INNER JOIN HairClubCMS.dbo.cfgMembership m
            ON m.MembershipID = dcm.MembershipID
        INNER JOIN HairClubCMS.dbo.lkpClientMembershipStatus cms
            ON cms.ClientMembershipStatusID = dcm.ClientMembershipStatusID
        INNER JOIN HairClubCMS.dbo.datClient clt
            ON clt.ClientGUID = dcm.ClientGUID
    WHERE dcm.EndDate
          BETWEEN @StartDate AND @EndDate
          AND m.MembershipDescription NOT IN ( 'New Client (ShowNoSale)', 'New Client (Surgery Offered)' )
          AND cms.ClientMembershipStatusDescription NOT IN ( 'Canceled', 'Expired', 'Inactive' );



    -- Convert @StartDate and @EndDate to UTC Date Format.
    SELECT tz.TimeZoneID,
           tz.UTCOffset,
           tz.UsesDayLightSavingsFlag,
           tz.IsActiveFlag,
           HairClubCMS.dbo.GetUTCFromLocal(@StartDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) AS 'UTCStartDate',
           HairClubCMS.dbo.GetUTCFromLocal(DATEADD(SECOND, 86399, @EndDate), tz.UTCOffset, tz.UsesDayLightSavingsFlag) AS 'UTCEndDate'
    INTO #UTCDates
    FROM HairClubCMS.dbo.lkpTimeZone tz
    WHERE tz.IsActiveFlag = 1;


    -- Clients with Transactions within the specified time period.
    SELECT DISTINCT
        cl.ClientIdentifier
    INTO #ClientTransactions
    FROM HairClubCMS.dbo.datSalesOrderDetail sod
        INNER JOIN HairClubCMS.dbo.datSalesOrder so
            ON so.SalesOrderGUID = sod.SalesOrderGUID
        INNER JOIN HairClubCMS.dbo.cfgCenter ctr
            ON ctr.CenterID = so.CenterID
        INNER JOIN HairClubCMS.dbo.lkpTimeZone tz
            ON tz.TimeZoneID = ctr.TimeZoneID
        JOIN #UTCDates u
            ON u.TimeZoneID = tz.TimeZoneID
        INNER JOIN HairClubCMS.dbo.datClient cl
            ON cl.ClientGUID = so.ClientGUID
        INNER JOIN HairClubCMS.dbo.datClientMembership cm
            ON cm.ClientMembershipGUID = so.ClientMembershipGUID
        INNER JOIN HairClubCMS.dbo.cfgMembership m
            ON m.MembershipID = cm.MembershipID
    WHERE so.OrderDate
          BETWEEN u.UTCStartDate AND u.UTCEndDate
          AND m.MembershipDescription NOT IN ( 'New Client (ShowNoSale)', 'New Client (Surgery Offered)' )
          AND so.IsVoidedFlag = 0;



    -- Get final list of Clients.
    INSERT INTO #Clients
    SELECT cm.ClientIdentifier
    FROM #ClientMemberships cm
    UNION
    SELECT ct.ClientIdentifier
    FROM #ClientTransactions ct;


    -- Display final list of Clients.
    WITH x_Phone
    AS (SELECT ROW_NUMBER() OVER (PARTITION BY dcp.ClientGUID ORDER BY dcp.ClientPhoneSortOrder ASC) AS 'RowID',
               dcp.ClientGUID,
               dcp.PhoneNumber,
               pt.PhoneTypeDescription AS 'PhoneType',
               dcp.CanConfirmAppointmentByCall,
               dcp.CanConfirmAppointmentByText,
               dcp.CanContactForPromotionsByCall,
               dcp.CanContactForPromotionsByText
        FROM HairClubCMS.dbo.datClientPhone dcp WITH (NOLOCK)
            INNER JOIN HairClubCMS.dbo.lkpPhoneType pt WITH (NOLOCK)
                ON pt.PhoneTypeID = dcp.PhoneTypeID),
         center
    AS (SELECT CC.CenterID,
               OC.cst_center_number,
               OC.company_id,
               CC.CenterDescription,
               CC.TimeZoneID,
               OC.cst_director_name,
               OC.cst_center_manager_name
        FROM HairClubCMS.dbo.cfgCenter AS CC
            LEFT JOIN HCM.dbo.oncd_company AS OC
                ON CC.CenterID = OC.cst_center_number)
    SELECT '012f40000008zTbAAI' AS RecordTypeID,
           ISNULL(ctr.company_id, clt.CenterID) company_id,
           clt.ClientIdentifier,
           ISNULL(clt.ContactID, '') AS 'ContactID',
           ISNULL(clt.ContactID, '') AS contact_id_lead,
           clt.FirstName,
           clt.LastName,
           ISNULL(LTRIM(RTRIM(REPLACE(clt.Address1, ',', ''))), '') + ' '
           + ISNULL(LTRIM(RTRIM(REPLACE(clt.Address2, ',', ''))), '') AS 'Address',
           ISNULL(LTRIM(RTRIM(REPLACE(clt.City, ',', ''))), '') AS 'City',
           ISNULL(ls.StateDescriptionShort, '') AS 'State',
           ISNULL(REPLACE(clt.PostalCode, '-', ''), '') AS 'ZipCode',
           lc.CountryDescriptionShort AS 'Country',
           tz.TimeZoneDescriptionShort AS 'Timezone',
           ISNULL(p1.PhoneNumber, '') AS 'Phone',
           ISNULL(p2.PhoneNumber, '') AS 'Secondary',
           ISNULL(p3.PhoneNumber, '') AS 'Alternative',
           ISNULL(p1.CanConfirmAppointmentByText, 0) AS 'CanConfirmAppointmentByPhone1Text',
           ISNULL(p1.CanContactForPromotionsByText, 0) AS 'CanContactForPromotionsByPhone1Text',
           CASE
               WHEN ISNULL(p1.CanConfirmAppointmentByText, 0) = 1 THEN
                   p1.PhoneNumber
               ELSE
                   CASE
                       WHEN ISNULL(p2.CanConfirmAppointmentByText, 0) = 1 THEN
                           p2.PhoneNumber
                       ELSE
                           CASE
                               WHEN ISNULL(p3.CanConfirmAppointmentByText, 0) = 1 THEN
                                   p3.PhoneNumber
                               ELSE
                                   ''
                           END
                   END
           END AS 'SMSPhoneNumber',
           clt.DoNotCallFlag,
           clt.DoNotContactFlag,
           CASE
               WHEN clt.DateOfBirth IS NULL THEN
                   ''
               ELSE
                   CONVERT(VARCHAR(11), clt.DateOfBirth, 101)
           END AS 'DateOfBirth',
           ISNULL(clt.AgeCalc, '') AS 'ClientAge',
           ISNULL(REPLACE(clt.EMailAddress, ',', '.'), '') AS 'EmailAddress',
           CASE ISNULL(clt.GenderID, 1)
               WHEN 1 THEN
                   'Male'
               WHEN 2 THEN
                   'Female'
           END AS 'Gender',
           CAST(YEAR(clt.CreateDate) AS NVARCHAR(4)) + '-' + CAST(MONTH(clt.CreateDate) AS NVARCHAR(2)) + '-'
           + CAST(DAY(clt.CreateDate) AS NVARCHAR(2)) + 'T' + CAST(DATEPART(HOUR, clt.CreateDate) AS NVARCHAR(2)) + ':'
           + CAST(DATEPART(MINUTE, clt.CreateDate) AS NVARCHAR(2)) + ':'
           + CAST(DATEPART(SECOND, clt.CreateDate) AS NVARCHAR(2)) AS Creation_date,
           CAST(YEAR(clt.LastUpdate) AS NVARCHAR(4)) + '-' + CAST(MONTH(clt.LastUpdate) AS NVARCHAR(2)) + '-'
           + CAST(DAY(clt.LastUpdate) AS NVARCHAR(2)) + 'T' + CAST(DATEPART(HOUR, clt.LastUpdate) AS NVARCHAR(2)) + ':'
           + CAST(DATEPART(MINUTE, clt.LastUpdate) AS NVARCHAR(2)) + ':'
           + CAST(DATEPART(SECOND, clt.LastUpdate) AS NVARCHAR(2)) AS LastUpdate,
           ISNULL(cst_director_name, '') AS cst_director_name,
           ISNULL(cst_center_manager_name, '') AS cst_center_manager_name,
           clt.LastUpdate AS lastUpdateDateTime,
           clt.CreateDate,
           ISNULL(cm_xtrp.MembershipDescription, '') AS 'XTRP_Membership',
           ISNULL(cm_ext.MembershipDescription, '') AS 'EXT_Membership',
           ISNULL(cm_xtr.MembershipDescription, '') AS 'XTR_Membership',
           ISNULL(cm_sur.MembershipDescription, '') AS 'SUR_Membership',
           ll.LanguageDescription,
           ISNULL(LDS.DISCStyleDescription, '') AS DISCStyleDescription,
           ISNULL(le.EthnicityDescription, '') AS EthnicityDescription,
           ISNULL(LLS.LudwigScaleDescription, '') AS LudwigScaleDescription,
           ISNULL(ms.MaritalStatusDescription, '') AS MaritalStatusDescription,
           ISNULL(LNS.NorwoodScaleDescription, '') AS NorwoodScaleDescription,
           ISNULL(lo.OccupationDescription, '') AS OccupationDescription,
           ISNULL(LBS.BusinessSegmentDescription, '') AS BusinessSegmentDescription,
           ISNULL(clt.SiebelID, '') AS SiebelID
    INTO #sf_clients
    FROM HairClubCMS.dbo.datClient clt WITH (NOLOCK)
        INNER JOIN #Clients c
            ON c.ClientIdentifier = clt.ClientIdentifier
        INNER JOIN center ctr WITH (NOLOCK)
            ON ctr.CenterID = clt.CenterID
        LEFT OUTER JOIN HairClubCMS.dbo.lkpTimeZone tz WITH (NOLOCK)
            ON tz.TimeZoneID = ctr.TimeZoneID
        LEFT OUTER JOIN HairClubCMS.dbo.lkpState ls WITH (NOLOCK)
            ON ls.StateID = clt.StateID
        LEFT OUTER JOIN HairClubCMS.dbo.lkpCountry lc WITH (NOLOCK)
            ON lc.CountryID = clt.CountryID
        LEFT OUTER JOIN HairClubCMS.dbo.lkpLanguage ll WITH (NOLOCK)
            ON ll.LanguageID = clt.LanguageID
        LEFT OUTER JOIN HairClubCMS.dbo.datClientDemographic dcd WITH (NOLOCK)
            ON dcd.ClientIdentifier = clt.ClientIdentifier
        LEFT OUTER JOIN HairClubCMS.dbo.lkpEthnicity le WITH (NOLOCK)
            ON le.EthnicityID = dcd.EthnicityID
        LEFT OUTER JOIN HairClubCMS.dbo.lkpOccupation lo WITH (NOLOCK)
            ON lo.OccupationID = dcd.OccupationID
        LEFT OUTER JOIN HairClubCMS.dbo.lkpMaritalStatus ms WITH (NOLOCK)
            ON ms.MaritalStatusID = dcd.MaritalStatusID
        LEFT OUTER JOIN HairClubCMS.dbo.lkpDISCStyle AS LDS WITH (NOLOCK)
            ON LDS.DISCStyleID = dcd.DISCStyleID
        LEFT OUTER JOIN HairClubCMS.dbo.lkpLudwigScale AS LLS WITH (NOLOCK)
            ON LLS.LudwigScaleID = dcd.LudwigScaleID
        LEFT OUTER JOIN HairClubCMS.dbo.lkpNorwoodScale AS LNS WITH (NOLOCK)
            ON LNS.NorwoodScaleID = dcd.NorwoodScaleID
        LEFT OUTER JOIN HairClubCMS.dbo.lkpBusinessSegment AS LBS WITH (NOLOCK)
            ON LBS.BusinessSegmentID = dcd.SolutionOfferedID
        LEFT OUTER JOIN HairClubCMS.dbo.datClientMembership dcm_xtrp WITH (NOLOCK)
            ON dcm_xtrp.ClientMembershipGUID = clt.CurrentBioMatrixClientMembershipGUID
        LEFT OUTER JOIN HairClubCMS.dbo.cfgMembership cm_xtrp WITH (NOLOCK)
            ON cm_xtrp.MembershipID = dcm_xtrp.MembershipID
        LEFT OUTER JOIN HairClubCMS.dbo.lkpRevenueGroup rg_xtrp WITH (NOLOCK)
            ON rg_xtrp.RevenueGroupID = cm_xtrp.RevenueGroupID
        LEFT OUTER JOIN HairClubCMS.dbo.lkpBusinessSegment bs_xtrp WITH (NOLOCK)
            ON bs_xtrp.BusinessSegmentID = cm_xtrp.BusinessSegmentID
        LEFT OUTER JOIN HairClubCMS.dbo.lkpClientMembershipStatus cms_xtrp WITH (NOLOCK)
            ON cms_xtrp.ClientMembershipStatusID = dcm_xtrp.ClientMembershipStatusID
        LEFT OUTER JOIN HairClubCMS.dbo.datClientEFT dce_xtrp WITH (NOLOCK)
            ON dce_xtrp.ClientMembershipGUID = dcm_xtrp.ClientMembershipGUID
        LEFT OUTER JOIN HairClubCMS.dbo.lkpEFTAccountType eat_xtrp WITH (NOLOCK)
            ON eat_xtrp.EFTAccountTypeID = dce_xtrp.EFTAccountTypeID
        LEFT OUTER JOIN HairClubCMS.dbo.datClientMembership dcm_ext WITH (NOLOCK)
            ON dcm_ext.ClientMembershipGUID = clt.CurrentExtremeTherapyClientMembershipGUID
        LEFT OUTER JOIN HairClubCMS.dbo.cfgMembership cm_ext WITH (NOLOCK)
            ON cm_ext.MembershipID = dcm_ext.MembershipID
        LEFT OUTER JOIN HairClubCMS.dbo.lkpRevenueGroup rg_ext WITH (NOLOCK)
            ON rg_ext.RevenueGroupID = cm_ext.RevenueGroupID
        LEFT OUTER JOIN HairClubCMS.dbo.lkpBusinessSegment bs_ext WITH (NOLOCK)
            ON bs_ext.BusinessSegmentID = cm_ext.BusinessSegmentID
        LEFT OUTER JOIN HairClubCMS.dbo.lkpClientMembershipStatus cms_ext WITH (NOLOCK)
            ON cms_ext.ClientMembershipStatusID = dcm_ext.ClientMembershipStatusID
        LEFT OUTER JOIN HairClubCMS.dbo.datClientEFT dce_ext WITH (NOLOCK)
            ON dce_ext.ClientMembershipGUID = dcm_ext.ClientMembershipGUID
        LEFT OUTER JOIN HairClubCMS.dbo.lkpEFTAccountType eat_ext WITH (NOLOCK)
            ON eat_ext.EFTAccountTypeID = dce_ext.EFTAccountTypeID
        LEFT OUTER JOIN HairClubCMS.dbo.datClientMembership dcm_xtr WITH (NOLOCK)
            ON dcm_xtr.ClientMembershipGUID = clt.CurrentXtrandsClientMembershipGUID
        LEFT OUTER JOIN HairClubCMS.dbo.cfgMembership cm_xtr WITH (NOLOCK)
            ON cm_xtr.MembershipID = dcm_xtr.MembershipID
        LEFT OUTER JOIN HairClubCMS.dbo.lkpRevenueGroup rg_xtr WITH (NOLOCK)
            ON rg_xtr.RevenueGroupID = cm_xtr.RevenueGroupID
        LEFT OUTER JOIN HairClubCMS.dbo.lkpBusinessSegment bs_xtr WITH (NOLOCK)
            ON bs_xtr.BusinessSegmentID = cm_xtr.BusinessSegmentID
        LEFT OUTER JOIN HairClubCMS.dbo.lkpClientMembershipStatus cms_xtr WITH (NOLOCK)
            ON cms_xtr.ClientMembershipStatusID = dcm_xtr.ClientMembershipStatusID
        LEFT OUTER JOIN HairClubCMS.dbo.datClientEFT dce_xtr WITH (NOLOCK)
            ON dce_xtr.ClientMembershipGUID = dcm_xtr.ClientMembershipGUID
        LEFT OUTER JOIN HairClubCMS.dbo.lkpEFTAccountType eat_xtr WITH (NOLOCK)
            ON eat_xtr.EFTAccountTypeID = dce_xtr.EFTAccountTypeID
        LEFT OUTER JOIN HairClubCMS.dbo.datClientMembership dcm_sur WITH (NOLOCK)
            ON dcm_sur.ClientMembershipGUID = clt.CurrentSurgeryClientMembershipGUID
        LEFT OUTER JOIN HairClubCMS.dbo.cfgMembership cm_sur WITH (NOLOCK)
            ON cm_sur.MembershipID = dcm_sur.MembershipID
        LEFT OUTER JOIN HairClubCMS.dbo.lkpRevenueGroup rg_sur WITH (NOLOCK)
            ON rg_sur.RevenueGroupID = cm_sur.RevenueGroupID
        LEFT OUTER JOIN HairClubCMS.dbo.lkpBusinessSegment bs_sur WITH (NOLOCK)
            ON bs_sur.BusinessSegmentID = cm_sur.BusinessSegmentID
        LEFT OUTER JOIN HairClubCMS.dbo.lkpClientMembershipStatus cms_sur WITH (NOLOCK)
            ON cms_sur.ClientMembershipStatusID = dcm_sur.ClientMembershipStatusID
        LEFT OUTER JOIN HC_DataAppend.dbo.Client_Append ca WITH (NOLOCK)
            ON ca.ClientIdentifier = clt.ClientIdentifier
        LEFT OUTER JOIN HC_DataAppend.dbo.lkpMosaicType mt_h WITH (NOLOCK)
            ON mt_h.MosaicTypeID = ca.[MOSAIC HOUSEHOLD]
        LEFT OUTER JOIN HC_DataAppend.dbo.lkpMosaicGroup mg_h WITH (NOLOCK)
            ON mg_h.MosaicGroupID = mt_h.MosaicGroupID
        LEFT OUTER JOIN HC_DataAppend.dbo.lkpMosaicType mt_z WITH (NOLOCK)
            ON mt_z.MosaicTypeID = ca.[MOSAIC ZIP4]
        LEFT OUTER JOIN HC_DataAppend.dbo.lkpMosaicGroup mg_z WITH (NOLOCK)
            ON mg_z.MosaicGroupID = mt_z.MosaicGroupID
        LEFT JOIN x_Phone p1
            ON p1.ClientGUID = clt.ClientGUID
               AND p1.RowID = 1
        LEFT JOIN x_Phone p2
            ON p2.ClientGUID = clt.ClientGUID
               AND p2.RowID = 2
        LEFT JOIN x_Phone p3
            ON p3.ClientGUID = clt.ClientGUID
               AND p3.RowID = 3;

    SELECT C.RecordTypeID,
           C.company_id,
           C.ClientIdentifier,
           contact_id_lead,
           LEFT(C.FirstName, 40) AS FirstName,
           CASE
               WHEN C.LastName = '' THEN
                   'N/A'
               ELSE
                   LEFT(C.LastName, 40)
           END AS LastName,
           C.Address,
           C.City,
           C.State,
           C.ZipCode,
           CASE
               WHEN C.State IN ( 'BC', 'ON', 'QC', 'SK' )
                    AND C.country = 'US' THEN
                   'CA'
               ELSE
                   C.country
           END AS country,
           CASE
               WHEN C.Phone != '' THEN
                   '(' + LEFT(C.Phone, 3) + ') ' + SUBSTRING(C.Phone, 4, 3) + '-' + SUBSTRING(C.Phone, 7, 4)
               ELSE
                   ''
           END AS Phone,
           CASE
               WHEN C.Secondary != '' THEN
                   '(' + LEFT(C.Secondary, 3) + ') ' + SUBSTRING(C.Secondary, 4, 3) + '-'
                   + SUBSTRING(C.Secondary, 7, 4)
               ELSE
                   ''
           END AS Secondary,
           CASE
               WHEN C.Alternative != '' THEN
                   '(' + LEFT(C.Alternative, 3) + ') ' + SUBSTRING(C.Alternative, 4, 3) + '-'
                   + SUBSTRING(C.Alternative, 7, 4)
               ELSE
                   ''
           END AS Alternative,
           C.SMSPhoneNumber,
           ISNULL(C.DoNotCallFlag, 0) AS DoNotCallFlag,
           C.DoNotContactFlag,
           C.DateOfBirth,
           C.ClientAge,
           CASE
               WHEN C.EmailAddress NOT LIKE '%_@__%.__%' THEN
                   ''
               ELSE
                   C.EmailAddress
           END AS EmailAddress,
           C.Gender,
           CASE
               WHEN C.Creation_date = '1900-1-1T0:0:0Z' THEN
                   C.LastUpdate
               ELSE
                   C.Creation_date
           END AS Creation_date,
           CASE
               WHEN C.lastUpdateDateTime !> C.CreateDate THEN
                   C.Creation_date
               ELSE
                   C.LastUpdate
           END AS LastUpdate,
           ISNULL(OC.cst_promotion_code, '') AS cst_promotion_code,
           ISNULL(CAST(OS.source_code AS VARCHAR(26)), 'Client Source Code Unknown') AS source_code,
           OZ.zip_id,
           C.cst_director_name,
           C.cst_center_manager_name,
           C.Creation_date AS ConCreation_date,
           C.LastUpdate AS ConLastUpdate,
           lastUpdateDateTime,
           ISNULL(LanguageDescription, 'English') AS Language,
           C.DISCStyleDescription AS DISC,
           C.EthnicityDescription AS Ethinicity,
           C.LudwigScaleDescription AS Ludwig_Scale,
           C.MaritalStatusDescription AS Marital_Status,
           C.NorwoodScaleDescription AS Norwood_Scale,
           C.OccupationDescription AS Occupation,
           C.BusinessSegmentDescription AS Solution_Offered,
           C.SiebelID,
           CASE
               WHEN LEN(OC.created_by_user_code) = 3 THEN
                   'Center'
               WHEN OC.created_by_user_code = 'TM 600' THEN
                   'Web Form'
               WHEN OC.created_by_user_code LIKE 'TM8%' THEN
                   'Web Chat'
               WHEN OC.created_by_user_code LIKE 'TM4%' THEN
                   'Web Chat'
               ELSE
                   'Phone'
           END AS PersonLeadSource
    FROM #sf_clients AS C
        LEFT JOIN HCM.dbo.oncd_contact AS OC
            ON C.ContactID = OC.contact_id
        LEFT JOIN HCM.dbo.oncd_contact_source AS OCS
            ON OCS.contact_id = OC.contact_id
               AND OCS.primary_flag = 'Y'
        LEFT JOIN HCM.dbo.onca_source AS OS
            ON OS.source_code = OCS.source_code
        LEFT JOIN HCM.dbo.onca_zip AS OZ
            ON OZ.zip_code = C.ZipCode
               AND OZ.city = C.City
    ORDER BY zip_id,
             C.company_id;

    DROP TABLE #ClientMemberships,
               #Clients,
               #ClientTransactions,
               #sf_clients,
               #UTCDates;
END;
GO
