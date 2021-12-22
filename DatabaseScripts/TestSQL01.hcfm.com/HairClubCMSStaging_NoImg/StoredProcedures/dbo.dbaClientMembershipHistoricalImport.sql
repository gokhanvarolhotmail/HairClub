/* CreateDate: 12/31/2010 13:35:54.217 , ModifyDate: 02/27/2017 09:49:15.710 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================
PROCEDURE:                    dbaClientMembershipHistoricalImport

DESTINATION SERVER:           SQL01

DESTINATION DATABASE:   HairClubCMS

RELATED APPLICATION:    CMS

AUTHOR:                       Mike Maass

IMPLEMENTOR:                  Mike Maass

DATE IMPLEMENTED:              11/08/2010

LAST REVISION DATE:      11/08/2010

==============================================================================
DESCRIPTION:      Run once to import non-surgery Clients & Client Memberships
==============================================================================
NOTES:
            * 11/08/2010 MM  - Created Stored Proc
			* 11/18/2010 MM  - Added @CenterID to the WHERE Clause in the Cursor
			* 11/23/2010 PRM - Removed part of WHERE clause so all Clients with any transaction (not just membership transactions) are returned
			* 12/15/2010 MM  - Fixed issue with Member1_ID value not being imported correctly
			* 03/02/2015 MVT - Updated proc for Xtrands Business Segment
==============================================================================
SAMPLE EXECUTION:
EXEC dbaClientMembershipHistoricalImport 804
==============================================================================
*/
CREATE PROCEDURE [dbo].[dbaClientMembershipHistoricalImport]
      @CenterID int = NULL
