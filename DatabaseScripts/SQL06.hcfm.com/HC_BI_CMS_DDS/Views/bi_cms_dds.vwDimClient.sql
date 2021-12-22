CREATE VIEW [bi_cms_dds].[vwDimClient] AS
-------------------------------------------------------------------------
-- [vwDimClient] is used to retrieve a
-- list of Clients
--
--   SELECT * FROM [bi_cms_dds].[vwDimClient]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/15/2009  RLifke       Initial Creation
-------------------------------------------------------------------------

SELECT  DC.[ClientKey]
,       DC.[ClientSSID]
,       DC.[ClientNumber_Temp]
,       DC.[ClientIdentifier]
,       DC.[CenterSSID]
,       DC.[ClientFirstName]
,       DC.[ClientMiddleName]
,       DC.[ClientLastName]
,       DC.[SalutationSSID]
,       DC.[ClientSalutationDescription]
,       DC.[ClientSalutationDescriptionShort]
,       DC.[ClientFullName]
,		((((ISNULL(DC.[ClientLastName],'') + ', ') + ISNULL(DC.[ClientFirstName],'')) +
			CASE WHEN LEN(ISNULL(DC.[ClientMiddleName], '')) > (0) THEN ' ' + LEFT(DC.[ClientMiddleName], (1)) ELSE '' END) +
			CASE WHEN LEN(ISNULL(CONVERT([VARCHAR](20), DC.[ClientIdentifier], (0)), '')) > (0) THEN (' (' + CONVERT([VARCHAR](20), DC.[ClientIdentifier], (0))) +')' ELSE '' END) AS [ClientFullNameCalc]
,       DC.[ClientAddress1]
,       DC.[ClientAddress2]
,       DC.[ClientAddress3]
,       DC.[CountryRegionDescription]
,       DC.[CountryRegionDescriptionShort]
,       DC.[StateProvinceDescription]
,       DC.[StateProvinceDescriptionShort]
,       DC.[City]
,       ISNULL(LEFT(DC.[PostalCode], 5), 'Unknown') AS PostalCode
,       DC.[ClientDateOfBirth]
,       ( FLOOR(DATEDIFF(WEEK, DC.[ClientDateOfBirth], GETDATE()) / ( 52 )) ) AS [AgeCalc]
,       DC.[GenderSSID]
,       DC.[ClientGenderDescription]
,       DC.[ClientGenderDescriptionShort]
,       DC.[MaritalStatusSSID]
,       DC.[ClientMaritalStatusDescription]
,       DC.[ClientMaritalStatusDescriptionShort]
,       DC.[OccupationSSID]
,       DC.[ClientOccupationDescription]
,       DC.[ClientOccupationDescriptionShort]
,       DC.[EthinicitySSID]
,       DC.[ClientEthinicityDescription]
,       DC.[ClientEthinicityDescriptionShort]
,       ISNULL(DC.[DoNotCallFlag], 0) AS 'DoNotCallFlag'
,       ISNULL(DC.[DoNotContactFlag], 0) AS 'DoNotContactFlag'
,       ISNULL(DC.[IsHairModelFlag], 0) AS 'IsHairModelFlag'
,       ISNULL(DC.[IsTaxExemptFlag], 0) AS 'IsTaxExemptFlag'
,       DC.[ClientEMailAddress]
,       DC.[ClientTextMessageAddress]
,       DC.[ClientPhone1]
,       '(' + LEFT(DC.[ClientPhone1], 3) + ') ' + SUBSTRING(DC.[ClientPhone1], 1, 3) + '-' + RIGHT(DC.[ClientPhone1], 4) AS 'Phone1Calc'
,       DC.[Phone1TypeSSID]
,       DC.[ClientPhone1TypeDescription]
,       DC.[ClientPhone1TypeDescriptionShort]
,       DC.[ClientPhone2]
,       '(' + LEFT(DC.[ClientPhone2], 3) + ') ' + SUBSTRING(DC.[ClientPhone2], 1, 3) + '-' + RIGHT(DC.[ClientPhone2], 4) AS 'Phone2Calc'
,       DC.[Phone2TypeSSID]
,       DC.[ClientPhone2TypeDescription]
,       DC.[ClientPhone2TypeDescriptionShort]
,       DC.[ClientPhone3]
,       '(' + LEFT(DC.[ClientPhone3], 3) + ') ' + SUBSTRING(DC.[ClientPhone3], 1, 3) + '-' + RIGHT(DC.[ClientPhone3], 4) AS 'Phone3Calc'
,       DC.[Phone3TypeSSID]
,       DC.[ClientPhone3TypeDescription]
,       DC.[ClientPhone3TypeDescriptionShort]
,       DC.[CurrentBioMatrixClientMembershipSSID]
,       DC.[CurrentSurgeryClientMembershipSSID]
,       DC.[CurrentExtremeTherapyClientMembershipSSID]
,       ISNULL(DC.[contactkey], -1) AS 'ContactKey'
,       DC.[ClientARBalance]
,       DC.[RowIsCurrent]
,       DC.[RowStartDate]
,       DC.[RowEndDate]
,		ISNULL(DCA.HouseholdMosaicGroup, 'Unknown') AS 'CLHHMosaicGroup'
,		ISNULL(DCA.HouseholdMosaicType, 'Unknown') AS 'CLHHMosaicType'
,		ISNULL(DCA.ZipCodeMosaicGroup, 'Unknown') AS 'CLZipCodeMosaicGroup'
,		ISNULL(DCA.ZipCodeMosaicType, 'Unknown') AS 'CLZipCodeMosaicType'
--,		CAST(DCA.CAPE_Income_HH_Median_Family AS DECIMAL(10,0)) AS 'CLHHMedianIncome'
--,		CASE WHEN DCA.CAPE_Income_HH_Median_Family IS NOT NULL THEN 1 ELSE 0 END AS 'CLIncomeReptd'
--,       ISNULL(DC.[ClientLastName],'') + ', ' + ISNULL(DC.[ClientFirstName],'') + ' (' + CONVERT([VARCHAR](20), DC.[ClientIdentifier], (0)) +')'  AS [ClientNameAndID]
,		DC.ClientEmailAddressHashed
,		dc.SFDC_Leadid

FROM    [bi_cms_dds].[DimClient] DC
		LEFT OUTER JOIN bi_cms_dds.DimClientAppend DCA
			ON DCA.ClientKey = DC.ClientKey
