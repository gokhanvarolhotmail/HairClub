/* CreateDate: 07/12/2011 10:46:21.440 , ModifyDate: 07/18/2011 10:01:12.627 */
GO
/***********************************************************************

PROCEDURE:				[spRpt_SurgeryAR_Balance]

VERSION:				v1.0

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	AR Balance - Surgery

AUTHOR: 				James Hannah

IMPLEMENTOR: 			Marlon Burrell

DATE IMPLEMENTED: 		5/15/2009

LAST REVISION DATE: 	7/11/2011

--------------------------------------------------------------------------------------------------------
NOTES:
	04/21/2011 - MB --> Joined all tables to the current membership to eliminate duplicates which were
						happening when multiple membership were being joined to
	05/26/2011 - MB --> Added section for Deposit To Meet The Doctor date (WO# 62924)
	05/31/2011 - MB --> Formatted MembershipStartDate column for report (WO# 63121)
	07/11/2011 - KM --> Migrated report to SQL06
--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [spRpt_SurgeryAR_Balance]
--------------------------------------------------------------------------------------------------------
GRANT EXECUTE ON [spRpt_SurgeryAR_Balance] TO IIS
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_SurgeryAR_Balance]
AS
BEGIN

SET NOCOUNT ON
SET FMTONLY OFF

SELECT
			RegionID
		,	RegionDescription
		,	RegionSortOrder
		,	CenterID
		,	CenterDescription
		,	CenterDescriptionFullCalc
		,	ClientIdentifier
		,	ClientNumber_Temp
		,	ClientGUID
		,	FirstName
		,	LastName
		,	ClientName + ' (' + CAST(clientidentifier as varchar) + ')' as 'ClientName'
		,	ClientName + ' (' + CAST(clientidentifier as varchar) + ')' as 'ClientFullNameCalc'
		,	GenderID
		,	GenderDescription as 'Gender'
		,	GenderDescriptionShort
		,	DateOfBirth
		,	Age
		,	Address1 as 'Address'
		,	City
		,	[State]
		,	Zip
		,	Country
		,	CountryDesriptionShort
		,	HomePhone
		,	WorkPhone
		,	EmailAddress
		--,	TextMessageAddress
		,	Membership
		,	MembershipStartDate
		,	MembershipEndDate
		,	ContractPrice
		,	ContractPaid
		,	TotalGrafts
		,	UsedGrafts
		,	ARBalance
		,	ContractPrice - ContractPaid as 'ContractBalance'
		,	LastApplicationDate
		,	LastCheckUpDate
		,	LastServiceDate
		,	LastPaymentDate
		,	NextAppointmentDate
		,	SurgeryDate
		,	DoNotCallFlag
		,	DoNotContactFlag
		,	IsTaxExemptFlag
		,	DepositDate
		,	ClientMembershipStatusDescription AS 'Status'
FROM vw_SurgeryClients
WHERE ARBalance <> 0
ORDER BY
			RegionSortOrder
		,	CenterID
		,	LastName

END
GO
