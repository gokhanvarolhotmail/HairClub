/* CreateDate: 11/05/2020 13:09:47.700 , ModifyDate: 11/25/2020 13:34:36.990 */
GO
/***********************************************************************
PROCEDURE:				spSvc_FirstPartyImportAudienceStudio
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Marketing
AUTHOR:					Kevin Murdoch
IMPLEMENTOR:			Kevin Murdoch
DATE IMPLEMENTED:		11/5/2020
DESCRIPTION:			11/5/2020
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_FirstPartyImportAudienceStudioExport
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_FirstPartyImportAudienceStudioExport]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


IF OBJECT_ID(N'tempdb..#MemberFirst') IS NOT NULL
BEGIN
DROP TABLE #MemberFirst
END

IF OBJECT_ID(N'tempdb..#MemberCurrent') IS NOT NULL
BEGIN
DROP TABLE #MemberCurrent
END

IF OBJECT_ID(N'tempdb..#MemberRevenue') IS NOT NULL
BEGIN
DROP TABLE #MemberRevenue
END

/*

Select All memberships for Clients with hashed Email; Get the first Membership

*/
SELECT  ROW_NUMBER() OVER ( PARTITION BY dc.ClientIdentifier ORDER BY clm.ClientMembershipBeginDate ASC ) AS 'RowID'

		,dc.ClientIdentifier AS 'ClientIdentifier',
		clm.ClientMembershipKey AS 'MembershipKey',
		mem.MembershipDescription AS 'Membership',
		BS.BusinessSegmentDescription AS 'BusinessSegment',
		CASE WHEN BS.BusinessSegmentSSID IN (1,6,7) THEN 'Replace'
			WHEN BS.BusinessSegmentSSID = 2 THEN 'Regrow'
			WHEN BS.BusinessSegmentSSID = 3 THEN 'Restore'
			ELSE 'Unknown'
			END AS 'BusinessLine',
		clm.ClientMembershipStatusDescription AS 'MembershipStatus',
       CONVERT( VARCHAR, clm.ClientMembershipBeginDate,112) AS 'MembershipBeginDate',
	   clm.ClientMembershipContractPrice AS 'ContractPrice',
	   rg.RevenueGroupDescription AS 'RevenueGroup',
	   rg.RevenueGroupDescriptionShort AS 'RevenueGroupShort',
	   rg.RevenueGroupSSID AS 'RevenueGroupID'
INTO #MemberFirst
FROM [HC_BI_CMS_DDS].[bi_cms_dds].[vwDimClient] dc
    LEFT OUTER JOIN [HC_BI_CMS_DDS].bi_cms_dds.DimClientMembership clm
        ON clm.ClientKey = dc.ClientKey
    LEFT OUTER JOIN [HC_BI_CMS_DDS].bi_cms_dds.DimMembership mem
        ON mem.MembershipKey = clm.MembershipKey
    LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimBusinessSegment bs
        ON bs.BusinessSegmentKey = mem.BusinessSegmentKey
	LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRevenueGroup rg
		ON rg.RevenueGroupSSID = mem.RevenueGroupSSID
WHERE dc.ClientEmailAddressHashed IS NOT NULL
      AND bs.BusinessSegmentDescriptionShort IN ( 'BIO', 'EXT', 'SUR', 'XTR', 'RESTORINK' )
      AND mem.MembershipKey NOT IN ( 64, 67, 110, 111, 260, 257, 95 ) --Initial memberships like shownosale,

ORDER BY dc.ClientIdentifier


--SELECT * FROM HC_BI_CMS_DDS.bi_cms_dds.DimMembership
--WHERE MembershipKey IN (64, 65, 67, 110, 111, 260, 257, 95)

--SELECT * FROM #MemberFirst WHERE RowID = 1 AND MembershipBeginDate > '20170101'

--SELECT * FROM #MemberFirst WHERE ClientIdentifier = 56182
/*

Select All memberships for Clients with hashed Email; Get the last membership and that membership's status

*/
SELECT  ROW_NUMBER() OVER ( PARTITION BY dc.ClientIdentifier ORDER BY clm.ClientMembershipEndDate DESC ) AS 'RowID'

		,dc.ClientIdentifier AS 'ClientIdentifier',
		clm.ClientMembershipKey AS 'MembershipKey',
		mem.MembershipDescription AS 'Membership',
		BS.BusinessSegmentDescription AS 'BusinessSegment',
		clm.ClientMembershipStatusDescription AS 'MembershipStatus',
       CONVERT( VARCHAR, clm.ClientMembershipBeginDate,112) AS 'MembershipBeginDate',
       CONVERT( VARCHAR, clm.ClientMembershipEndDate,112) AS 'MembershipEndDate',
	   CASE WHEN eft.EFTAccountTypeID = 1 THEN 'CC'
			WHEN eft.EFTAccountTypeID = 2 THEN 'Checking'
			WHEN eft.EFTAccountTypeID = 3 THEN 'Savings'
			WHEN eft.EFTAccountTypeID = 4 THEN 'A/R'
		ELSE
			NULL
		END AS 'PaymentMethod'
