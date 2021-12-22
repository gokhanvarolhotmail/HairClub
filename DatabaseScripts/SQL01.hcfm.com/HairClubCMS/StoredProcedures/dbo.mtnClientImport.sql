/*
==============================================================================
PROCEDURE:				mtnClientImport

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		 2/10/2010

LAST REVISION DATE: 	 10/17/2012

==============================================================================
DESCRIPTION:	Import Clients from legacy system
==============================================================================
NOTES:
		* 10/19/10 PRM - Created Stored Proc
		* 01/03/10 PRM - Removed reference to temp table to include other clients not within the date range of query
		* 01/05/10 PRM - Change reference to CreateDate & LastUpdate to a new Import version of the columns
		* 01/06/10 KM  - Removed "AND c.ClientGUID IS NULL" from select statement so INSERTS work
		* 08/15/11 KM  - Modified Insert to use CMSCreateDate rather than CMSUpdateDate
		* 09/22/11 KM  - Modified Create users for datClientMembership to denote where created
		* 09/22/11 KM  - Modified initial select to make Member1_id = 0; reformatted select
		* 09/29/11 MB  - Modified procedure to include clients who have been canceled
		* 06/19/12 MLM - Fixed with the @BusinessSegment_EXTREME begin wrong thus causing Client(s) to not have a current Client membership
		* 10/17/12 MT  - Added a script at the end to update Membership Identifier for newly added memberships.
							Updated to trim client first name, last name, email, address1, city, phone1, and phone2 to remove extra spaces.
		* 03/03/13 MT - Added update statement to update status to "Cancel" on Cancel Memberships that are in Inactive Status.
		* 05/06/13 MLM - Add Check to update Clients if they have a ContactID
		* 05/08/13 MLM	- Added Logic to populate the datRequestQueue Table when a POSTEXT Membership is added.
		* 05/14/13 MLM  - Added columns to the datRequestQueue Table
		* 06/03/13 MLM - Fixed Issue with Clients Having both BioMatrix & Extreme Memberships
		* 06/14/13 MLM - Modified to process missing Member1_ids.
		* 07/09/13 MT  - Modified the update of the ClientNumber_Temp on the datClient to use the @InfostoreClients temp
						table to speed up the query.
		* 08/02/13 MT  - Modified to add all accumulator records for newly added clients.  Modified to update Product Kits, Services,
							and Solutions accumulators in addition to Hair Systems.
		* 08/14/13 MT  - Fixed issue with accumulators not being updated in some conditions.
		* 10/29/13 MLM - Fixed issue with accumulators not being set correctly for a new client
		* 06/09/14 SAL - Fixed issue with calculating accumulator totals
		* 03/06/15 MVT - Updated for Xtrands Business Segment
==============================================================================
SAMPLE EXECUTION:
EXEC mtnClientImport
==============================================================================
*/
CREATE PROCEDURE [dbo].[mtnClientImport]
	@CenterID int = NULL
