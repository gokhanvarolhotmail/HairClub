/* CreateDate: 12/11/2012 14:57:18.500 , ModifyDate: 12/11/2012 14:57:18.500 */
GO
/***********************************************************************

PROCEDURE:				dbaInsertSalesCodesByCenter

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Kevin Murdoch

IMPLEMENTOR: 			Kevin Murdoch

DATE IMPLEMENTED: 		 04/30/2012

/LAST REVISION DATE: 	 04/30/2012

--------------------------------------------------------------------------------------------------------
NOTES:  This script is used to import Sales Transactions into CMS.
		* 04/12/2012 KRM - Created stored proc
		* 06/29/2012 KRM - Added delete of GradServ 12 except Barth
		* 10/29/2012 KRM - Added update to SCM records for EXTENH9

--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [dbaInsertSalesCodesByCenter]
***********************************************************************/
CREATE PROCEDURE [dbo].[dbaInsertSalesCodesByCenter] AS
BEGIN

	SET NOCOUNT ON

	--Create table object with ID column
	CREATE TABLE #Centers(
		ID INT IDENTITY(1,1)
	,	Center INT
	)

	--Declare variables
	DECLARE @Count INT
	,	@Total INT
	,	@SQL VARCHAR(100)
	,	@CurrentCenter INT

	--Populate temp table with all centers
	INSERT INTO #Centers (Center)
	SELECT center_num
	FROM [HCSQL2\SQL2005].[HCFMDirectory].dbo.[tblCenter]
	--
	-- RUN ALL CENTER INCLUDING 100 AND 279
	--
	WHERE ([Type] in ('c','j','f')
		AND [Inactive]=0
				AND [Center_num] IN (240,292,281,242))  ----
		--AND [Center_Num] like '[278]%'
		--and [Center_Num] = 244)
		--AND [CMS42ConversionComplete] = 1 ) --or 	([Center_Num] = 100)


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


				IF OBJECT_ID('tempdb..#SCHOLD') IS NOT NULL
				BEGIN
					DROP TABLE #SCHOLD
				END

				--set @CURRENTCENTER = 201
				--
				-- Clear out Sales Codes for center
				--
				DELETE cscm
				FROM cfgSalesCodeMembership cscm
					inner join cfgSalesCodeCenter cscc
						on cscm.SalesCodeCenterID = cscc.SalesCodeCenterID
				WHERE cscc.CenterID = @CURRENTCENTER

				DELETE FROM cfgSalesCodeCenter WHERE CenterID = @CURRENTCENTER

				DELETE FROM [hcsql2\sql2005].bosoperations.dbo.CMSSALESCODEHOLDING

						SET @SQL = '[hcsql2\sql2005].bosoperations.dbo.spsvc_GetCenterSpecificSalesCodes ' + CONVERT(VARCHAR, @CURRENTCENTER) + ',DTS'
						EXEC(@SQL)

				SELECT
					scconv.salescodeid,
					max(bsc.price) AS Price,
					max(CenterTaxRateID) AS Centertaxrateid


				INTO #SCHOLD
				FROM [hcsql2\sql2005].bosoperations.dbo.CMSSALESCODEHOLDING bsc
					inner join 	[hcsql2\sql2005].bosoperations.dbo.SalesCodebyMembership scconv
						ON bsc.code = scconv.code
					left outer join cfgCenterTaxRate ctr
						ON CASE WHEN bsc.tax_rate_1 = 0 THEN 4 ELSE bsc.tax_rate_1 END = ctr.TaxTypeID
							and ctr.CenterID = @CURRENTCENTER

				where bsc.department <> 30 and bsc.code <> 'tender'
				group by scconv.SalescodeID
				--
				-- Inserts Sales codes from BOSOperations
				--
				INSERT INTO [cfgSalesCodeCenter]
						   ([CenterID]
						   ,[SalesCodeID]
						   ,[PriceRetail]
						   ,[TaxRate1ID]
						   ,[TaxRate2ID]
						   ,[QuantityOnHand]
						   ,[QuantityOnOrdered]
						   ,[QuantityTotalSold]
						   ,[QuantityMaxLevel]
						   ,[QuantityMinLevel]
						   ,[IsActiveFlag]
						   ,[CreateDate]
						   ,[CreateUser]
						   ,[LastUpdate]
						   ,[LastUpdateUser])


				select
					@CURRENTCENTER,
					scconv.salescodeid,
					max(#SCHOLD.price),
					max(#SCHOLD.Centertaxrateid),
					null,
					0,
					0,
					0,
					0,
					0,
					1,
					GETUTCDATE(),
					'sa',
					GETUTCDATE(),
					'sa'

				from [hcsql2\sql2005].bosoperations.dbo.CMSSALESCODEHOLDING bsc
					inner join 	[hcsql2\sql2005].bosoperations.dbo.SalesCodebyMembership scconv
						on bsc.code = scconv.code
					inner join #SCHOLD
						on scconv.SalescodeID = #SCHOLD.SalescodeID
					left outer join cfgCenterTaxRate ctr
						on case when bsc.tax_rate_1 = 0 then 4 else bsc.tax_rate_1 end = ctr.TaxTypeID
							and ctr.CenterID = @CURRENTCENTER
				where bsc.department <> 30 and bsc.code <> 'tender'
				group by scconv.SalescodeID
				--
				-- Inserts Sales Codes for EXT Only
				--
				INSERT INTO [cfgSalesCodeCenter]
						   ([CenterID]
						   ,[SalesCodeID]
						   ,[PriceRetail]
						   ,[TaxRate1ID]
						   ,[TaxRate2ID]
						   ,[QuantityOnHand]
						   ,[QuantityOnOrdered]
						   ,[QuantityTotalSold]
						   ,[QuantityMaxLevel]
						   ,[QuantityMinLevel]
						   ,[IsActiveFlag]
						   ,[CreateDate]
						   ,[CreateUser]
						   ,[LastUpdate]
						   ,[LastUpdateUser])
				select
					@CURRENTCENTER,
					cfgSalesCode.salescodeid,
					pricedefault,
					cfgCenterTaxRate.CenterTaxRateID,
					null,
					0,
					0,
					0,
					0,
					0,
					1,
					GETUTCDATE(),
					'sa',
					GETUTCDATE(),
					'sa'

				from cfgSalesCode
				INNER JOIN cfgCenterTaxRate ON
					cfgCenterTaxRate.CenterID = @CurrentCenter
						and cfgCenterTaxRate.TaxTypeID = 4
				where IsEXTOnlyProductFlag=1

				--
				-- Insert cfgsalescodemembership records
				--
				IF OBJECT_ID('tempdb..#SCJOIN') IS NOT NULL
				BEGIN
					DROP TABLE #SCJOIN
				END
				select SalescodeID,
						MAX(bsext) as bsext,
						MAX(bsbio) as bsbio,
						MAX(bssur) as bssur,
						MAX(rtnew) as rtnew,
						MAX(rtpcp) as rtpcp,
						MAX(rtoth) as rtoth
				into #SCJOIN
				from [hcsql2\sql2005].bosoperations.dbo.SalesCodebyMembership
				where department <> 30 and code <> 'tender'
				group by salescodeid
				--select * from #SCJOIN

				--
				-- EXT Memberships, New Business
				--
				INSERT INTO [cfgSalesCodeMembership]
						   ([SalesCodeCenterID]
						   ,[MembershipID]
						   ,[Price]
						   ,[TaxRate1ID]
						   ,[TaxRate2ID]
						   ,[IsActiveFlag]
						   ,[CreateDate]
						   ,[CreateUser]
						   ,[LastUpdate]
						   ,[LastUpdateUser])

				select
					cscc.SalesCodeCenterID,
					cmem.MembershipID,
					cscc.PriceRetail,
					cscc.TaxRate1ID,
					null,
					1,
					GETUTCDATE(),
					'sa',
					GETUTCDATE(),
					'sa'

				from
					#SCJOIN
						inner join cfgMembership cmem
							on #SCJOIN.BSEXT = cmem.BusinessSegmentID
								and #SCJOIN.rtnew = cmem.RevenueGroupID
						inner join cfgSalesCodeCenter cscc
							on #SCJOIN.SalescodeID = cscc.SalesCodeID
								and CenterID = @CURRENTCENTER
				--
				-- BIO Memberships, New Business
				--
				INSERT INTO [cfgSalesCodeMembership]
						   ([SalesCodeCenterID]
						   ,[MembershipID]
						   ,[Price]
						   ,[TaxRate1ID]
						   ,[TaxRate2ID]
						   ,[IsActiveFlag]
						   ,[CreateDate]
						   ,[CreateUser]
						   ,[LastUpdate]
						   ,[LastUpdateUser])

				select
					cscc.SalesCodeCenterID,
					cmem.MembershipID,
					cscc.PriceRetail,
					cscc.TaxRate1ID,
					null,
					1,
					GETUTCDATE(),
					'sa',
					GETUTCDATE(),
					'sa'

				from
					#SCJOIN
						inner join cfgMembership cmem
							on #SCJOIN.bsbio = cmem.BusinessSegmentID
								and #SCJOIN.rtnew = cmem.RevenueGroupID
						inner join cfgSalesCodeCenter cscc
							on #SCJOIN.SalescodeID = cscc.SalesCodeID
								and CenterID = @CURRENTCENTER
				--
				-- BIO Memberships, PCP
				--
				INSERT INTO [cfgSalesCodeMembership]
						   ([SalesCodeCenterID]
						   ,[MembershipID]
						   ,[Price]
						   ,[TaxRate1ID]
						   ,[TaxRate2ID]
						   ,[IsActiveFlag]
						   ,[CreateDate]
						   ,[CreateUser]
						   ,[LastUpdate]
						   ,[LastUpdateUser])

				select
					cscc.SalesCodeCenterID,
					cmem.MembershipID,
					cscc.PriceRetail,
					cscc.TaxRate1ID,
					null,
					1,
					GETUTCDATE(),
					'sa',
					GETUTCDATE(),
					'sa'
					--,cscc.SalesCodeID
					--,#SCJOIN.bsbio
					--,cmem.BusinessSegmentID
					--,#SCJOIN.rtpcp
					--,cmem.RevenueGroupID
				from
					#SCJOIN
						inner join cfgMembership cmem
							on #SCJOIN.bsbio = cmem.BusinessSegmentID
								and #SCJOIN.rtpcp = cmem.RevenueGroupID
						inner join cfgSalesCodeCenter cscc
							on #SCJOIN.SalescodeID = cscc.SalesCodeID
								and CenterID = @CURRENTCENTER
				--select * from cfgMembership
				--
				-- EXT Memberships, PCP
				--
				INSERT INTO [cfgSalesCodeMembership]
						   ([SalesCodeCenterID]
						   ,[MembershipID]
						   ,[Price]
						   ,[TaxRate1ID]
						   ,[TaxRate2ID]
						   ,[IsActiveFlag]
						   ,[CreateDate]
						   ,[CreateUser]
						   ,[LastUpdate]
						   ,[LastUpdateUser])

				select
					cscc.SalesCodeCenterID,
					cmem.MembershipID,
					cscc.PriceRetail,
					cscc.TaxRate1ID,
					null,
					1,
					GETUTCDATE(),
					'sa',
					GETUTCDATE(),
					'sa'

				from
					#SCJOIN
						inner join cfgMembership cmem
							on #SCJOIN.bsext = cmem.BusinessSegmentID
								and #SCJOIN.rtpcp = cmem.RevenueGroupID
						inner join cfgSalesCodeCenter cscc
							on #SCJOIN.SalescodeID = cscc.SalesCodeID
								and CenterID = @CURRENTCENTER
				--
				-- BIO Memberships, Oth
				--
				INSERT INTO [cfgSalesCodeMembership]
						   ([SalesCodeCenterID]
						   ,[MembershipID]
						   ,[Price]
						   ,[TaxRate1ID]
						   ,[TaxRate2ID]
						   ,[IsActiveFlag]
						   ,[CreateDate]
						   ,[CreateUser]
						   ,[LastUpdate]
						   ,[LastUpdateUser])

				select
					cscc.SalesCodeCenterID,
					cmem.MembershipID,
					cscc.PriceRetail,
					cscc.TaxRate1ID,
					null,
					1,
					GETUTCDATE(),
					'sa',
					GETUTCDATE(),
					'sa'

				from
					#SCJOIN
						inner join cfgMembership cmem
							on #SCJOIN.bsbio = cmem.BusinessSegmentID
								and #SCJOIN.rtoth = cmem.RevenueGroupID
						inner join cfgSalesCodeCenter cscc
							on #SCJOIN.SalescodeID = cscc.SalesCodeID
								and CenterID = @CURRENTCENTER
				--
				-- EXT Memberships, oth
				--
				INSERT INTO [cfgSalesCodeMembership]
						   ([SalesCodeCenterID]
						   ,[MembershipID]
						   ,[Price]
						   ,[TaxRate1ID]
						   ,[TaxRate2ID]
						   ,[IsActiveFlag]
						   ,[CreateDate]
						   ,[CreateUser]
						   ,[LastUpdate]
						   ,[LastUpdateUser])

				select
					cscc.SalesCodeCenterID,
					cmem.MembershipID,
					cscc.PriceRetail,
					cscc.TaxRate1ID,
					null,
					1,
					GETUTCDATE(),
					'sa',
					GETUTCDATE(),
					'sa'

				from
					#SCJOIN
						inner join cfgMembership cmem
							on #SCJOIN.bsext = cmem.BusinessSegmentID
								and #SCJOIN.rtoth = cmem.RevenueGroupID
						inner join cfgSalesCodeCenter cscc
							on #SCJOIN.SalescodeID = cscc.SalesCodeID
								and CenterID = @CURRENTCENTER

				----
				---- EXT Memberships, EXT Service ONLY, New Business
				----
				INSERT INTO [cfgSalesCodeMembership]
						   ([SalesCodeCenterID]
						   ,[MembershipID]
						   ,[Price]
						   ,[TaxRate1ID]
						   ,[TaxRate2ID]
						   ,[IsActiveFlag]
						   ,[CreateDate]
						   ,[CreateUser]
						   ,[LastUpdate]
						   ,[LastUpdateUser])

				select
					cscc.SalesCodeCenterID,
					cmem.MembershipID,
					cscc.PriceRetail,
					cscc.TaxRate1ID,
					null,
					1,
					GETUTCDATE(),
					'sa',
					GETUTCDATE(),
					'sa'

				from
					#SCJOIN
						inner join cfgMembership cmem
							on #SCJOIN.bsext = cmem.BusinessSegmentID
								and #SCJOIN.rtnew = cmem.RevenueGroupID
						inner join cfgSalesCodeCenter cscc
							on #SCJOIN.SalescodeID = cscc.SalesCodeID
								and CenterID = @CURRENTCENTER
				WHERE cscc.SalesCodeID between 409 and 416
				----
				---- EXT Memberships, EXT Service ONLY, PCP Business
				----
				INSERT INTO [cfgSalesCodeMembership]
						   ([SalesCodeCenterID]
						   ,[MembershipID]
						   ,[Price]
						   ,[TaxRate1ID]
						   ,[TaxRate2ID]
						   ,[IsActiveFlag]
						   ,[CreateDate]
						   ,[CreateUser]
						   ,[LastUpdate]
						   ,[LastUpdateUser])

				select
					cscc.SalesCodeCenterID,
					cmem.MembershipID,
					cscc.PriceRetail,
					cscc.TaxRate1ID,
					null,
					1,
					GETUTCDATE(),
					'sa',
					GETUTCDATE(),
					'sa'

				from
					#SCJOIN
						inner join cfgMembership cmem
							on #SCJOIN.bsext = cmem.BusinessSegmentID
								and #SCJOIN.rtpcp = cmem.RevenueGroupID
						inner join cfgSalesCodeCenter cscc
							on #SCJOIN.SalescodeID = cscc.SalesCodeID
								and CenterID = @CURRENTCENTER
				WHERE cscc.SalesCodeID between 409 and 416
				----
				---- EXT Memberships, EXT Service ONLY, Other Business
				----
				INSERT INTO [cfgSalesCodeMembership]
						   ([SalesCodeCenterID]
						   ,[MembershipID]
						   ,[Price]
						   ,[TaxRate1ID]
						   ,[TaxRate2ID]
						   ,[IsActiveFlag]
						   ,[CreateDate]
						   ,[CreateUser]
						   ,[LastUpdate]
						   ,[LastUpdateUser])

				select
					cscc.SalesCodeCenterID,
					cmem.MembershipID,
					cscc.PriceRetail,
					cscc.TaxRate1ID,
					null,
					1,
					GETUTCDATE(),
					'sa',
					GETUTCDATE(),
					'sa'

				from
					#SCJOIN
						inner join cfgMembership cmem
							on #SCJOIN.bsext = cmem.BusinessSegmentID
								and #SCJOIN.rtoth = cmem.RevenueGroupID
						inner join cfgSalesCodeCenter cscc
							on #SCJOIN.SalescodeID = cscc.SalesCodeID
								and CenterID = @CURRENTCENTER
				WHERE cscc.SalesCodeID between 409 and 416
			SET @Count = @Count + 1
	END
--
-- Update Sales Code Memberships for EXTMEM and EXTMEMSOL
--

	DECLARE @taxtable TABLE (
		[CenterID] [int] NULL
	,	[CenterTaxRateID] [int] NULL
		)
	INSERT @taxtable
	SELECT centerid, CenterTaxRateID
	FROM cfgCenterTaxRate
	WHERE centerid like '[278]%' and TaxTypeID = 1

	UPDATE scm
		set scm.taxrate1id = tt.CenterTaxRateID
	--select tt.CenterTaxRateID,*
	FROM cfgSalesCodeMembership scm
		inner join cfgSalesCodeCenter scc
			on scm.SalesCodeCenterID = scc.SalesCodeCenterID
		inner join cfgSalesCode sc
			on scc.SalesCodeID = sc.SalesCodeID
		inner join @taxtable tt
			on scc.CenterID = tt.CenterID
	WHERE scc.CenterID like '[278]%'
		and sc.SalesCodeDescriptionShort in ('EXTPMTLC','EXTPMTLCP','FEE EXPIRED',
						'FEE FROZEN','EFTFEE','CARD EXPIRED','EFTDECLINE')
		and MembershipID in ( 40,41,53 )
--
-- Update Sales Code Memberships for EXTENH9
--
	UPDATE scm
		set scm.taxrate1id = tt.CenterTaxRateID
	--select tt.CenterTaxRateID,*
	FROM cfgSalesCodeMembership scm
		inner join cfgSalesCodeCenter scc
			on scm.SalesCodeCenterID = scc.SalesCodeCenterID
		inner join cfgSalesCode sc
			on scc.SalesCodeID = sc.SalesCodeID
		inner join @taxtable tt
			on scc.CenterID = tt.CenterID
	WHERE scc.CenterID like '[278]%'
		and sc.SalesCodeDescriptionShort in ('EXTPMTLC','EXTPMTLCP','MEMPMT',
						'MEMPMTINIT')
		and MembershipID in ( 53 )

--
--	Delete GradServ 12 and GradServ Solutions 12 membership for all centers but Barth
--
	DELETE scm
	--select c.CenterID, CenterDescription,*
	FROM cfgSalesCodeMembership scm
		inner join cfgSalesCodeCenter sc
			ON scm.SalesCodeCenterID = sc.SalesCodeCenterID
		inner join cfgCenter c
			ON sc.CenterID = c.CenterID
	WHERE MembershipID in (45,46) and c.RegionID not in (6)





END
GO
