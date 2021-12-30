/* CreateDate: 04/05/2013 13:27:41.543 , ModifyDate: 09/25/2020 11:12:14.380 */
GO
/***********************************************************************

PROCEDURE:	[spsvc_InsertUpdateFactPCPDetail]

DESTINATION SERVER:	   SQL06

DESTINATION DATABASE: HC_Accounting

AUTHOR: Marlon Burrell

IMPLEMENTOR: Marlon Burrell

DATE IMPLEMENTED: 04/05/2013
------------------------------------------------------------------------
This procedure populates the FactPCPDetail table
------------------------------------------------------------------------
Notes:
	05/16/2013 - MB - Filtered results so only DISTINCT clients get counted
						for PCP
	12/15/2014 - RH - Added IsXtr for Xtrands Memberships which populates XTR in FactPCPDetail
	09/21/2015 - RH - Added Membership Keys (129,130) for Xtrands Memberships 1000
	10/13/2015 - RH - Added Membership Keys (132,133) for EXT Premium memberships

------------------------------------------------------------------------
SAMPLE EXEC:
exec [spsvc_InsertUpdateFactPCPDetail]
***********************************************************************/
CREATE PROCEDURE [dbo].[spsvc_InsertUpdateFactPCPDetail] AS
BEGIN

	SET NOCOUNT ON
	SET XACT_ABORT ON

--Get PCP Deferred Revenue data for the previous month
SELECT	ctr.CenterKey
,		clt.ClientKey
,		clt.GenderSSID AS 'GenderKey'
,		drd.MembershipKey
,		d.DateKey
,		1 AS 'IsPCP'
,		CASE WHEN drd.MembershipKey IN ( 93, 94, 132, 133 ) THEN 1 ELSE 0 END AS 'IsEXT'
,		CASE WHEN drd.MembershipKey IN ( 123, 125, 129, 130 ) THEN 1 ELSE 0 END AS 'IsXTR'
INTO	#tmp
FROM	SQL06.HC_DeferredRevenue_DAILY.dbo.vwDeferredRevenueDetails drd
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
			ON ctr.CenterNumber = drd.Center
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
			ON clt.ClientKey = drd.ClientKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
			ON d.FullDate = DATEADD(MONTH, 1, drd.Period)
WHERE	drd.DeferredRevenueTypeID = 4
		AND drd.Period >= CAST(DATEADD(MONTH, -1, DATEADD(DAY, -(DAY(GETDATE()) -1), GETDATE())) AS DATE)
		--AND drd.Period >= '7/1/2020'
		AND drd.Revenue >= 1


	--Update FactPCPDetail records if they exist
	UPDATE D
	SET D.GenderKey = T.GenderKey
	,	D.MembershipKey = T.MembershipKey
	,	D.PCP = T.IsPCP
	,	D.EXT = t.IsEXT
	,	D.XTR = t.IsXtr
	FROM FactPCPDetail D
		INNER JOIN #tmp T
			ON D.CenterKey = T.CenterKey
			AND D.ClientKey = T.ClientKey
			AND D.DateKey = T.DateKey


	--Insert FactPCPDetail records if they do not exist
	INSERT INTO FactPCPDetail (
		CenterKey
	,	ClientKey
	,	GenderKey
	,	MembershipKey
	,	DateKey
	,	PCP
	,	EXT
	,	XTR)
	SELECT T.CenterKey
	,	T.ClientKey
	,	T.GenderKey
	,	T.MembershipKey
	,	T.DateKey
	,	T.IsPCP
	,	T.IsEXT
	,	T.IsXTR
	FROM #tmp T
		LEFT OUTER JOIN FactPCPDetail D
			ON T.CenterKey = D.CenterKey
			AND T.ClientKey = D.ClientKey
			AND T.DateKey = D.DateKey
	WHERE D.ID IS NULL

END
GO
