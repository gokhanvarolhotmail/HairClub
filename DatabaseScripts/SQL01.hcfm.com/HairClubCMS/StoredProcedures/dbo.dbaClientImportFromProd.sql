-- EXEC dbaClientImportFromProd 999

CREATE PROCEDURE [dbo].[dbaClientImportFromProd]
	@CenterNum	INT

AS

DECLARE
	@StateID INT

BEGIN

	-------------------------------------------------------------------------------------------------------
	-- Get the StateID for the selected Center.
	SELECT @StateID =
		lkp.StateID
	FROM lkpState lkp
		INNER JOIN bosproduction.dbo.centers c
			ON lkp.StateDescriptionShort = c.[CState]
	WHERE c.cCenter = @CenterNum

	-------------------------------------------------------------------------------------------------------
	-- Get Client records from BosProduction..Clients, and put into a temp table.
	SELECT
		c.Center
	,	NEWID() AS 'ClientGUID'
	,	NEWID() AS 'ClientMembershipGUID'
	,	c.[Client_no]
	,	c.[LastName] as 'Last_Name'
	,	c.[FirstName] as 'First_Name'
	,	c.[Address]
	,	c.[City]
	,	c.[State]
	,	CASE WHEN st.StateID = '' THEN @StateID ELSE ISNULL(st.StateID, @StateID) END AS 'StateID'
	,	st.[CountryID]
	,	c.[Zip]
	,	RTRIM(CAST(c.[HPhoneAc] AS CHAR)) + RTRIM(CAST(c.[HPhone] AS CHAR)) AS 'HomePhone'
	,	c.[WPhone]
	,	1 AS 'Phone1TypeID'
	,	2 AS 'Phone2TypeID'
	,	1 AS 'IsPhone1PrimaryFlag'
	,	0 AS 'IsPhone2PrimaryFlag'
	,	0 AS 'IsPhone3PrimaryFlag'
	,	0 AS 'IsHairSystemClientFlag'
	,	0 AS 'DoNotContactFlag'
	,	0 AS 'IsHairModelFlag'
	,	null AS 'ContactID'
	,	null AS 'ARBalance'
	,	ISNULL(c.[Gender], 'Male') AS 'Gender'
	,	ISNULL(g.[GenderID], 1) AS 'GenderID'
	,	null AS 'Bday'
	,	null AS 'DoNotCall'
	,	null AS 'IsTaxExempt'
	,	null AS 'Email'
	,	c.lastupdate AS 'CMSCreateDate'
	,	'sa' AS 'CMSCreateID'
	,	GETUTCDATE() AS 'CMSLastUpdate'
	,	'sa' AS 'CMSLastUpdateID'
	,	0.00 AS 'Credit_Limit'
	,	0.00 AS 'Payment_Amount'
	,	c.begindate1 AS 'Member1_Beg'
	,	c.expirdate1 AS 'Member1_Exp'
	,	case									--c.member1
			when c.center = 996 then 'NONPGM'
			when c.center = 997 then 'NONPGM'
			when c.center = 998 then 'HCFK'
			else 'NONPGM' END AS 'Member1'
	,	null AS 'Member_Additional'
	,	null AS 'Member1_ID'
	,	case when c.center = 996 then 'NONPGM'
			when c.center = 997 then 'NONPGM'
			when c.center = 998 then 'HCFK'
			else 'NONPGM'
		end AS 'Membership'
	,	CASE when c.center = 996 then 15
			when c.center = 997 then 15
			when c.center = 998 then 12
			else 15
		end AS 'MembershipID'
	,	1 AS 'ClientMembershipStatusID'
	,	8 AS 'AccumulatorID'
	,	0.00 AS 'Amount'
	,	null AS 'Age Calc'
	,	RTRIM(c.[FirstName]) + ' ' + RTRIM(c.[LastName]) AS 'ClientFullNameAltCalc'
	,	RTRIM(c.[LastName]) + ', ' + RTRIM(c.[FirstName]) + ' (' + RTRIM(CAST(c.[Client_no] AS CHAR)) + ')' AS 'ClientFullNameCalc'
	,	RTRIM(c.[FirstName]) + ' ' + RTRIM(c.[LastName]) AS 'ClientFullNameAlt3Calc'
	,	null  AS 'CancelDate'
	,	null  AS 'AccumQuantityRemainingCalc'
	,	0  AS 'UsedAccumQuantity'
	,	0  AS 'TotalAccumQuantity'
	,	'SystemUser' AS 'CreateUser'
	,	'SystemUser' AS 'LastUpdateUser'
	INTO #ClientData
	FROM bosproduction.dbo.[clients] c
		LEFT OUTER JOIN [lkpState] st
			ON c.[State] = st.[StateDescriptionShort]
		LEFT OUTER JOIN [lkpGender] g
			ON c.[Gender] = g.[GenderDescriptionShort]
		inner join HairSystemOrderConv_Temp.dbo.FOClients0707 FOC
			on c.center = foc.center and
				c.client_no = foc.client_no
		--LEFT OUTER JOIN EFT.dbo.[hcmtbl_EFT] eft
		--	ON c.[Center] = eft.Center
		--	AND c.[Client_no] = eft.Client_No
		----LEFT OUTER JOIN [cfgMembership] mem
		--	ON fx_GetCMSMembership(c.Member1, c.Member_Additional) = mem.MembershipDescriptionShort
	WHERE c.[Center] = @CenterNum

	CREATE CLUSTERED INDEX ix_ClientNo ON [#ClientData] (Client_No)

	-----------------------------------------------------------------------------------------------------------
	-- Update existing records
	-----------------------------------------------------------------------------------------------------------
	-- datClient table

	UPDATE c
	SET
		c.CountryID = d.CountryID
	,	c.FirstName = d.First_Name
	,	c.LastName = d.Last_Name
	,	c.Address1 = d.[Address]
	,	c.City = d.City
	,	c.StateID = d.StateID
	,	c.PostalCode = d.Zip
	,	c.ARBalance = d.ARBalance
	,	c.GenderID = d.GenderID
	,	c.DateOfBirth = d.Bday
	,	c.DoNotCallFlag = d.DoNotCall
	,	c.IsTaxExemptFlag = d.IsTaxExempt
	,	c.EmailAddress = d.Email
	,	c.Phone1 = d.HomePhone
	,	c.Phone2 = d.WPhone
	,	c.Phone1TypeID = d.Phone1TypeID
	,	c.Phone2TypeID = d.Phone2TypeID
	,	c.IsPhone1PrimaryFlag = d.IsPhone1PrimaryFlag
	,	c.IsPhone2PrimaryFlag = d.IsPhone2PrimaryFlag
	,	c.IsPhone3PrimaryFlag = d.IsPhone3PrimaryFlag
	,	c.IsHairSystemClientFlag = d.IsHairSystemClientFlag
	,	c.DoNotContactFlag = d.DoNotContactFlag
	,	c.IsHairModelFlag = d.IsHairModelFlag
	,	c.LastUpdate = d.CMSLastUpdate
	,	c.LastUpdateUser = d.CMSLastUpdateID
	--,	c.AgeCalc = d.AgeCalc
	--,	c.ClientFullNameAltCalc = d.ClientFullNameAltCalc
	--,	c.ClientFullNameCalc = d.ClientFullNameCalc
	FROM datClient c
		INNER JOIN [#ClientData] d
			ON c.CenterID = d.Center
			AND c.ClientNumber_Temp = d.Client_No

	-----------------------------------------------------------------------------------------------------------
	-- datClientMembership

	UPDATE c
	SET
		c.MembershipID = d.MembershipID
	,	c.ClientMembershipStatusID = d.ClientMembershipStatusID
	,	c.ContractPrice = d.Credit_Limit
	,	c.ContractPaidAmount = d.Payment_Amount
	,	c.MonthlyFee = d.Amount
	,	c.BeginDate = d.Member1_Beg
	,	c.EndDate = d.Member1_Exp
	,	c.CancelDate = d.CancelDate
	,	c.IsActiveFlag = 1
	,	c.LastUpdate = GETDATE()
	,	c.LastUpdateUser = d.LastUpdateUser
	FROM datClientMembership c
		INNER JOIN datClient client
			ON c.ClientGUID = client.ClientGUID
		INNER JOIN [#ClientData] d
			ON client.CenterID = d.Center
			AND client.ClientNumber_Temp = d.Client_No

	-----------------------------------------------------------------------------------------------------------
	-- datClientMembershipAccum

	UPDATE c
	SET
		c.UsedAccumQuantity = d.UsedAccumQuantity
	,	c.TotalAccumQuantity = d.TotalAccumQuantity
	--,	c.AccumQuantityRemainingCalc = d.AccumQuantityRemainingCalc
	,	c.LastUpdate = GETDATE()
	,	c.LastUpdateUser = 'SystemUser'
	FROM datClientMembershipAccum c
		INNER JOIN datClientMembership mem
			ON c.ClientMembershipGUID = mem.ClientMembershipGUID
		INNER JOIN datClient client
			ON mem.ClientGUID = client.ClientGUID
		INNER JOIN #ClientData d
			ON client.CenterID = d.Center
			AND client.ClientNumber_Temp = d.Client_No

	-----------------------------------------------------------------------------------------------------------
	-- Insert new records
	-----------------------------------------------------------------------------------------------------------
	-- datClient

	INSERT INTO [datClient] (
		[ClientGUID],
		[ClientNumber_Temp],
		[CenterID],
		[CountryID],
		[ContactID],
		[FirstName],
		[LastName],
		[Address1],
		[City],
		[StateID],
		[PostalCode],
		[ARBalance],
		[GenderID],
		[DateOfBirth],
		[DoNotCallFlag],
		[IsTaxExemptFlag],
		[EMailAddress],
		[Phone1],
		[Phone2],
		[Phone1TypeID],
		[Phone2TypeID],
		[IsPhone1PrimaryFlag],
		[IsPhone2PrimaryFlag],
		[IsPhone3PrimaryFlag],
		[IsHairSystemClientFlag],
		[DoNotContactFlag],
		[IsHairModelFlag],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser])
		--[AgeCalc],
		--[ClientFullNameCalc],
		--[ClientFullNameAltCalc],
		--[ClientFullNameAlt3Calc]		)
	SELECT
		ClientGUID
	,	CAST(CAST(Center as varchar(10)) + cast(LEFT(Client_No,6) as varchar(10)) as Int)
	,	100
	,	CountryID
	,	ContactID
	,	First_Name
	,	Last_Name
	,	[Address]
	,	City
	,	StateID
	,	Zip
	,	ARBalance
	,	GenderID
	,	Bday
	,	DoNotCall
	,	IsTaxExempt
	,	Email
	,	HomePhone
	,	WPhone
	,	Phone1TypeID
	,	Phone2TypeID
	,	IsPhone1PrimaryFlag
	,	IsPhone2PrimaryFlag
	,	IsPhone3PrimaryFlag
	,	IsHairSystemClientFlag
	,	DoNotContactFlag
	,	IsHairModelFlag
	,	CMSCreateDate
	,	CMSCreateID
	,	CMSLastUpdate
	,	CMSLastUpdateID
	--,	AgeCalc
	--,	[ClientFullNameCalc]
	--,	[ClientFullNameAltCalc]
	--,	[ClientFullNameAlt3Calc]
	FROM [#ClientData]
	WHERE [Client_No] NOT IN (SELECT ClientNumber_Temp FROM datClient WHERE CenterID = 100 AND [ClientNumber_Temp] IS NOT NULL)

	-----------------------------------------------------------------------------------------------------------
	-- datClientMembership

	INSERT INTO [datClientMembership] (
		[ClientMembershipGUID],
		[Member1_ID_Temp],
		[ClientGUID],
		[CenterID],
		[MembershipID],
		[ClientMembershipStatusID],
		[ContractPrice],
		[ContractPaidAmount],
		[MonthlyFee],
		[BeginDate],
		[EndDate],
		[CancelDate],
		[IsActiveFlag],
		[IsGuaranteeFlag],
		[IsRenewalFlag],
		[IsMultipleSurgeryFlag],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser]	)
	SELECT
		ClientMembershipGUID
	,	Member1_ID
	,	ClientGUID
	,	100
	,	MembershipID
	,	1
	,	Credit_Limit
	,	Payment_Amount
	,	Amount
	,	Member1_Beg
	,	Member1_Exp
	,	CancelDate
	,	1
	,	0
	,	0
	,	0
	,	GETUTCDATE()
	,	'SystemUser'
	,	GETUTCDATE()
	,	'SytemUser'
	FROM [#ClientData]
	WHERE [Client_No] NOT IN (SELECT c.ClientNumber_Temp
								FROM datClient c
									INNER JOIN datClientMembership m
										ON c.ClientGUID = m.ClientGUID
								WHERE c.CenterID = @CenterNum AND c.[ClientNumber_Temp] IS NOT NULL)

	-----------------------------------------------------------------------------------------------------------
	-- datClientMembershipAccum

	INSERT INTO [datClientMembershipAccum] (
		[ClientMembershipAccumGUID],
		[ClientMembershipGUID],
		[AccumulatorID],
		[UsedAccumQuantity],
		[TotalAccumQuantity],
		--[AccumQuantityRemainingCalc],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser]	)
	SELECT
		NEWID()
	,	ClientMembershipGUID
	,	AccumulatorID
	,	UsedAccumQuantity
	,	TotalAccumQuantity
	--,	AccumQuantityRemainingCalc
	,	GETUTCDATE()
	,	'SystemUser'
	,	GETUTCDATE()
	,	'SystemUser'
	FROM [#ClientData]
	WHERE [Client_No] NOT IN (SELECT c.ClientNumber_Temp
								FROM datClient c
									INNER JOIN datClientMembership m
										ON c.ClientGUID = m.ClientGUID
									INNER JOIN datClientMembershipAccum a
										ON m.ClientMembershipGUID = a.ClientMembershipGUID
								WHERE c.CenterID = 100 AND c.ClientNumber_Temp IS NOT NULL)


END
