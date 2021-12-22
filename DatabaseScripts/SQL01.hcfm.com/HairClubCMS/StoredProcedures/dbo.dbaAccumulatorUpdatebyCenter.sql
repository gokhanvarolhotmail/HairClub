/***********************************************************************

		PROCEDURE:				dbaAccumulatorUpdatebyCenter

		DESTINATION SERVER:		SQL01

		DESTINATION DATABASE: 	HairClubCMS

		RELATED APPLICATION:  	CMS

		AUTHOR: 				Kevin Murdoch

		IMPLEMENTOR: 			Kevin Murdoch

		DATE IMPLEMENTED: 		 10/26/2012

		LAST REVISION DATE: 	 10/26/2012

		--------------------------------------------------------------------------------------------------------
		NOTES:  This script is used to reset Accumulator Records as well as update the transactions.
				* 10/26/2012 KRM - Created stored proc
				* 02/22/2013 KRM - Added in delete and insert of join between lasercomb payment and contract bal accum.
				* 03/13/2013 KRM - Added in Client Membership accum inserts for 8,9,10,11,36,37 and update of 36,37
				* 03/14/2013 KRM - Added in Client Membership accum inserts for any other missing accums
				* 09/19/2013 MVT - Updated to only run Closed orders through accumulator proc. Also, modified to exclude
									surgery memberships from running through accumulators.
				* 03/02/2015 MVT - Updated proc for Xtrands Business Segment
				* 08/01/2017 PRM - Added new replacement statuses for Cancel CM Status (up, down, convert, renew)
		--------------------------------------------------------------------------------------------------------
		SAMPLE EXECUTION:

		EXEC [dbaAccumulatorUpdatebyCenter] '207'
		***********************************************************************/

		CREATE PROCEDURE [dbo].[dbaAccumulatorUpdatebyCenter] (
			@Center int
		) AS
		BEGIN

			SET NOCOUNT ON
				--
				--  Client Membership Accumulator Inserts - BIO SYSTEMS
				--

				INSERT INTO [datClientMembershipAccum]
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

				select
						   NEWID() as 'ClientMembershipAccumGUID'
						   ,clm.ClientMembershipGUID as 'ClientMembershipGUID'
						   ,ma.AccumulatorID as 'AccumulatorID'
						   ,0 as 'UsedAccumQuantity'
						   ,0.00 as 'AccumMoney'
						   ,Null as 'AccumDate'
						   ,ma.InitialQuantity as 'TotalAccumQuantity'
						   ,GETUTCDATE() AS CreateDate
						   ,'sa' AS CreateUser
						   ,GETUTCDATE() AS LastUpdate
						   ,'sa' AS LastUpdateUser

				from datClientMembership clm
					   inner join cfgMembershipAccum ma
							  on clm.MembershipID = ma.MembershipID
									 and ma.accumulatorid = 8
					   left outer Join datclientmembershipaccum clma
							  on clm.clientmembershipguid = clma.clientmembershipguid
									 and ma.AccumulatorID = clma.accumulatorid
					   left outer join datClient cb
							  on clm.ClientMembershipGUID = cb.[CurrentBioMatrixClientMembershipGUID]
					   inner join cfgAccumulator a
							  on ma.AccumulatorID = a.AccumulatorID
				WHERE clma.clientmembershipaccumguid is null and
						(cb.clientguid is not null) and
						ma.accumulatorID in (8)
						and clm.ClientMembershipStatusID not in (3,4,6,7,8,9)
						and clm.EndDate > (getdate() -365)
						and clm.centerid = @Center

				--
				--  Client Membership Accumulator Inserts - EXT & BIO SERVICES.  Added XTR Services 3/2/15
				--

				INSERT INTO [datClientMembershipAccum]
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

				select
						   NEWID() as 'ClientMembershipAccumGUID'
						   ,clm.ClientMembershipGUID as 'ClientMembershipGUID'
						   ,ma.AccumulatorID as 'AccumulatorID'
						   ,0 as 'UsedAccumQuantity'
						   ,0.00 as 'AccumMoney'
						   ,Null as 'AccumDate'
						   ,ma.InitialQuantity as 'TotalAccumQuantity'
						   ,GETUTCDATE() AS CreateDate
						   ,'sa' AS CreateUser
						   ,GETUTCDATE() AS LastUpdate
						   ,'sa' AS LastUpdateUser

				from datClientMembership clm
					   inner join cfgMembershipAccum ma
							  on clm.MembershipID = ma.MembershipID
									 and ma.accumulatorid = 9
					   left outer Join datclientmembershipaccum clma
							  on clm.clientmembershipguid = clma.clientmembershipguid
									 and ma.AccumulatorID = clma.accumulatorid
					   left outer join datClient cb
							  on clm.ClientMembershipGUID = cb.[CurrentBioMatrixClientMembershipGUID]
					   left outer join datclient ce
							  on clm.ClientMembershipGUID = ce.[CurrentExtremeTherapyClientMembershipGUID]
					   left outer join datclient cx
							  on clm.ClientMembershipGUID = cx.[CurrentXtrandsClientMembershipGUID]
					   inner join cfgAccumulator a
							  on ma.AccumulatorID = a.AccumulatorID


				WHERE clma.clientmembershipaccumguid is null and
						(cb.clientguid is not null or ce.clientguid is not null) and
						ma.accumulatorID in (9)
						and clm.ClientMembershipStatusID not in (3,4,6,7,8,9)
						and clm.EndDate > (getdate() -365)
						and clm.centerid = @Center
				--
				--  Client Membership Accumulator Inserts - BIO & EXT Solutions. Added XTR Solutions 3/2/15
				--

				INSERT INTO [datClientMembershipAccum]
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

				select
						   NEWID() as 'ClientMembershipAccumGUID'
						   ,clm.ClientMembershipGUID as 'ClientMembershipGUID'
						   ,ma.AccumulatorID as 'AccumulatorID'
						   ,0 as 'UsedAccumQuantity'
						   ,0.00 as 'AccumMoney'
						   ,Null as 'AccumDate'
						   ,ma.InitialQuantity as 'TotalAccumQuantity'
						   ,GETUTCDATE() AS CreateDate
						   ,'sa' AS CreateUser
						   ,GETUTCDATE() AS LastUpdate
						   ,'sa' AS LastUpdateUser

				from datClientMembership clm
					   inner join cfgMembershipAccum ma
							  on clm.MembershipID = ma.MembershipID
									 and ma.accumulatorid = 10
					   left outer Join datclientmembershipaccum clma
							  on clm.clientmembershipguid = clma.clientmembershipguid
									 and ma.AccumulatorID = clma.accumulatorid
					   left outer join datClient cb
							  on clm.ClientMembershipGUID = cb.[CurrentBioMatrixClientMembershipGUID]
					   left outer join datclient ce
							  on clm.ClientMembershipGUID = ce.[CurrentExtremeTherapyClientMembershipGUID]
					   left outer join datclient cx
							  on clm.ClientMembershipGUID = cx.[CurrentXtrandsClientMembershipGUID]
					   inner join cfgAccumulator a
							  on ma.AccumulatorID = a.AccumulatorID
				WHERE clma.clientmembershipaccumguid is null and
						(cb.clientguid is not null or ce.clientguid is not null) and
						ma.accumulatorID in (10)
						and clm.ClientMembershipStatusID not in (3,4,6,7,8,9)
						and clm.EndDate > (getdate() -365)
						and clm.centerid = @Center

				--
				--  Client Membership Accumulator Inserts - BIO & EXT Product Kits. Added XTR Product Kits 3/2/15
				--

				INSERT INTO [datClientMembershipAccum]
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

				select
						   NEWID() as 'ClientMembershipAccumGUID'
						   ,clm.ClientMembershipGUID as 'ClientMembershipGUID'
						   ,ma.AccumulatorID as 'AccumulatorID'
						   ,0 as 'UsedAccumQuantity'
						   ,0.00 as 'AccumMoney'
						   ,Null as 'AccumDate'
						   ,ma.InitialQuantity as 'TotalAccumQuantity'
						   ,GETUTCDATE() AS CreateDate
						   ,'sa' AS CreateUser
						   ,GETUTCDATE() AS LastUpdate
						   ,'sa' AS LastUpdateUser

				from datClientMembership clm
					   inner join cfgMembershipAccum ma
							  on clm.MembershipID = ma.MembershipID
									 and ma.accumulatorid = 11
					   left outer Join datclientmembershipaccum clma
							  on clm.clientmembershipguid = clma.clientmembershipguid
									 and ma.AccumulatorID = clma.accumulatorid
					   left outer join datClient cb
							  on clm.ClientMembershipGUID = cb.[CurrentBioMatrixClientMembershipGUID]
					   left outer join datclient ce
							  on clm.ClientMembershipGUID = ce.[CurrentExtremeTherapyClientMembershipGUID]
					   left outer join datclient cx
							  on clm.ClientMembershipGUID = cx.[CurrentXtrandsClientMembershipGUID]
					   inner join cfgAccumulator a
							  on ma.AccumulatorID = a.AccumulatorID


				WHERE clma.clientmembershipaccumguid is null and
						(cb.clientguid is not null or ce.clientguid is not null) and
						ma.accumulatorID in (11)
						and clm.ClientMembershipStatusID not in (3,4,6,7,8,9)
						and clm.EndDate > (getdate() -365)
						and clm.centerid = @Center

				--
				--  Client Membership Accumulator Inserts - Last Used PK & Solutions
				--

				INSERT INTO [datClientMembershipAccum]
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

				select
						   NEWID() as 'ClientMembershipAccumGUID'
						   ,clm.ClientMembershipGUID as 'ClientMembershipGUID'
						   ,ma.AccumulatorID as 'AccumulatorID'
						   ,0 as 'UsedAccumQuantity'
						   ,0.00 as 'AccumMoney'
						   ,Null as 'AccumDate'
						   ,ma.InitialQuantity as 'TotalAccumQuantity'
						   ,GETUTCDATE() AS CreateDate
						   ,'sa' AS CreateUser
						   ,GETUTCDATE() AS LastUpdate
						   ,'sa' AS LastUpdateUser

				from datClientMembership clm
					   inner join cfgMembershipAccum ma
							  on clm.MembershipID = ma.MembershipID
									 and ma.accumulatorid <> 8
					   left outer Join datclientmembershipaccum clma
							  on clm.clientmembershipguid = clma.clientmembershipguid
									 and ma.AccumulatorID = clma.accumulatorid
					   left outer join datClient cb
							  on clm.ClientMembershipGUID = cb.[CurrentBioMatrixClientMembershipGUID]
					   left outer join datclient ce
							  on clm.ClientMembershipGUID = ce.[CurrentExtremeTherapyClientMembershipGUID]
					   left outer join datclient cx
							  on clm.ClientMembershipGUID = cx.[CurrentXtrandsClientMembershipGUID]
					   inner join cfgAccumulator a
							  on ma.AccumulatorID = a.AccumulatorID


				WHERE clma.clientmembershipaccumguid is null and
						(cb.clientguid is not null or ce.clientguid is not null) and
						ma.accumulatorID in (36, 37)
						and clm.ClientMembershipStatusID not in (3,4,6,7,8,9)
						and clm.EndDate > (getdate() -365)
						and clm.centerid = @Center
				--
				-- Insert any other missing Accumulator Records
				--
				INSERT INTO [datClientMembershipAccum]
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
						   NEWID() as 'ClientMembershipAccumGUID'
						   ,clm.ClientMembershipGUID as 'ClientMembershipGUID'
						   ,ma.AccumulatorID as 'AccumulatorID'
						   ,0 as 'UsedAccumQuantity'
						   ,0.00 as 'AccumMoney'
						   ,Null as 'AccumDate'
						   ,ma.InitialQuantity as 'TotalAccumQuantity'
						   ,GETUTCDATE() AS CreateDate
						   ,'sa' AS CreateUser
						   ,GETUTCDATE() AS LastUpdate
						   ,'sa' AS LastUpdateUser

				FROM cfgMembershipAccum ma
					inner join cfgmembership mem
						on ma.membershipid = mem.membershipid
					left outer join datclientmembership clm
						on ma.MembershipID = clm.membershipid
					left outer join datclientmembershipAccum clma
						on clm.clientmembershipguid = clma.clientmembershipguid
							and ma.accumulatorid = clma.accumulatorid
					left outer join datClient cb
							on clm.ClientMembershipGUID = cb.[CurrentBioMatrixClientMembershipGUID]
					left outer join datclient ce
							on clm.ClientMembershipGUID = ce.[CurrentExtremeTherapyClientMembershipGUID]
					left outer join datclient cx
							on clm.ClientMembershipGUID = cx.[CurrentXtrandsClientMembershipGUID]
				WHERE clientmembershipaccumguid is null
						and (cb.clientguid is not null or ce.clientguid is not null)
						--and clm.ClientMembershipStatusID not in (3,4,6,7,8,9)
						and clm.EndDate > (getdate() -365)
						and clm.centerid = @Center
				ORDER BY clm.clientmembershipguid, ma.accumulatorid

				--
				-- Get Client List for
				--
				IF OBJECT_ID('tempdb..#ClientID') IS NOT NULL
					DROP TABLE #ClientID

				CREATE TABLE #ClientID (
						ID INT IDENTITY(1,1) ,
						ClientIdentifier INT
										)

				--
				-- Delete Accumulator join between lasercomb payment and contract balance
				--
				DELETE FROM cfgAccumulatorJoin WHERE SalesCodeID = 673 and AccumulatorID = 1
				--
				INSERT INTO #ClientID (ClientIdentifier)

				SELECT cl.clientidentifier
				FROM datClientMembership clm
					inner join datclient cl
						ON clm.clientmembershipguid = cl.CurrentBioMatrixClientMembershipGUID
				WHERE clm.BeginDate >= '10/1/2011' and cl.CenterID = @center

				UNION

				SELECT cl.clientidentifier
				FROM datClientMembership clm
					inner join datclient cl
						ON clm.clientmembershipguid = cl.CurrentExtremeTherapyClientMembershipGUID
				WHERE clm.BeginDate >= '10/1/2011' and cl.CenterID = @center

				UNION

				SELECT cl.clientidentifier
				FROM datClientMembership clm
					inner join datclient cl
						ON clm.clientmembershipguid = cl.CurrentXtrandsClientMembershipGUID
				WHERE clm.BeginDate >= '10/1/2011' and cl.CenterID = @center

				DECLARE
					@MASTERCount INT
				,	@MASTERTotal INT
				,	@ClientIdentifier INT

				--					--
				--Set counter and total centers variables
				--
				SET @MasterCount = 1
				SELECT @MasterTotal = MAX(ID)
				FROM #ClientID

				WHILE @MASTERCount <= @MASTERTotal
					BEGIN

							SET @ClientIdentifier = (SELECT ClientIdentifier from #ClientID where ID = @MASTERCount)
							--
							IF OBJECT_ID('tempdb..#clientorders') IS NOT NULL
							DROP TABLE #clientorders
							--
							--Create table object with ID column
							--
							CREATE TABLE #ClientOrders(
								ID INT IDENTITY(1,1)
							,	OrderGUID UniqueIdentifier
							,	CLMGuid	UniqueIdentifier
							)

							--Declare variables
							DECLARE @Count INT
							,	@Total INT
							,	@SQL VARCHAR(200)
							,	@CurrentOrderGUID UniqueIdentifier
							--
							--Update CLMA records with zero used
							--
							UPDATE clma
								SET UsedAccumQuantity = 0
							--select *
							FROM datclientmembershipaccum clma
								inner join datclientmembership clm
									on clma.clientmembershipguid = clm.clientmembershipguid
								inner join datclient cl
									on clm.clientguid = cl.clientguid
							WHERE cl.clientidentifier = @clientidentifier
								and clma.accumulatorid in (8,9,10,11)
								and (cl.[CurrentBioMatrixClientMembershipGUID] = clma.clientmembershipguid
										or cl.[CurrentExtremeTherapyClientMembershipGUID] = clma.clientmembershipguid
										or cl.[CurrentXtrandsClientMembershipGUID] = clma.clientmembershipguid)
							--
							--Update CLMA records with zero Membership Revenue
							--
							UPDATE clma
								SET AccumMoney = 0
							--select *
							FROM datclientmembershipaccum clma
								inner join datclientmembership clm
									ON clma.clientmembershipguid = clm.clientmembershipguid
								inner join datclient cl
									ON clm.clientguid = cl.clientguid
							WHERE cl.clientidentifier = @clientidentifier
								and clma.accumulatorid in (20)
								and (cl.[CurrentBioMatrixClientMembershipGUID] = clma.clientmembershipguid
										or cl.[CurrentExtremeTherapyClientMembershipGUID] = clma.clientmembershipguid
										or cl.[CurrentXtrandsClientMembershipGUID] = clma.clientmembershipguid)
							--
							--Update CLMA records with zero Contract Balance
							--
							UPDATE clma
								SET AccumMoney = 0
							--select *
							FROM datclientmembershipaccum clma
								inner join datclientmembership clm
									ON clma.clientmembershipguid = clm.clientmembershipguid
								inner join datclient cl
									ON clm.clientguid = cl.clientguid
							WHERE cl.clientidentifier = @clientidentifier
								and clma.accumulatorid in (1)
								and (cl.[CurrentBioMatrixClientMembershipGUID] = clma.clientmembershipguid
										or cl.[CurrentExtremeTherapyClientMembershipGUID] = clma.clientmembershipguid
										or cl.[CurrentXtrandsClientMembershipGUID] = clma.clientmembershipguid)
							--
							--Update CLM records with zero Contract paid & price amounts to zero
							--
							UPDATE clm
								SET ContractPrice = 0,ContractPaidAmount=0
							--select *
							FROM datclientmembership clm
								inner join datclient cl
									ON clm.clientguid = cl.clientguid
							WHERE cl.clientidentifier = @clientidentifier
								and (cl.[CurrentBioMatrixClientMembershipGUID] = clm.clientmembershipguid
										or cl.[CurrentExtremeTherapyClientMembershipGUID] = clm.clientmembershipguid
										or cl.[CurrentXtrandsClientMembershipGUID] = clm.clientmembershipguid)

							--
							--Populate temp table with all Client's Orders
							--
							INSERT INTO #ClientOrders (OrderGUID,CLMGUID)
							SELECT so.SalesOrderGUID, so.ClientMembershipGUID
							FROM datsalesorder so
								inner join datclient cl
									ON so.clientguid = cl.clientguid
								inner join datClientMembership cm ON cm.ClientMembershipGuid = so.ClientMembershipGuid
								inner join cfgMembership mem ON mem.MembershipID = cm.MembershipID
								inner join lkpBusinessSegment bs ON bs.BusinessSegmentID = mem.BusinessSegmentID
								inner join INFOSTORECONV.dbo.Clients ic
									on cl.centerid = ic.center and cl.clientnumber_temp = ic.client_no

							WHERE cl.clientidentifier = @clientidentifier
								and so.isvoidedflag = 0
								and so.isClosedflag = 1
								and bs.BusinessSegmentDescriptionShort <> 'SUR' -- Exclude Surgery Memberships
								and (
										so.OrderDate > ic.Member1_Beg
								or		(cl.[CurrentBioMatrixClientMembershipGUID] = so.clientmembershipguid
										or cl.[CurrentExtremeTherapyClientMembershipGUID] = so.clientmembershipguid
										or cl.[CurrentXtrandsClientMembershipGUID] = so.clientmembershipguid)
										)
							order by so.orderdate
							--select * from #ClientOrders

							--
							--Set counter and total centers variables
							--
							SET @Count = 1
							SELECT @Total = MAX(ID)
							FROM #ClientOrders
							--
							--Loop through each center and execute the dynamic SQL for each center
							--
							WHILE @Count <= @Total
							BEGIN
								SELECT @CurrentOrderGUID = OrderGUID
								FROM #ClientOrders
								WHERE ID = @Count

								SET @SQL = 'mtnMembershipAccumAdjustment ''SALES ORDER'',''' + CONVERT(nvarchar(max), @CurrentOrderGUID) + ''''

								EXEC(@SQL)
								--print @currentOrderGUID

								SET @Count = @Count + 1
							END

					SET @MASTERCount = @MASTERCount + 1
				END
				--
				-- Re-Insert Accumulator join between lasercomb payment and contract balance
				--
				INSERT INTO [dbo].[cfgAccumulatorJoin]
					([AccumulatorJoinSortOrder],[AccumulatorJoinTypeID],[SalesCodeID],[AccumulatorID]
					,[AccumulatorDataTypeID],[AccumulatorActionTypeID],[AccumulatorAdjustmentTypeID],[IsActiveFlag]
					,[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser],[HairSystemOrderProcessID])
				VALUES
					(4,1,673,1,2,1,6,1,GETUTCDATE(),'sa',GETUTCDATE(),'sa',null)
				--
				--
				--Update CLMA Hair System Accumulator (8)
				--
				update clma
				set clma.TotalAccumQuantity = c.time1 + c.time1_used,
					clma.UsedAccumQuantity = time1_used,
					clma.lastupdate = getutcdate(),
					clma.LastUpdateUser = 'sa-conv'
				from datclient clbio
					inner join datClientmembership clm
						on clbio.CurrentBioMatrixClientMembershipGUID = clm.ClientMembershipGUID
					inner join datclientmembershipaccum clma
						on clm.clientmembershipguid = clma.clientmembershipguid
							and clma.accumulatorid = 8
					inner join INFOSTORECONV.dbo.clients c
						on clbio.centerid = c.center
						and clbio.clientnumber_temp = c.client_no
				where
						clm.centerid = @center and clm.member1_ID_temp <> 0
						and (time1 + Time1_Used) <> TotalAccumQuantity
				--
				--Update CLMA Services Accumulator (9)
				--
				update clma
				set clma.TotalAccumQuantity = (c.time2 + c.time2_used),
					clma.UsedAccumQuantity = time2_used,
					clma.lastupdate = getutcdate(),
					clma.LastUpdateUser = 'sa-conv'
				from datclient clbio
					inner join datClientmembership clm
						on clbio.CurrentBioMatrixClientMembershipGUID = clm.ClientMembershipGUID
					inner join datclientmembershipaccum clma
						on clm.clientmembershipguid = clma.clientmembershipguid
							and clma.accumulatorid = 9
					inner join INFOSTORECONV.dbo.clients c
						on clbio.centerid = c.center
						and clbio.clientnumber_temp = c.client_no
				where
						clm.centerid = @center and clm.member1_ID_temp <> 0
						and (time2 + Time2_Used) <> TotalAccumQuantity
				--
				--Update CLMA Solutions Accumulator (10)
				--
				update clma
				set clma.TotalAccumQuantity = (c.time3 + c.time3_used),
					clma.UsedAccumQuantity = time2_used,
					clma.lastupdate = getutcdate(),
					clma.LastUpdateUser = 'sa-conv'
				from datclient clbio
					inner join datClientmembership clm
						on clbio.CurrentBioMatrixClientMembershipGUID = clm.ClientMembershipGUID
					inner join datclientmembershipaccum clma
						on clm.clientmembershipguid = clma.clientmembershipguid
							and clma.accumulatorid = 10
					inner join INFOSTORECONV.dbo.clients c
						on clbio.centerid = c.center
						and clbio.clientnumber_temp = c.client_no
				where
						clm.centerid = @center and clm.member1_ID_temp <> 0
						and (time3 + Time3_Used) <> TotalAccumQuantity
				--
				--Update CLMA Product Kit Accumulator (11) for BIOMatrix
				--
				update clma
				set clma.TotalAccumQuantity = (c.time4 + c.time4_used),
					clma.UsedAccumQuantity = time4_used,
					clma.lastupdate = getutcdate(),
					clma.LastUpdateUser = 'sa-conv'
				from datclient clbio
					inner join datClientmembership clm
						on clbio.CurrentBioMatrixClientMembershipGUID = clm.ClientMembershipGUID
					inner join datclientmembershipaccum clma
						on clm.clientmembershipguid = clma.clientmembershipguid
							and clma.accumulatorid = 11
					inner join INFOSTORECONV.dbo.clients c
						on clbio.centerid = c.center
						and clbio.clientnumber_temp = c.client_no
				where
						clm.centerid = @center and clm.member1_ID_temp <> 0
						and (time4 + Time4_Used) <> TotalAccumQuantity
				--
				--Update CLMA Product Kit Accumulator (11) for EXT
				--
				update clma
				set clma.TotalAccumQuantity = (c.time4 + c.time4_used),
					clma.UsedAccumQuantity = time4_used,
					clma.lastupdate = getutcdate(),
					clma.LastUpdateUser = 'sa-conv'
				from datclient clext
					inner join datClientmembership clm
						on clext.CurrentExtremeTherapyClientMembershipGUID = clm.ClientMembershipGUID
					inner join datclientmembershipaccum clma
						on clm.clientmembershipguid = clma.clientmembershipguid
							and clma.accumulatorid = 11
					inner join INFOSTORECONV.dbo.clients c
						on clext.centerid = c.center
						and clext.clientnumber_temp = c.client_no
				where
						clm.centerid = @center and clm.member1_ID_temp <> 0
						and (time4 + Time4_Used) <> TotalAccumQuantity
				--
				--Update CLMA Services Accumulator (9) for EXT
				--
				update clma
				set clma.TotalAccumQuantity = (c.time2 + c.time2_used),
					clma.UsedAccumQuantity = time2_used,
					clma.lastupdate = getutcdate(),
					clma.LastUpdateUser = 'sa-conv'
				from datclient clext
					inner join datClientmembership clm
						on clext.CurrentExtremeTherapyClientMembershipGUID = clm.ClientMembershipGUID
					inner join datclientmembershipaccum clma
						on clm.clientmembershipguid = clma.clientmembershipguid
							and clma.accumulatorid = 9
					inner join INFOSTORECONV.dbo.clients c
						on clext.centerid = c.center
						and clext.clientnumber_temp = c.client_no
				where
						clm.centerid = @center and clm.member1_ID_temp <> 0
						and (time2 + Time2_Used) <> TotalAccumQuantity

				--
				--Update CLMA Product Kit Accumulator (11) for XTR
				--
				update clma
				set clma.TotalAccumQuantity = (c.time4 + c.time4_used),
					clma.UsedAccumQuantity = time4_used,
					clma.lastupdate = getutcdate(),
					clma.LastUpdateUser = 'sa-conv'
				from datclient clxtr
					inner join datClientmembership clm
						on clxtr.CurrentXtrandsClientMembershipGUID = clm.ClientMembershipGUID
					inner join datclientmembershipaccum clma
						on clm.clientmembershipguid = clma.clientmembershipguid
							and clma.accumulatorid = 11
					inner join INFOSTORECONV.dbo.clients c
						on clxtr.centerid = c.center
						and clxtr.clientnumber_temp = c.client_no
				where
						clm.centerid = @center and clm.member1_ID_temp <> 0
						and (time4 + Time4_Used) <> TotalAccumQuantity
--
				--Update CLMA Services Accumulator (9) for XTR
				--
				update clma
				set clma.TotalAccumQuantity = (c.time2 + c.time2_used),
					clma.UsedAccumQuantity = time2_used,
					clma.lastupdate = getutcdate(),
					clma.LastUpdateUser = 'sa-conv'
				from datclient clxtr
					inner join datClientmembership clm
						on clxtr.CurrentXtrandsClientMembershipGUID = clm.ClientMembershipGUID
					inner join datclientmembershipaccum clma
						on clm.clientmembershipguid = clma.clientmembershipguid
							and clma.accumulatorid = 9
					inner join INFOSTORECONV.dbo.clients c
						on clxtr.centerid = c.center
						and clxtr.clientnumber_temp = c.client_no
				where
						clm.centerid = @center and clm.member1_ID_temp <> 0
						and (time2 + Time2_Used) <> TotalAccumQuantity
--
				--Update CLMA Solutions Accumulator (10) for XTR
				--
				update clma
				set clma.TotalAccumQuantity = (c.time3 + c.time3_used),
					clma.UsedAccumQuantity = time2_used,
					clma.lastupdate = getutcdate(),
					clma.LastUpdateUser = 'sa-conv'
				from datclient clxtr
					inner join datClientmembership clm
						on clxtr.CurrentXtrandsClientMembershipGUID = clm.ClientMembershipGUID
					inner join datclientmembershipaccum clma
						on clm.clientmembershipguid = clma.clientmembershipguid
							and clma.accumulatorid = 10
					inner join INFOSTORECONV.dbo.clients c
						on clxtr.centerid = c.center
						and clxtr.clientnumber_temp = c.client_no
				where
						clm.centerid = @center and clm.member1_ID_temp <> 0
						and (time3 + Time3_Used) <> TotalAccumQuantity

				--
				--Update CLMA Accumulator (36,37) for Last Used PK & Solutions
				--
				Update cma

				Set AccumDate = orderQuery.OrderDate

				from
					(Select so.clientmembershipguid, so.OrderDate

						From cfgAccumulatorJoin aj
							Inner Join datSalesOrderDetail sod on aj.SalesCodeId = sod.SalesCodeId
							Inner Join datSalesOrder so on so.salesorderguid = sod.salesorderguid

						Where aj.accumulatorid in (36,37) and
							so.IsVoidedFlag = 0 and
							so.IsClosedFlag = 1 and
							so.orderdate = (select Max(orderdate) from datSalesOrder where clientmembershipguid = so.clientmembershipguid) and
							so.centerid = @Center) as orderQuery

						Inner Join datClientMembershipAccum cma on orderQuery.clientmembershipguid = cma.clientmembershipGuid and cma.accumulatorid in (36,37)

		END
