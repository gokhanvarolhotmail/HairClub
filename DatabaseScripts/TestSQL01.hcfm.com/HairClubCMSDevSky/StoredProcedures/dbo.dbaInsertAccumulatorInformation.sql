/* CreateDate: 02/04/2013 17:26:18.817 , ModifyDate: 10/03/2014 09:53:36.477 */
GO
/***********************************************************************

PROCEDURE:				dbaInsertAccumulatorInformation

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass, Skyline Technologies

IMPLEMENTOR: 			Mike Maass, Skyline Technologies

DATE IMPLEMENTED: 		 09/17/2012

/LAST REVISION DATE: 	 12/04/2012

--------------------------------------------------------------------------------------------------------
NOTES:  This script is used to import Sales Transactions into CMS.
		* 09/17/2012 MLM - Created stored proc
		* 09/19/2012 JGE - Fix duplicate Accumulator issue.
		* 12/04/2012 KRM - Broke out accumulator builds for sys/srv/sol/pk into 4 scripts rather than one
		*					big one. Easier to control adds.
		* 08/20/2014 RMH - Added APPSOL to "Add Last Application -13" section; and added EXTSVCSOL, EXTMEMSVCSOL, SVCSOL and APPSOL to "Add Last Service Date -16" section
		* 10/03/2014 RMH - Added EXTSVCXTD to "Add Last Service Date -16" section

--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [dbaInsertAccumulatorInformation]
***********************************************************************/
CREATE PROCEDURE [dbo].[dbaInsertAccumulatorInformation] AS
BEGIN

	SET NOCOUNT ON
--
-- Clear and INSERT Initial Membership Quantities into cfgMembershipAccum for Services
-- THESE ALREADY EXIST IN LIVE
--

		DELETE FROM cfgMembershipAccum
		WHERE accumulatorid = 9

		INSERT INTO [cfgMembershipAccum]
				   ([MembershipAccumulatorSortOrder]
				   ,[MembershipID]
				   ,[AccumulatorID]
				   ,[InitialQuantity]
				   ,[IsActiveFlag]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser])
		SELECT
						1 as 'MembershipAccumulatorSortOrder'
					--, csc.code
					--, csc.accum_2_plus
					--, CSC.member_type
					--, CSC.additional_type
					,	mem.[MembershipID]
   					,	9 as 'AccumulatorID'		--Services
					,	accum_2_plus as 'InitialQuantity'
					,	1  as 'IsActiveFlag'
					,	GETUTCDATE() as 'CreateDate'
					,	'sa' as 'CreateUser'
					,	GETUTCDATE() as 'LastUpdate'
					,	'sa' as 'LastUpdateUser'


		 from INFOSTORECONV.dbo.CMSCONVSales_Code csc
			LEFT JOIN cfgMembership mem
				ON dbo.fx_GetCMSMembership(csc.member_type, csc.additional_type) = mem.MembershipDescriptionShort
			where accum_2_plus <> 0
					and csc.code not in ( 'convsol2svr', 'promosvr', 'pcpxd', 'pcpxu','EXTMEMR','EXTMEMSOLR',
											 'HCFKR')
					and department NOT IN (21,31)
