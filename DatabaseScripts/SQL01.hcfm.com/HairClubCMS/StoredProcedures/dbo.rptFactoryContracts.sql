/* CreateDate: 06/18/2012 15:11:12.993 , ModifyDate: 10/11/2019 09:59:06.360 */
GO
/***********************************************************************
PROCEDURE:				[rptFactoryContracts]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				Hdu
IMPLEMENTOR: 			Hdu
DATE IMPLEMENTED: 		4/25/12
LAST REVISION DATE: 	4/25/12
--------------------------------------------------------------------------------------------------------
NOTES: 	Returns Contracts for report, report pivots
--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:

[rptFactoryContracts] 16
***********************************************************************/


CREATE PROCEDURE [dbo].[rptFactoryContracts]
      @VendorID INT
AS
BEGIN
      SET NOCOUNT ON;

SELECT	hsvc.ContractName
,		hsvc.ContractBeginDate
,		hsvc.ContractEndDate
,		hshc.HairSystemHairCapDescription
,		hshl.HairSystemHairLengthDescriptionShort
,		hshl.HairSystemHairLengthValue
,		CAST(hsvcp.HairSystemAreaRangeBegin AS VARCHAR) + ' - ' + CAST(hsvcp.HairSystemAreaRangeEnd AS VARCHAR) AS 'AREA'
,		hsvcp.HairSystemCost AS 'HairSystemPrice'
,		hsvc.IsRepair
FROM	cfgHairSystemVendorContract hsvc
		INNER JOIN cfgHairSystemVendorContractPricing hsvcp
			ON hsvc.HairSystemVendorContractID = hsvcp.HairSystemVendorContractID
		INNER JOIN dbo.lkpHairSystemHairLength hshl
			ON hshl.HairSystemHairLengthID = hsvcp.HairSystemHairLengthID
		INNER JOIN dbo.lkpHairSystemHairCap hshc
			ON hshc.HairSystemHairCapID = hsvcp.HairSystemHairCapID
WHERE	hsvc.VendorID = @VendorID

END
GO
