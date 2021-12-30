/* CreateDate: 07/23/2020 06:10:10.357 , ModifyDate: 07/23/2020 06:10:10.357 */
GO
-------------------------------------------------------------------------
-- [vwDimContact] is used to retrieve a
-- list of Contacts
--
--   SELECT * FROM [bi_mktg_dds].[vwDimContact]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    10/12/2009  RLifke       Initial Creation
--			08/07/2019  KMurdoch     Removed ContactSSID
--			07/14/2020  KMurdoch     Added DMA Region & Description
-------------------------------------------------------------------------




CREATE VIEW [bi_mktg_dds].[vwDimContactJoinToLead]
AS
SELECT DC.ContactKey,
       --,	DC.ContactSSID
       ISNULL(LTRIM(RTRIM(REPLACE(REPLACE(CAST(ContactFullName AS VARCHAR(MAX)), '?', ''), '  ', ''))), '') AS 'ContactFullName',
       ISNULL(LTRIM(RTRIM(REPLACE(REPLACE(CAST(ContactFirstName AS VARCHAR(MAX)), '?', ''), '  ', ''))), '') AS 'ContactFirstName',
       ISNULL(LTRIM(RTRIM(REPLACE(REPLACE(CAST(ContactMiddleName AS VARCHAR(MAX)), '?', ''), '  ', ''))), '') AS 'ContactMiddleName',
       ISNULL(LTRIM(RTRIM(REPLACE(REPLACE(CAST(ContactLastName AS VARCHAR(MAX)), '?', ''), '  ', ''))), '') AS 'ContactLastName',
       ContactSuffix,
       Salutation,
       ContactStatusSSID,
       ContactStatusDescription,
       ContactMethodSSID,
       ContactMethodDescription,
       DoNotSolicitFlag,
       DC.DoNotCallFlag,
       DoNotEmailFlag,
       DoNotMailFlag,
       DoNotTextFlag,
       ContactGender,
       ContactCallTime,
       CompleteSale,
       ContactResearch,
       ReferringStore,
       ReferringStylist,
       ContactLanguageSSID,
       ContactLanguageDescription,
       ContactPromotonSSID,
       ContactPromotionDescription,
       ContactRequestSSID,
       ContactRequestDescription,
       ContactAgeRangeSSID,
       ContactAgeRangeDescription,
       ContactHairLossSSID,
       ContactHairLossDescription,
       ISNULL(   (CASE
                      WHEN DiscStyleSSID = 'd' THEN
                          'Dominant'
                      WHEN DiscStyleSSID = 'i' THEN
                          'Influential'
                      WHEN DiscStyleSSID = 's' THEN
                          'Steady'
                      WHEN DiscStyleSSID = 'c' THEN
                          'Conscientious'
                      ELSE
                          'Unknown'
                  END
                 ),
                 'Unknown'
             ) AS DiscStyle,
       DNCFlag,
       DNCDate,
       ContactAffiliateID,
       ContactCenterSSID,
       ContactCenter,
       ContactAlternateCenter,
       CASE
           WHEN FL.Shows >= 1 THEN
               1
           ELSE
               0
       END AS 'ShowFlag',
       CASE
           WHEN FL.Sales >= 1 THEN
               1
           ELSE
               0
       END AS 'SaleFlag',
       ISNULL(DCA.HouseholdMosaicGroup, 'Unknown') AS 'LDHHMosaicGroup',
       ISNULL(DCA.HouseholdMosaicType, 'Unknown') AS 'LDHHMosaicType',
       ISNULL(DCA.ZipCodeMosaicGroup, 'Unknown') AS 'LDZipCodeMosaicGroup',
       ISNULL(DCA.ZipCodeMosaicType, 'Unknown') AS 'LDZipCodeMosaicType',
       ISNULL(DCA.LeadScore, -1) AS 'LDScore',
       CASE
           WHEN ISNULL(DCA.CAPE_Income_HH_Median_Family, '') <> '' THEN
               CAST(DCA.CAPE_Income_HH_Median_Family AS DECIMAL(10, 0))
           ELSE
               0
       END AS 'LDHHMedianIncome',
       CASE
           WHEN DCA.CAPE_Income_HH_Median_Family IS NOT NULL THEN
               1
           ELSE
               0
       END AS 'LDIncomeReptd',
       --,	UPPER(ISNULL(HairLossTreatment, 'Unknown')) AS 'HairLossTreatment'
       1 AS 'HairLossTreatment',
       UPPER(ISNULL(HairLossSpot, 'Unknown')) AS 'HairLossSpot',
       UPPER(ISNULL(HairLossExperience, 'Unknown')) AS 'HairLossExperience',
       UPPER(ISNULL(HairLossinFamily, 'Unknown')) AS 'HairLossinFamily',
       UPPER(ISNULL(HairLossFamily, 'Unknown')) AS 'HairLossFamily',
       ISNULL(DC.[ContactLastName], '') + ', ' + ISNULL(DC.[ContactFirstName], '') + ' ('
       + CONVERT([VARCHAR](20), DC.[ContactSSID], (0)) + ')' AS [ContactNameAndID],
       ISNULL(ISNULL(DCAD.StateCode, l.StateCode),'') AS 'State',
       ISNULL(ISNULL(DCAD.StateName,l.[State]), '') AS 'StateName',
       ISNULL(ISNULL(DCAD.City, l.City),'') AS 'City',
       ISNULL(ISNULL(DCAD.StateCode + '-' + DCAD.City,l.StateCode + '-' + l.City), '') AS 'StateCity',
       CASE
           WHEN DCAD.CountryCode = 'CA' THEN
               ISNULL(ISNULL(DCAD.ZipCode,l.PostalCode), '')
           WHEN DCAD.CountryCode = 'US' THEN
               LEFT(ISNULL(ISNULL(DCAD.ZipCode,l.PostalCode), ''), 5)
           ELSE
               ISNULL(ISNULL(DCAD.ZipCode,l.PostalCode), '')
       END AS 'PostalCode',
       DC.SFDC_LeadID,
       DC.DMARegion,
       DC.DMADescription,
       DC.RowIsCurrent,
       DC.RowStartDate,
       DC.RowEndDate
FROM bi_mktg_dds.DimContact DC
    LEFT OUTER JOIN bi_mktg_dds.FactLead FL
        ON FL.ContactKey = DC.ContactKey
    LEFT OUTER JOIN bi_mktg_dds.DimContactAppend DCA
        ON DCA.ContactKey = DC.ContactKey
    LEFT OUTER JOIN HC_BI_SFDC.dbo.Lead l
        ON DC.SFDC_LeadID = l.Id
    --LEFT OUTER JOIN bi_mktg_dds.DimContactAddress DCAD
    --		ON DCAD.ContactSSID = DC.ContactSSID
    --		AND DCAD.PrimaryFlag = 'Y'
    OUTER APPLY
(
    SELECT TOP 1
           *
    FROM bi_mktg_dds.DimContactAddress DCA
    WHERE DCA.SFDC_LeadID = DC.SFDC_LeadID
          AND DCA.PrimaryFlag = 'Y'
) DCAD;
GO
