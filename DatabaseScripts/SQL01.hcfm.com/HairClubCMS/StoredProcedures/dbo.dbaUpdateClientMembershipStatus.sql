/***********************************************************************

		PROCEDURE:				dbaUpdateClientMembershipStatus

		DESTINATION SERVER:		SQL01

		DESTINATION DATABASE: 	HairClubCMS

		RELATED APPLICATION:  	CMS

		AUTHOR: 				Kevin Murdoch

		IMPLEMENTOR: 			Kevin Murdoch

		DATE IMPLEMENTED: 		01/10/2013

		LAST REVISION DATE: 	01/10/2013

		--------------------------------------------------------------------------------------------------------
		NOTES: 	Delete invalid client records
			* 01/10/2013 KRM - Created Stored Proc

		--------------------------------------------------------------------------------------------------------

		SAMPLE EXECUTION:

		EXEC dbaUpdateClientMembershipStatus '201'

		***********************************************************************/

		CREATE PROCEDURE [dbo].[dbaUpdateClientMembershipStatus](
			@Center int
		)AS
		BEGIN
			SET NOCOUNT ON
			IF OBJECT_ID('tempdb..#EXPIRE') IS NOT NULL
				DROP TABLE #EXPIRE

			IF OBJECT_ID('tempdb..#CONV') IS NOT NULL
				DROP TABLE #CONV

			IF OBJECT_ID('tempdb..#UPG') IS NOT NULL
				DROP TABLE #UPG

			IF OBJECT_ID('tempdb..#DWN') IS NOT NULL
				DROP TABLE #DWN

			IF OBJECT_ID('tempdb..#RNKREN') is not null
				DROP TABLE #RNKREN

			IF OBJECT_ID('tempdb..#REN') IS NOT NULL
				DROP TABLE #REN

			IF OBJECT_ID('tempdb..#CXL') IS NOT NULL
				DROP TABLE #CXL

			IF OBJECT_ID('tempdb..#CANCEL') IS NOT NULL
				DROP TABLE #CANCEL
			-------------------------------------------------------------------------------------
			-- Change ClientMembershipStatus to Expire for Membership Expired in CMS 2.5
			-------------------------------------------------------------------------------------
			SELECT
				center,
				member1_id
			INTO #EXPIRE
			FROM [hcsql2\sql2005].infostore.dbo.transactions
			WHERE code like 'nb1xpr' and date >= '07/01/08'
				AND MEMBER1_ID <> 0
				and center = @center

			--SELECT * FROM #EXPIRE

			UPDATE CLM
			SET ClientMembershipStatusID = 4,
				LastUpdate = GETUTCDATE(),
				LastUpdateUser = 'sa'
			--SELECT	CLIENTMEMBERSHIPSTATUSID, 	*
			FROM DATCLIENTMEMBERSHIP CLM
				INNER JOIN #EXPIRE
					ON CLM.CENTERID = #EXPIRE.CENTER
						AND CLM.MEMBER1_ID_TEMP = #EXPIRE.MEMBER1_ID
			WHERE CLM.ClientMembershipStatusID <> 1

			-------------------------------------------------------------------------------------
			-- Change ClientMembershipStatus to Convert for Membership Converted in CMS 2.5
			-------------------------------------------------------------------------------------

			SELECT
				center,
				member1_id
			INTO #CONV
			FROM [hcsql2\sql2005].infostore.dbo.transactions
			WHERE department = 12 and date >= '07/01/08'  --nb1c and extc
				AND MEMBER1_ID <> 0
				and center = @center

			--SELECT * FROM #CONV

			UPDATE CLM
			SET ClientMembershipStatusID = 6,
				LastUpdate = GETUTCDATE(),
				LastUpdateUser = 'sa'
			--SELECT	CLIENTMEMBERSHIPSTATUSID, 	*
			FROM DATCLIENTMEMBERSHIP CLM
				INNER JOIN #CONV
					ON CLM.CENTERID = #CONV.CENTER
						AND CLM.MEMBER1_ID_TEMP = #CONV.MEMBER1_ID
			WHERE CLM.ClientMembershipStatusID <> 1
			-------------------------------------------------------------------------------------
			-- Change ClientMembershipStatus to Upgraded for Membership Upgraded in CMS 2.5
			-------------------------------------------------------------------------------------
			SELECT
				center,
				member1_id
			INTO #UPG
			FROM [hcsql2\sql2005].infostore.dbo.transactions
			WHERE department IN (22,32) and date >= '07/01/08' --nb2xu, pcpxu
				AND MEMBER1_ID <> 0
				and center = @center

			--SELECT * FROM #UPG

			UPDATE CLM
			SET ClientMembershipStatusID = 7,
				LastUpdate = GETUTCDATE(),
				LastUpdateUser = 'sa'
			--SELECT	CLIENTMEMBERSHIPSTATUSID, 	*
			FROM DATCLIENTMEMBERSHIP CLM
				INNER JOIN #UPG
					ON CLM.CENTERID = #UPG.CENTER
						AND CLM.MEMBER1_ID_TEMP = #UPG.MEMBER1_ID
			WHERE CLM.ClientMembershipStatusID <> 1
			-------------------------------------------------------------------------------------
			-- Change ClientMembershipStatus to Downgraded for Membership Downgraded in CMS 2.5
			-------------------------------------------------------------------------------------
			SELECT
				center,
				member1_id
			INTO #DWN
			FROM [hcsql2\sql2005].infostore.dbo.transactions
			WHERE department IN (33) and date >= '07/01/08'  --pcpxd
				AND MEMBER1_ID <> 0
				and center = @center

			--SELECT * FROM #DWN

			UPDATE CLM
			SET ClientMembershipStatusID = 8,
				LastUpdate = GETUTCDATE(),
				LastUpdateUser = 'sa'
			--SELECT	CLIENTMEMBERSHIPSTATUSID, 	*
			FROM DATCLIENTMEMBERSHIP CLM
				INNER JOIN #DWN
					ON CLM.CENTERID = #DWN.CENTER
						AND CLM.MEMBER1_ID_TEMP = #DWN.MEMBER1_ID
			WHERE CLM.ClientMembershipStatusID <> 1

			-------------------------------------------------------------------------------------
			-- Change ClientMembershipStatus to Renewed for Membership Renewed in CMS 2.5
			-------------------------------------------------------------------------------------
			SELECT center
			,      client_no
			,      transact_no
			,      ticket_no
			,      date
			,      code
			,      member1_id
			,	   rank() OVER
					(PARTITION BY client_no ORDER BY member1_id asc) AS 'MRank'
			,	   rank() OVER
					(PARTITION BY client_no ORDER BY member1_id asc) +1 AS 'NRank'
			INTO #RNKREN
			FROM [hcsql2\sql2005].infostore.dbo.transactions
			WHERE center=@CENTER and department in (21,31)
				   and member1_id <> 0
				   and ticket_no = member1_id
				   and date >= '07/01/08'
			ORDER BY client_no,transact_no

			--select * from #new

			SELECT
				t.center,
				T.CLIENT_NO,
				orig.mrank,
				newmem.nrank,
				newmem.member1_id as 'FromMember1_ID',
				--orig.member1_id,
				t.member1_id as 'TrxMember1_ID'
			INTO #REN
			FROM  [hcsql2\sql2005].infostore.dbo.transactions t
					inner join #RNKREN orig
						ON t.client_no = orig.client_no
							and t.member1_id = orig.member1_id
					inner join #RNKREN newmem
						ON t.client_no = newmem.Client_no
							and orig.mrank = newmem.nrank
			WHERE t.department in (21,31) and t.center = @CENTER
				and t.[date] >= '07/01/08'
			ORDER BY t.CENTER, T.CLIENT_NO,t.transact_no

			--SELECT * FROM #REN

			UPDATE CLM
			SET ClientMembershipStatusID = 9,
				LastUpdate = GETUTCDATE(),
				LastUpdateUser = 'sa'
			--SELECT	CLIENTMEMBERSHIPSTATUSID,cl.ClientNumber_Temp, 	*
			FROM DATCLIENTMEMBERSHIP CLM
				INNER JOIN #REN
					ON CLM.CENTERID = #REN.CENTER
						AND CLM.MEMBER1_ID_TEMP = #REN.FromMember1_ID
				INNER JOIN datclient cl
					on CLM.CLIENTGUID = cl.clientguid
			WHERE CLM.ClientMembershipStatusID <> 3
				AND #REN.FromMember1_ID <> 0
				AND CLM.ClientMembershipStatusID <> 1

			-------------------------------------------------------------------------------------
			-- Change ClientMembershipStatus to Cancelled for Membership Cancelled in CMS 2.5
			-------------------------------------------------------------------------------------

			SELECT
				center,
				member1_id
			INTO #CXL
			FROM [hcsql2\sql2005].infostore.dbo.transactions
			WHERE department IN (14,24,34) and date >= '07/01/08'
				AND MEMBER1_ID <> 0
				and center = @CENTER

			--SELECT * FROM #CXL

			UPDATE CLM
			SET ClientMembershipStatusID = 3,
				LastUpdate = GETUTCDATE(),
				LastUpdateUser = 'sa'
			--SELECT	CLIENTMEMBERSHIPSTATUSID, 	*
			FROM DATCLIENTMEMBERSHIP CLM
				INNER JOIN #CXL
					ON CLM.CENTERID = #CXL.CENTER
						AND CLM.MEMBER1_ID_TEMP = #CXL.MEMBER1_ID
			WHERE CLM.ClientMembershipStatusID NOT IN (1,3,4)
				AND MEMBER1_ID <> 0
			-------------------------------------------------------------------------------------
			-- Change ClientMembershipStatus to Cancelled for Membership = CANCEL
			-------------------------------------------------------------------------------------

			SELECT
				center,
				member1_id
			INTO #CANCEL
			FROM [hcsql2\sql2005].infostore.dbo.transactions
			WHERE CODE = 'CANCEL' and date >= '07/01/08'
				AND MEMBER1_ID <> 0
				and center = @CENTER

			--SELECT * FROM #CANCEL

			UPDATE CLM
			SET ClientMembershipStatusID = 3,
				LastUpdate = GETUTCDATE(),
				LastUpdateUser = 'sa'
			--SELECT	CLIENTMEMBERSHIPSTATUSID, 	*
			FROM DATCLIENTMEMBERSHIP CLM
				INNER JOIN #CANCEL
					ON CLM.CENTERID = #CANCEL.CENTER
						AND CLM.MEMBER1_ID_TEMP = #CANCEL.MEMBER1_ID
			WHERE CLM.ClientMembershipStatusID <> 1
				AND MEMBER1_ID <> 0
		END