AS
BEGIN

	DECLARE @IsLoggingEnabled bit = 0


	DECLARE @BeginDate datetime = '7/1/2007'

	DECLARE @ClientGUID uniqueidentifier, @Member1_ID int, @CurMember1_ID_Temp int, @MembershipID int, @BusinessSegment nvarchar(50), @NewClientMembershipGUID uniqueidentifier, @CurClientMembershipGUID uniqueidentifier, @SiebelID nvarchar(50)

	DECLARE @BusinessSegment_BIO nvarchar(50) = 'BIO'
	DECLARE @BusinessSegment_EXTREME nvarchar(50) = 'EXT'
	DECLARE @BusinessSegment_XTRANDS nvarchar(50) = 'XTR'

	DECLARE @ClientMembershipStatusID_Active int, @ClientMembershipStatusID_Cancel int
	DECLARE @AccumulatorID_BIOSystems int
	DECLARE @MembershipID_CANCEL int
	DECLARE @MembershipID_POSTEXT int


	IF @IsLoggingEnabled = 1
		INSERT INTO [HairClubCMSStaging].[dbo].[tmpInfostoreDailyImportLog] ([RunDate],[JobStep],[Timestamp],[Message])
			VALUES (GETDATE(),3,GETDATE(),'Step 3 (Client Import): Starting Execution for Center #: ' + CAST(@CenterID as nvarchar(10)))


	SELECT @ClientMembershipStatusID_Active = ClientMembershipStatusID FROM lkpClientMembershipStatus WHERE ClientMembershipStatusDescriptionShort = 'A'
	SELECT @ClientMembershipStatusID_Cancel = ClientMembershipStatusID FROM lkpClientMembershipStatus WHERE ClientMembershipStatusDescriptionShort = 'C'
	SELECT @AccumulatorID_BIOSystems = AccumulatorID FROM cfgAccumulator WHERE AccumulatorDescriptionShort = 'BioSys'
	SELECT @MembershipID_CANCEL = MembershipID FROM cfgMembership WHERE MembershipDescriptionShort = 'CANCEL'
	SELECT @MembershipID_POSTEXT = MembershipID FROM cfgMembership WHERE MembershipDescriptionShort = 'POSTEXT'

	-------------------------------------------------------------------------------------------------------
	-- Check to see if Client Exists by Joining on the ConectId
	-------------------------------------------------------------------------------------------------------
	DECLARE @InfostoreClients TABLE
	(
	  Client_No int,
	  ContactID nvarchar(50)
	)

	INSERT INTO @InfostoreClients (Client_No, ContactID)
		SELECT hcc.Client_No, hcc.ContactID
			FROM [HCSQL2\SQL2005].Infostore.dbo.Clients hcc
			WHERE hcc.Center = @CenterID

	Update c
		SET c.ClientNumber_Temp = hcc.Client_No
	FROM @InfostoreClients hcc
		INNER JOIN datClient c on hcc.ContactID = c.ContactID
	WHERE c.ClientNumber_Temp IS NULL


	-----------------------------------------------
	-- Logging
	-----------------------------------------------
	IF @IsLoggingEnabled = 1
		INSERT INTO [HairClubCMSStaging].[dbo].[tmpInfostoreDailyImportLog] ([RunDate],[JobStep],[Timestamp],[Message])
			VALUES (GETDATE(),3,GETDATE(),'Step 3 (Client Import): Updated Client Number Temp for Center #: ' + CAST(@CenterID as nvarchar(10)))


	-------------------------------------------------------------------------------------------------------
	-- Select Client records from Infostore..Clients, and put into a temp table
	-------------------------------------------------------------------------------------------------------
	SELECT
			hcc.Center
		,	c.ClientGUID AS ClientGUID
		,	NEWID() AS NewClientGUID
		,	c.CurrentBioMatrixClientMembershipGUID
		,	c.CurrentExtremeTherapyClientMembershipGUID
		,	c.CurrentXtrandsClientMembershipGUID
		,	NEWID() AS NewClientMembershipGUID
		,	hcc.Client_no
		,	hcc.Last_Name
		,	hcc.First_Name
		,	hcc.[Address]
		,	hcc.City
		,	hcc.[State]
		,	ISNULL(s.StateID, ctr.StateID) AS StateID
		,	ISNULL(s.CountryID
		,	ctr.CountryID) AS CountryID
		,	hcc.Zip
		,	RTRIM(CAST(hcc.HPhoneAc AS CHAR)) + RTRIM(CAST(hcc.HPhone AS CHAR)) AS HomePhone
		,	hcc.WPhone
		,	1 AS Phone1TypeID
		,	2 AS Phone2TypeID
		,	1 AS IsPhone1PrimaryFlag
		,	0 AS IsPhone2PrimaryFlag
		,	0 AS IsPhone3PrimaryFlag
		,	0 AS IsHairSystemClientFlag
		,	0 AS DoNotContactFlag
		,	hcc.isHairModel AS IsHairModelFlag
		,	hcc.ContactID
		,	ISNULL(hcc.Balance, 0) AS ARBalance
		,	ISNULL(hcc.Gender, 'Male') AS Gender
		,	ISNULL(g.GenderID, 1) AS GenderID
		,	hcc.Bday
		,	hcc.DoNotCall
		,	hcc.IsTaxExempt
		,	hcc.Email
		,	hcc.CMSCreateDate
		,	hcc.CMSCreateID
		,	hcc.CMSLastUpdate
		,	hcc.CMSLastUpdateID
		,	ISNULL(hcc.Credit_Limit, 0) AS Credit_Limit
		,	ISNULL(hcc.Payment_Amount, 0) AS Payment_Amount
		,	hcc.Member1_Beg
		,	hcc.Member1_Exp
		,	hcc.Member1
		,	hcc.Member_Additional
		--,	CASE WHEN (hcc.Member1_ID = 0) THEN NULL ELSE hcc.Member1_ID END AS Member1_ID
		,	ISNULL(hcc.Member1_ID,0) AS Member1_ID				--KRM 9/22/2011
		,	dbo.fx_GetCMSMembership(hcc.Member1, hcc.Member_Additional) AS CMSMembership
		,	mem.MembershipID
		,	bs.BusinessSegmentDescriptionShort
		, 	CASE WHEN mem.MembershipID = @MembershipID_CANCEL THEN @ClientMembershipStatusID_Cancel ELSE @ClientMembershipStatusID_Active END AS ClientMembershipStatusID
		,	cmBIO.Member1_ID_Temp AS BIOMember1_ID_Temp
		,	cmEXT.Member1_ID_Temp AS EXTMember1_ID_Temp
		,	cmXTR.Member1_ID_Temp AS XTRMember1_ID_Temp
		,	eft.Amount
		--,	0.00 AS Amount
		,	CASE WHEN mem.MembershipID = @MembershipID_CANCEL THEN hcc.Member1_Beg ELSE NULL END AS CancelDate
		,	ISNULL(hcc.Time1,0) AS AccumQuantityRemainingCalc
		,	ISNULL(hcc.Time1_Used,0) AS UsedAccumQuantity
		,	(ISNULL(hcc.Time1,0) + ISNULL(hcc.Time1_Used,0)) AS TotalAccumQuantity
		,	ISNULL(hcc.Time2_Used,0) AS ServicesUsedAccumQuantity
		,	(ISNULL(hcc.Time2,0) + ISNULL(hcc.Time2_Used,0)) AS ServicesTotalAccumQuantity
		,	ISNULL(hcc.Time3_Used,0) AS SolutionsUsedAccumQuantity
		,	(ISNULL(hcc.Time3,0) + ISNULL(hcc.Time3_Used,0)) AS SolutionsTotalAccumQuantity
		,	ISNULL(hcc.Time4_Used,0) AS ProductKitsUsedAccumQuantity
		,	(ISNULL(hcc.Time4,0) + ISNULL(hcc.Time4_Used,0)) AS ProductKitsTotalAccumQuantity
		,   c.SiebelID as SiebelID
	INTO #ClientData
	FROM [HCSQL2\SQL2005].Infostore.dbo.Clients hcc WITH (NOLOCK)
		LEFT JOIN datClient c WITH (NOLOCK) ON c.CenterID = hcc.Center AND c.ClientNumber_Temp = hcc.Client_No
		LEFT JOIN lkpState s WITH (NOLOCK) ON hcc.[State] = s.StateDescriptionShort
		LEFT JOIN cfgCenter ctr WITH (NOLOCK) ON hcc.Center = ctr.CenterID
		LEFT JOIN cfgConfigurationCenter cc WITH (NOLOCK) on hcc.Center = cc.CenterID
		LEFT JOIN lkpGender g WITH (NOLOCK) ON hcc.Gender = g.GenderDescriptionShort
		LEFT JOIN [HCSQL2\SQL2005].EFT.dbo.hcmtbl_EFT eft WITH (NOLOCK) ON hcc.Center = eft.Center AND hcc.Client_no = eft.Client_No
		LEFT JOIN cfgMembership mem WITH (NOLOCK) ON dbo.fx_GetCMSMembership(hcc.Member1, hcc.Member_Additional) = mem.MembershipDescriptionShort
		LEFT JOIN lkpBusinessSegment bs WITH (NOLOCK) ON mem.BusinessSegmentID = bs.BusinessSegmentID
		LEFT JOIN datClientMembership cmBIO WITH (NOLOCK) ON cmBIO.ClientMembershipGUID = c.CurrentBioMatrixClientMembershipGUID
		LEFT JOIN datClientMembership cmEXT WITH (NOLOCK) ON cmEXT.ClientMembershipGUID = c.CurrentExtremeTherapyClientMembershipGUID
		LEFT JOIN datClientMembership cmXTR WITH (NOLOCK) ON cmXTR.ClientMembershipGUID = c.CurrentXtrandsClientMembershipGUID
		--Missing Member1_IDs
		LEFT OUTER JOIN dbo.datClientMembership cm WITH (NOLOCK)
				ON hcc.Member1_ID = cm.Member1_ID_Temp
				AND c.CenterID = cm.CenterID
				AND c.ClientGUID = cm.ClientGUID
	WHERE ctr.IsActiveFlag = 1
		AND cc.HasFullAccess = 0
		AND (@CenterID IS NULL OR hcc.Center = @CenterID)
		AND (
			((hcc.CMSLastUpdate > @BeginDate AND c.LastUpdate IS NULL)
				OR (hcc.CMSLastUpdate IS NULL AND c.LastUpdate IS NULL)
				OR (hcc.CMSLastUpdate > c.LastUpdate)
				OR (cm.ClientMembershipGUID IS NULL AND hcc.CMSLastUpdate > @BeginDate AND hcc.Member1_Exp > GETDATE())
			)
		)


	CREATE CLUSTERED INDEX ix_ClientNo ON #ClientData (Center, Client_No)

	-----------------------------------------------
	-- Logging
	-----------------------------------------------
	IF @IsLoggingEnabled = 1
		INSERT INTO [HairClubCMSStaging].[dbo].[tmpInfostoreDailyImportLog] ([RunDate],[JobStep],[Timestamp],[Message])
			VALUES (GETDATE(),3,GETDATE(),'Step 3 (Client Import): Inserted Client records from Infostore into a Temp Table for Center #: ' + CAST(@CenterID as nvarchar(10)))


	-----------------------------------------------------------------------------------------------------------
	-- Update/Insert records in the datClient Table
	-----------------------------------------------------------------------------------------------------------
	-- Update client record if it exists
	UPDATE c
	SET CountryID = hcc.CountryID
		, FirstName = RTRIM(LTRIM(hcc.First_Name))
		, LastName = RTRIM(LTRIM(hcc.Last_Name))
		, Address1 = RTRIM(LTRIM(hcc.[Address]))
		, City = RTRIM(LTRIM(hcc.City))
		, StateID = hcc.StateID
		, PostalCode = RTRIM(LTRIM(hcc.Zip))
		, ARBalance = hcc.ARBalance
		, GenderID = hcc.GenderID
		, DateOfBirth = hcc.Bday
		, DoNotCallFlag = hcc.DoNotCall
		, IsTaxExemptFlag = hcc.IsTaxExempt
		, EmailAddress = RTRIM(LTRIM(hcc.Email))
		, Phone1 = RTRIM(LTRIM(hcc.HomePhone))
		, Phone2 = RTRIM(LTRIM(hcc.WPhone))
		, Phone1TypeID = hcc.Phone1TypeID
		, Phone2TypeID = hcc.Phone2TypeID
		, IsPhone1PrimaryFlag = hcc.IsPhone1PrimaryFlag
		, IsPhone2PrimaryFlag = hcc.IsPhone2PrimaryFlag
		, IsPhone3PrimaryFlag = hcc.IsPhone3PrimaryFlag
		, IsHairSystemClientFlag = hcc.IsHairSystemClientFlag
		, DoNotContactFlag = hcc.DoNotContactFlag
		, IsHairModelFlag = hcc.IsHairModelFlag
		, LastUpdate = hcc.CMSLastUpdate
		, LastUpdateUser = 'sa'
		, ImportLastUpdate = GETUTCDATE()
	FROM datClient c
		INNER JOIN #ClientData hcc WITH (NOLOCK) ON c.ClientGUID = hcc.ClientGUID


	-----------------------------------------------
	-- Logging
	-----------------------------------------------
	IF @IsLoggingEnabled = 1
		INSERT INTO [HairClubCMSStaging].[dbo].[tmpInfostoreDailyImportLog] ([RunDate],[JobStep],[Timestamp],[Message])
			VALUES (GETDATE(),3,GETDATE(),'Step 3 (Client Import): Update existing Client records for Center #: ' + CAST(@CenterID as nvarchar(10)))



	--Insert client record if it's new
	INSERT INTO datClient (ClientGUID, ClientNumber_Temp, CenterID, CountryID, ContactID, FirstName, LastName, Address1, City, StateID, PostalCode, ARBalance, GenderID, DateOfBirth, DoNotCallFlag,
		IsTaxExemptFlag, EMailAddress, Phone1, Phone2, Phone1TypeID, Phone2TypeID, IsPhone1PrimaryFlag, IsPhone2PrimaryFlag, IsPhone3PrimaryFlag, IsHairSystemClientFlag, DoNotContactFlag, IsHairModelFlag,
		CreateDate, CreateUser, LastUpdate, LastUpdateUser, ImportCreateDate, ImportLastUpdate)
	SELECT NewClientGUID, Client_No, Center, CountryID, ContactID, RTRIM(LTRIM(First_Name)), RTRIM(LTRIM(Last_Name)), RTRIM(LTRIM([Address])), RTRIM(LTRIM(City)), StateID, RTRIM(LTRIM(Zip)), ARBalance, GenderID, Bday, DoNotCall,
		IsTaxExempt, RTRIM(LTRIM(Email)), RTRIM(LTRIM(HomePhone)), RTRIM(LTRIM(WPhone)), Phone1TypeID, Phone2TypeID, IsPhone1PrimaryFlag, IsPhone2PrimaryFlag, IsPhone3PrimaryFlag, IsHairSystemClientFlag, DoNotContactFlag, IsHairModelFlag,
		ISNULL(CMSCreateDate,GETUTCDATE()), 'sa', ISNULL(CMSLastUpdate,GETUTCDATE()), 'sa', GETUTCDATE(), GETUTCDATE()
	FROM #ClientData WITH (NOLOCK)
	WHERE ClientGUID IS NULL


	-----------------------------------------------
	-- Logging
	-----------------------------------------------
	IF @IsLoggingEnabled = 1
		INSERT INTO [HairClubCMSStaging].[dbo].[tmpInfostoreDailyImportLog] ([RunDate],[JobStep],[Timestamp],[Message])
			VALUES (GETDATE(),3,GETDATE(),'Step 3 (Client Import): Insert new Client records for Center #: ' + CAST(@CenterID as nvarchar(10)))



	-- INSERT datClientMembership record for new Clients
	INSERT INTO datClientMembership (ClientMembershipGUID, Member1_ID_Temp, ClientGUID, CenterID, MembershipID, ClientMembershipStatusID, ContractPrice, ContractPaidAmount, MonthlyFee, BeginDate, EndDate, CancelDate,
		IsActiveFlag, IsGuaranteeFlag, IsRenewalFlag, IsMultipleSurgeryFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser	)
	SELECT NewClientMembershipGUID, Member1_ID, NewClientGUID, Center, MembershipID, @ClientMembershipStatusID_Active, Credit_Limit, Payment_Amount, Amount, Member1_Beg, Member1_Exp, CancelDate,
		1, 0, 0, 0, GETUTCDATE(), 'sa-new', GETUTCDATE(), 'sa'
	FROM #ClientData WITH (NOLOCK)
	WHERE ClientGUID IS NULL

	-----------------------------------------------
	-- Logging
	-----------------------------------------------
	IF @IsLoggingEnabled = 1
		INSERT INTO [HairClubCMSStaging].[dbo].[tmpInfostoreDailyImportLog] ([RunDate],[JobStep],[Timestamp],[Message])
			VALUES (GETDATE(),3,GETDATE(),'Step 3 (Client Import): Insert Client Membership records for new clients for Center #: ' + CAST(@CenterID as nvarchar(10)))


	---- INSERT datClientMembershipAccum record for new Clients
	--INSERT INTO datClientMembershipAccum (ClientMembershipAccumGUID, ClientMembershipGUID, AccumulatorID, UsedAccumQuantity, TotalAccumQuantity, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
	--	SELECT NEWID(), NewClientMembershipGUID, @AccumulatorID_BIOSystems, UsedAccumQuantity, TotalAccumQuantity, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa'
	--	FROM #ClientData WITH (NOLOCK)
	--	WHERE ClientGUID IS NULL


	-- MVT (8/2/13): Create Client Membership Accumulator records for New Clients
	INSERT INTO [datClientMembershipAccum] ([ClientMembershipAccumGUID],[ClientMembershipGUID],[AccumulatorID],[UsedAccumQuantity],[AccumMoney],[AccumDate],[TotalAccumQuantity],[CreateDate],[CreateUser],[LastUpdate], [LastUpdateUser])
	SELECT NEWID(),
		cd.NewClientMembershipGUID,
		mac.AccumulatorID,
		CASE WHEN acc.AccumulatorDescriptionShort = 'BioSys' THEN cd.UsedAccumQuantity
		WHEN acc.AccumulatorDescriptionShort = 'SERV' THEN cd.ServicesUsedAccumQuantity
		WHEN acc.AccumulatorDescriptionShort = 'SOL' THEN cd.SolutionsUsedAccumQuantity
		WHEN acc.AccumulatorDescriptionShort = 'PRODKIT' THEN cd.ProductKitsUsedAccumQuantity
		ELSE 0 END,
		0.00,
		NULL,
		CASE WHEN acc.AccumulatorDescriptionShort = 'BioSys' THEN cd.TotalAccumQuantity
		WHEN acc.AccumulatorDescriptionShort = 'SERV' THEN cd.ServicesTotalAccumQuantity
		WHEN acc.AccumulatorDescriptionShort = 'SOL' THEN cd.SolutionsTotalAccumQuantity
		WHEN acc.AccumulatorDescriptionShort = 'PRODKIT' THEN cd.ProductKitsTotalAccumQuantity
		ELSE 0 END,
		GETUTCDATE(),
		'sa' ,
		GETUTCDATE(),
		'sa'
	FROM #ClientData cd
		INNER JOIN cfgMembershipAccum mac ON mac.MembershipID = cd.MembershipId
		INNER JOIN cfgAccumulator acc ON mac.AccumulatorID = acc.AccumulatorID
	WHERE mac.IsActiveFlag = 1 AND ClientGUID IS NULL

	-----------------------------------------------
	-- Logging
	-----------------------------------------------
	IF @IsLoggingEnabled = 1
		INSERT INTO [HairClubCMSStaging].[dbo].[tmpInfostoreDailyImportLog] ([RunDate],[JobStep],[Timestamp],[Message])
			VALUES (GETDATE(),3,GETDATE(),'Step 3 (Client Import): Insert Client Membership Accum records for new clients for Center #: ' + CAST(@CenterID as nvarchar(10)))


	-- Update client record if it exists
	-- MLM (6/3/13) : Clients can now have both BioMatrix & Extreme Therapy Memberships
	UPDATE c
	SET CurrentBioMatrixClientMembershipGUID = CASE WHEN BusinessSegmentDescriptionShort = @BusinessSegment_BIO THEN NewClientMembershipGUID ELSE c.CurrentBioMatrixClientMembershipGUID END
		, CurrentExtremeTherapyClientMembershipGUID = CASE WHEN BusinessSegmentDescriptionShort = @BusinessSegment_EXTREME THEN NewClientMembershipGUID ELSE c.CurrentExtremeTherapyClientMembershipGUID END
		, CurrentXtrandsClientMembershipGUID = CASE WHEN BusinessSegmentDescriptionShort = @BusinessSegment_XTRANDS THEN NewClientMembershipGUID ELSE c.CurrentXtrandsClientMembershipGUID END
		, IsHairSystemClientFlag = CASE WHEN BusinessSegmentDescriptionShort = @BusinessSegment_BIO THEN 1 ELSE c.IsHairSystemClientFlag END
		, LastUpdate = hcc.CMSLastUpdate
		, LastUpdateUser = 'sa'
	FROM datClient c WITH (NOLOCK)
		INNER JOIN #ClientData hcc ON c.ClientGUID = hcc.NewClientGUID
	WHERE hcc.ClientGUID IS NULL


	-----------------------------------------------
	-- Logging
	-----------------------------------------------
	IF @IsLoggingEnabled = 1
		INSERT INTO [HairClubCMSStaging].[dbo].[tmpInfostoreDailyImportLog] ([RunDate],[JobStep],[Timestamp],[Message])
			VALUES (GETDATE(),3,GETDATE(),'Step 3 (Client Import): Update client record for memberships for Center #: ' + CAST(@CenterID as nvarchar(10)))


	-- We already took care of these so don't even worry about them anymore
	DELETE FROM #ClientData WHERE ClientGUID IS NULL


	-----------------------------------------------
	-- Logging
	-----------------------------------------------
	IF @IsLoggingEnabled = 1
		INSERT INTO [HairClubCMSStaging].[dbo].[tmpInfostoreDailyImportLog] ([RunDate],[JobStep],[Timestamp],[Message])
			VALUES (GETDATE(),3,GETDATE(),'Step 3 (Client Import): Removed from temp table all clients that are new for Center #: ' + CAST(@CenterID as nvarchar(10)))




	DECLARE @Client_Cursor cursor
	SET @Client_Cursor = CURSOR FAST_FORWARD FOR
		SELECT ClientGUID, Member1_ID, BusinessSegmentDescriptionShort, NewClientMembershipGUID, MembershipID,
			CASE WHEN BusinessSegmentDescriptionShort = @BusinessSegment_EXTREME THEN CurrentExtremeTherapyClientMembershipGUID
						WHEN BusinessSegmentDescriptionShort = @BusinessSegment_XTRANDS THEN CurrentXtrandsClientMembershipGUID
					ELSE CurrentBioMatrixClientMembershipGUID END AS CurClientMembershipGUID,
			CASE WHEN BusinessSegmentDescriptionShort = @BusinessSegment_EXTREME THEN EXTMember1_ID_Temp
					WHEN BusinessSegmentDescriptionShort = @BusinessSegment_XTRANDS THEN XTRMember1_ID_Temp
				ELSE BIOMember1_ID_Temp END AS CurMember1_ID_Temp,
			SiebelID
		FROM #ClientData WITH (NOLOCK)
		ORDER BY Center, Client_no

	OPEN @Client_Cursor
	FETCH NEXT FROM @Client_Cursor INTO @ClientGUID, @Member1_ID, @BusinessSegment, @NewClientMembershipGUID, @MembershipID, @CurClientMembershipGUID, @CurMember1_ID_Temp, @SiebelID

	WHILE @@FETCH_STATUS = 0
	  BEGIN
		  --Same ClientMembership or Membership Cancelled, just update
		  IF (@Member1_ID = @CurMember1_ID_Temp)
			BEGIN
				-- datClientMembership
				UPDATE cm
				SET --MembershipID = hcc.MembershipID
					ClientMembershipStatusID = hcc.ClientMembershipStatusID
					, ContractPrice = hcc.Credit_Limit
					, ContractPaidAmount = hcc.Payment_Amount
					, MonthlyFee = hcc.Amount
					, BeginDate = hcc.Member1_Beg
					, EndDate = hcc.Member1_Exp
					, CancelDate = hcc.CancelDate
					, IsActiveFlag = 1
					, LastUpdate = GETUTCDATE()
					, LastUpdateUser = 'sa'
				FROM datClientMembership cm WITH (NOLOCK)
					INNER JOIN datClient c WITH (NOLOCK) ON cm.ClientGUID = c.ClientGUID
					INNER JOIN #ClientData hcc WITH (NOLOCK) ON hcc.NewClientMembershipGUID = @NewClientMembershipGUID
				WHERE cm.ClientMembershipGUID = @CurClientMembershipGUID

				---- datClientMembershipAccum
				--UPDATE cma
				--SET UsedAccumQuantity = hcc.UsedAccumQuantity
				--	, TotalAccumQuantity = hcc.TotalAccumQuantity
				--	, LastUpdate = GETUTCDATE()
				--	, LastUpdateUser = 'sa'
				--FROM datClientMembershipAccum cma
				--	INNER JOIN datClientMembership cm WITH (NOLOCK) ON cma.ClientMembershipGUID = cm.ClientMembershipGUID
				--	INNER JOIN datClient c WITH (NOLOCK) ON cm.ClientGUID = c.ClientGUID
				--	INNER JOIN #ClientData hcc WITH (NOLOCK) ON hcc.NewClientMembershipGUID = @NewClientMembershipGUID
				--WHERE cma.ClientMembershipGUID = @CurClientMembershipGUID


				-- MVT (8/2/13): Update Accum Records from Infostore
				UPDATE cma
				SET UsedAccumQuantity = CASE WHEN acc.AccumulatorDescriptionShort = 'BioSys' THEN hcc.UsedAccumQuantity
												WHEN acc.AccumulatorDescriptionShort = 'SERV' THEN hcc.ServicesUsedAccumQuantity
												WHEN acc.AccumulatorDescriptionShort = 'SOL' THEN hcc.SolutionsUsedAccumQuantity
												WHEN acc.AccumulatorDescriptionShort = 'PRODKIT' THEN hcc.ProductKitsUsedAccumQuantity
												ELSE 0 END
					, TotalAccumQuantity = CASE WHEN acc.AccumulatorDescriptionShort = 'BioSys' THEN hcc.TotalAccumQuantity
												WHEN acc.AccumulatorDescriptionShort = 'SERV' THEN hcc.ServicesTotalAccumQuantity
												WHEN acc.AccumulatorDescriptionShort = 'SOL' THEN hcc.SolutionsTotalAccumQuantity
												WHEN acc.AccumulatorDescriptionShort = 'PRODKIT' THEN hcc.ProductKitsTotalAccumQuantity
												ELSE 0 END
					, LastUpdate = GETUTCDATE()
					, LastUpdateUser = 'sa'
				FROM datClientMembershipAccum cma
					INNER JOIN cfgAccumulator acc WITH (NOLOCK) ON acc.AccumulatorID = cma.AccumulatorID
					INNER JOIN datClientMembership cm WITH (NOLOCK) ON cma.ClientMembershipGUID = cm.ClientMembershipGUID
					INNER JOIN datClient c WITH (NOLOCK) ON cm.ClientGUID = c.ClientGUID
					INNER JOIN #ClientData hcc WITH (NOLOCK) ON hcc.NewClientMembershipGUID = @NewClientMembershipGUID
				WHERE cma.ClientMembershipGUID = @CurClientMembershipGUID

			END
		ELSE
		  BEGIN

			IF (@CurClientMembershipGUID IS NOT NULL )
				BEGIN
					-- Cancel current datClientMembership
					UPDATE cm
					SET ClientMembershipStatusID = @ClientMembershipStatusID_Cancel
						, EndDate = CASE WHEN EndDate > GETDATE() THEN GETDATE() ELSE EndDate END
						, CancelDate = GETUTCDATE()
						, IsActiveFlag = 0
						, LastUpdate = GETUTCDATE()
						, LastUpdateUser = 'sa'
					FROM datClientMembership cm
					WHERE cm.ClientMembershipGUID = @CurClientMembershipGUID
				END

			-- MLM (6/3/13) : Add New Membership if Extreme or BIO is Missing
			IF (@MembershipID <> @MembershipID_CANCEL OR @CurClientMembershipGUID IS NULL)
			  BEGIN
				-- INSERT new datClientMembership record
				INSERT INTO datClientMembership (ClientMembershipGUID, Member1_ID_Temp, ClientGUID, CenterID, MembershipID, ClientMembershipStatusID, ContractPrice, ContractPaidAmount, MonthlyFee, BeginDate, EndDate, CancelDate,
					IsActiveFlag, IsGuaranteeFlag, IsRenewalFlag, IsMultipleSurgeryFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser	)
				SELECT NewClientMembershipGUID, Member1_ID, ClientGUID, Center, MembershipID, @ClientMembershipStatusID_Active, Credit_Limit, Payment_Amount, Amount, Member1_Beg, Member1_Exp, CancelDate,
					1, 0, 0, 0, GETUTCDATE(), 'sa-cancel', GETUTCDATE(), 'sa'
				FROM #ClientData WITH (NOLOCK)
				WHERE NewClientMembershipGUID = @NewClientMembershipGUID


				------ INSERT datClientMembershipAccum record for new Membership, Bio Only
				----IF ( @BusinessSegment = @BusinessSegment_BIO )
				----	BEGIN
				----		INSERT INTO datClientMembershipAccum (ClientMembershipAccumGUID, ClientMembershipGUID, AccumulatorID, UsedAccumQuantity, TotalAccumQuantity, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
				----			SELECT NEWID(), NewClientMembershipGUID, @AccumulatorID_BIOSystems, UsedAccumQuantity, TotalAccumQuantity, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa'
				----			FROM #ClientData
				----			WHERE NewClientMembershipGUID = @NewClientMembershipGUID
				----	END

				-- MVT (8/2/13): Insert Accum memberships for EXT and BIO
				INSERT INTO [datClientMembershipAccum] ([ClientMembershipAccumGUID],[ClientMembershipGUID],[AccumulatorID],[UsedAccumQuantity],[AccumMoney],[AccumDate],[TotalAccumQuantity],[CreateDate],[CreateUser],[LastUpdate], [LastUpdateUser])
				SELECT NEWID(), cd.NewClientMembershipGUID, mac.AccumulatorID, 0, 0.00, NULL, 0,
					GETUTCDATE(), 'sa' ,GETUTCDATE(), 'sa'
				FROM #ClientData cd
					INNER JOIN cfgMembershipAccum mac ON mac.MembershipID = cd.MembershipId
				WHERE mac.IsActiveFlag = 1
					AND cd.NewClientMembershipGUID = @NewClientMembershipGUID


				-- MVT (8/14/13): Update Accum Records from Infostore
				UPDATE cma
				SET UsedAccumQuantity = CASE WHEN acc.AccumulatorDescriptionShort = 'BioSys' THEN hcc.UsedAccumQuantity
												WHEN acc.AccumulatorDescriptionShort = 'SERV' THEN hcc.ServicesUsedAccumQuantity
												WHEN acc.AccumulatorDescriptionShort = 'SOL' THEN hcc.SolutionsUsedAccumQuantity
												WHEN acc.AccumulatorDescriptionShort = 'PRODKIT' THEN hcc.ProductKitsUsedAccumQuantity
												ELSE 0 END
					, TotalAccumQuantity = CASE WHEN acc.AccumulatorDescriptionShort = 'BioSys' THEN hcc.TotalAccumQuantity
												WHEN acc.AccumulatorDescriptionShort = 'SERV' THEN hcc.ServicesTotalAccumQuantity
												WHEN acc.AccumulatorDescriptionShort = 'SOL' THEN hcc.SolutionsTotalAccumQuantity
												WHEN acc.AccumulatorDescriptionShort = 'PRODKIT' THEN hcc.ProductKitsTotalAccumQuantity
												ELSE 0 END
					, LastUpdate = GETUTCDATE()
					, LastUpdateUser = 'sa'
				FROM datClientMembershipAccum cma
					INNER JOIN cfgAccumulator acc WITH (NOLOCK) ON acc.AccumulatorID = cma.AccumulatorID
					INNER JOIN datClientMembership cm WITH (NOLOCK) ON cma.ClientMembershipGUID = cm.ClientMembershipGUID
					INNER JOIN datClient c WITH (NOLOCK) ON cm.ClientGUID = c.ClientGUID
					INNER JOIN #ClientData hcc WITH (NOLOCK) ON hcc.NewClientMembershipGUID = @NewClientMembershipGUID
				WHERE cma.ClientMembershipGUID = @NewClientMembershipGUID



				-- MLM (6/3/13) : Clients can now have both BioMatrix & Extreme Therapy Memberships
				UPDATE c
				SET CurrentBioMatrixClientMembershipGUID = CASE WHEN @BusinessSegment = @BusinessSegment_BIO THEN @NewClientMembershipGUID ELSE c.CurrentBioMatrixClientMembershipGUID END
					, CurrentExtremeTherapyClientMembershipGUID = CASE WHEN @BusinessSegment = @BusinessSegment_EXTREME THEN @NewClientMembershipGUID ELSE c.CurrentExtremeTherapyClientMembershipGUID END
					, CurrentXtrandsClientMembershipGUID = CASE WHEN @BusinessSegment = @BusinessSegment_XTRANDS THEN @NewClientMembershipGUID ELSE c.CurrentXtrandsClientMembershipGUID END
					, IsHairSystemClientFlag = CASE WHEN @BusinessSegment = @BusinessSegment_BIO THEN 1 ELSE c.IsHairSystemClientFlag END
					, LastUpdate = hcc.CMSLastUpdate
					, LastUpdateUser = 'sa'
				FROM datClient c
					INNER JOIN #ClientData hcc WITH (NOLOCK) ON c.ClientGUID = hcc.ClientGUID
				WHERE NewClientMembershipGUID = @NewClientMembershipGUID


				--INSERT RECORD INTO datRequestQueue Table if new membership is POSTEXT && Client has SiebelID
				IF ( @MembershipID = @MembershipID_POSTEXT AND @SiebelID IS NOT NULL)
					BEGIN
						EXEC extSiebelAddPostExtAddToQueue @ClientGuid
					END
			  END
		  END

		FETCH NEXT FROM @Client_Cursor INTO @ClientGUID, @Member1_ID, @BusinessSegment, @NewClientMembershipGUID, @MembershipID, @CurClientMembershipGUID, @CurMember1_ID_Temp, @SiebelID
	  END

	CLOSE @Client_Cursor
	DEALLOCATE @Client_Cursor


	-----------------------------------------------
	-- Logging
	-----------------------------------------------
	IF @IsLoggingEnabled = 1
		INSERT INTO [HairClubCMSStaging].[dbo].[tmpInfostoreDailyImportLog] ([RunDate],[JobStep],[Timestamp],[Message])
			VALUES (GETDATE(),3,GETDATE(),'Step 3 (Client Import): Completed cursor to update existing clients for Center #: ' + CAST(@CenterID as nvarchar(10)))



            /*
                Create a ClientMembership records for all clients that were created, but never had a ClientMembership record created,
                This should mainly be retail clients and old clients with missing membership transactions, just pull the data
                from the Client_Profile record instead of a transaction
                todo: need to review handling/cleanup of CANCEL memberships through this process since we don't use a CANCEL membership anymore, just a status
            */
            DECLARE @ClientsWithoutMembershipRecords TABLE  (
				ClientGUID uniqueidentifier
			)

            INSERT INTO @ClientsWithoutMembershipRecords
                SELECT c.ClientGUID
                FROM datClient c WITH (NOLOCK)
                      LEFT JOIN datClientMembership cm WITH (NOLOCK) on c.ClientGUID = cm.ClientGUID
                WHERE cm.ClientMembershipGUID IS NULL
                      AND (@CenterID IS NULL OR c.CenterID = @CenterID)


			INSERT INTO dbo.datClientMembership
				(ClientMembershipGUID
				, Member1_ID_Temp
				, ClientGUID
				, CenterID
				, MembershipID
				, ClientMembershipStatusID
				, ContractPrice
				, ContractPaidAmount
				, MonthlyFee
				, BeginDate
				, EndDate
				, MembershipCancelReasonID
				, CancelDate
				, IsGuaranteeFlag
				, IsRenewalFlag
				, IsMultipleSurgeryFlag
				, RenewalCount
				, IsActiveFlag
				, CreateDate
				, CreateUser
				, LastUpdate
				, LastUpdateUser)
			SELECT
				NEWID()
				, cp.Member1_ID
				, c.ClientGUID
				, c.CenterID
				, m.MembershipID
				, CASE WHEN m.MembershipID = 11 THEN 3 ELSE 1 END
				, ISNULL(cp.Credit_Limit,0)
				, ISNULL(cp.Payment_Amount,0)
				, 0
				, cp.Member1_Beg
				, cp.Member1_Exp
				, NULL
				, CASE WHEN m.MembershipID = 11 THEN cp.Member1_Exp ELSE NULL END
				, 1   -- IsGuaranteeFlag
				, 0   -- IsRenewalFlag
				, 0   -- IsMultipleSurgeryFlag
				, 0   -- RenewalCount
				, CASE WHEN m.MembershipID = 11 THEN 0 ELSE 1 END
				, GETUTCDATE()
				,'sa-cwom'
				, GETUTCDATE()
				, 'sa'
			FROM datClient c WITH (NOLOCK)
				  INNER JOIN @ClientsWithoutMembershipRecords cwmr ON c.ClientGUID = cwmr.ClientGUID -- INNER JOIN to this table handles the WHERE statement
				  INNER JOIN [HCSQL2\SQL2005].Infostore.dbo.Clients cp WITH (NOLOCK) on c.ClientNumber_Temp = cp.Client_no AND c.CenterID = cp.Center
				  LEFT JOIN dbo.cfgMembership m WITH (NOLOCK) ON dbo.fx_GetCMSMembership(cp.Member1, cp.Member_Additional) = m.MembershipDescriptionShort


			-----------------------------------------------
			-- Logging
			-----------------------------------------------
			IF @IsLoggingEnabled = 1
				INSERT INTO [HairClubCMSStaging].[dbo].[tmpInfostoreDailyImportLog] ([RunDate],[JobStep],[Timestamp],[Message])
					VALUES (GETDATE(),3,GETDATE(),'Step 3 (Client Import): Inserted client membership for all clients without a membership for Center #: ' + CAST(@CenterID as nvarchar(10)))


			---- INSERT datClientMembershipAccum record for new Clients
          --INSERT INTO dbo.datClientMembershipAccum (ClientMembershipAccumGUID, ClientMembershipGUID, AccumulatorID, UsedAccumQuantity, TotalAccumQuantity, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
          --      SELECT NEWID(), cm.ClientMembershipGUID, @AccumulatorID_BIOSystems, ISNULL(cp.Time1_Used,0), (ISNULL(cp.Time1,0) + ISNULL(cp.Time1_Used,0)), GETUTCDATE(),'sa' , GETUTCDATE(), 'sa'
          --      FROM datClient c
          --            INNER JOIN @ClientsWithoutMembershipRecords cwmr ON c.ClientGUID = cwmr.ClientGUID -- INNER JOIN to this table handles the WHERE statement
          --            INNER JOIN [HCSQL2\SQL2005].Infostore.dbo.Clients cp WITH (NOLOCK) on c.ClientNumber_Temp = cp.Client_no AND c.CenterID = cp.Center
          --            INNER JOIN datClientMembership cm WITH (NOLOCK) ON c.ClientGUID = cm.ClientGUID
          --            INNER JOIN cfgMembership m WITH (NOLOCK) ON cm.MembershipID = m.MembershipID
          --            INNER JOIN lkpBusinessSegment bs WITH (NOLOCK) ON m.BusinessSegmentID = bs.BusinessSegmentID
          --      WHERE bs.BusinessSegmentDescriptionShort = @BusinessSegment_BIO


			-- MVT (8/2/13): Insert all Accum records
			INSERT INTO [datClientMembershipAccum] ([ClientMembershipAccumGUID],[ClientMembershipGUID],[AccumulatorID],[UsedAccumQuantity],[AccumMoney],[AccumDate],[TotalAccumQuantity],
						[CreateDate],[CreateUser],[LastUpdate], [LastUpdateUser])
				SELECT NEWID(), cm.ClientMembershipGUID, mac.AccumulatorID, 0, 0.00, NULL, 0,
					GETUTCDATE(), 'sa' ,GETUTCDATE(), 'sa'
				FROM datClient c
                      INNER JOIN @ClientsWithoutMembershipRecords cwmr ON c.ClientGUID = cwmr.ClientGUID -- INNER JOIN to this table handles the WHERE statement
                      INNER JOIN [HCSQL2\SQL2005].Infostore.dbo.Clients cp WITH (NOLOCK) on c.ClientNumber_Temp = cp.Client_no AND c.CenterID = cp.Center
                      INNER JOIN datClientMembership cm WITH (NOLOCK) ON c.ClientGUID = cm.ClientGUID
                      INNER JOIN cfgMembership m WITH (NOLOCK) ON cm.MembershipID = m.MembershipID
					  INNER JOIN cfgMembershipAccum mac ON mac.MembershipID = m.MembershipId
				WHERE mac.IsActiveFlag = 1


			-- MVT (8/14/13): Update Accum Records from Infostore
			UPDATE cma
			SET UsedAccumQuantity = CASE WHEN acc.AccumulatorDescriptionShort = 'BioSys' THEN ISNULL(hcc.Time1_Used,0)
											WHEN acc.AccumulatorDescriptionShort = 'SERV' THEN ISNULL(hcc.Time2_Used,0)
											WHEN acc.AccumulatorDescriptionShort = 'SOL' THEN ISNULL(hcc.Time3_Used,0)
											WHEN acc.AccumulatorDescriptionShort = 'PRODKIT' THEN ISNULL(hcc.Time4_Used,0)
											ELSE 0 END
				, TotalAccumQuantity = CASE WHEN acc.AccumulatorDescriptionShort = 'BioSys' THEN (ISNULL(hcc.Time1,0) + ISNULL(hcc.Time1_Used,0))
											WHEN acc.AccumulatorDescriptionShort = 'SERV' THEN (ISNULL(hcc.Time2,0) + ISNULL(hcc.Time2_Used,0))
											WHEN acc.AccumulatorDescriptionShort = 'SOL' THEN (ISNULL(hcc.Time3,0) + ISNULL(hcc.Time3_Used,0))
											WHEN acc.AccumulatorDescriptionShort = 'PRODKIT' THEN (ISNULL(hcc.Time4,0) + ISNULL(hcc.Time4_Used,0))
											ELSE 0 END
				, LastUpdate = GETUTCDATE()
				, LastUpdateUser = 'sa'
			FROM datClientMembershipAccum cma
				INNER JOIN cfgAccumulator acc ON acc.AccumulatorID = cma.AccumulatorID
				INNER JOIN datClientMembership cm ON cm.ClientMembershipGuid = cma.ClientMembershipGuid
				INNER JOIN datClient c with (nolock) ON c.ClientGuid = cm.ClientGuid
				INNER JOIN @ClientsWithoutMembershipRecords cwmr ON c.ClientGUID = cwmr.ClientGUID
				INNER JOIN [HCSQL2\SQL2005].Infostore.dbo.Clients hcc WITH (NOLOCK) ON c.CenterID = hcc.Center AND c.ClientNumber_Temp = hcc.Client_No


			-----------------------------------------------
			-- Logging
			-----------------------------------------------
			IF @IsLoggingEnabled = 1
				INSERT INTO [HairClubCMSStaging].[dbo].[tmpInfostoreDailyImportLog] ([RunDate],[JobStep],[Timestamp],[Message])
					VALUES (GETDATE(),3,GETDATE(),'Step 3 (Client Import): Inserted client membership accums for all clients without a membership for Center #: ' + CAST(@CenterID as nvarchar(10)))


			--Update current membership on client
            UPDATE c
            SET CurrentBioMatrixClientMembershipGUID = cm.ClientMembershipGUID
                  , IsHairSystemClientFlag = 1
                  , LastUpdate = GETUTCDATE()
                  , LastUpdateUser = 'sa'
            FROM datClient c
                  INNER JOIN @ClientsWithoutMembershipRecords cwmr ON c.ClientGUID = cwmr.ClientGUID -- INNER JOIN to this table handles the WHERE statement
                  INNER JOIN datClientMembership cm WITH (NOLOCK) ON c.ClientGUID = cm.ClientGUID
                  INNER JOIN cfgMembership m WITH (NOLOCK) ON cm.MembershipID = m.MembershipID
                  INNER JOIN lkpBusinessSegment bs WITH (NOLOCK) ON m.BusinessSegmentID = bs.BusinessSegmentID
            WHERE bs.BusinessSegmentDescriptionShort = @BusinessSegment_BIO

            UPDATE c
            SET CurrentExtremeTherapyClientMembershipGUID = cm.ClientMembershipGUID
                  , LastUpdate = GETUTCDATE()
                  , LastUpdateUser = 'sa'
            FROM datClient c
                  INNER JOIN @ClientsWithoutMembershipRecords cwmr ON c.ClientGUID = cwmr.ClientGUID -- INNER JOIN to this table handles the WHERE statement
                  INNER JOIN datClientMembership cm WITH (NOLOCK) ON c.ClientGUID = cm.ClientGUID
                  INNER JOIN cfgMembership m WITH (NOLOCK) ON cm.MembershipID = m.MembershipID
                  INNER JOIN lkpBusinessSegment bs WITH (NOLOCK) ON m.BusinessSegmentID = bs.BusinessSegmentID
            WHERE bs.BusinessSegmentDescriptionShort = @BusinessSegment_EXTREME

            UPDATE c
            SET CurrentXtrandsClientMembershipGUID = cm.ClientMembershipGUID
                  , LastUpdate = GETUTCDATE()
                  , LastUpdateUser = 'sa'
            FROM datClient c
                  INNER JOIN @ClientsWithoutMembershipRecords cwmr ON c.ClientGUID = cwmr.ClientGUID -- INNER JOIN to this table handles the WHERE statement
                  INNER JOIN datClientMembership cm WITH (NOLOCK) ON c.ClientGUID = cm.ClientGUID
                  INNER JOIN cfgMembership m WITH (NOLOCK) ON cm.MembershipID = m.MembershipID
                  INNER JOIN lkpBusinessSegment bs WITH (NOLOCK) ON m.BusinessSegmentID = bs.BusinessSegmentID
            WHERE bs.BusinessSegmentDescriptionShort = @BusinessSegment_XTRANDS

			-----------------------------------------------
			-- Logging
			-----------------------------------------------
			IF @IsLoggingEnabled = 1
				INSERT INTO [HairClubCMSStaging].[dbo].[tmpInfostoreDailyImportLog] ([RunDate],[JobStep],[Timestamp],[Message])
					VALUES (GETDATE(),3,GETDATE(),'Step 3 (Client Import): Updated membership on client records for all clients that did not have a membership for Center #: ' + CAST(@CenterID as nvarchar(10)))



			-- Set the Membership Identifier for the newly added client memberships

			-- Cursor Variables
			DECLARE @mi_ClientMembershipGuid uniqueidentifier,
						@mi_ClientGUID uniqueidentifier,
						@mi_BeginDate Date,
						@mi_LastUpdate Datetime,
						@mi_LastUpdateUser nvarchar(25),
						@mi_ClientMembershipIdentifier nvarchar(50)

			DECLARE @ClientMem_Cursor cursor
			SET @ClientMem_Cursor = CURSOR FAST_FORWARD FOR
					SELECT cm.ClientMembershipGuid
					, cm.ClientGuid
					, cm.BeginDate
					FROM datClientMembership cm WITH (NOLOCK)
					WHERE cm.CenterId = @CenterID AND cm.ClientMembershipIdentifier IS NULL
					ORDER BY cm.BeginDate asc

			OPEN @ClientMem_Cursor
			FETCH NEXT FROM @ClientMem_Cursor INTO @mi_ClientMembershipGuid, @mi_ClientGUID, @mi_BeginDate
			WHILE @@FETCH_STATUS = 0
			BEGIN

				EXEC [mtnGetClientMembershipNumber] @mi_ClientGuid, @CenterID, @mi_BeginDate, @mi_ClientMembershipIdentifier OUTPUT

				UPDATE datClientMembership SET
					[ClientMembershipIdentifier] = @mi_ClientMembershipIdentifier
					, LastUpdate = GETUTCDATE()
					, LastUpdateUser = 'sa'
				WHERE ClientMembershipGUID = @mi_ClientMembershipGuid

				FETCH NEXT FROM @ClientMem_Cursor INTO @mi_ClientMembershipGuid, @mi_ClientGUID, @mi_BeginDate
			END

			CLOSE @ClientMem_Cursor
			DEALLOCATE @ClientMem_Cursor


			-----------------------------------------------
			-- Logging
			-----------------------------------------------
			IF @IsLoggingEnabled = 1
				INSERT INTO [HairClubCMSStaging].[dbo].[tmpInfostoreDailyImportLog] ([RunDate],[JobStep],[Timestamp],[Message])
					VALUES (GETDATE(),3,GETDATE(),'Step 3 (Client Import): Completed updating client membership identifier for newly inserted memberships for Center #: ' + CAST(@CenterID as nvarchar(10)))


			UPDATE cm SET
				cm.ClientMembershipStatusID = @ClientMembershipStatusID_Cancel
				,cm.LastUpdate = GETUTCDATE()
				,cm.LastUpdateUser = 'sa'
			FROM datClient c WITH (NOLOCK)
				INNER JOIN datClientMembership cm ON c.[CurrentBioMatrixClientMembershipGUID] = cm.ClientMembershipGuid
				INNER JOIN cfgMembership mem WITH (NOLOCK) ON mem.MembershipID = cm.MembershipID
				INNER JOIN lkpClientMembershipStatus stat WITH (NOLOCK) ON stat.ClientMembershipStatusID = cm.ClientMembershipStatusID
			WHERE c.CenterID = @CenterID
				AND mem.[MembershipDescriptionShort] = 'CANCEL'
				AND stat.ClientMembershipStatusDescriptionShort = 'I'


			UPDATE cm SET
				cm.ClientMembershipStatusID = @ClientMembershipStatusID_Cancel
				,cm.LastUpdate = GETUTCDATE()
				,cm.LastUpdateUser = 'sa'
			FROM datClient c WITH (NOLOCK)
				INNER JOIN datClientMembership cm ON c.[CurrentExtremeTherapyClientMembershipGUID] = cm.ClientMembershipGuid
				INNER JOIN cfgMembership mem WITH (NOLOCK) ON mem.MembershipID = cm.MembershipID
				INNER JOIN lkpClientMembershipStatus stat WITH (NOLOCK) ON stat.ClientMembershipStatusID = cm.ClientMembershipStatusID
			WHERE c.CenterID = @CenterID
				AND mem.[MembershipDescriptionShort] = 'CANCEL'
				AND stat.ClientMembershipStatusDescriptionShort = 'I'


				-----------------------------------------------
			-- Logging
			-----------------------------------------------
			IF @IsLoggingEnabled = 1
				INSERT INTO [HairClubCMSStaging].[dbo].[tmpInfostoreDailyImportLog] ([RunDate],[JobStep],[Timestamp],[Message])
					VALUES (GETDATE(),3,GETDATE(),'Step 3 (Client Import): Updated membership Status for CANCEL Inactive client memberships for Center #: ' + CAST(@CenterID as nvarchar(10)))



  /*
SELECT * FROM datClient WHERE ClientNumber_Temp IN (4,5) AND CenterID = 201
SELECT cm.* FROM datClient c INNER JOIN datClientMembership cm ON c.ClientGUID = cm.ClientGUID WHERE ClientNumber_Temp IN (4,5) AND c.CenterID = 201 order by c.ClientNumber_Temp, cm.CreateDate desc
SELECT cma.* FROM datClient c INNER JOIN datClientMembership cm ON c.ClientGUID = cm.ClientGUID INNER JOIN datClientMembershipAccum cma ON cm.ClientMembershipGUID = cma.ClientMembershipGUID WHERE ClientNumber_Temp IN (4,5) AND c.CenterID = 201 order by c.ClientNumber_Temp, cm.CreateDate desc
  */

  /*
update datClient set CurrentBioMatrixClientMembershipGUID = null, CurrentExtremeTherapyClientMembershipGUID = null WHERE ClientNumber_Temp IN (4,5) AND CenterID = 201
delete from datClientMembershipAccum where ClientmembershipGUID in (select ClientmembershipGUID FROM datClient c INNER JOIN datClientMembership cm ON c.ClientGUID = cm.ClientGUID WHERE ClientNumber_Temp IN (4,5) AND c.CenterID = 201)
delete from datClientMembership where ClientGUID in (select ClientGUID FROM datClient WHERE ClientNumber_Temp IN (4,5) AND CenterID = 201)
DELETE FROM datClient WHERE ClientNumber_Temp IN (4,5) AND CenterID = 201
  */

  /*
UPDATE INFOSTORE..Clients
SET CMSLastUpdate = DATEADD(M, 1, CMSLastUpdate),
	Member1 = 'CANCEL',
	Member2 = NULL,
	Member1_ID = Member1_ID + 1
WHERE Center = 201
	AND Client_no = 4
  */

END