INTO #MemberCurrent
FROM [HC_BI_CMS_DDS].[bi_cms_dds].[vwDimClient] dc
    LEFT OUTER JOIN [HC_BI_CMS_DDS].bi_cms_dds.DimClientMembership clm
        ON clm.ClientKey = dc.ClientKey
	LEFT OUTER JOIN Hairclubcms.dbo.datClientEFT eft
		 ON clm.ClientMembershipSSID = eft.ClientMembershipGUID
    LEFT OUTER JOIN [HC_BI_CMS_DDS].bi_cms_dds.DimMembership mem
        ON mem.MembershipKey = clm.MembershipKey
    LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimBusinessSegment bs
        ON bs.BusinessSegmentKey = mem.BusinessSegmentKey
	LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRevenueGroup rg
		ON rg.RevenueGroupSSID = mem.RevenueGroupSSID
WHERE dc.ClientEmailAddressHashed IS NOT NULL
      AND bs.BusinessSegmentDescriptionShort IN ( 'BIO', 'EXT', 'SUR', 'XTR', 'RESTORINK' )
      AND mem.MembershipKey NOT IN ( 64, 65, 67, 110, 111, 260, 257, 95 )

--ORDER BY dc.ClientIdentifier
/*

Select all sales orders from the BI environment, group by clientidentifier and break out revenue into New Business, NonProgram & Recurring membership. Also, some Product
Service and Laser Revenue

*/

SELECT
		dc.ClientIdentifier AS 'ClientIdentifier',
		dc.ClientFullName AS 'ClientName',
       SUM(CASE WHEN dscd.SalesCodeDepartmentSSID LIKE '2%' AND drg.revenuegroupdescriptionshort = 'NB' THEN fst.ExtendedPrice ELSE 0 END) AS 'NBMembershipRevenue',
	   SUM(CASE WHEN dscd.SalesCodeDepartmentSSID LIKE '2%' AND drg.revenuegroupdescriptionshort IN ('NP') THEN fst.ExtendedPrice ELSE 0 END) AS 'NPMembershipRevenue',
	   SUM(CASE WHEN dscd.SalesCodeDepartmentSSID LIKE '2%' AND drg.revenuegroupdescriptionshort IN ( 'PCP') THEN fst.ExtendedPrice ELSE 0 END) AS 'RRMembershipRevenue',
	   SUM(CASE WHEN dscd.SalesCodeDepartmentSSID IN (3010,3020,3030,3040,3050,3060,3070,3080, 7052) THEN fst.ExtendedPrice ELSE 0 END) 'ProductRevenue',
	   SUM(CASE WHEN dscd.SalesCodeDepartmentSSID IN (3065) THEN fst.ExtendedPrice ELSE 0 END) 'LaserRevenue',
	   SUM(CASE WHEN dscd.SalesCodeDepartmentSSID LIKE '5%' THEN fst.ExtendedPrice ELSE 0 END) AS 'ServiceRevenue'
INTO #MemberRevenue
FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
    INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient dc
        ON dc.ClientKey = fst.ClientKey
    INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership clm
        ON clm.ClientMembershipKey = fst.ClientMembershipKey
    INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership mem
        ON mem.MembershipKey = fst.MembershipKey
    INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRevenueGroup drg
        ON drg.RevenueGroupSSID = mem.RevenueGroupSSID
    INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
        ON fst.OrderDateKey = dd.DateKey
    INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode dsc
        ON fst.SalesCodeKey = dsc.SalesCodeKey
    INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment dscd
        ON dscd.SalesCodeDepartmentKey = dsc.SalesCodeDepartmentKey
    INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDivision dscdiv
        ON dscd.SalesCodeDivisionKey = dscdiv.SalesCodeDivisionKey
WHERE
      ISNULL(fst.IsVoided, 0) = 0 AND
      dc.ClientEmailAddressHashed IS NOT NULL AND
      dscd.SalesCodeDepartmentSSID NOT LIKE '1%' AND
	  fst.SalesOrderTypeKey NOT IN (3,7)
GROUP BY dc.ClientIdentifier,
		dc.ClientFullName
ORDER BY dc.ClientIdentifier,
		dc.ClientFullName

/*

Convert hashed email to text from varbinary, remove first 2 characters, convert to lowercase
Get base client information, join on temp tables to determine initial & current or last membership depending on the membership status
Concatenate all of that together to create a string

*/


