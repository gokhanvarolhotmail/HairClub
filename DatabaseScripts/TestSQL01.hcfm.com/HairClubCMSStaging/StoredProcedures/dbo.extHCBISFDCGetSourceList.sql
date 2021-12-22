/* CreateDate: 11/04/2019 08:17:32.063 , ModifyDate: 11/04/2019 08:17:32.063 */
GO
/*
==============================================================================
PROCEDURE:				extHCBISFDCGetSourceList

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Jeremy Miller

IMPLEMENTOR: 			Jeremy Miller

DATE IMPLEMENTED: 		 09/04/2019

LAST REVISION DATE: 	 09/25/2019

==============================================================================
DESCRIPTION:	Interface with HC_BI_SFDC database
==============================================================================
NOTES:
		* 09/04/2019 JLM - Created (TFS #12904)
		* 09/25/2019 JLM - Change name to 'extHCBISFDCGetSourceList' to follow naming conventions

==============================================================================
SAMPLE EXECUTION:
EXEC extHCBISFDCGetSourceList 'HAIRCLUB', 1
==============================================================================
*/

CREATE PROCEDURE [dbo].[extHCBISFDCGetSourceList]
(
	@BusinessUnitBrandDescriptionShort NVARCHAR(10),
	@IsInHouseLead BIT = 0
)
AS
BEGIN
	SET NOCOUNT ON

	EXEC HC_BI_SFDC_extHairClubCMSGetSourceList_PROC @BusinessUnitBrandDescriptionShort, @IsInHouseLead
	--select CONVERT(NVARCHAR(50), '') AS 'ID', CONVERT(NVARCHAR(50), '') AS 'Description'
END
GO
