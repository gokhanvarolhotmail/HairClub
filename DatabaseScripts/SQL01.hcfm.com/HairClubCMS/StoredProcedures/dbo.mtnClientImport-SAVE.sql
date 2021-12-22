/*
==============================================================================
PROCEDURE:				mtnClientImport

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		 2/10/2010

LAST REVISION DATE: 	 2/10/2010

==============================================================================
DESCRIPTION:	Complete Hair System Allocation
==============================================================================
NOTES:
		* 10/19/10 PRM - Created Stored Proc

==============================================================================
SAMPLE EXECUTION:
EXEC mtnClientImport 233, 0
==============================================================================
*/
CREATE PROCEDURE [dbo].[mtnClientImport-SAVE]
	@CenterID int = NULL,
	@IncludeRequiredClients bit = 0
AS
BEGIN
	DECLARE @BeginDate datetime = '7/1/2007'

	DECLARE @Member1_ID int, @CurMember1_ID_Temp int, @MembershipID int, @BusinessSegment nvarchar(50), @NewClientMembershipGUID uniqueidentifier, @CurClientMembershipGUID uniqueidentifier

	DECLARE @BusinessSegment_BIO nvarchar(50) = 'BIO'
	DECLARE @BusinessSegment_EXTREME nvarchar(50) = 'EXTREME'

	DECLARE @ClientMembershipStatusID_Active int, @ClientMembershipStatusID_Cancel int
	DECLARE @AccumulatorID_BIOSystems int
	DECLARE @MembershipID_CANCEL int

	SELECT @ClientMembershipStatusID_Active = ClientMembershipStatusID FROM lkpClientMembershipStatus WHERE ClientMembershipStatusDescriptionShort = 'A'
	SELECT @ClientMembershipStatusID_Cancel = ClientMembershipStatusID FROM lkpClientMembershipStatus WHERE ClientMembershipStatusDescriptionShort = 'C'
	SELECT @AccumulatorID_BIOSystems = AccumulatorID FROM cfgAccumulator WHERE AccumulatorDescriptionShort = 'BioSys'
	SELECT @MembershipID_CANCEL = MembershipID FROM cfgMembership WHERE MembershipDescriptionShort = 'CANCEL'


	--IF OBJECT_ID(N'tempdb..#ClientData', N'U') IS NOT NULL
	--  BEGIN
	--	DROP TABLE #ClientData
	--  END

	-------------------------------------------------------------------------------------------------------
	-- Select Client records from Infostore..Clients, and put into a temp table
	-------------------------------------------------------------------------------------------------------
	SELECT hcc.Center, c.ClientGUID AS ClientGUID, NEWID() AS NewClientGUID, c.CurrentBioMatrixClientMembershipGUID, c.CurrentExtremeTherapyClientMembershipGUID, NEWID() AS NewClientMembershipGUID,
		hcc.Client_no, hcc.Last_Name, hcc.First_Name, hcc.[Address], hcc.City, hcc.[State], ISNULL(s.StateID, ctr.StateID) AS StateID, ISNULL(s.CountryID, ctr.CountryID) AS CountryID, hcc.Zip,
		RTRIM(CAST(hcc.HPhoneAc AS CHAR)) + RTRIM(CAST(hcc.HPhone AS CHAR)) AS HomePhone, hcc.WPhone, 1 AS Phone1TypeID, 2 AS Phone2TypeID, 1 AS IsPhone1PrimaryFlag, 0 AS IsPhone2PrimaryFlag, 0 AS IsPhone3PrimaryFlag,
		0 AS IsHairSystemClientFlag, 0 AS DoNotContactFlag, 0 AS IsHairModelFlag, hcc.ContactID, ISNULL(hcc.Balance, 0) AS ARBalance,
		ISNULL(hcc.Gender, 'Unknown') AS Gender, ISNULL(g.GenderID, 3) AS GenderID, hcc.Bday, hcc.DoNotCall, hcc.IsTaxExempt, hcc.Email,
		hcc.CMSCreateDate, hcc.CMSCreateID, hcc.CMSLastUpdate, hcc.CMSLastUpdateID, ISNULL(hcc.Credit_Limit, 0) AS Credit_Limit, ISNULL(hcc.Payment_Amount, 0) AS Payment_Amount,
		hcc.Member1_Beg, hcc.Member1_Exp, hcc.Member1, hcc.Member_Additional, CASE WHEN (hcc.Member1_ID = 0) THEN NULL ELSE hcc.Member1_ID END AS Member1_ID,
		dbo.fx_GetCMSMembership(hcc.Member1, hcc.Member_Additional) AS CMSMembership, mem.MembershipID, bs.BusinessSegmentDescriptionShort,
		CASE WHEN mem.MembershipID = @MembershipID_CANCEL THEN @ClientMembershipStatusID_Cancel ELSE @ClientMembershipStatusID_Active END AS ClientMembershipStatusID,
		cmBIO.BeginDate AS BIOBeginDate, cmBIO.EndDate AS BIOEndDate, cmBIO.MembershipID AS BIOMembershipID, cmBIO.Member1_ID_Temp AS BIOMember1_ID_Temp,
		cmEXT.BeginDate AS EXTBeginDate, cmEXT.EndDate AS EXTEndDate, cmEXT.MembershipID AS EXTMembershipID, cmEXT.Member1_ID_Temp AS EXTMember1_ID_Temp,
		--, eft.Amount fixme: uncomment this once we have a database
		0.00 AS Amount , CASE WHEN mem.MembershipID = @MembershipID_CANCEL THEN hcc.Member1_Beg ELSE NULL END AS CancelDate,
		ISNULL(hcc.Time1,0) AS AccumQuantityRemainingCalc, ISNULL(hcc.Time1_Used,0) AS UsedAccumQuantity, (ISNULL(hcc.Time1,0) + ISNULL(hcc.Time1_Used,0)) AS TotalAccumQuantity
	INTO #ClientData
	FROM [HCSQL2\SQL2005].Infostore.dbo.Clients hcc
		LEFT JOIN datClient c ON c.CenterID = hcc.Center AND c.ClientNumber_Temp = hcc.Client_No
		LEFT JOIN lkpState s ON hcc.[State] = s.StateDescriptionShort
		LEFT JOIN cfgCenter ctr ON hcc.Center = ctr.CenterID
		LEFT JOIN lkpGender g ON hcc.Gender = g.GenderDescriptionShort
		LEFT JOIN HairSystemOrderClientImport_Temp.dbo.tmpClientImport hcci ON hcc.center = hcci.CenterID AND hcc.client_no = hcci.Client_No
		--LEFT JOIN EFT.dbo.hcmtbl_EFT eft ON hcc.Center = eft.Center AND hcc.Client_no = eft.Client_No
		LEFT JOIN cfgMembership mem ON dbo.fx_GetCMSMembership(hcc.Member1, hcc.Member_Additional) = mem.MembershipDescriptionShort
		LEFT JOIN lkpBusinessSegment bs ON mem.BusinessSegmentID = bs.BusinessSegmentID
		LEFT JOIN datClientMembership cmBIO ON cmBIO.ClientMembershipGUID = c.CurrentBioMatrixClientMembershipGUID
		LEFT JOIN datClientMembership cmEXT ON cmEXT.ClientMembershipGUID = c.CurrentExtremeTherapyClientMembershipGUID

	WHERE ctr.IsActiveFlag = 1
		AND (@CenterID IS NULL OR hcc.Center = @CenterID)
		AND ((
			((hcc.CMSLastUpdate > @BeginDate AND c.LastUpdate IS NULL)
				OR (hcc.CMSLastUpdate IS NULL AND c.LastUpdate IS NULL)
				OR (hcc.CMSLastUpdate > c.LastUpdate))
			AND (mem.MembershipID <> @MembershipID_CANCEL AND c.ClientGUID IS NULL)
		) OR
			(@IncludeRequiredClients = 1 AND hcci.CenterID IS NOT NULL) -- AND hcci.Client_No IS NOT NULL
		)

	ORDER BY hcc.Center, hcc.Client_no


	CREATE CLUSTERED INDEX ix_ClientNo ON #ClientData (Center, Client_No)


	-----------------------------------------------------------------------------------------------------------
	-- Update/Insert records in the datClient Table
	-----------------------------------------------------------------------------------------------------------
	-- Update client record if it exists
	UPDATE c
	SET CountryID = hcc.CountryID
		, FirstName = hcc.First_Name
		, LastName = hcc.Last_Name
		, Address1 = hcc.[Address]
		, City = hcc.City
		, StateID = hcc.StateID
		, PostalCode = hcc.Zip
		, ARBalance = hcc.ARBalance
		, GenderID = hcc.GenderID
		, DateOfBirth = hcc.Bday
		, DoNotCallFlag = hcc.DoNotCall
		, IsTaxExemptFlag = hcc.IsTaxExempt
		, EmailAddress = hcc.Email
		, Phone1 = hcc.HomePhone
		, Phone2 = hcc.WPhone
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
	FROM datClient c
		INNER JOIN #ClientData hcc ON c.ClientGUID = hcc.ClientGUID


	--Insert client record if it's new
	INSERT INTO datClient (ClientGUID, ClientNumber_Temp, CenterID, CountryID, ContactID, FirstName, LastName, Address1, City, StateID, PostalCode, ARBalance, GenderID, DateOfBirth, DoNotCallFlag,
		IsTaxExemptFlag, EMailAddress, Phone1, Phone2, Phone1TypeID, Phone2TypeID, IsPhone1PrimaryFlag, IsPhone2PrimaryFlag, IsPhone3PrimaryFlag, IsHairSystemClientFlag, DoNotContactFlag, IsHairModelFlag,
		CreateDate, CreateUser, LastUpdate, LastUpdateUser)
	SELECT NewClientGUID, Client_No, Center, CountryID, ContactID, First_Name, Last_Name, [Address], City, StateID, Zip, ARBalance, GenderID, Bday, DoNotCall,
		IsTaxExempt, Email, HomePhone, WPhone, Phone1TypeID, Phone2TypeID, IsPhone1PrimaryFlag, IsPhone2PrimaryFlag, IsPhone3PrimaryFlag, IsHairSystemClientFlag, DoNotContactFlag, IsHairModelFlag,
		CMSLastUpdate, 'sa', CMSLastUpdate, 'sa'
	FROM #ClientData
	WHERE ClientGUID IS NULL

	-- INSERT datClientMembership record for new Clients
	INSERT INTO datClientMembership (ClientMembershipGUID, Member1_ID_Temp, ClientGUID, CenterID, MembershipID, ClientMembershipStatusID, ContractPrice, ContractPaidAmount, MonthlyFee, BeginDate, EndDate, CancelDate,
		IsActiveFlag, IsGuaranteeFlag, IsRenewalFlag, IsMultipleSurgeryFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser	)
	SELECT NewClientMembershipGUID, Member1_ID, NewClientGUID, Center, MembershipID, @ClientMembershipStatusID_Active, Credit_Limit, Payment_Amount, Amount, Member1_Beg, Member1_Exp, CancelDate,
		1, 0, 0, 0, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa'
	FROM #ClientData
	WHERE ClientGUID IS NULL

	-- INSERT datClientMembershipAccum record for new Clients
	INSERT INTO datClientMembershipAccum (ClientMembershipAccumGUID, ClientMembershipGUID, AccumulatorID, UsedAccumQuantity, TotalAccumQuantity, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT NEWID(), NewClientMembershipGUID, @AccumulatorID_BIOSystems, UsedAccumQuantity, TotalAccumQuantity, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa'
		FROM #ClientData
		WHERE ClientGUID IS NULL

	-- Update client record if it exists
	UPDATE c
	SET CurrentBioMatrixClientMembershipGUID = CASE WHEN BusinessSegmentDescriptionShort = @BusinessSegment_BIO THEN NewClientMembershipGUID ELSE NULL END
		, CurrentExtremeTherapyClientMembershipGUID = CASE WHEN BusinessSegmentDescriptionShort = @BusinessSegment_EXTREME THEN NewClientMembershipGUID ELSE NULL END
		, IsHairSystemClientFlag = CASE WHEN BusinessSegmentDescriptionShort = @BusinessSegment_BIO THEN 1 ELSE 0 END
		, LastUpdate = hcc.CMSLastUpdate
		, LastUpdateUser = 'sa'
	FROM datClient c
		INNER JOIN #ClientData hcc ON c.ClientGUID = hcc.NewClientGUID
	WHERE hcc.ClientGUID IS NULL

	-- We already took care of these so don't even worry about them anymore
	DELETE FROM #ClientData WHERE ClientGUID IS NULL



	DECLARE @Client_Cursor cursor
	SET @Client_Cursor = CURSOR FAST_FORWARD FOR
		SELECT Member1_ID, BusinessSegmentDescriptionShort, NewClientMembershipGUID, MembershipID,
		CASE WHEN CurrentBioMatrixClientMembershipGUID IS NOT NULL THEN CurrentBioMatrixClientMembershipGUID ELSE CurrentExtremeTherapyClientMembershipGUID END AS CurClientMembershipGUID,
		CASE WHEN CurrentBioMatrixClientMembershipGUID IS NOT NULL THEN BIOMember1_ID_Temp ELSE EXTMember1_ID_Temp END AS CurMember1_ID_Temp
		FROM #ClientData
		ORDER BY Center, Client_no

	OPEN @Client_Cursor
	FETCH NEXT FROM @Client_Cursor INTO @Member1_ID, @BusinessSegment, @NewClientMembershipGUID, @MembershipID, @CurClientMembershipGUID, @CurMember1_ID_Temp

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
				FROM datClientMembership cm
					INNER JOIN datClient c ON cm.ClientGUID = c.ClientGUID
					INNER JOIN #ClientData hcc ON hcc.NewClientMembershipGUID = @NewClientMembershipGUID
				WHERE cm.ClientMembershipGUID = @CurClientMembershipGUID

				-- datClientMembershipAccum
				UPDATE cma
				SET UsedAccumQuantity = hcc.UsedAccumQuantity
					, TotalAccumQuantity = hcc.TotalAccumQuantity
					, LastUpdate = GETUTCDATE()
					, LastUpdateUser = 'sa'
				FROM datClientMembershipAccum cma
					INNER JOIN datClientMembership cm ON cma.ClientMembershipGUID = cm.ClientMembershipGUID
					INNER JOIN datClient c ON cm.ClientGUID = c.ClientGUID
					INNER JOIN #ClientData hcc ON hcc.NewClientMembershipGUID = @NewClientMembershipGUID
				WHERE cma.ClientMembershipGUID = @CurClientMembershipGUID
			END
		ELSE
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

			IF (@MembershipID <> @MembershipID_CANCEL)
			  BEGIN
				-- INSERT new datClientMembership record
				INSERT INTO datClientMembership (ClientMembershipGUID, Member1_ID_Temp, ClientGUID, CenterID, MembershipID, ClientMembershipStatusID, ContractPrice, ContractPaidAmount, MonthlyFee, BeginDate, EndDate, CancelDate,
					IsActiveFlag, IsGuaranteeFlag, IsRenewalFlag, IsMultipleSurgeryFlag, CreateDate, CreateUser, LastUpdate, LastUpdateUser	)
				SELECT NewClientMembershipGUID, Member1_ID, ClientGUID, Center, MembershipID, @ClientMembershipStatusID_Active, Credit_Limit, Payment_Amount, Amount, Member1_Beg, Member1_Exp, CancelDate,
					1, 0, 0, 0, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa'
				FROM #ClientData
				WHERE NewClientMembershipGUID = @NewClientMembershipGUID

				-- INSERT datClientMembershipAccum record for new Membership
				INSERT INTO datClientMembershipAccum (ClientMembershipAccumGUID, ClientMembershipGUID, AccumulatorID, UsedAccumQuantity, TotalAccumQuantity, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
					SELECT NEWID(), NewClientMembershipGUID, @AccumulatorID_BIOSystems, UsedAccumQuantity, TotalAccumQuantity, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa'
					FROM #ClientData
					WHERE NewClientMembershipGUID = @NewClientMembershipGUID

				UPDATE c
				SET CurrentBioMatrixClientMembershipGUID = CASE WHEN @BusinessSegment = @BusinessSegment_BIO THEN @NewClientMembershipGUID ELSE NULL END
					, CurrentExtremeTherapyClientMembershipGUID = CASE WHEN @BusinessSegment = @BusinessSegment_EXTREME THEN @NewClientMembershipGUID ELSE NULL END
					, IsHairSystemClientFlag = CASE WHEN @BusinessSegment = @BusinessSegment_BIO THEN 1 ELSE 0 END
					, LastUpdate = hcc.CMSLastUpdate
					, LastUpdateUser = 'sa'
				FROM datClient c
					INNER JOIN #ClientData hcc ON c.ClientGUID = hcc.ClientGUID
				WHERE NewClientMembershipGUID = @NewClientMembershipGUID
			  END
		  END

		FETCH NEXT FROM @Client_Cursor INTO @Member1_ID, @BusinessSegment, @NewClientMembershipGUID, @MembershipID, @CurClientMembershipGUID, @CurMember1_ID_Temp
	  END

	CLOSE @Client_Cursor
	DEALLOCATE @Client_Cursor



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
                FROM datClient c
                      LEFT JOIN datClientMembership cm on c.ClientGUID = cm.ClientGUID
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
				,'sa'
				, GETUTCDATE()
				, 'sa'
			FROM datClient c
				  INNER JOIN @ClientsWithoutMembershipRecords cwmr ON c.ClientGUID = cwmr.ClientGUID -- INNER JOIN to this table handles the WHERE statement
				  INNER JOIN [HCSQL2\SQL2005].Infostore.dbo.Clients cp on c.ClientNumber_Temp = cp.Client_no AND c.CenterID = cp.Center
				  LEFT JOIN dbo.cfgMembership m ON dbo.fx_GetCMSMembership(cp.Member1, cp.Member_Additional) = m.MembershipDescriptionShort


          -- INSERT datClientMembershipAccum record for new Clients
          INSERT INTO dbo.datClientMembershipAccum (ClientMembershipAccumGUID, ClientMembershipGUID, AccumulatorID, UsedAccumQuantity, TotalAccumQuantity, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
                SELECT NEWID(), cm.ClientMembershipGUID, @AccumulatorID_BIOSystems, ISNULL(cp.Time1_Used,0), (ISNULL(cp.Time1,0) + ISNULL(cp.Time1_Used,0)), GETUTCDATE(),'sa' , GETUTCDATE(), 'sa'
                FROM datClient c
                      INNER JOIN @ClientsWithoutMembershipRecords cwmr ON c.ClientGUID = cwmr.ClientGUID -- INNER JOIN to this table handles the WHERE statement
                      INNER JOIN [HCSQL2\SQL2005].Infostore.dbo.Clients cp on c.ClientNumber_Temp = cp.Client_no AND c.CenterID = cp.Center
                      INNER JOIN datClientMembership cm ON c.ClientGUID = cm.ClientGUID
                      INNER JOIN cfgMembership m ON cm.MembershipID = m.MembershipID
                      INNER JOIN lkpBusinessSegment bs ON m.BusinessSegmentID = bs.BusinessSegmentID
                WHERE bs.BusinessSegmentDescriptionShort = @BusinessSegment_BIO

			--Update current membership on client
            UPDATE c
            SET CurrentBioMatrixClientMembershipGUID = cm.ClientMembershipGUID
                  , IsHairSystemClientFlag = 1
                  , LastUpdate = GETUTCDATE()
                  , LastUpdateUser = 'sa'
            FROM datClient c
                  INNER JOIN @ClientsWithoutMembershipRecords cwmr ON c.ClientGUID = cwmr.ClientGUID -- INNER JOIN to this table handles the WHERE statement
                  INNER JOIN datClientMembership cm ON c.ClientGUID = cm.ClientGUID
                  INNER JOIN cfgMembership m ON cm.MembershipID = m.MembershipID
                  INNER JOIN lkpBusinessSegment bs ON m.BusinessSegmentID = bs.BusinessSegmentID
            WHERE bs.BusinessSegmentDescriptionShort = @BusinessSegment_BIO

            UPDATE c
            SET CurrentExtremeTherapyClientMembershipGUID = cm.ClientMembershipGUID
                  , LastUpdate = GETUTCDATE()
                  , LastUpdateUser = 'sa'
            FROM datClient c
                  INNER JOIN @ClientsWithoutMembershipRecords cwmr ON c.ClientGUID = cwmr.ClientGUID -- INNER JOIN to this table handles the WHERE statement
                  INNER JOIN datClientMembership cm ON c.ClientGUID = cm.ClientGUID
                  INNER JOIN cfgMembership m ON cm.MembershipID = m.MembershipID
                  INNER JOIN lkpBusinessSegment bs ON m.BusinessSegmentID = bs.BusinessSegmentID
            WHERE bs.BusinessSegmentDescriptionShort <> @BusinessSegment_BIO

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