SELECT --TOP 1000
	   LOWER(SUBSTRING(master.dbo.fn_varbintohexstr(dc.[ClientEmailAddressHashed]), 3, 8000))+
       '^Center:' + '"' + c.CenterDescriptionNumber + '"'
	   + ';Country:' + '"' + dc.CountryRegionDescription + '"'
	   + ';StateProvince:' + '"' + dc.StateProvinceDescription + '"'
	   + ';City:' + '"' + dc.City + '"'
	   + ';PostalCode:' + '"' + UPPER(dc.[PostalCode]) + '"'
       + CASE
             WHEN dc.ClientDateOfBirth IS NOT NULL THEN
                 ';Birthdate:' + '"' + CONVERT(VARCHAR, dc.[ClientDateOfBirth], 112) + '"'
             ELSE
                 ''
         END + CASE
                   WHEN dc.[ClientGenderDescription] IS NOT NULL THEN
                       ';Gender:' + '"' + dc.[ClientGenderDescription] + '"'
                   ELSE
                       ''
        END + CASE
                    WHEN dc.[ClientMaritalStatusDescription] IS NOT NULL
						AND dc.[ClientMaritalStatusDescription] <> '' THEN
                        ';MaritalStatus:' + '"' + dc.[ClientMaritalStatusDescription] + '"'
                    ELSE
                        ''
        END + CASE
					WHEN dc.[ClientOccupationDescription] IS NOT NULL
						AND dc.[ClientOccupationDescription] <> '' THEN
						';Occupation:' + '"' + dc.[ClientOccupationDescription] + '"'
					ELSE
						''
        END + CASE
                    WHEN dc.[ClientEthinicityDescription] IS NOT NULL
                        AND dc.[ClientEthinicityDescription] <> '' THEN
                        ';Ethnicity:' + '"' + dc.[ClientEthinicityDescription] + '"'
                    ELSE
                        ''
        END + CASE
                    WHEN dcon.ContactPromotonSSID IS NOT NULL THEN
                        ';PromoCode:' + '"' + dcon.ContactPromotonSSID + '"'
                    ELSE
                        ''
        END + CASE
                    WHEN hlt.HairLossTypeDescription IS NOT NULL AND hlt.HairLossTypeDescription <> 'Unknown' THEN
                        ';HairLossType:' + '"' + hlt.HairLossTypeDescription + '"'
                    ELSE
                        ''
        END + CASE
                    WHEN mf.Membership IS NOT NULL THEN
                        ';InitialMembership:' + '"' + mf.Membership + '"'
                    ELSE
                        ''
        END + CASE
                    WHEN mf.BusinessSegment IS NOT NULL THEN
                        ';InitialBusinessSegment:' + '"' + mf.BusinessSegment + '"'
                    ELSE
                        ''
        END + CASE
                    WHEN mf.BusinessSegment IS NOT NULL THEN
                        ';InitialBusinessLine:' + '"' + mf.BusinessLine + '"'
                    ELSE
                        ''
        END + CASE
                    WHEN mf.MembershipBeginDate IS NOT NULL THEN
                        ';InitialStartDate:' + '"' + mf.MembershipBeginDate + '"'
                    ELSE
                        ''
        END	 + CASE
                    WHEN ISNULL(mf.ContractPrice, 0) <> 0 THEN
                        ';InitialMembershipContractAmt:' + '"' + CONVERT(VARCHAR, CAST(mf.ContractPrice AS MONEY)) + '"'
                    ELSE
                        ''
        END + CASE
                    WHEN ISNULL(mr.NBMembershipRevenue, 0) <> 0 THEN
                        ';InitialMembershipRevenue:' + '"' + CONVERT(VARCHAR, CAST(mr.NBMembershipRevenue AS MONEY)) + '"'
                    ELSE
                        ''
        END + CASE
                    WHEN mc.MembershipStatus = 'Active' THEN
                        ';CurrentMembership:' + '"' + mc.Membership + '"'
                    ELSE
                        ''
        END  + CASE
                    WHEN mc.PaymentMethod IS NOT NULL THEN
                        ';PaymentMethod:' + '"' + mc.PaymentMethod + '"'
                    ELSE
                        ''
        END  +CASE
                    WHEN mc.MembershipStatus = 'Active' THEN
                        ';CurrentBusinessSegment:' + '"' + mc.BusinessSegment + '"'
                    ELSE
                        ''
        END + CASE
                    WHEN mc.MembershipStatus = 'Active' THEN
                        ';CurrentStartDate:' + '"' + mc.MembershipBeginDate + '"'
                    ELSE
                        ''
        END + CASE
                    WHEN ISNULL(mr.RRMembershipRevenue,0) <> 0 THEN
                        ';TotalRecurringRevenue:' + '"' + CONVERT(VARCHAR, CAST(mr.RRMembershipRevenue AS MONEY)) + '"'
                    ELSE
                        ''
        END + CASE
                    WHEN ISNULL(mr.NPMembershipRevenue,0) <> 0 THEN
                        ';TotalNonProgramRevenue:' + '"' + CONVERT(VARCHAR, CAST(mr.NPMembershipRevenue AS MONEY)) + '"'
                    ELSE
                        ''
        END + CASE
                    WHEN ISNULL(mr.ProductRevenue,0) <> 0 THEN
                        ';ProductRevenue:' + '"' + CONVERT(VARCHAR, CAST(mr.ProductRevenue AS MONEY)) + '"'
                    ELSE
                        ''
        END + CASE
                    WHEN ISNULL(mr.ServiceRevenue,0) <> 0 THEN
                        ';ServiceRevenue:' + '"' + CONVERT(VARCHAR, CAST(mr.ServiceRevenue AS MONEY)) + '"'
                    ELSE
                        ''
        END + CASE
                    WHEN ISNULL(mr.LaserRevenue,0) <> 0 THEN
                        ';LaserRevenue:' + '"' + CONVERT(VARCHAR, CAST(mr.LaserRevenue AS MONEY)) + '"'
                    ELSE
                        ''
        END + CASE
                    WHEN mc.MembershipStatus IS NOT NULL THEN
                        ';CurrentMembershipStatus:' + '"' + mc.MembershipStatus + '"'
                    ELSE
                        ''
        END +CASE
                    WHEN mc.MembershipStatus LIKE 'Cancel%' THEN
                        ';CancelFlag:"Y"'
                    ELSE
                        ''
        END + CASE
                    WHEN mc.MembershipStatus LIKE 'Cancel%' THEN
                        ';CancelDate:' + '"' + mc.MembershipEndDate + '"'
                    ELSE
                        ''
        END
		--,mf.Membership AS 'InitialMembership',
		--mf.BusinessSegment AS 'InitialBusinessSegment',
		--mf.MembershipBeginDate AS 'InitialStartDate',
		--mf.contractprice as 'ContractPrice',
		--mr.NBMembershipRevenue,
		--mr.RRMembershipRevenue,
		--mc.Membership AS 'CurrentMembership',
		--mc.MembershipStatus AS 'CurrentMembershipStatus',
		--mc.MembershipBeginDate AS 'CurrentBeginDate',
		--mc.MembershipEndDate AS 'CurrentEndDate',
  --     c.CenterDescriptionNumber AS 'Center',
  --     LOWER(SUBSTRING(master.dbo.fn_varbintohexstr(dc.[ClientEmailAddressHashed]), 3, 8000)) AS 'ClientEmailAddressHashed',
		--dc.ClientIdentifier,
  --     dc.CountryRegionDescription AS 'Country',
  --     dc.[StateProvinceDescription] AS 'StateProvince',
  --     dc.[City],
  --     UPPER(dc.[PostalCode]) AS 'PostalCode',
  --     dc.[ClientDateOfBirth] AS 'Birthdate',
  --     [AgeCalc] AS 'Age',
  --     [ClientGenderDescription] AS 'Gender',
  --     [ClientMaritalStatusDescription] AS 'MaritalStatus',
  --     [ClientOccupationDescription] AS 'Occupation',
  --     [ClientEthinicityDescription] AS 'Ethnicity'
