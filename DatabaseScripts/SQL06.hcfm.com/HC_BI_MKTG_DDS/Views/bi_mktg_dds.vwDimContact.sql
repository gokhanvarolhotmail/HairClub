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
--			07/23/2020  KMurdoch	 Added Address Info from DimContact
--			09/15/2020  KMurdoch     Added full name + contact
--			12/01/2020  KMurdoch     Added LeadSource
--			12/16/2020  KMurdoch     Changed derivation of Lead Source aka Communication Method
--			12/30/2020  KMurdoch     Added Accommodation to View
--			02/01/2021  KMurdoch     Added Valid Lead Flag
-------------------------------------------------------------------------




CREATE view [bi_mktg_dds].[vwDimContact]
as
select DC.ContactKey,
       --,	DC.ContactSSID
       isnull(ltrim(rtrim(replace(replace(cast(ContactFullName as varchar(max)), '?', ''), '  ', ''))), '') as 'ContactFullName',
       isnull(ltrim(rtrim(replace(replace(cast(ContactFirstName as varchar(max)), '?', ''), '  ', ''))), '') as 'ContactFirstName',
       isnull(ltrim(rtrim(replace(replace(cast(ContactMiddleName as varchar(max)), '?', ''), '  ', ''))), '') as 'ContactMiddleName',
       isnull(ltrim(rtrim(replace(replace(cast(ContactLastName as varchar(max)), '?', ''), '  ', ''))), '') as 'ContactLastName',
       isnull(ltrim(rtrim(replace(replace(cast(ContactFullName as varchar(max)), '?', ''), '  ', ''))), '') + ' ('
       + DC.SFDC_LeadID + ')' as 'ContactFullNameandID',
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
       isnull(   (case
                      when DiscStyleSSID = 'd' then
                          'Dominant'
                      when DiscStyleSSID = 'i' then
                          'Influential'
                      when DiscStyleSSID = 's' then
                          'Steady'
                      when DiscStyleSSID = 'c' then
                          'Conscientious'
                      else
                          'Unknown'
                  end
                 ),
                 'Unknown'
             ) as DiscStyle,
       DNCFlag,
       DNCDate,
       ContactAffiliateID,
       ContactCenterSSID,
       ContactCenter,
       ContactAlternateCenter,
       case
           when FL.Shows >= 1 then
               1
           else
               0
       end as 'ShowFlag',
       case
           when FL.Sales >= 1 then
               1
           else
               0
       end as 'SaleFlag',
	   isnull(fl.Leads,0) as 'ValidLeadFlag',
       isnull(DCA.HouseholdMosaicGroup, 'Unknown') as 'LDHHMosaicGroup',
       isnull(DCA.HouseholdMosaicType, 'Unknown') as 'LDHHMosaicType',
       isnull(DCA.ZipCodeMosaicGroup, 'Unknown') as 'LDZipCodeMosaicGroup',
       isnull(DCA.ZipCodeMosaicType, 'Unknown') as 'LDZipCodeMosaicType',
       isnull(DCA.LeadScore, -1) as 'LDScore',
       case
           when isnull(DCA.CAPE_Income_HH_Median_Family, '') <> '' then
               cast(DCA.CAPE_Income_HH_Median_Family as decimal(10, 0))
           else
               0
       end as 'LDHHMedianIncome',
       case
           when DCA.CAPE_Income_HH_Median_Family is not null then
               1
           else
               0
       end as 'LDIncomeReptd',
       --,	UPPER(ISNULL(HairLossTreatment, 'Unknown')) AS 'HairLossTreatment'
       1 as 'HairLossTreatment',
       upper(isnull(HairLossSpot, 'Unknown')) as 'HairLossSpot',
       upper(isnull(HairLossExperience, 'Unknown')) as 'HairLossExperience',
       upper(isnull(HairLossinFamily, 'Unknown')) as 'HairLossinFamily',
       upper(isnull(HairLossFamily, 'Unknown')) as 'HairLossFamily',
       isnull(DC.[ContactFirstName], '') + ' ' + isnull(DC.[ContactLastName], '') + ' ('
       + convert([varchar](20), isnull(replace(ltrim(rtrim(DC.ContactSSID)), '', null), DC.SFDC_LeadID), (0)) + ')' as [ContactNameAndID],
       isnull(isnull(DC.StateCode, DCAD.StateCode), '') as 'State',
       isnull(isnull(DC.State, DCAD.StateName), '') as 'StateName',
       isnull(isnull(DC.City, DCAD.City), '') as 'City',
       isnull(DC.StateCode + '-' + DC.City, '') as 'StateCity',
       isnull(DC.CountryCode, DCAD.CountryCode) as 'CountryCode',
       case
           when isnull(DC.CountryCode, DCAD.CountryCode) = 'CA' then
               isnull(isnull(DC.PostalCode, DCAD.ZipCode), '')
           when DCAD.CountryCode = 'US' then
               left(isnull(isnull(DC.PostalCode, DCAD.ZipCode), ''), 5)
           else
               isnull(isnull(DC.PostalCode, DCAD.ZipCode), '')
       end as 'PostalCode',
       DC.SFDC_LeadID,
       DC.DMARegion,
       DC.DMADescription,
       isnull(DC.GCLID, 'Unknown') as 'GCLID',
       case
           when l.LeadSource is null
                and u.Username = 'bosleyintegration@hairclub.com' then
               'Other-Bos'
           when l.LeadSource is null
                and u.Username = 'conectintegration@hcfm.com' then
               'Other-HC'
           when l.LeadSource is null
                and u.Username = 'hanswiemannintegration@hcfm.com' then
               'Other-HW'
           when l.LeadSource is null
                and u.Username = 'sfintegration@hcfm.com' then
               'Other-Web'
           else
               isnull(l.LeadSource, 'Unknown')
       end as 'CommunicationMethod',
	   isnull(DC.Accomodation,'Unknown') as 'LeadAccommodation',
       DC.RowIsCurrent,
       DC.RowStartDate,
       DC.RowEndDate
from bi_mktg_dds.DimContact DC
    left outer join bi_mktg_dds.FactLead FL
        on FL.ContactKey = DC.ContactKey
    left outer join bi_mktg_dds.DimContactAppend DCA
        on DCA.ContactKey = DC.ContactKey
    left outer join HC_BI_SFDC.dbo.Lead l
        on DC.SFDC_LeadID = l.Id
    left outer join HC_BI_SFDC.dbo.[User] u
        on u.Id = l.CreatedById
    --LEFT OUTER JOIN bi_mktg_dds.DimContactAddress DCAD
    --		ON DCAD.ContactSSID = DC.ContactSSID
    --		AND DCAD.PrimaryFlag = 'Y'
    outer apply
(
    select top 1
           *
    from bi_mktg_dds.DimContactAddress DCA
    where DCA.SFDC_LeadID = DC.SFDC_LeadID
          and DCA.PrimaryFlag = 'Y'
    order by DCA.ContactAddressKey desc
) DCAD;
