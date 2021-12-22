/* CreateDate: 03/28/2011 11:18:39.670 , ModifyDate: 02/18/2013 19:04:02.583 */
GO
/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [dbo].[vw_Clients_LastMbrship]
AS
SELECT
	vw_Clients_Abbreviated.CenterID
	, CenterDescription
	, CenterName
	, ClientIdentifier
	, ClientNumber_Temp
	, vw_Clients_Abbreviated.ClientGUID
	, FirstName
	, LastName
	, ClientName
	, vw_Clients_Abbreviated.GenderID
	, Gender
	, GenderDescriptionShort
	, DateOfBirth
	, Age
	, Address
	, City
	, State
	, Zip
	, CountryID
	, Country
	, CountryDescriptionShort
	, HomePhone
	, WorkPhone
	, HomePhoneUnformatted
	, WorkPhoneUnformatted
	, HphoneAC
	, EMailAddress
	, TextMessageAddress
	, DoNotCallFlag
	, DoNotContactFlag
	, IsTaxExemptFlag
	, ContactID
	, vw_Clients_Abbreviated.CreateUser
	, vw_Clients_Abbreviated.CreateDate
	, ARBalance
        --                  (SELECT  cfgmembership_1.MembershipDescriptionShort
        --                    FROM          SQL05.HairclubCMS.dbo.datClientmembership AS datClientmembership_1
								--INNER JOIN SQL05.HairclubCMS.dbo.datClient AS datClient_1 ON
								--	datClient_1.ClientGUID = datClientmembership_1.ClientGUID INNER JOIN
        --                                           SQL05.HairclubCMS.dbo.cfgmembership AS cfgmembership_1 ON
        --                                           cfgmembership_1.MembershipID = datClientmembership_1.MembershipID
        --                    WHERE      (datClientmembership_1.ClientGUID = dbo.vw_Clients_Abbreviated.ClientGUID)
        --                    ORDER BY datClientmembership_1.EndDate DESC)
     , cfgmembership_1.MembershipDescriptionShort AS Membership
     , datClientMembership.BeginDate
     , datClientMembership.EndDate

FROM         dbo.vw_Clients_Abbreviated
			INNER JOIN datClientmembership AS datClientmembership ON
				datClientmembership.ClientmembershipGUID = vw_Clients_Abbreviated.CurrentSurgeryClientMembershipGUID
			INNER JOIN cfgmembership AS cfgmembership_1 ON
                cfgmembership_1.MembershipID = datClientmembership.MembershipID
GO