FROM [HC_BI_CMS_DDS].[bi_cms_dds].[vwDimClient] dc
    INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
        ON c.CenterSSID = dc.CenterSSID
	LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact dcon
		ON dcon.SFDC_LeadID = dc.SFDC_Leadid
	LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.FactLead fl
		ON fl.ContactKey = dcon.ContactKey
	LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimHairLossType hlt
		ON fl.HairLossTypeKey = hlt.HairLossTypeKey
	LEFT OUTER JOIN #MemberFirst mf
		ON dc.ClientIdentifier = mf.ClientIdentifier
		AND mf.RowID = 1
	LEFT OUTER JOIN #MemberCurrent mc
		ON dc.ClientIdentifier = mc.ClientIdentifier
		AND mf.BusinessSegment = mc.BusinessSegment
		AND mc.RowID = 1
	LEFT OUTER JOIN #MemberRevenue mr
		ON dc.ClientIdentifier = mr.ClientIdentifier
WHERE dc.ClientEmailAddressHashed IS NOT NULL

END

--add method of payment for recurring members
--add promocode
--add BusinessLine Restore, Replace, Regrow
--add HairLoss Type

--SELECT TOP 1000 * FROM HC_BI_MKTG_DDS.bi_mktg_dds.DimContact
--ORDER BY ContactKey desc
GO