--
-- INSERT Initial Membership Quantities into cfgMembershipAccum for Solutions
--
		INSERT INTO [cfgMembershipAccum]
				   ([MembershipAccumulatorSortOrder]
				   ,[MembershipID]
				   ,[AccumulatorID]
				   ,[InitialQuantity]
				   ,[IsActiveFlag]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser])
		select
						1 as 'MembershipAccumulatorSortOrder'
					--, csc.code
					--, csc.accum_2_plus
					--, CSC.member_type
					--, CSC.additional_type
					,	mem.[MembershipID]
   					,	10 as 'AccumulatorID'			--BIO Solutions
					,	accum_3_plus as 'InitialQuantity'
					,	1  as 'IsActiveFlag'
					,	GETUTCDATE() as 'CreateDate'
					,	'sa' as 'CreateUser'
					,	GETUTCDATE() as 'LastUpdate'
					,	'sa' as 'LastUpdateUser'


		 from INFOSTORECONV.dbo.CMSCONVSales_Code csc
			LEFT JOIN cfgMembership mem
				ON dbo.fx_GetCMSMembership(csc.member_type, csc.additional_type) = mem.MembershipDescriptionShort
			LEFT JOIN cfgMembershipAccum aMem on mem.[MembershipID] = aMem.[MembershipID]
				AND 10 = aMem.[AccumulatorID]
		where accum_3_plus <> 0 and csc.code not in ( 'PROMOSOL','EXTMEMR')
				AND department NOT IN (21,31)
				AND aMem.MembershipID IS NULL
		--
		-- INSERT Initial Membership Quantities into cfgMembershipAccum for Product Kits
		--
		INSERT INTO [cfgMembershipAccum]
				   ([MembershipAccumulatorSortOrder]
				   ,[MembershipID]
				   ,[AccumulatorID]
				   ,[InitialQuantity]
				   ,[IsActiveFlag]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser])
		select
						1 as 'MembershipAccumulatorSortOrder'
					--, csc.code
					--, csc.accum_4_plus
					,	mem.[MembershipID]
   					,	11 as 'AccumulatorID'		--Product Kits
					,	accum_4_plus as 'InitialQuantity'
					,	1  as 'IsActiveFlag'
					,	GETUTCDATE() as 'CreateDate'
					,	'sa' as 'CreateUser'
					,	GETUTCDATE() as 'LastUpdate'
					,	'sa' as 'LastUpdateUser'


		 from INFOSTORECONV.dbo.CMSCONVSales_Code csc
			LEFT JOIN cfgMembership mem
				ON dbo.fx_GetCMSMembership(csc.member_type, csc.additional_type) = mem.MembershipDescriptionShort
			LEFT JOIN cfgMembershipAccum aMem on mem.[MembershipID] = aMem.[MembershipID]
				AND 11 = aMem.[AccumulatorID]
		where accum_4_plus <> 0
			and csc.code not in ('PROMOSOL')
			AND department NOT IN (21,31)
			AND aMem.[MembershipID] IS NULL
		order by MembershipID

		--
		-- INSERT Miscellaneous Accumulators for Each Active Membership
		--
		INSERT INTO [cfgMembershipAccum]
				   ([MembershipAccumulatorSortOrder]
				   ,[MembershipID]
				   ,[AccumulatorID]
				   ,[InitialQuantity]
				   ,[IsActiveFlag]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser])
		select
						1 as 'MembershipAccumulatorSortOrder'
					--,mem.MembershipDescription
					--,ac.AccumulatorDescriptionShort
					,	mem.[MembershipID]
   					,	ac.AccumulatorID as 'AccumulatorID'
					,	0 as 'InitialQuantity'
					,	1  as 'IsActiveFlag'
					,	GETUTCDATE() as 'CreateDate'
					,	'sa' as 'CreateUser'
					,	GETUTCDATE() as 'LastUpdate'
					,	'sa' as 'LastUpdateUser'
				--,*

		 from cfgMembership mem
			inner join cfgAccumulator ac on
				1 = ac.SalesOrderProcessFlag
					and ac.AccumulatorID in (1,		--Contract Balance
											3,		--A/R Balance
											4,		--Cancel Date
											5,		--Sale Date
											7,		--Last Payment
											13,		--Last Application
											15,		--Last CKU
											16,		--Last SVC
											20,		--Membership Revenue
											22,		--Product Revenue
											23,		--Service Revenue
											24		--Misc Revenue
											)

			LEFT JOIN cfgMembershipAccum aMem on mem.[MembershipID] = aMem.[MembershipID]
				AND ac.AccumulatorID = aMem.[AccumulatorID]
		WHERE aMem.[MembershipID] IS NULL
		order by mem.MembershipDescriptionShort
		--
		-- INSERT Conversion Date for New Business Memberships
		--
		INSERT INTO [cfgMembershipAccum]
				   ([MembershipAccumulatorSortOrder]
				   ,[MembershipID]
				   ,[AccumulatorID]
				   ,[InitialQuantity]
				   ,[IsActiveFlag]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser])
		select
						1 as 'MembershipAccumulatorSortOrder'
					--,mem.MembershipDescription
					--,ac.AccumulatorDescriptionShort
					,	mem.[MembershipID]
   					,	ac.AccumulatorID as 'AccumulatorID'
					,	0 as 'InitialQuantity'
					,	1  as 'IsActiveFlag'
					,	GETUTCDATE() as 'CreateDate'
					,	'sa' as 'CreateUser'
					,	GETUTCDATE() as 'LastUpdate'
					,	'sa' as 'LastUpdateUser'
				--,*

		 from cfgMembership mem
			inner join cfgAccumulator ac on
				1 = ac.SalesOrderProcessFlag
					and ac.AccumulatorID in (25		--Conversion Date
											)
				and MembershipDescriptionShort in ('EXTENH6',
				'EXTENH12',
				'EXTENH9',
				'TRADITION',
				'GRDSV12',
				'GRDSVSOL12',
				'GRDSV',
				'GRDSVSOL',
				'GRAD',
				'GRADSOL6',
				'GRADSOL12',
				'EXT12',
				'EXT6',
				'POSTEXT',
				'POSTEL'
				)
			LEFT JOIN cfgMembershipAccum aMem on mem.[MembershipID] = aMem.[MembershipID]
				AND ac.AccumulatorID = aMem.[AccumulatorID]
		WHERE aMem.[MembershipID] IS NULL
		order by mem.MembershipDescriptionShort
		--
		-- INSERT Inital Application Date for New Business Memberships
		--
		INSERT INTO [cfgMembershipAccum]
				   ([MembershipAccumulatorSortOrder]
				   ,[MembershipID]
				   ,[AccumulatorID]
				   ,[InitialQuantity]
				   ,[IsActiveFlag]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser])
		select
						1 as 'MembershipAccumulatorSortOrder'
					--,mem.MembershipDescription
					--,ac.AccumulatorDescriptionShort
					,	mem.[MembershipID]
   					,	ac.AccumulatorID as 'AccumulatorID'
					,	0 as 'InitialQuantity'
					,	1  as 'IsActiveFlag'
					,	GETUTCDATE() as 'CreateDate'
					,	'sa' as 'CreateUser'
					,	GETUTCDATE() as 'LastUpdate'
					,	'sa' as 'LastUpdateUser'
				--,*

		 from cfgMembership mem
			inner join cfgAccumulator ac on
				1 = ac.SalesOrderProcessFlag
					and ac.AccumulatorID in (17		--Initial Application Date
											)
				and MembershipDescriptionShort in (
				'TRADITION',
				'GRDSV12',
				'GRDSVSOL12',
				'GRDSV',
				'GRDSVSOL',
				'GRAD',
				'GRADSOL6',
				'GRADSOL12'
				)
			LEFT JOIN cfgMembershipAccum aMem on mem.[MembershipID] = aMem.[MembershipID]
				AND ac.AccumulatorID = aMem.[AccumulatorID]
		WHERE aMem.[MembershipID] IS NULL
		order by mem.MembershipDescriptionShort


		-------------------------------------------------------------------------------------------
		--                CFGACCUMULATORJOIN
		-------------------------------------------------------------------------------------------

		--
		-- (8,9,10,11) INSERT BIO Systems, Services, Solutions, and Product Kits-ADD (PCP mbr Chg)
		--
		INSERT INTO [cfgAccumulatorJoin]
				   ([AccumulatorJoinSortOrder]
				   ,[AccumulatorJoinTypeID]
				   ,[SalesCodeID]
				   ,[AccumulatorID]
				   ,[AccumulatorDataTypeID]
				   ,[AccumulatorActionTypeID]
				   ,[AccumulatorAdjustmentTypeID]
				   ,[IsActiveFlag]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser]
				   ,[HairSystemOrderProcessID])
		select
						1 as 'AccumulatorJoinSortOrder'
					,	1 AS 'AccumulatorJoinTypeID'			--Sales Code
   					,	csc.salescodeid as 'SalesCodeID'
					,	accum.AccumulatorID as 'AccumulatorID'		--BIO Systems
					,	1 as 'AccumulatorDataTypeID'			--Quantity Total
					,	3 as 'AccumulatorActionType'			--Replace
					,	8 as 'AccumulatorAdjustmentTypeID'		--Membership Initial Quantity
					,	1  as 'IsActiveFlag'
					,	GETUTCDATE() as 'CreateDate'
					,	'sa' as 'CreateUser'
					,	GETUTCDATE() as 'LastUpdate'
					,	'sa' as 'LastUpdateUser'
					,	NULL as 'HairSystemOrderProcessID'
				   --,*
		 from INFOSTORECONV.dbo.CMSCONVSales_Code csc
			LEFT JOIN cfgSalesCode sc
				ON csc.SalescodeID = sc.SalesCodeID
			left outer join cfgAccumulator accum
				on accum.AccumulatorID in (8,9,10,11)
			LEFT JOIN cfgAccumulatorJoin aJoin on csc.SalesCodeId = aJoin.SalesCodeId
				AND accum.AccumulatorID = aJoin.AccumulatorID
		where csc.code in (	'nb1c' --CONV
							,'nb1' --INITASG
							,'basr'--RENEW
							,'postext'--POSTEXT
							,'pcpxu'--UPGRADE
							,'pcpxd'--DOWNGRADE
							,'nb2'--NONPGM
							,'nb2r'--NONPGM RENEWAL
							--,'HCFK'--UPDMBR    This is causing duplicate HCFK and nb2 have same sales code. JGE 9/19/2012
							)
			AND aJoin.AccumulatorJoinID IS NULL
		order by csc.SalescodeID
		--
		-- INSERT Accumulator Join records for BIO Systems-SUBTRACT
		--
		INSERT INTO [cfgAccumulatorJoin]
				   ([AccumulatorJoinSortOrder]
				   ,[AccumulatorJoinTypeID]
				   ,[SalesCodeID]
				   ,[AccumulatorID]
				   ,[AccumulatorDataTypeID]
				   ,[AccumulatorActionTypeID]
				   ,[AccumulatorAdjustmentTypeID]
				   ,[IsActiveFlag]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser]
				   ,[HairSystemOrderProcessID])
		select
						1 as 'AccumulatorJoinSortOrder'
					,	1 AS 'AccumulatorJoinTypeID'			--Sales Code
   					,	sc.salescodeid as 'SalesCodeID'
					,	8 as 'AccumulatorID'					--BIO Systems
					,	4 as 'AccumulatorDataTypeID'			--Quantity Used
					,	1 as 'AccumulatorActionType'			--Add
					,	5 as 'AccumulatorAdjustmentTypeID'		--Sales Order Quantity
					,	1  as 'IsActiveFlag'
					,	GETUTCDATE() as 'CreateDate'
					,	'sa' as 'CreateUser'
					,	GETUTCDATE() as 'LastUpdate'
					,	'sa' as 'LastUpdateUser'
					,	NULL as 'HairSystemOrderProcessID'
				   --,*
		 from INFOSTORECONV.dbo.CMSCONVSales_Code csc
			LEFT JOIN cfgSalesCode sc
				ON csc.SalescodeID = sc.SalesCodeID
			--LEFT JOIN cfgAccumulatorJoin aJoin on csc.SalesCodeId = aJoin.SalesCodeId
			--	AND (case when accum_1_minus <> 0 then 8		--BIO Systems
			--				when accum_2_minus <> 0 then 9		--BIO Services
			--				when accum_3_minus <> 0 then 10		--BIO Solutions
			--				when accum_4_minus <> 0 then 11		--BIO Product Kits
			--				else null end)  = aJoin.AccumulatorID
		where Isnull(accum_1_minus,0) <> 0
			and csc.code not in ('CONVSOL2SVR', 'REMOVESYS')
			--AND aJoin.AccumulatorJoinID IS NULL
			order by csc.SalescodeID
		--
		-- INSERT Accumulator Join records for Services-SUBTRACT
		--
		INSERT INTO [cfgAccumulatorJoin]
				   ([AccumulatorJoinSortOrder]
				   ,[AccumulatorJoinTypeID]
				   ,[SalesCodeID]
				   ,[AccumulatorID]
				   ,[AccumulatorDataTypeID]
				   ,[AccumulatorActionTypeID]
				   ,[AccumulatorAdjustmentTypeID]
				   ,[IsActiveFlag]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser]
				   ,[HairSystemOrderProcessID])
		select
						1 as 'AccumulatorJoinSortOrder'
					,	1 AS 'AccumulatorJoinTypeID'			--Sales Code
   					,	sc.salescodeid as 'SalesCodeID'
					,	9 as 'AccumulatorID'					--Services
					,	4 as 'AccumulatorDataTypeID'			--Quantity Used
					,	1 as 'AccumulatorActionType'			--Add
					,	5 as 'AccumulatorAdjustmentTypeID'		--Sales Order Quantity
					,	1  as 'IsActiveFlag'
					,	GETUTCDATE() as 'CreateDate'
					,	'sa' as 'CreateUser'
					,	GETUTCDATE() as 'LastUpdate'
					,	'sa' as 'LastUpdateUser'
					,	NULL as 'HairSystemOrderProcessID'
				   --,*
		 from INFOSTORECONV.dbo.CMSCONVSales_Code csc
			LEFT JOIN cfgSalesCode sc
				ON csc.SalescodeID = sc.SalesCodeID
			--LEFT JOIN cfgAccumulatorJoin aJoin on csc.SalesCodeId = aJoin.SalesCodeId
			--	AND (case when accum_1_minus <> 0 then 8		--BIO Systems
			--				when accum_2_minus <> 0 then 9		--BIO Services
			--				when accum_3_minus <> 0 then 10		--BIO Solutions
			--				when accum_4_minus <> 0 then 11		--BIO Product Kits
			--				else null end)  = aJoin.AccumulatorID
		where
			isnull(accum_2_minus,0) <> 0

			and csc.code not in ('CONVSOL2SVR', 'REMOVESVR')
			--AND aJoin.AccumulatorJoinID IS NULL
			order by csc.SalescodeID

		--
		-- INSERT Accumulator Join records for Solutions-SUBTRACT
		--
		INSERT INTO [cfgAccumulatorJoin]
				   ([AccumulatorJoinSortOrder]
				   ,[AccumulatorJoinTypeID]
				   ,[SalesCodeID]
				   ,[AccumulatorID]
				   ,[AccumulatorDataTypeID]
				   ,[AccumulatorActionTypeID]
				   ,[AccumulatorAdjustmentTypeID]
				   ,[IsActiveFlag]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser]
				   ,[HairSystemOrderProcessID])
		select
						1 as 'AccumulatorJoinSortOrder'
					,	1 AS 'AccumulatorJoinTypeID'			--Sales Code
   					,	sc.salescodeid as 'SalesCodeID'
					,	10 as 'AccumulatorID'					--Solutions
					,	4 as 'AccumulatorDataTypeID'			--Quantity Used
					,	1 as 'AccumulatorActionType'			--Add
					,	5 as 'AccumulatorAdjustmentTypeID'		--Sales Order Quantity
					,	1  as 'IsActiveFlag'
					,	GETUTCDATE() as 'CreateDate'
					,	'sa' as 'CreateUser'
					,	GETUTCDATE() as 'LastUpdate'
					,	'sa' as 'LastUpdateUser'
					,	NULL as 'HairSystemOrderProcessID'
				   --,*
		 from INFOSTORECONV.dbo.CMSCONVSales_Code csc
			LEFT JOIN cfgSalesCode sc
				ON csc.SalescodeID = sc.SalesCodeID
			--LEFT JOIN cfgAccumulatorJoin aJoin on csc.SalesCodeId = aJoin.SalesCodeId
			--	AND (case when accum_1_minus <> 0 then 8		--BIO Systems
			--				when accum_2_minus <> 0 then 9		--BIO Services
			--				when accum_3_minus <> 0 then 10		--BIO Solutions
			--				when accum_4_minus <> 0 then 11		--BIO Product Kits
			--				else null end)  = aJoin.AccumulatorID
		where
			isnull(accum_3_minus,0) <> 0

			and csc.code not in ('CONVSOL2SVR', 'REMOVESOL')
			--AND aJoin.AccumulatorJoinID IS NULL
			order by csc.SalescodeID

		--
		-- INSERT Accumulator Join records for Product Kits-SUBTRACT
		--
		INSERT INTO [cfgAccumulatorJoin]
				   ([AccumulatorJoinSortOrder]
				   ,[AccumulatorJoinTypeID]
				   ,[SalesCodeID]
				   ,[AccumulatorID]
				   ,[AccumulatorDataTypeID]
				   ,[AccumulatorActionTypeID]
				   ,[AccumulatorAdjustmentTypeID]
				   ,[IsActiveFlag]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser]
				   ,[HairSystemOrderProcessID])
		select
						1 as 'AccumulatorJoinSortOrder'
					,	1 AS 'AccumulatorJoinTypeID'			--Sales Code
   					,	sc.salescodeid as 'SalesCodeID'
					,	11 as 'AccumulatorID'					--Product Kits
					,	4 as 'AccumulatorDataTypeID'			--Quantity Used
					,	1 as 'AccumulatorActionType'			--Add
					,	5 as 'AccumulatorAdjustmentTypeID'		--Sales Order Quantity
					,	1  as 'IsActiveFlag'
					,	GETUTCDATE() as 'CreateDate'
					,	'sa' as 'CreateUser'
					,	GETUTCDATE() as 'LastUpdate'
					,	'sa' as 'LastUpdateUser'
					,	NULL as 'HairSystemOrderProcessID'
				   --,*
		 from INFOSTORECONV.dbo.CMSCONVSales_Code csc
			LEFT JOIN cfgSalesCode sc
				ON csc.SalescodeID = sc.SalesCodeID
			--LEFT JOIN cfgAccumulatorJoin aJoin on csc.SalesCodeId = aJoin.SalesCodeId
			--	AND (case when accum_1_minus <> 0 then 8		--BIO Systems
			--				when accum_2_minus <> 0 then 9		--BIO Services
			--				when accum_3_minus <> 0 then 10		--BIO Solutions
			--				when accum_4_minus <> 0 then 11		--BIO Product Kits
			--				else null end)  = aJoin.AccumulatorID
		where
			isnull(accum_4_minus,0) <> 0

			and csc.code not in ('CONVSOL2SVR', 'REMOVEPKIT')
			--AND aJoin.AccumulatorJoinID IS NULL
			order by csc.SalescodeID
		--
		-- INSERT Accumulator Join records for Promo System, Service, Solution
		--
		INSERT INTO [cfgAccumulatorJoin]
				   ([AccumulatorJoinSortOrder]
				   ,[AccumulatorJoinTypeID]
				   ,[SalesCodeID]
				   ,[AccumulatorID]
				   ,[AccumulatorDataTypeID]
				   ,[AccumulatorActionTypeID]
				   ,[AccumulatorAdjustmentTypeID]
				   ,[IsActiveFlag]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser]
				   ,[HairSystemOrderProcessID])
		select
						1 as 'AccumulatorJoinSortOrder'
					,	1 AS 'AccumulatorJoinTypeID'			--Sales Code
   					,	sc.salescodeid as 'SalesCodeID'
					,	case when accum_1_plus <> 0 then 8		--BIO Systems
							when accum_2_plus <> 0 then 9		--BIO Services
							when accum_3_plus <> 0 then 10		--BIO Solutions
							when accum_4_plus <> 0 then 11		--BIO Product Kits
							else null end as 'AccumulatorID'					--BIO Systems
					,	1 as 'AccumulatorDataTypeID'			--Quantity Used
					,	1 as 'AccumulatorActionType'			--Remove
					,	2 as 'AccumulatorAdjustmentTypeID'		--Sales Order Quantity
					,	1  as 'IsActiveFlag'
					,	GETUTCDATE() as 'CreateDate'
					,	'sa' as 'CreateUser'
					,	GETUTCDATE() as 'LastUpdate'
					,	'sa' as 'LastUpdateUser'
					,	NULL as 'HairSystemOrderProcessID'
				   --,*
		 from INFOSTORECONV.dbo.CMSCONVSales_Code csc
			LEFT JOIN cfgSalesCode sc
				ON csc.SalescodeID = sc.SalesCodeID
			LEFT JOIN cfgAccumulatorJoin aJoin on csc.SalesCodeId = aJoin.SalesCodeId
				AND (case when accum_1_minus <> 0 then 8		--BIO Systems
							when accum_2_minus <> 0 then 9		--BIO Services
							when accum_3_minus <> 0 then 10		--BIO Solutions
							when accum_4_minus <> 0 then 11		--BIO Product Kits
							else null end)  = aJoin.AccumulatorID
		where (isnull(accum_1_plus,0) <> 0
			or isnull(accum_2_plus,0) <> 0
			or isnull(accum_3_plus,0) <> 0
			or isnull(accum_4_plus,0) <> 0)
			and csc.code in ('PROMOSVR','PROMOSOL','PROMOSYS','PROMOPKIT')
			AND aJoin.AccumulatorJoinID IS NULL
			order by csc.SalescodeID
		--
		-- INSERT Accumulator Join records for Remove System, Service, Solution
		--
		INSERT INTO [cfgAccumulatorJoin]
				   ([AccumulatorJoinSortOrder]
				   ,[AccumulatorJoinTypeID]
				   ,[SalesCodeID]
				   ,[AccumulatorID]
				   ,[AccumulatorDataTypeID]
				   ,[AccumulatorActionTypeID]
				   ,[AccumulatorAdjustmentTypeID]
				   ,[IsActiveFlag]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser]
				   ,[HairSystemOrderProcessID])
		select
						1 as 'AccumulatorJoinSortOrder'
					,	1 AS 'AccumulatorJoinTypeID'			--Sales Code
   					,	sc.salescodeid as 'SalesCodeID'
					,	case when accum_1_minus <> 0 then 8		--BIO Systems
							when accum_2_minus <> 0 then 9		--BIO Services
							when accum_3_minus <> 0 then 10		--BIO Solutions
							when accum_4_minus <> 0 then 11		--BIO Product Kits
							else null end as 'AccumulatorID'					--BIO Systems
					,	1 as 'AccumulatorDataTypeID'			--Quantity Used
					,	2 as 'AccumulatorActionType'			--Remove
					,	2 as 'AccumulatorAdjustmentTypeID'		--Sales Order Quantity
					,	1  as 'IsActiveFlag'
					,	GETUTCDATE() as 'CreateDate'
					,	'sa' as 'CreateUser'
					,	GETUTCDATE() as 'LastUpdate'
					,	'sa' as 'LastUpdateUser'
					,	NULL as 'HairSystemOrderProcessID'
				   --,*
		 from INFOSTORECONV.dbo.CMSCONVSales_Code csc
			LEFT JOIN cfgSalesCode sc
				ON csc.SalescodeID = sc.SalesCodeID
			LEFT JOIN cfgAccumulatorJoin aJoin on csc.SalesCodeId = aJoin.SalesCodeId
				AND (case when accum_1_minus <> 0 then 8		--BIO Systems
							when accum_2_minus <> 0 then 9		--BIO Services
							when accum_3_minus <> 0 then 10		--BIO Solutions
							when accum_4_minus <> 0 then 11		--BIO Product Kits
							else null end)  = aJoin.AccumulatorID
		where (isnull(accum_1_minus,0) <> 0
			or isnull(accum_2_minus,0) <> 0
			or isnull(accum_3_minus,0) <> 0
			or isnull(accum_4_minus,0) <> 0)
			and csc.code in ('REMOVESVR','REMOVESOL','REMOVESYS','REMOVEPKIT')
			AND aJoin.AccumulatorJoinID IS NULL
			order by csc.SalescodeID
		--
		-- INSERT Accumulator ADD SERV for CONVSOL2SVR
		--
		INSERT INTO [cfgAccumulatorJoin]
				   ([AccumulatorJoinSortOrder]
				   ,[AccumulatorJoinTypeID]
				   ,[SalesCodeID]
				   ,[AccumulatorID]
				   ,[AccumulatorDataTypeID]
				   ,[AccumulatorActionTypeID]
				   ,[AccumulatorAdjustmentTypeID]
				   ,[IsActiveFlag]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser]
				   ,[HairSystemOrderProcessID])
		select
						1 as 'AccumulatorJoinSortOrder'
					,	1 AS 'AccumulatorJoinTypeID'			--Sales Code
   					,	sc.salescodeid as 'SalesCodeID'
					,	9 'AccumulatorID'					--Services
					,	4 as 'AccumulatorDataTypeID'			--Quantity Used
					,	2 as 'AccumulatorActionType'			--Remove
					,	5 as 'AccumulatorAdjustmentTypeID'		--Sales Order Quantity
					,	1  as 'IsActiveFlag'
					,	GETUTCDATE() as 'CreateDate'
					,	'sa' as 'CreateUser'
					,	GETUTCDATE() as 'LastUpdate'
					,	'sa' as 'LastUpdateUser'
					,	NULL as 'HairSystemOrderProcessID'
				   --,*
		 from INFOSTORECONV.dbo.CMSCONVSales_Code csc
			LEFT JOIN cfgSalesCode sc
				ON csc.SalescodeID = sc.SalesCodeID
			LEFT JOIN cfgAccumulatorJoin aJoin on csc.SalesCodeId = aJoin.SalesCodeId
				AND 9 = aJoin.AccumulatorID
		where (isnull(accum_1_minus,0) <> 0
			or isnull(accum_2_minus,0) <> 0
			or isnull(accum_3_minus,0) <> 0
			or isnull(accum_4_minus,0) <> 0)
			and csc.code in ('CONVSOL2SVR')
			AND aJoin.AccumulatorJoinID IS NULL
			order by csc.SalescodeID
		--
		-- INSERT Accumulator SUBTRACT 3SOL for CONVSOL2SVR
		--
		INSERT INTO [cfgAccumulatorJoin]
				   ([AccumulatorJoinSortOrder]
				   ,[AccumulatorJoinTypeID]
				   ,[SalesCodeID]
				   ,[AccumulatorID]
				   ,[AccumulatorDataTypeID]
				   ,[AccumulatorActionTypeID]
				   ,[AccumulatorAdjustmentTypeID]
				   ,[IsActiveFlag]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser]
				   ,[HairSystemOrderProcessID])
		select
						1 as 'AccumulatorJoinSortOrder'
					,	1 AS 'AccumulatorJoinTypeID'			--Sales Code
   					,	sc.salescodeid as 'SalesCodeID'
					,	10 as 'AccumulatorID'					--SOLUTIONS
					,	4 as 'AccumulatorDataTypeID'			--Quantity Used
					,	2 as 'AccumulatorActionType'			--Remove
					,	5 as 'AccumulatorAdjustmentTypeID'		--Sales Order Quantity
					,	1  as 'IsActiveFlag'
					,	GETUTCDATE() as 'CreateDate'
					,	'sa' as 'CreateUser'
					,	GETUTCDATE() as 'LastUpdate'
					,	'sa' as 'LastUpdateUser'
					,	NULL as 'HairSystemOrderProcessID'
				   --,*
		 from INFOSTORECONV.dbo.CMSCONVSales_Code csc
			LEFT JOIN cfgSalesCode sc
				ON csc.SalescodeID = sc.SalesCodeID
			LEFT JOIN cfgAccumulatorJoin aJoin on csc.SalesCodeId = aJoin.SalesCodeId
				AND 10 = aJoin.AccumulatorID
		where (isnull(accum_1_minus,0) <> 0
			or isnull(accum_2_minus,0) <> 0
			or isnull(accum_3_minus,0) <> 0
			or isnull(accum_4_minus,0) <> 0)
			and csc.code in ('CONVSOL2SVR')
			AND aJoin.AccumulatorJoinID IS NULL
			order by csc.SalescodeID

		--
		-- Add Product Revenue Accumulator - 22
		--
		INSERT INTO [cfgAccumulatorJoin]
				   ([AccumulatorJoinSortOrder]
				   ,[AccumulatorJoinTypeID]
				   ,[SalesCodeID]
				   ,[AccumulatorID]
				   ,[AccumulatorDataTypeID]
				   ,[AccumulatorActionTypeID]
				   ,[AccumulatorAdjustmentTypeID]
				   ,[IsActiveFlag]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser]
				   ,[HairSystemOrderProcessID])
		select
						1 as 'AccumulatorJoinSortOrder'
					,	1 AS 'AccumulatorJoinTypeID'			--Sales Code
   					,	sc.salescodeid as 'SalesCodeID'
					,	22 as 'AccumulatorID'					--Product Revenue
					,	2 as 'AccumulatorDataTypeID'			--Money
					,	1 as 'AccumulatorActionType'			--Add
					,	6 as 'AccumulatorAdjustmentTypeID'		--Sales Order Price EXT
					,	1  as 'IsActiveFlag'
					,	GETUTCDATE() as 'CreateDate'
					,	'sa' as 'CreateUser'
					,	GETUTCDATE() as 'LastUpdate'
					,	'sa' as 'LastUpdateUser'
					,	NULL as 'HairSystemOrderProcessID'
				   --,*
		 from INFOSTORECONV.dbo.CMSCONVSales_Code csc
			LEFT JOIN cfgSalesCode sc
				ON csc.SalescodeID = sc.SalesCodeID
			LEFT JOIN cfgAccumulatorJoin aJoin on csc.SalesCodeId = aJoin.SalesCodeId
				AND 22 = aJoin.AccumulatorID
		where division = 4 AND aJoin.AccumulatorJoinID IS NULL
			order by csc.SalescodeID
		--
		-- Add service Revenue Accumulators - 23
		--
		INSERT INTO [cfgAccumulatorJoin]
				   ([AccumulatorJoinSortOrder]
				   ,[AccumulatorJoinTypeID]
				   ,[SalesCodeID]
				   ,[AccumulatorID]
				   ,[AccumulatorDataTypeID]
				   ,[AccumulatorActionTypeID]
				   ,[AccumulatorAdjustmentTypeID]
				   ,[IsActiveFlag]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser]
				   ,[HairSystemOrderProcessID])
		select
						1 as 'AccumulatorJoinSortOrder'
					,	2 AS 'AccumulatorJoinTypeID'			--Membership Code
   					,	sc.salescodeid as 'SalesCodeID'
					,	23 as 'AccumulatorID'					--Service Revenue
					,	2 as 'AccumulatorDataTypeID'			--Money
					,	1 as 'AccumulatorActionType'			--Add
					,	6 as 'AccumulatorAdjustmentTypeID'		--Sales Order Price EXT
					,	1  as 'IsActiveFlag'
					,	GETUTCDATE() as 'CreateDate'
					,	'sa' as 'CreateUser'
					,	GETUTCDATE() as 'LastUpdate'
					,	'sa' as 'LastUpdateUser'
					,	NULL as 'HairSystemOrderProcessID'
				   --,*
		 from INFOSTORECONV.dbo.CMSCONVSales_Code csc
			LEFT JOIN cfgSalesCode sc
				ON csc.SalescodeID = sc.SalesCodeID
			LEFT JOIN cfgAccumulatorJoin aJoin on csc.SalesCodeId = aJoin.SalesCodeId
				AND 23 = aJoin.AccumulatorID
		where division = 5 AND aJoin.AccumulatorJoinID IS NULL
			order by csc.SalescodeID

		--
		-- Add Membership Revenue Accumulators -20
		--
		INSERT INTO [cfgAccumulatorJoin]
				   ([AccumulatorJoinSortOrder]
				   ,[AccumulatorJoinTypeID]
				   ,[SalesCodeID]
				   ,[AccumulatorID]
				   ,[AccumulatorDataTypeID]
				   ,[AccumulatorActionTypeID]
				   ,[AccumulatorAdjustmentTypeID]
				   ,[IsActiveFlag]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser]
				   ,[HairSystemOrderProcessID])
		select
						1 as 'AccumulatorJoinSortOrder'
					,	1 AS 'AccumulatorJoinTypeID'			--Sales Code
   					,	sc.salescodeid as 'SalesCodeID'
					,	20 as 'AccumulatorID'					--Revenue
					,	2 as 'AccumulatorDataTypeID'			--Money
					,	1 as 'AccumulatorActionType'			--Add
					,	6 as 'AccumulatorAdjustmentTypeID'		--Sales Order Price EXT
					,	1  as 'IsActiveFlag'
					,	GETUTCDATE() as 'CreateDate'
					,	'sa' as 'CreateUser'
					,	GETUTCDATE() as 'LastUpdate'
					,	'sa' as 'LastUpdateUser'
					,	NULL as 'HairSystemOrderProcessID'
				   --,*
		 from cfgSalesCode sc
 			LEFT JOIN cfgAccumulatorJoin aJoin on sc.SalesCodeId = aJoin.SalesCodeId
				AND 20 = aJoin.AccumulatorID
		where sc.SalesCodeDescriptionShort in ('MEMPMT','EXTREVWO','EFTFEE','EXTPMTLC','EXTPMTLCP','FEE EXPIRED','FEE FROZEN','PCPMBRPMT','PCPREVWO','CARD EXPIRED','NB1REVWO','SURCREDITNB1','SURCREDITPCP')
			AND aJoin.AccumulatorJoinID IS NULL
		order by sc.SalesCodeDescriptionShort
		--
		-- Add Last Membership Payment Date - 7
		--
		INSERT INTO [cfgAccumulatorJoin]
				   ([AccumulatorJoinSortOrder]
				   ,[AccumulatorJoinTypeID]
				   ,[SalesCodeID]
				   ,[AccumulatorID]
				   ,[AccumulatorDataTypeID]
				   ,[AccumulatorActionTypeID]
				   ,[AccumulatorAdjustmentTypeID]
				   ,[IsActiveFlag]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser]
				   ,[HairSystemOrderProcessID])
		select
						1 as 'AccumulatorJoinSortOrder'
					,	1 AS 'AccumulatorJoinTypeID'			--Sales Code
   					,	sc.salescodeid as 'SalesCodeID'
					,	7 as 'AccumulatorID'					--Last Payment Date
					,	3 as 'AccumulatorDataTypeID'			--Date
					,	3 as 'AccumulatorActionType'			--Replace
					,	4 as 'AccumulatorAdjustmentTypeID'		--Sales Order Date
					,	1  as 'IsActiveFlag'
					,	GETUTCDATE() as 'CreateDate'
					,	'sa' as 'CreateUser'
					,	GETUTCDATE() as 'LastUpdate'
					,	'sa' as 'LastUpdateUser'
					,	NULL as 'HairSystemOrderProcessID'
				   --,*
		 from cfgSalesCode sc
 			LEFT JOIN cfgAccumulatorJoin aJoin on sc.SalesCodeId = aJoin.SalesCodeId
				AND 7 = aJoin.AccumulatorID
		where sc.SalesCodeDescriptionShort in ('MEMPMT','EXTREVWO','EFTFEE','EXTPMTLC','EXTPMTLCP','FEE EXPIRED','FEE FROZEN','PCPMBRPMT','PCPREVWO','CARD EXPIRED','NB1REVWO','SURCREDITNB1','SURCREDITPCP')
			AND aJoin.AccumulatorJoinID IS NULL
		order by sc.SalesCodeDescriptionShort

		--
		-- Replace Membership Contract Balance - 1
		--
		INSERT INTO [cfgAccumulatorJoin]
				   ([AccumulatorJoinSortOrder]
				   ,[AccumulatorJoinTypeID]
				   ,[SalesCodeID]
				   ,[AccumulatorID]
				   ,[AccumulatorDataTypeID]
				   ,[AccumulatorActionTypeID]
				   ,[AccumulatorAdjustmentTypeID]
				   ,[IsActiveFlag]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser]
				   ,[HairSystemOrderProcessID])
		select
						1 as 'AccumulatorJoinSortOrder'
					,	1 AS 'AccumulatorJoinTypeID'			--Sales Code
   					,	sc.salescodeid as 'SalesCodeID'
					,	1 as 'AccumulatorID'					--Contract Balance
					,	2 as 'AccumulatorDataTypeID'			--Money
					,	3 as 'AccumulatorActionType'			--Replace
					,	6 as 'AccumulatorAdjustmentTypeID'		--Sales Order Price EXT
					,	1  as 'IsActiveFlag'
					,	GETUTCDATE() as 'CreateDate'
					,	'sa' as 'CreateUser'
					,	GETUTCDATE() as 'LastUpdate'
					,	'sa' as 'LastUpdateUser'
					,	NULL as 'HairSystemOrderProcessID'
				   --,*
		 from cfgSalesCode sc
  			LEFT JOIN cfgAccumulatorJoin aJoin on sc.SalesCodeId = aJoin.SalesCodeId
				AND 1 = aJoin.AccumulatorID
		where sc.SalesCodeDescriptionShort in ('PCPXD','PCPXU', 'GUARANTEE', 'UPDMBR')
			AND aJoin.AccumulatorJoinID IS NULL
		order by sc.SalesCodeDescriptionShort
		--
		-- Add Last Cancel Date - 4
		--
		INSERT INTO [cfgAccumulatorJoin]
				   ([AccumulatorJoinSortOrder]
				   ,[AccumulatorJoinTypeID]
				   ,[SalesCodeID]
				   ,[AccumulatorID]
				   ,[AccumulatorDataTypeID]
				   ,[AccumulatorActionTypeID]
				   ,[AccumulatorAdjustmentTypeID]
				   ,[IsActiveFlag]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser]
				   ,[HairSystemOrderProcessID])
		select
						1 as 'AccumulatorJoinSortOrder'
					,	1 AS 'AccumulatorJoinTypeID'			--Sales Code
   					,	sc.salescodeid as 'SalesCodeID'
					,	4 as 'AccumulatorID'					--Cancel Date
					,	3 as 'AccumulatorDataTypeID'			--Date
					,	3 as 'AccumulatorActionType'			--Replace
					,	4 as 'AccumulatorAdjustmentTypeID'		--Sales Order Date
					,	1  as 'IsActiveFlag'
					,	GETUTCDATE() as 'CreateDate'
					,	'sa' as 'CreateUser'
					,	GETUTCDATE() as 'LastUpdate'
					,	'sa' as 'LastUpdateUser'
					,	NULL as 'HairSystemOrderProcessID'
				   --,*
		 from cfgSalesCode sc
  			LEFT JOIN cfgAccumulatorJoin aJoin on sc.SalesCodeId = aJoin.SalesCodeId
				AND 4 = aJoin.AccumulatorID
		where sc.SalesCodeDescriptionShort in ('CANCEL')
			AND aJoin.AccumulatorJoinID IS NULL
		order by sc.SalesCodeDescriptionShort
		--
		-- Add Sale Date - 5
		--
		INSERT INTO [cfgAccumulatorJoin]
				   ([AccumulatorJoinSortOrder]
				   ,[AccumulatorJoinTypeID]
				   ,[SalesCodeID]
				   ,[AccumulatorID]
				   ,[AccumulatorDataTypeID]
				   ,[AccumulatorActionTypeID]
				   ,[AccumulatorAdjustmentTypeID]
				   ,[IsActiveFlag]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser]
				   ,[HairSystemOrderProcessID])
		select
						1 as 'AccumulatorJoinSortOrder'
					,	1 AS 'AccumulatorJoinTypeID'			--Sales Code
   					,	sc.salescodeid as 'SalesCodeID'
					,	5 as 'AccumulatorID'					--Sale Date
					,	3 as 'AccumulatorDataTypeID'			--Date
					,	3 as 'AccumulatorActionType'			--Replace
					,	4 as 'AccumulatorAdjustmentTypeID'		--Sales Order Date
					,	1  as 'IsActiveFlag'
					,	GETUTCDATE() as 'CreateDate'
					,	'sa' as 'CreateUser'
					,	GETUTCDATE() as 'LastUpdate'
					,	'sa' as 'LastUpdateUser'
					,	NULL as 'HairSystemOrderProcessID'
				   --,*
		 from cfgSalesCode sc
  			LEFT JOIN cfgAccumulatorJoin aJoin on sc.SalesCodeId = aJoin.SalesCodeId
				AND 5 = aJoin.AccumulatorID
		where sc.SalesCodeDescriptionShort in ('INITASG','CONV','RENEW','PCPXU','PCPXD','NB2R','UPDMBR','TXFROUT','GUARANTEE')
			AND aJoin.AccumulatorJoinID IS NULL
		order by sc.SalesCodeDescriptionShort
		--
		-- Add Last Application -13
		--
		INSERT INTO [cfgAccumulatorJoin]
				   ([AccumulatorJoinSortOrder]
				   ,[AccumulatorJoinTypeID]
				   ,[SalesCodeID]
				   ,[AccumulatorID]
				   ,[AccumulatorDataTypeID]
				   ,[AccumulatorActionTypeID]
				   ,[AccumulatorAdjustmentTypeID]
				   ,[IsActiveFlag]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser]
				   ,[HairSystemOrderProcessID])
		select
						1 as 'AccumulatorJoinSortOrder'
					,	1 AS 'AccumulatorJoinTypeID'			--Sales Code
   					,	sc.salescodeid as 'SalesCodeID'
					,	13 as 'AccumulatorID'					--last App Date
					,	3 as 'AccumulatorDataTypeID'			--Date
					,	3 as 'AccumulatorActionType'			--Replace
					,	4 as 'AccumulatorAdjustmentTypeID'		--Sales Order Date
					,	1  as 'IsActiveFlag'
					,	GETUTCDATE() as 'CreateDate'
					,	'sa' as 'CreateUser'
					,	GETUTCDATE() as 'LastUpdate'
					,	'sa' as 'LastUpdateUser'
					,	NULL as 'HairSystemOrderProcessID'
				   --,*
		 from cfgSalesCode sc
  			LEFT JOIN cfgAccumulatorJoin aJoin on sc.SalesCodeId = aJoin.SalesCodeId
				AND 13 = aJoin.AccumulatorID
		where sc.SalesCodeDescriptionShort in ('APP','NB1A','APPSOL')	--Added APPSOL RH 8/20/2014
			AND aJoin.AccumulatorJoinID IS NULL
		order by sc.SalesCodeDescriptionShort
		--
		-- Add Last Application -17
		--
		INSERT INTO [cfgAccumulatorJoin]
				   ([AccumulatorJoinSortOrder]
				   ,[AccumulatorJoinTypeID]
				   ,[SalesCodeID]
				   ,[AccumulatorID]
				   ,[AccumulatorDataTypeID]
				   ,[AccumulatorActionTypeID]
				   ,[AccumulatorAdjustmentTypeID]
				   ,[IsActiveFlag]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser]
				   ,[HairSystemOrderProcessID])
		select
						1 as 'AccumulatorJoinSortOrder'
					,	1 AS 'AccumulatorJoinTypeID'			--Sales Code
   					,	sc.salescodeid as 'SalesCodeID'
					,	17 as 'AccumulatorID'					--Initial App Date
					,	3 as 'AccumulatorDataTypeID'			--Date
					,	3 as 'AccumulatorActionType'			--Replace
					,	4 as 'AccumulatorAdjustmentTypeID'		--Sales Order Date
					,	1  as 'IsActiveFlag'
					,	GETUTCDATE() as 'CreateDate'
					,	'sa' as 'CreateUser'
					,	GETUTCDATE() as 'LastUpdate'
					,	'sa' as 'LastUpdateUser'
					,	NULL as 'HairSystemOrderProcessID'
				   --,*
		 from cfgSalesCode sc
  			LEFT JOIN cfgAccumulatorJoin aJoin on sc.SalesCodeId = aJoin.SalesCodeId
				AND 17 = aJoin.AccumulatorID
		where sc.SalesCodeDescriptionShort in ('NB1A')
			AND aJoin.accumulatorJoinID IS NULL
		order by sc.SalesCodeDescriptionShort
		--
		-- Add Last Checkup Date -15
		--
		INSERT INTO [cfgAccumulatorJoin]
				   ([AccumulatorJoinSortOrder]
				   ,[AccumulatorJoinTypeID]
				   ,[SalesCodeID]
				   ,[AccumulatorID]
				   ,[AccumulatorDataTypeID]
				   ,[AccumulatorActionTypeID]
				   ,[AccumulatorAdjustmentTypeID]
				   ,[IsActiveFlag]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser]
				   ,[HairSystemOrderProcessID])
		select
						1 as 'AccumulatorJoinSortOrder'
					,	1 AS 'AccumulatorJoinTypeID'			--Sales Code
   					,	sc.salescodeid as 'SalesCodeID'
					,	15 as 'AccumulatorID'					--Last Checkup Date
					,	3 as 'AccumulatorDataTypeID'			--Date
					,	3 as 'AccumulatorActionType'			--Replace
					,	4 as 'AccumulatorAdjustmentTypeID'		--Sales Order Date
					,	1  as 'IsActiveFlag'
					,	GETUTCDATE() as 'CreateDate'
					,	'sa' as 'CreateUser'
					,	GETUTCDATE() as 'LastUpdate'
					,	'sa' as 'LastUpdateUser'
					,	NULL as 'HairSystemOrderProcessID'
				   --,*
		 from cfgSalesCode sc
  			LEFT JOIN cfgAccumulatorJoin aJoin on sc.SalesCodeId = aJoin.SalesCodeId
				AND 15 = aJoin.AccumulatorID
		where sc.SalesCodeDescriptionShort in ('CKUD','CKUN','CKU','CKUPCP','CKU24','CKUPRE')
			AND aJoin.AccumulatorJoinID IS NULL
		order by sc.SalesCodeDescriptionShort
		--
		-- Add Last Service Date -16
		--
		INSERT INTO [cfgAccumulatorJoin]
				   ([AccumulatorJoinSortOrder]
				   ,[AccumulatorJoinTypeID]
				   ,[SalesCodeID]
				   ,[AccumulatorID]
				   ,[AccumulatorDataTypeID]
				   ,[AccumulatorActionTypeID]
				   ,[AccumulatorAdjustmentTypeID]
				   ,[IsActiveFlag]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser]
				   ,[HairSystemOrderProcessID])
		select
						1 as 'AccumulatorJoinSortOrder'
					,	1 AS 'AccumulatorJoinTypeID'			--Sales Code
   					,	sc.salescodeid as 'SalesCodeID'
					,	16 as 'AccumulatorID'					--Last Service Date
					,	3 as 'AccumulatorDataTypeID'			--Date
					,	3 as 'AccumulatorActionType'			--Replace
					,	4 as 'AccumulatorAdjustmentTypeID'		--Sales Order Date
					,	1  as 'IsActiveFlag'
					,	GETUTCDATE() as 'CreateDate'
					,	'sa' as 'CreateUser'
					,	GETUTCDATE() as 'LastUpdate'
					,	'sa' as 'LastUpdateUser'
					,	NULL as 'HairSystemOrderProcessID'
				   --,*
		 from cfgSalesCode sc
  			LEFT JOIN cfgAccumulatorJoin aJoin on sc.SalesCodeId = aJoin.SalesCodeId
				AND 16 = aJoin.AccumulatorID
		where sc.SalesCodeDescriptionShort in ('EXTPROSVC','EXTSVC','EXTSVCSOL','REDO','SVC','SVCSOL','EXTMEMSVC','EXTMEMSVCSOL','SVCPCP','EXTLSVC','APP','APPSOL','NB1A',
		'PRM','PRMSYS','HGH','HGHSYS','NB1REM','COL','COLSYS','H&S','HC','RFL','RTU','S&B','LSVC','HGH-FULL','COL-FULL',
		'PRM-LONG','S&B-LONG','EXTSVCXTD')	--Added EXTSVCSOL, SVCSOL and APPSOL RH 8/20/2014
											--Added EXTSVCXTD RH 10/03/2014
			AND aJoin.AccumulatorJoinID IS NULL
		order by sc.SalesCodeDescriptionShort
		--
		-- Add Last Conversion Date -25
		--
		INSERT INTO [cfgAccumulatorJoin]
				   ([AccumulatorJoinSortOrder]
				   ,[AccumulatorJoinTypeID]
				   ,[SalesCodeID]
				   ,[AccumulatorID]
				   ,[AccumulatorDataTypeID]
				   ,[AccumulatorActionTypeID]
				   ,[AccumulatorAdjustmentTypeID]
				   ,[IsActiveFlag]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser]
				   ,[HairSystemOrderProcessID])
		select
						1 as 'AccumulatorJoinSortOrder'
					,	1 AS 'AccumulatorJoinTypeID'			--Sales Code
   					,	sc.salescodeid as 'SalesCodeID'
					,	25 as 'AccumulatorID'					--Conversion Date
					,	3 as 'AccumulatorDataTypeID'			--Date
					,	3 as 'AccumulatorActionType'			--Replace
					,	4 as 'AccumulatorAdjustmentTypeID'		--Sales Order Date
					,	1  as 'IsActiveFlag'
					,	GETUTCDATE() as 'CreateDate'
					,	'sa' as 'CreateUser'
					,	GETUTCDATE() as 'LastUpdate'
					,	'sa' as 'LastUpdateUser'
					,	NULL as 'HairSystemOrderProcessID'
				   --,*
		 from cfgSalesCode sc
  			LEFT JOIN cfgAccumulatorJoin aJoin on sc.SalesCodeId = aJoin.SalesCodeId
				AND 25 = aJoin.AccumulatorID
		where sc.SalesCodeDescriptionShort in ('CONV')
			AND aJoin.AccumulatorJoinID IS NULL
		order by sc.SalesCodeDescriptionShort
		--
		-- Add Miscellaneous Revenue Accumulators -24
		--
		INSERT INTO [cfgAccumulatorJoin]
				   ([AccumulatorJoinSortOrder]
				   ,[AccumulatorJoinTypeID]
				   ,[SalesCodeID]
				   ,[AccumulatorID]
				   ,[AccumulatorDataTypeID]
				   ,[AccumulatorActionTypeID]
				   ,[AccumulatorAdjustmentTypeID]
				   ,[IsActiveFlag]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser]
				   ,[HairSystemOrderProcessID])
		select
						1 as 'AccumulatorJoinSortOrder'
					,	1 AS 'AccumulatorJoinTypeID'			--Sales Code
   					,	sc.salescodeid as 'SalesCodeID'
					,	24 as 'AccumulatorID'					--Revenue
					,	2 as 'AccumulatorDataTypeID'			--Money
					,	1 as 'AccumulatorActionType'			--Add
					,	6 as 'AccumulatorAdjustmentTypeID'		--Sales Order Price EXT
					,	1  as 'IsActiveFlag'
					,	GETUTCDATE() as 'CreateDate'
					,	'sa' as 'CreateUser'
					,	GETUTCDATE() as 'LastUpdate'
					,	'sa' as 'LastUpdateUser'
					,	NULL as 'HairSystemOrderProcessID'
				   --,*
		 from cfgSalesCode sc
  			LEFT JOIN cfgAccumulatorJoin aJoin on sc.SalesCodeId = aJoin.SalesCodeId
				AND 24 = aJoin.AccumulatorID
		where sc.SalesCodeDescriptionShort in ('XMSREVWO','REFERRAL','CONTADJ','LATEFEE','RCC','FC','NS','ACTADJ')
			AND aJoin.AccumulatorJoinID IS NULL
		order by sc.SalesCodeDescriptionShort
		--
		-- Add AR Balance Accumulators  for Write-offs - 3
		--
		INSERT INTO [cfgAccumulatorJoin]
				   ([AccumulatorJoinSortOrder]
				   ,[AccumulatorJoinTypeID]
				   ,[SalesCodeID]
				   ,[AccumulatorID]
				   ,[AccumulatorDataTypeID]
				   ,[AccumulatorActionTypeID]
				   ,[AccumulatorAdjustmentTypeID]
				   ,[IsActiveFlag]
				   ,[CreateDate]
				   ,[CreateUser]
				   ,[LastUpdate]
				   ,[LastUpdateUser]
				   ,[HairSystemOrderProcessID])
		select
						1 as 'AccumulatorJoinSortOrder'
					,	1 AS 'AccumulatorJoinTypeID'			--Sales Code
   					,	sc.salescodeid as 'SalesCodeID'
					,	3 as 'AccumulatorID'					--AR Balance
					,	2 as 'AccumulatorDataTypeID'			--Money
					,	1 as 'AccumulatorActionType'			--Add
					,	3 as 'AccumulatorAdjustmentTypeID'		--Sales Order Price - EXT price is negative
					,	1  as 'IsActiveFlag'
					,	GETUTCDATE() as 'CreateDate'
					,	'sa' as 'CreateUser'
					,	GETUTCDATE() as 'LastUpdate'
					,	'sa' as 'LastUpdateUser'
					,	NULL as 'HairSystemOrderProcessID'
				   --,*
		 from cfgSalesCode sc
  			LEFT JOIN cfgAccumulatorJoin aJoin on sc.SalesCodeId = aJoin.SalesCodeId
				AND 3 = aJoin.AccumulatorID
		where sc.SalesCodeDescriptionShort in ('EXTREVWO','NB1REVWO','PCPREVWO','PRODWO','SERVWO','XMSREVWO')
			AND aJoin.AccumulatorJoinID IS NULL
		order by sc.SalesCodeDescriptionShort
		--
		-- Add EXTPMTLC - Add to Contract Balance
		--
		INSERT INTO [dbo].[cfgAccumulatorJoin]
           ([AccumulatorJoinSortOrder]
           ,[AccumulatorJoinTypeID]
           ,[SalesCodeID]
           ,[AccumulatorID]
           ,[AccumulatorDataTypeID]
           ,[AccumulatorActionTypeID]
           ,[AccumulatorAdjustmentTypeID]
           ,[IsActiveFlag]
           ,[CreateDate]
           ,[CreateUser]
           ,[LastUpdate]
           ,[LastUpdateUser]
           ,[HairSystemOrderProcessID])
		VALUES
           (4
           ,1
           ,673
           ,1
           ,2
           ,1
           ,6
           ,1
           ,getutcdate()
           ,'sa'
           ,GETUTCDATE()
           ,'sa'
           ,null)

		   -----------------------------------------------------------------------------
			--  cfg AccumulatorJoin
			--
			-----------------------------------------------------------------------------
			if not exists (select * from (select count(SalesCodeID) as 'total' from cfgaccumulatorjoin where salescodeid = 723) as rowcnt where rowcnt.total > 2)
			begin
			--INSERT INTO [cfgaccumulatorjoin] ([AccumulatorJoinSortOrder],[AccumulatorJoinTypeID],[SalesCodeID],[AccumulatorID],[AccumulatorDataTypeID],[AccumulatorActionTypeID],[AccumulatorAdjustmentTypeID],[IsActiveFlag],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser],[UpdateStamp],[HairSystemOrderProcessID])VALUES(4,1,723,1,2,3,6,1,getDate(),'sa',getDate(),'sa',DEFAULT,NULL)
				INSERT INTO [cfgaccumulatorjoin] ([AccumulatorJoinSortOrder],[AccumulatorJoinTypeID],[SalesCodeID],[AccumulatorID],[AccumulatorDataTypeID],[AccumulatorActionTypeID],[AccumulatorAdjustmentTypeID],[IsActiveFlag],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser],[UpdateStamp],[HairSystemOrderProcessID])VALUES(8,1,723,12,1,3,2,1,getDate(),'sa',getDate(),'sa',DEFAULT,NULL)
				INSERT INTO [cfgaccumulatorjoin] ([AccumulatorJoinSortOrder],[AccumulatorJoinTypeID],[SalesCodeID],[AccumulatorID],[AccumulatorDataTypeID],[AccumulatorActionTypeID],[AccumulatorAdjustmentTypeID],[IsActiveFlag],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser],[UpdateStamp],[HairSystemOrderProcessID])VALUES(29,1,723,30,2,3,3,1,getDate(),'sa',getDate(),'sa',DEFAULT,NULL)
				INSERT INTO [cfgaccumulatorjoin] ([AccumulatorJoinSortOrder],[AccumulatorJoinTypeID],[SalesCodeID],[AccumulatorID],[AccumulatorDataTypeID],[AccumulatorActionTypeID],[AccumulatorAdjustmentTypeID],[IsActiveFlag],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser],[UpdateStamp],[HairSystemOrderProcessID])VALUES(1,1,723,8,1,3,8,1,getDate(),'sa',getDate(),'sa',DEFAULT,NULL)
				INSERT INTO [cfgaccumulatorjoin] ([AccumulatorJoinSortOrder],[AccumulatorJoinTypeID],[SalesCodeID],[AccumulatorID],[AccumulatorDataTypeID],[AccumulatorActionTypeID],[AccumulatorAdjustmentTypeID],[IsActiveFlag],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser],[UpdateStamp],[HairSystemOrderProcessID])VALUES(1,1,723,9,1,3,8,1,getDate(),'sa',getDate(),'sa',DEFAULT,NULL)
				INSERT INTO [cfgaccumulatorjoin] ([AccumulatorJoinSortOrder],[AccumulatorJoinTypeID],[SalesCodeID],[AccumulatorID],[AccumulatorDataTypeID],[AccumulatorActionTypeID],[AccumulatorAdjustmentTypeID],[IsActiveFlag],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser],[UpdateStamp],[HairSystemOrderProcessID])VALUES(1,1,723,10,1,3,8,1,getDate(),'sa',getDate(),'sa',DEFAULT,NULL)
				INSERT INTO [cfgaccumulatorjoin] ([AccumulatorJoinSortOrder],[AccumulatorJoinTypeID],[SalesCodeID],[AccumulatorID],[AccumulatorDataTypeID],[AccumulatorActionTypeID],[AccumulatorAdjustmentTypeID],[IsActiveFlag],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser],[UpdateStamp],[HairSystemOrderProcessID])VALUES(1,1,723,11,1,3,8,1,getDate(),'sa',getDate(),'sa',DEFAULT,NULL)
			--INSERT INTO [cfgaccumulatorjoin] ([AccumulatorJoinSortOrder],[AccumulatorJoinTypeID],[SalesCodeID],[AccumulatorID],[AccumulatorDataTypeID],[AccumulatorActionTypeID],[AccumulatorAdjustmentTypeID],[IsActiveFlag],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser],[UpdateStamp],[HairSystemOrderProcessID])VALUES(1,1,723,5,3,3,4,1,getDate(),'sa',getDate(),'sa',DEFAULT,NULL)
			end

			if not exists (select * from (select count(SalesCodeID) as 'total' from cfgaccumulatorjoin where salescodeid = 724) as rowcnt where rowcnt.total > 0)
			begin
				INSERT INTO [cfgaccumulatorjoin] ([AccumulatorJoinSortOrder],[AccumulatorJoinTypeID],[SalesCodeID],[AccumulatorID],[AccumulatorDataTypeID],[AccumulatorActionTypeID],[AccumulatorAdjustmentTypeID],[IsActiveFlag],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser],[UpdateStamp],[HairSystemOrderProcessID])VALUES(37,1,724,1,2,3,6,1, getDate(),'sa',getDate(),'sa',DEFAULT,NULL)
				INSERT INTO [cfgaccumulatorjoin] ([AccumulatorJoinSortOrder],[AccumulatorJoinTypeID],[SalesCodeID],[AccumulatorID],[AccumulatorDataTypeID],[AccumulatorActionTypeID],[AccumulatorAdjustmentTypeID],[IsActiveFlag],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser],[UpdateStamp],[HairSystemOrderProcessID])VALUES(38,1,724,12,1,3,2,1,getDate(),'sa',getDate(),'sa',DEFAULT,NULL)
				INSERT INTO [cfgaccumulatorjoin] ([AccumulatorJoinSortOrder],[AccumulatorJoinTypeID],[SalesCodeID],[AccumulatorID],[AccumulatorDataTypeID],[AccumulatorActionTypeID],[AccumulatorAdjustmentTypeID],[IsActiveFlag],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser],[UpdateStamp],[HairSystemOrderProcessID])VALUES(39,1,724,30,2,3,3,1,getDate(),'sa',getDate(),'sa',DEFAULT,NULL)
			end

END
GO
