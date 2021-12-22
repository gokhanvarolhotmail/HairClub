/* CreateDate: 02/04/2013 17:36:51.270 , ModifyDate: 02/08/2013 13:30:32.610 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				dbaInsertSalesCodesByCenter

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Kevin Murdoch

IMPLEMENTOR: 			Kevin Murdoch

DATE IMPLEMENTED: 		 04/30/2012

/LAST REVISION DATE: 	 11/05/2012

--------------------------------------------------------------------------------------------------------
NOTES:  This script is used to import Sales Transactions into CMS.
		* 04/12/2012 KRM - Created stored proc
		* 06/29/2012 KRM - Added delete of GradServ 12 except Barth
		* 10/29/2012 KRM - Added update to SCM records for EXTENH9
		* 11/05/2012 KRM - Modified stored proc to run for one center at a time.
		* 12/04/2012 KRM - Changed temp Table fixed Group by on 1st insert
		* 02/04/2013 KRM - Modified script to have taxation at Membership level for Mbr Revenue

--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [dbaInsertSalesCodesByCenter] 267
***********************************************************************/
CREATE PROCEDURE [dbo].[dbaInsertSalesCodesByCenter] (
	@Center int
)AS
BEGIN

	SET NOCOUNT ON

	--Declare variables
	DECLARE @Count INT
	,	@Total INT
	,	@SQL VARCHAR(100)
	,	@CurrentCenter INT

	CREATE TABLE #SCHOLD (
		Salescodeid int,
		price money,
		CenterTaxRateID int,
		SourceTable varchar(10)
		)
	set @CURRENTCENTER = @Center
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

	INSERT INTO #SCHOLD (
		Salescodeid,
		Price,
		CenterTaxRateID,
		SourceTable
		)

	SELECT
		scconv.salescodeid as 'SalescodeID',
		max(bsc.price) AS 'Price',
		max(CenterTaxRateID) AS 'Centertaxrateid',
		min(bsc.SourceTable) As 'SourceTable'
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


	SELECT
		@CURRENTCENTER,
		scconv.salescodeid,
		CASE WHEN (#SCHOLD.sourcetable = 'ALT'
			and (@currentcenter like '[78]%' or
				 @currentcenter in (228,229,239,241,242,243,244,264,265))) THEN max(#SCHOLD.price) ELSE NULL END,
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
	group by scconv.SalescodeID, #SCHOLD.SourceTable

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
	SELECT
		@CURRENTCENTER,
		cfgSalesCode.salescodeid,
		NULL,
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
	SELECT SalescodeID,
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
	--SELECT * from #SCJOIN

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

	SELECT
		cscc.SalesCodeCenterID,
		cmem.MembershipID,
		cscc.PriceRetail,
		case when sc.salescodedepartmentid = 2020 then cscc.TaxRate1ID else null end,
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
			inner join cfgsalescode sc
				on cscc.salescodeID = sc.salescodeID
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

	SELECT
		cscc.SalesCodeCenterID,
		cmem.MembershipID,
		cscc.PriceRetail,
		case when sc.salescodedepartmentid = 2020 then cscc.TaxRate1ID else null end,
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
			inner join cfgsalescode sc
				on cscc.salescodeID = sc.salescodeID
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

	SELECT
		cscc.SalesCodeCenterID,
		cmem.MembershipID,
		cscc.PriceRetail,
		case when sc.salescodedepartmentid = 2020 then cscc.TaxRate1ID else null end,
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
					and #SCJOIN.rtpcp = cmem.RevenueGroupID
			inner join cfgSalesCodeCenter cscc
				on #SCJOIN.SalescodeID = cscc.SalesCodeID
					and CenterID = @CURRENTCENTER
			inner join cfgsalescode sc
				on cscc.salescodeID = sc.salescodeID
	--SELECT * from cfgMembership
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

	SELECT
		cscc.SalesCodeCenterID,
		cmem.MembershipID,
		cscc.PriceRetail,
		case when sc.salescodedepartmentid = 2020 then cscc.TaxRate1ID else null end,
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
			inner join cfgsalescode sc
				on cscc.salescodeID = sc.salescodeID

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

	SELECT
		cscc.SalesCodeCenterID,
		cmem.MembershipID,
		cscc.PriceRetail,
		case when sc.salescodedepartmentid = 2020 then cscc.TaxRate1ID else null end,
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
			inner join cfgsalescode sc
				on cscc.salescodeID = sc.salescodeID
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

	SELECT
		cscc.SalesCodeCenterID,
		cmem.MembershipID,
		cscc.PriceRetail,
		case when sc.salescodedepartmentid = 2020 then cscc.TaxRate1ID else null end,
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
			inner join cfgsalescode sc
				on cscc.salescodeID = sc.salescodeID

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

	SELECT
		cscc.SalesCodeCenterID,
		cmem.MembershipID,
		cscc.PriceRetail,
		case when sc.salescodedepartmentid = 2020 then cscc.TaxRate1ID else null end,
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
			inner join cfgsalescode sc
				on cscc.salescodeID = sc.salescodeID
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

	SELECT
		cscc.SalesCodeCenterID,
		cmem.MembershipID,
		cscc.PriceRetail,
		case when sc.salescodedepartmentid = 2020 then cscc.TaxRate1ID else null end,
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
			inner join cfgsalescode sc
				on cscc.salescodeID = sc.salescodeID
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

	SELECT
		cscc.SalesCodeCenterID,
		cmem.MembershipID,
		cscc.PriceRetail,
		case when sc.salescodedepartmentid = 2020 then cscc.TaxRate1ID else null end,
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
			inner join cfgsalescode sc
				on cscc.salescodeID = sc.salescodeID
	WHERE cscc.SalesCodeID between 409 and 416

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
	WHERE centerid like @CURRENTCENTER and TaxTypeID = 1

	UPDATE scm
		set scm.taxrate1id = tt.CenterTaxRateID
	--SELECT tt.CenterTaxRateID,*
	FROM cfgSalesCodeMembership scm
		inner join cfgSalesCodeCenter scc
			on scm.SalesCodeCenterID = scc.SalesCodeCenterID
		inner join cfgSalesCode sc
			on scc.SalesCodeID = sc.SalesCodeID
		inner join @taxtable tt
			on scc.CenterID = tt.CenterID
	WHERE scc.CenterID = @CURRENTCENTER
		and sc.SalesCodeDescriptionShort in ('EXTPMTLC','EXTPMTLCP','FEE EXPIRED',
						'FEE FROZEN','EFTFEE','CARD EXPIRED','EFTDECLINE')
		and MembershipID in ( 40,41 )
--
-- Update Sales Code Memberships for EXTENH9
--
	UPDATE scm
		set scm.taxrate1id = tt.CenterTaxRateID
	--SELECT tt.CenterTaxRateID,*
	FROM cfgSalesCodeMembership scm
		inner join cfgSalesCodeCenter scc
			on scm.SalesCodeCenterID = scc.SalesCodeCenterID
		inner join cfgSalesCode sc
			on scc.SalesCodeID = sc.SalesCodeID
		inner join @taxtable tt
			on scc.CenterID = tt.CenterID
	WHERE scc.CenterID = @CURRENTCENTER
		and sc.SalesCodeDescriptionShort in ('EXTPMTLC','EXTPMTLCP','MEMPMT','MEMPMTINIT',
				'FEE EXPIRED','FEE FROZEN','EFTFEE','CARD EXPIRED','EFTDECLINE')
		and MembershipID in ( 53 )

--
--	Delete GradServ 12 and GradServ Solutions 12 membership for all centers but Barth
--
	DELETE scm
	--SELECT c.CenterID, CenterDescription,*
	FROM cfgSalesCodeMembership scm
		inner join cfgSalesCodeCenter sc
			ON scm.SalesCodeCenterID = sc.SalesCodeCenterID
		inner join cfgCenter c
			ON sc.CenterID = c.CenterID
	WHERE MembershipID in (45,46) and c.RegionID not in (6)

--
--	Update Pricing for Gold/Diamond S&B to be zero
--
	UPDATE SCM
		SET PRICE = 0
	--SELECT c.CenterID, CenterDescription,*
	FROM cfgSalesCodeMembership scm
		INNER JOIN cfgSalesCodeCenter scc
			ON scm.salescodecenterid = scc.SalesCodeCenterID
	WHERE scc.CenterID = @CURRENTCENTER
		AND (salescodeid = 406 and membershipid in (28,29,30,31))
--
--	Update Pricing for COLSYS/PRMSYS to be zero
--
	UPDATE SCM
		SET PRICE = 0
	--SELECT *
	FROM cfgSalesCodeMembership scm
		INNER JOIN cfgSalesCodeCenter scc
			ON scm.salescodecenterid = scc.SalesCodeCenterID
		INNER JOIN cfgMembership mem
			on scm.membershipid = mem.membershipid
	WHERE scc.CenterID = @CURRENTCENTER
		AND scc.salescodeid in (391,402) --COLSYS/PRMSYS
		AND mem.Businesssegmentid = 1
		and scm.membershipid not in (14,52,51,11)
--
-- Fix Membership to be Taxable for EXT Memberships
--
	UPDATE cscm
	SET TaxRate1ID = ctr.centertaxrateid
	--select ctr.centertaxrateid,*
	from cfgSalesCodeMembership cscm
		inner join cfgSalesCodeCenter cscc
			on cscm.SalesCodeCenterID = cscc.SalesCodeCenterID
				and cscc.centerid = @CURRENTCENTER
		inner join cfgCenterTaxRate ctr
			on ctr.CenterID = @CURRENTCENTER
				and ctr.taxtypeid = 1
	where cscc.salescodeid in (693,349,665,666,720,677,678,709) and membershipid in (53,6,7,8,9,40,41)
--
-- Update taxation for membership Revenue to be Null at center level - completed at
--
	UPDATE cscc
	SET cscc.TaxRate1ID = null
	--select ctr.centertaxrateid,*
	from cfgsalescodecenter cscc
		inner join cfgSalesCode sc
			on cscc.salescodeid = sc.salescodeid
	where cscc.centerid = @CurrentCenter
		and sc.salescodedepartmentID = 2020
--
-- Set PriceRetail to null for Center Sales Codes
--
update scc
	set scc.priceretail = null,
	LastUpdate = GETUTCDATE(),
	LastUpdateUser = 'sa'
--select *
from cfgSalesCodeCenter scc
	inner join cfgsalescode sc
		on scc.salescodeid = sc.salescodeid
where scc.centerid = @CurrentCenter
		and sc.salescodedepartmentid < 2000
		and scc.priceretail is not null
--
-- Set TaxRate1ID to null for Center Sales Codes
--
update scc
	set scc.TaxRate1ID = null,
	LastUpdate = GETUTCDATE(),
	LastUpdateUser = 'sa'
--select *
from cfgSalesCodeCenter scc
	inner join cfgsalescode sc
		on scc.salescodeid = sc.salescodeid
where scc.centerid = @CurrentCenter
		and sc.salescodedepartmentid < 2000
		and scc.TaxRate1ID is not null
--
-- Set PriceRetail to null for Membership Sales Codes
--
update scm
	set scm.TaxRate1ID = null,
	LastUpdate = GETUTCDATE(),
	LastUpdateUser = 'sa'
--select *
from cfgSalesCodeCenter scc
	inner join cfgsalescode sc
		on scc.salescodeid = sc.salescodeid
	inner join cfgSalesCodeMembership scm
		on scc.SalesCodeCenterID = scm.SalesCodeCenterID
where scc.centerid = @CurrentCenter
		and sc.salescodedepartmentid < 2000
		and scm.TaxRate1ID is not null
--
-- Set TaxRate1ID to null for Membership Sales Codes
--
update scm
	set scm.price = null,
	LastUpdate = GETUTCDATE(),
	LastUpdateUser = 'sa'
--select *
from cfgSalesCodeCenter scc
	inner join cfgsalescode sc
		on scc.salescodeid = sc.salescodeid
	inner join cfgSalesCodeMembership scm
		on scc.SalesCodeCenterID = scm.SalesCodeCenterID
where scc.centerid = @CurrentCenter
		and sc.salescodedepartmentid < 2000
		and scm.price is not null

END
GO