AS
BEGIN

      --DELETE datClient WHERE (@CenterID IS NULL OR CenterID = @CenterID) -- would have to delete a lot more records to make this useful (cm, so, hso, etc)

      DECLARE @StartDate datetime = '7/1/2007'

      DECLARE @BusinessSegment_BIO nvarchar(50) = 'BIO'
      DECLARE @BusinessSegment_EXTREME nvarchar(50) = 'EXTREME'
      DECLARE @BusinessSegment_XTR nvarchar(50) = 'XTR'

      DECLARE @AccumulatorID_BIOSystems int
      SELECT @AccumulatorID_BIOSystems = AccumulatorID FROM dbo.cfgAccumulator WHERE AccumulatorDescriptionShort = 'BioSys'

      INSERT INTO dbo.datClient(
                        ClientGUID
                        ,ClientNumber_Temp
                        ,CenterID
                        ,CountryID
                        ,ContactID
                        ,FirstName
                        ,LastName
                        ,Address1
                        ,City
                        ,StateID
                        ,PostalCode
                        ,ARBalance
                        ,GenderID
                        ,DateOfBirth
                        ,DoNotCallFlag
                        ,IsHairModelFlag
                        ,IsTaxExemptFlag
                        ,EMailAddress
                        ,Phone1
                        ,Phone2
                        ,Phone1TypeID
                        ,Phone2TypeID
                        ,IsPhone1PrimaryFlag
                        ,IsPhone2PrimaryFlag
                        ,IsPhone3PrimaryFlag
                        ,IsHairSystemClientFlag
                        ,DoNotContactFlag
                        ,CreateDate
                        ,CreateUser
                        ,LastUpdate
                        ,LastUpdateUser)
      Select NEWID()
            ,*
      FROM (
      SELECT Distinct cp.Client_no as Client_no
            ,cp.Center as Center
            ,ISNULL(s.CountryID, ctr.CountryID) as CountryID
            ,cp.[ContactID]
            ,cp.[First_Name]
            ,cp.[Last_Name]
            ,cp.[Address]
            ,cp.[City]
            ,ISNULL(s.StateID, ctr.StateID) as StateID
            ,cp.[Zip]
            ,ISNULL(cp.Balance, 0) as ARBalance
            ,ISNULL(g.GenderID, 1) AS GenderID --changed to make null male
            ,cp.[Bday]
            ,cp.[DoNotCall]
            ,cp.Ishairmodel as IsHairModelFlag
            ,cp.[IsTaxExempt]
            ,cp.[Email]
            ,RTRIM(CAST(cp.HPhoneAc AS CHAR)) + RTRIM(CAST(cp.HPhone AS CHAR)) AS HomePhone
            ,cp.WPhone
            ,1 AS Phone1TypeID
            ,2 AS Phone2TypeID
            ,1 AS IsPhone1PrimaryFlag
            ,0 AS IsPhone2PrimaryFlag
            ,0 AS IsPhone3PrimaryFlag
            ,0 AS IsHairSystemClientFlag
            ,0 AS DoNotContactFlag
            ,cp.[CMSCreateDate] as CreateDate
            ,'sa' as CreateUser
            ,cp.[CMSLastUpdate] as LastUpdate
            ,'sa' as LastUpdateUser
      FROM	[HCSQL2\SQL2005].Infostore.dbo.clients cp
			--[HCSQL2\SQL2005].Infostore.dbo.Transactions  trans
            --INNER JOIN [HCSQL2\SQL2005].Infostore.dbo.Clients cp on trans.client_no = cp.Client_no AND trans.Center = cp.Center
            INNER JOIN HairSystemOrderConv_Temp.dbo.FOClients0707 on cp.Center = FOClients0707.center and
                        cp.client_no = FOClients0707.client_no
            LEFT OUTER JOIN dbo.lkpState s on cp.[State] = s.StateDescriptionShort
            LEFT OUTER JOIN dbo.cfgCenter ctr ON cp.[Center] = ctr.CenterID
            INNER JOIN dbo.lkpGender g ON cp.Gender = g.GenderDescriptionShort
      WHERE
			--trans.[Date] >= @StartDate
            (@CenterID IS NULL OR cp.Center = @CenterID)) results
			--AND trans.ticket_no = trans.Member1_ID -- got rid of this so we get all clients with tickets after start date even if their initial membership transaction was prior to this date



      -- Cursor Variables
      DECLARE @InsertMembership bit,
                  @PreviousMembershipGUID char(36),
                  @PreviousMembershipID integer,
                  @PreviousClientGUID char(36),
                  @RenewalFlag bit,
                  @RenewalCount integer,
                  @ClientMembershipGUID char(36),
                  @ClientRowNumber integer,
                  @Client_Number integer,
                  @Member1_ID integer,
                  @ClientGUID char(36),
                  @CenterID2 integer,
                  @MembershipID integer,
                  @ClientMembershipStatusID integer,
                  @ContractPrice money,
                  @ContractPaidAmount money,
                  @MonthlyFee money,
                  @BeginDate datetime,
                  @EndDate datetime,
                  @MembershipCancelReasonID integer,
                  @CancelDate datetime,
                  @IsActiveFlag bit,
                  @UsedAccumQuantity int,
                  @TotalAccumQuantity int,
                  @TransNumber int,
                  @BusinessSegmentDescriptionShort nvarchar(10)

            DECLARE @Client_Cursor cursor
            SET @Client_Cursor = CURSOR FAST_FORWARD FOR
                  SELECT RANK() over (Partition by trans.center,trans.client_no Order by trans.transact_no) as Client_rowNumber
                              ,trans.transact_no
                              ,CASE WHEN (cp.Member1_ID = 0) THEN NULL ELSE cp.Member1_ID END AS Member1_ID
                              ,trans.Client_no
                              ,client.ClientGUID
                              ,trans.Center
                              ,mem.MembershipID
                              ,CASE WHEN mem.MembershipID = 11 THEN 3
                                    ELSE 1
                              END as ClientMemberhipStatusID
                              ,ISNULL(trans.Member1_Price, 0) AS Credit_Limit
                              ,ISNULL(cp.Payment_Amount, 0) AS Payment_Amount
                              ,0.00 as Amount
                              ,trans.[Date]
                              ,cp.Member1_Exp
                              ,NULL
                              ,CASE WHEN mem.MembershipID = 11 THEN cp.Member1_Beg ELSE NULL END AS CancelDate
                              ,CASE WHEN mem.MembershipID = 11 then 0 else 1 end as IsActiveFlag
                              ,ISNULL(cp.Time1_Used,0) AS UsedAccumQuantity
                              ,(ISNULL(cp.Time1,0) + ISNULL(cp.Time1_Used,0)) AS TotalAccumQuantity
                              ,bs.BusinessSegmentDescriptionShort
                  FROM [HCSQL2\SQL2005].Infostore.dbo.Transactions  trans
                        INNER JOIN [HCSQL2\SQL2005].Infostore.dbo.Clients cp on trans.client_no = cp.Client_no AND trans.Center = cp.Center
                        INNER JOIN dbo.datClient client on cp.Client_no = client.ClientNumber_Temp and trans.Center = client.CenterID
                        LEFT JOIN dbo.cfgMembership mem ON dbo.fx_GetCMSMembership(trans.Member1, cp.Member_Additional) = mem.MembershipDescriptionShort
                        LEFT JOIN dbo.lkpBusinessSegment bs ON mem.BusinessSegmentID = bs.BusinessSegmentID
                  WHERE (trans.ticket_no = trans.Member1_ID) AND (@CenterID IS NULL OR trans.Center = @CenterID) and
							(trans.member1_id <> 0)
                  ORDER BY trans.center,trans.client_no, trans.transact_no

                  OPEN @Client_Cursor
                  FETCH NEXT FROM @Client_Cursor INTO @ClientRowNumber,@TransNumber,@Member1_ID,@Client_Number,@ClientGUID,@CenterID2,@MembershipID,@ClientMembershipStatusID,@ContractPrice,@ContractPaidAmount,@MonthlyFee,@BeginDate,@EndDate,@MembershipCancelReasonID,@CancelDate,@IsActiveFlag,@UsedAccumQuantity,@TotalAccumQuantity, @BusinessSegmentDescriptionShort
            WHILE @@FETCH_STATUS = 0
              BEGIN

                        SET @ClientMembershipGUID = NEWID()
                        SET @InsertMembership = 1

                        -- Check For Renewals, Membership must be active
                        IF (@ClientRowNumber <> 1 )
                        BEGIN
							-- Membership has been Cancelled
							if ( @MembershipID = 11)
							BEGIN
								-- Update Previous MemberShip With Correct Status And EndDate
								UPDATE dbo.datClientMembership
									  SET IsActiveFlag = 0,
											ContractPrice = @ContractPrice,
											ContractPaidAmount = @ContractPaidAmount,
											ClientMembershipStatusID = 3,
											EndDate = DATEADD(day,-1,@BeginDate)
								FROM dbo.datClientMembership
								WHERE ClientMembershipGUID = @PreviousMembershipGUID

								SET @RenewalFlag = 0
								SET @RenewalCount = 0
								SET @InsertMembership = 0
							END
							ELSE
							BEGIN
								-- Update Previous Membership with Inactive and EndDate
								UPDATE dbo.datClientMembership
									  SET IsActiveFlag = 0,
											EndDate = DATEADD(day,-1,@BeginDate)
								FROM dbo.datClientMembership
								WHERE ClientMembershipGUID = @PreviousMembershipGUID
							END
                        END


                        IF (@InsertMembership = 1 )
                        -- INSERT New client Membership
                        BEGIN

                              --Insert datClientMembership Record for Active Memberships
                              if ( @MembershipID <> 11 )
                              BEGIN

									-- Set the RenewalFlag and Count
									IF ( @PreviousClientGUID = @ClientGUID AND @PreviousMembershipID = @MembershipID)
									BEGIN
										SET @RenewalFlag = 1
										SET @RenewalCount = @RenewalCount+1
									END
									ELSE
									BEGIN
										SET @RenewalFlag = 0
										SET @RenewalCount = 0
									END

                                    INSERT INTO dbo.datClientMembership(
                                                      ClientMembershipGUID
                                                      ,Member1_ID_Temp
                                                      ,ClientGUID
                                                      ,CenterID
                                                      ,MembershipID
                                                      ,ClientMembershipStatusID
                                                      ,ContractPrice
                                                      ,ContractPaidAmount
                                                      ,MonthlyFee
                                                      ,BeginDate
                                                      ,EndDate
                                                      ,MembershipCancelReasonID
                                                      ,CancelDate
                                                      ,IsGuaranteeFlag
                                                      ,IsRenewalFlag
                                                      ,IsMultipleSurgeryFlag
                                                      ,RenewalCount
                                                      ,IsActiveFlag
                                                      ,CreateDate
                                                      ,CreateUser
                                                      ,LastUpdate
                                                      ,LastUpdateUser)
                                    VALUES(@ClientMembershipGUID
                                                ,@Member1_ID
                                                ,@ClientGUID
                                                ,@CenterID2
                                                ,@MembershipID
                                                ,@ClientMembershipStatusID
                                                ,@ContractPrice
                                                ,@ContractPaidAmount
                                                ,@MonthlyFee
                                                ,@BeginDate
                                                ,@EndDate
                                                ,@MembershipCancelReasonID
                                                ,@CancelDate
                                                ,1   -- IsGuaranteeFlag
                                                ,@RenewalFlag   -- IsRenewalFlag
                                                ,0   -- IsMultipleSurgeryFlag
                                                ,@RenewalCount   -- RenewalCount
                                                ,@IsActiveFlag
                                                ,GETUTCDATE()
                                                ,'sa'
                                                ,GETUTCDATE()
                                                ,'sa')
                                    END
							  ELSE -- Handle Cancelled Memberships
							  BEGIN

						    	  SELECT TOP 1 @MembershipID = mem.MembershipID
									FROM [HCSQL2\SQL2005].Infostore.dbo.Transactions  trans
										  INNER JOIN [HCSQL2\SQL2005].Infostore.dbo.Clients cp on trans.client_no = cp.Client_no AND trans.Center = cp.Center
										  LEFT JOIN dbo.cfgMembership mem ON dbo.fx_GetCMSMembership(trans.Member1, cp.Member_Additional) = mem.MembershipDescriptionShort
									WHERE trans.client_no = @Client_Number AND trans.transact_no < @TransNumber
										  ORDER BY trans.transact_no DESC

								  INSERT INTO dbo.datClientMembership(
													ClientMembershipGUID
													,Member1_ID_Temp
													,ClientGUID
													,CenterID
													,MembershipID
													,ClientMembershipStatusID
													,ContractPrice
													,ContractPaidAmount
													,MonthlyFee
													,BeginDate
													,EndDate
													,MembershipCancelReasonID
													,CancelDate
													,IsGuaranteeFlag
													,IsRenewalFlag
													,IsMultipleSurgeryFlag
													,RenewalCount
													,IsActiveFlag
													,CreateDate
													,CreateUser
													,LastUpdate
													,LastUpdateUser)
								  VALUES(@ClientMembershipGUID
											  ,@Member1_ID
											  ,@ClientGUID
											  ,@CenterID2
											  ,@MembershipID
											  ,@ClientMembershipStatusID
											  ,@ContractPrice
											  ,@ContractPaidAmount
											  ,@MonthlyFee
											  ,@BeginDate
											  ,@EndDate
											  ,@MembershipCancelReasonID
											  ,@CancelDate
											  ,1   -- IsGuaranteeFlag
											  ,0   -- IsRenewalFlag
											  ,0   -- IsMultipleSurgeryFlag
											  ,0   -- RenewalCount
											  ,@IsActiveFlag
											  ,GETUTCDATE()
											  ,'sa'
											  ,GETUTCDATE()
											  ,'sa')
						      END

	                          -- Update client record if it exists
							  IF (@BusinessSegmentDescriptionShort = @BusinessSegment_BIO)
								BEGIN
									-- INSERT datClientMembershipAccum record for new Clients
									INSERT INTO dbo.datClientMembershipAccum (
															ClientMembershipAccumGUID
															,ClientMembershipGUID
															,AccumulatorID
															,UsedAccumQuantity
															,TotalAccumQuantity
															,CreateDate
															,CreateUser
															,LastUpdate
															,LastUpdateUser)
									VALUES( NEWID()
												,@ClientMembershipGUID
												,@AccumulatorID_BIOSystems
												,@UsedAccumQuantity
												,@TotalAccumQuantity
												,GETUTCDATE()
												,'sa'
												,GETUTCDATE()
												,'sa')

									  UPDATE c
											SET CurrentBioMatrixClientMembershipGUID = @ClientMembershipGUID
												  ,IsHairSystemClientFlag = 1
												  , LastUpdate = GETUTCDATE()
												  , LastUpdateUser = 'sa'
											FROM dbo.datClient c
											WHERE c.ClientGUID = @ClientGUID
								END
								ELSE IF (@BusinessSegmentDescriptionShort = @BusinessSegment_XTR)
								BEGIN
									  UPDATE c
											SET CurrentXtrandsClientMembershipGUID = @ClientMembershipGUID
												  , LastUpdate = GETUTCDATE()
												  , LastUpdateUser = 'sa'
											FROM dbo.datClient c
											WHERE c.ClientGUID = @ClientGUID
								END
								ELSE
								BEGIN
									  UPDATE c
											SET CurrentExtremeTherapyClientMembershipGUID = @ClientMembershipGUID
												  , LastUpdate = GETUTCDATE()
												  , LastUpdateUser = 'sa'
											FROM dbo.datClient c
											WHERE c.ClientGUID = @ClientGUID
								END

                        END



                        -- Used for Renewal Count Generation
                        SET @PreviousClientGUID = @ClientGUID
                        SET @PreviousMembershipID = @MembershipID
                        SET @PreviousMembershipGUID = @ClientMembershipGUID

                  FETCH NEXT FROM @Client_Cursor INTO @ClientRowNumber,@TransNumber,@Member1_ID,@Client_Number,@ClientGUID,@CenterID2,@MembershipID,@ClientMembershipStatusID,@ContractPrice,@ContractPaidAmount,@MonthlyFee,@BeginDate,@EndDate,@MembershipCancelReasonID,@CancelDate,@IsActiveFlag,@UsedAccumQuantity,@TotalAccumQuantity,@BusinessSegmentDescriptionShort
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
            WHERE bs.BusinessSegmentDescriptionShort = @BusinessSegment_EXTREME

            UPDATE c
            SET CurrentXtrandsClientMembershipGUID = cm.ClientMembershipGUID
                  , LastUpdate = GETUTCDATE()
                  , LastUpdateUser = 'sa'
            FROM datClient c
                  INNER JOIN @ClientsWithoutMembershipRecords cwmr ON c.ClientGUID = cwmr.ClientGUID -- INNER JOIN to this table handles the WHERE statement
                  INNER JOIN datClientMembership cm ON c.ClientGUID = cm.ClientGUID
                  INNER JOIN cfgMembership m ON cm.MembershipID = m.MembershipID
                  INNER JOIN lkpBusinessSegment bs ON m.BusinessSegmentID = bs.BusinessSegmentID
            WHERE bs.BusinessSegmentDescriptionShort = @BusinessSegment_XTR

END
GO
