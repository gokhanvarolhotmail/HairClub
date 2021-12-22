/* CreateDate: 08/27/2013 14:18:43.957 , ModifyDate: 05/07/2015 16:12:20.150 */
GO
/***********************************************************************

		PROCEDURE:				dbaGoLiveUpdatesforCenter

		DESTINATION SERVER:		SQL01

		DESTINATION DATABASE: 	HairClubCMS

		RELATED APPLICATION:  	CMS

		AUTHOR: 				Kevin Murdoch

		IMPLEMENTOR: 			Kevin Murdoch

		DATE IMPLEMENTED: 		 10/30/2012

		/LAST REVISION DATE: 	 10/30/2012

		--------------------------------------------------------------------------------------------------------
		NOTES:  This script is used to run conversions for predetermined list of centers
				*10/30/2012 KRM - Created stored proc
				*01/15/2013 KRM - Added Delete Clients/Update Status Scripts
				*02/12/2013 KRM - Added Initialize AR Storec Proc
				*08/16/2013 MLM - Added Copy SalesCode
				*08/19/2013 MLM - Added parameters
				*01/30/2014 MLM - Set Center Type based on Center ie. Corporate, Franchise, Joint Venture.
				*02/11/2014 MLM - Added Historical Note Update
				*04/03/2015 MVT - Modified to not import Sales Codes if @CopySalesCodeCenter is null
				*04/10/2015	MVT - Modified to update Finance companies
				*05/07/2015 MVT - Added Step to Delete existing EFT Profiles
		--------------------------------------------------------------------------------------------------------
		SAMPLE EXECUTION:

		EXEC [dbaGoLiveUpdatesforCenter] 210, 292

		***********************************************************************/

		CREATE PROCEDURE [dbo].[dbaGoLiveUpdatesforCenter]
			@CenterToUpdate int,
			@CopySalesCodeCenter int

		AS

		BEGIN

			SET NOCOUNT ON
			--Create table object with ID column
			IF OBJECT_ID('tempdb..#Centers') IS NOT NULL
			BEGIN
				DROP TABLE #Centers
			END
			CREATE TABLE #Centers(
				ID INT IDENTITY(1,1)
			,	Center INT
			)

			--Declare variables
			DECLARE @Count INT
			,	@Total INT
			,	@SQL VARCHAR(100)
			,	@CurrentCenter INT
			,   @CenterBusinessTypeId_Conect int
			,   @CenterBusinessTypeId_ConectFranchise int
			,   @CenterBusinessTypeId_ConectJointVenture int

			SELECT @CenterBusinessTypeId_Conect = CenterBusinessTypeID FROM lkpCenterBusinessType where CenterBusinessTypeDescriptionShort = 'cONEctCorp'
			SELECT @CenterBusinessTypeId_ConectFranchise = CenterBusinessTypeID FROM lkpCenterBusinessType where CenterBusinessTypeDescriptionShort = 'cONEctFran'
			SELECT @CenterBusinessTypeId_ConectJointVenture = CenterBusinessTypeID FROM lkpCenterBusinessType where CenterBusinessTypeDescriptionShort = 'cONEctJV'


            --Populate temp table with all centers
            INSERT INTO #Centers (Center)
            SELECT center_num
            FROM [HCSQL2\SQL2005].[HCFMDirectory].dbo.[tblCenter]
            --
            -- RUN ALL CENTER INCLUDING 100 AND 279
            --
            WHERE ([Type] in ('c','j','f')
                AND [Inactive]=0
                AND [Center_num] = @CenterToUpdate)


			--Set counter and total centers variables
			SET @Count = 1
			SELECT @Total = MAX(ID)
			FROM #Centers

			--Loop through each center and execute the dynamic SQL for each center
			WHILE @Count <= @Total
			BEGIN
				SELECT @CurrentCenter = Center
				FROM #Centers
				WHERE ID = @Count
				--
				--  Insert membership accumulatator join for AR Accumulator - all memberships should have this one.
				--
				INSERT INTO [dbo].[datClientMembershipAccum]
						   ([ClientMembershipAccumGUID]
						   ,[ClientMembershipGUID]
						   ,[AccumulatorID]
						   ,[UsedAccumQuantity]
						   ,[AccumMoney]
						   ,[AccumDate]
						   ,[TotalAccumQuantity]
						   ,[CreateDate]
						   ,[CreateUser]
						   ,[LastUpdate]
						   ,[LastUpdateUser])
					  SELECT
									 NEWID(),
									 cm.ClientMembershipGuid,
									 3,
									 0,
									 0,
									 NULL,
									 0,
									 GETUTCDATE(),
									 'sa',
									 GETUTCDATE(),
									 'sa'
							  FROM datClientMembership cm
									 LEFT OUTER JOIN datClientMembershipAccum cma
										on cm.ClientMembershipGuid = cma.ClientMembershipGuid AND cma.AccumulatorID = 3
							  WHERE cma.ClientMembershipGuid IS NULL
									and cm.centerid = @CurrentCenter


				--
				--	Update Expired (older than 13mos) ClientMemberships to Cancelled from active status
				--

				update clm
						set clientmembershipstatusid = 3,
						lastupdate = getutcdate(),
						lastupdateuser = 'sa'
				from [dbo].[datClientMembership] CLM
						INNER JOIN lkpClientMembershipStatus clms
								on clm.ClientMembershipStatusID = clms.ClientMembershipStatusID
						where enddate < dateadd(MM,-13,getdate())
								and clms.ClientMembershipStatusDescription = 'active'
								and clm.centerid = @CurrentCenter
				--
				-- Update Membership Assignment Orders to have price from Member1_Price
				--
				UPDATE SOD
				SET		SOD.PRICE = T.Member1_price,
						lastupdate = getutcdate(),
						lastupdateuser = 'sa'
				--SELECT MEMBER1_PRICE,SOD.PRICE,*
				FROM [HCSQL2\SQL2005].INFOSTORE.DBO.TRANSACTIONS T
					INNER JOIN datSalesOrder SO
						ON SO.TICKETNUMBER_TEMP = T.TICKET_NO
							AND SO.CENTERID = T.CENTER
					INNER JOIN datSalesOrderDetail SOD
						on SO.SalesorderGUID = sod.Salesorderguid
				WHERE
					T.CENTER = @CurrentCenter
					AND T.DATE >= '7/1/08'
					AND DEPARTMENT IN (10,12,20,21,22,30,31,32,33)
					AND SOD.PRICE = 0
				--
				-- Update Balance Due
				--

				--UPDATE datclient
				--SET ARBALANCE = 0
				--WHERE CENTERID = @CurrentCenter
				----

				--UPDATE DC
				--	SET ARBALANCE = isnull(r.balance-r.prepaid,0)
				----select c.balance as 'curbalance',	c.prepaid as 'curprepaid',	c.member1_beg,	c.member1_beg -1 as 'joindate',
				----	r.balance,	r.prepaid, r.[date], dc.ARbalance,	isnull(r.balance-r.prepaid,0),*
				--FROM [HCSQL2\SQL2005].INFOSTORE.DBO.CLIENTS c
				--	INNER JOIN datclient dc
				--		on dc.centerid = c.center
				--			and dc.clientnumber_temp = c.client_no
				--	LEFT OUTER JOIN datclientmembership clmBIO
				--		on dc.CurrentBioMatrixClientMembershipGUID = clmBIO.clientmembershipGUID
				--	LEFT OUTER JOIN datClientMembership clmEXT
				--		on dc.[CurrentExtremeTherapyClientMembershipGUID] = clmEXT.clientmembershipGUID
				--	LEFT OUTER JOIN [HCSQL2\SQL2005].INFOSTORE.DBO.HCMTBL_RECEIVABLES r
				--		on r.center = c.center
				--			and r.client_no = c.client_no
				--				and r.[date] = (c.member1_beg-1)
				--		WHERE c.CENTER = @CurrentCenter
				--				AND ((c.balance <> 0 or c.prepaid <> 0)
				--					or (r.balance <> 0 or r.prepaid <> 0))
				--				AND
				--					(clmEXT.ClientMembershipstatusID = 1
				--						or clmBIO.ClientMembershipStatusID = 1)

				--UPDATE clmBIOAccum
				--	SET clmBIOAccum.AccumMoney = dc.ARBalance
				----select *
				--FROM [HCSQL2\SQL2005].INFOSTORE.DBO.CLIENTS c
				--	INNER JOIN datclient dc
				--		on dc.centerid = c.center
				--			and dc.clientnumber_temp = c.client_no
				--	LEFT OUTER JOIN datclientmembership clmBIO
				--		on dc.CurrentBioMatrixClientMembershipGUID = clmBIO.clientmembershipGUID
				--	LEFT OUTER JOIN datClientMembershipAccum clmBIOAccum
				--		on clmBIO.ClientMembershipGUID = clmBIOAccum.ClientMembershipGUID
				--			and clmBIOAccum.AccumulatorID = 3
				--WHERE c.CENTER = @CurrentCenter
				--		AND
				--			clmBIO.ClientMembershipStatusID = 1
				--		AND
				--			dc.ARBalance <> 0


				--UPDATE clmEXTAccum
				--	SET clmEXTAccum.AccumMoney = dc.ARBalance
				----select dc.arbalance, clmextaccum.accummoney,*
				--FROM [HCSQL2\SQL2005].INFOSTORE.DBO.CLIENTS c
				--	INNER JOIN datclient dc
				--		on dc.centerid = c.center
				--			and dc.clientnumber_temp = c.client_no
				--	LEFT OUTER JOIN datClientMembership clmEXT
				--		on dc.[CurrentExtremeTherapyClientMembershipGUID] = clmEXT.clientmembershipGUID
				--	LEFT OUTER JOIN datClientMembershipAccum clmEXTAccum
				--		on clmEXT.ClientMembershipGUID = clmEXTAccum.ClientMembershipGUID
				--			and clmEXTAccum.AccumulatorID = 3
				--WHERE c.CENTER = @CurrentCenter
				--		AND
				--			clmEXT.ClientMembershipStatusID = 1
				--		AND
				--			dc.ARBalance <> 0
				--
				-- Delete Hair System datClientMembershipAccum records created in previous conversion for EXT Clients
				--
				DELETE CLMA
				--select *
				from datclientmembershipaccum clma
				INNER JOIN datClientMembership clm
					ON clma.clientmembershipguid = clm.ClientMembershipGUID
				WHERE membershipid in (6,7,8,9,13,40,41,51,52,53,54) and AccumulatorID = 8
				AND Centerid = @CurrentCenter


				IF @CurrentCenter >= 800
					BEGIN
						Update cfgConfigurationCenter
							SET CenterBusinessTypeId = @CenterBusinessTypeId_ConectFranchise
								,HasFullAccess = 1
								,IsFeeProcessedCentrallyFlag = 1
								,UseCreditCardProcessorFlag = 1
								,lastUpdate  = GETUTCDATE()
								,LastUpdateUser = 'sa'
						FROM cfgConfigurationCenter
						Where CenterId = @CurrentCenter
					END
				ELSE IF @CurrentCenter BETWEEN 700 and 799
					BEGIN
						Update cfgConfigurationCenter
							SET CenterBusinessTypeId = @CenterBusinessTypeId_ConectJointVenture
								,HasFullAccess = 1
								,IsFeeProcessedCentrallyFlag = 1
								,UseCreditCardProcessorFlag = 1
								,lastUpdate  = GETUTCDATE()
								,LastUpdateUser = 'sa'
						FROM cfgConfigurationCenter
						Where CenterId = @CurrentCenter
					END
				ELSE
					BEGIN
						Update cfgConfigurationCenter
							SET CenterBusinessTypeId = @CenterBusinessTypeId_Conect
								,HasFullAccess = 1
								,IsFeeProcessedCentrallyFlag = 1
								,UseCreditCardProcessorFlag = 1
								,lastUpdate  = GETUTCDATE()
								,LastUpdateUser = 'sa'
						FROM cfgConfigurationCenter
						Where CenterId = @CurrentCenter
					END


				 IF @CopySalesCodeCenter IS NOT NULL
				 BEGIN
					--Copy the SalesCode from 292 - Las Vegas
					SET @SQL = 'mtnSalesCodeCopyToCenter ' + CONVERT(VARCHAR, @CopySalesCodeCenter) + ', ' + CONVERT(VARCHAR, @CurrentCenter) + ',NULL'
					EXEC(@SQL)
				 END

				SET @SQL = 'dbo.dbaAppointmentImportbyCenter ' + CONVERT(VARCHAR, @CurrentCenter)
				EXEC(@SQL)

				--SET @SQL = 'dbaInsertSalesCodesByCenter ' + CONVERT(VARCHAR, @CurrentCenter)
				--EXEC(@SQL)

				SET @SQL = 'dbaAccumulatorUpdatebyCenter ' + CONVERT(VARCHAR, @CurrentCenter)
				EXEC(@SQL)

				SET @SQL = 'dbaInsertTechnicalProfiles ' + CONVERT(VARCHAR, @CurrentCenter)
				EXEC(@SQL)

				--SET @SQL = 'dbaDeleteInvalidClientsbyCenter ' + CONVERT(VARCHAR, @CurrentCenter)
				--EXEC(@SQL)

				SET @SQL = 'dbaUpdateClientMembershipStatus ' + CONVERT(VARCHAR, @CurrentCenter)
				EXEC(@SQL)

				SET @SQL = 'dbaInitializeAccountReceivable ' + CONVERT(VARCHAR, @CurrentCenter)
				EXEC(@SQL)

				SET @SQL = 'dbaRefundOrderConversionUpdate ' + CONVERT(VARCHAR, @CurrentCenter) + ',2000'
				EXEC(@SQL)

				SET @SQL ='dbaUpdateHistoricalNotesClient ' +  + CONVERT(VARCHAR, @CurrentCenter)
				EXEC(@SQL)

				--
				-- Update TotalAccum quantity to =
				--
				UPDATE CLMA
				SET		totalaccumquantity = usedaccumquantity,
						LastUpdate = GETUTCDATE(),
						LastUpdateUser = 'sa'
				FROM datclientmembershipaccum clma
					inner join datclientmembership clm
						on clma.ClientMembershipGUID = clm.ClientMembershipGUID
					inner join datclient cl
						on clm.ClientGUID = cl.ClientGUID
				WHERE AccumQuantityRemainingCalc < 0
					and accumulatorid in (8,9,10,11)
					and cl.CenterID = @CurrentCenter


				--
				-- Update Finance Companies
				--
				UPDATE sot SET
					sot.FinanceCompanyID = fc.FinanceCompanyID,
					sot.LastUpdate = GETUTCDATE(),
					sot.LastUpdateUser = 'sa-GoLive'
				FROM datSalesOrderTender sot
					INNER JOIN datSalesOrder so ON so.SalesOrderGUID = sot.SalesOrderGUID
					INNER JOIN lkpTenderType tt ON tt.TenderTypeID = sot.TenderTypeID
					LEFT JOIN [HCSQL2\SQL2005].INFOSTORE.dbo.Transactions trn ON trn.ticket_no = so.TicketNumber_Temp
																				AND trn.Center = so.CenterID
					LEFT JOIN lkpFinanceCompany fc ON fc.FinanceCompanyDescriptionShort =
											(CASE WHEN trn.FinanceCompany = 'GE/CitiHealth' THEN 'Citi'
													WHEN trn.FinanceCompany = 'Springstone' THEN 'Spring'
													WHEN trn.FinanceCompany = 'Unicorn' THEN 'Unicorn'
													WHEN trn.FinanceCompany = 'CareCredit' THEN 'CareCredit'
													WHEN trn.FinanceCompany = 'HealthCare Finance Direct' THEN 'HFD' END)
				WHERE tt.TenderTypeDescriptionShort = 'Finance'
					AND sot.FinanceCompanyID IS NULL
					AND LTRIM(RTRIM(trn.FinanceCompany)) <> ''
					AND trn.Code = 'Tender'
					AND trn.gc = sot.Amount
					AND so.CenterID = @CurrentCenter

				--
				-- Delete existing EFT profiles for the Center (will get re-imported as part of GO LIve)
				--
				DELETE DCE
					FROM datClientEFT DCE
						INNER JOIN datClient C ON C.ClientGUID = DCE.ClientGUID
					WHERE C.CenterID = @CurrentCenter


				print @currentcenter

				SET @Count = @Count + 1
			END
		END
GO
