/* CreateDate: 04/05/2013 13:29:01.333 , ModifyDate: 09/25/2020 11:12:57.430 */
GO
/***********************************************************************

PROCEDURE:	[spsvc_InsertUpdateFactPCP]

DESTINATION SERVER:	   SQL06

DESTINATION DATABASE: HC_Accounting

AUTHOR: Marlon Burrell

IMPLEMENTOR: Marlon Burrell

DATE IMPLEMENTED: 04/05/2013
------------------------------------------------------------------------
This procedure populates the FactPCP table
------------------------------------------------------------------------
CHANGE HISTORY:
03/12/2015	RH	Added XTR - populated from FactPCPDetail
------------------------------------------------------------------------
SAMPLE EXEC:
exec [spsvc_InsertUpdateFactPCP]

***********************************************************************/
CREATE PROCEDURE [dbo].[spsvc_InsertUpdateFactPCP] AS
BEGIN

	SET NOCOUNT ON
	SET XACT_ABORT ON


	--Get PCP records from FactPCPDetail
	SELECT C.CenterSSID AS 'CenterID'
	,	CLT.GenderSSID AS 'GenderID'
	,	M.MembershipSSID AS 'MembershipID'
	,	PCPD.DateKey
	,	SUM(PCPD.PCP) AS 'PCP'
	,	SUM(PCPD.EXT) AS 'EXTREME'
	,	1 AS 'CorporateAdjustmentID'
	,	C.CenterKey
	,	CLT.GenderSSID AS 'GenderKey'
	,	SUM(PCPD.XTR) AS 'XTR'
	INTO #tmp
	FROM FactPCPDetail PCPD
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON DD.DateKey = PCPD.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON PCPD.CenterKey = C.CenterKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON CT.CenterTypeKey = C.CenterTypeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON PCPD.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON PCPD.MembershipKey = M.MembershipKey
	WHERE DD.FirstDateOfMonth >= CAST(DATEADD(MONTH, -1, DATEADD(DAY, -(DAY(GETDATE()) -1), GETDATE())) AS DATE)
	--WHERE PCPD.DateKey IN (
	--	SELECT DD.DateKey
	--	FROM HC_BI_ENT_DDS.bief_dds.DimDate DD
	--	WHERE DD.FullDate >= '7/1/2020'
	--)
	AND CT.CenterTypeDescriptionShort IN('C','F','JV')
			AND C.Active = 'Y'
			AND C.CenterKey <> 2 --Corporate
	GROUP BY C.CenterSSID
	,	CLT.GenderSSID
	,	M.MembershipSSID
	,	PCPD.DateKey
	,	C.CenterKey


	--Update FactPCP records if they exist
	UPDATE P
	SET P.PCP = T.PCP
	,	P.EXTREME = T.EXTREME
	,	P.XTR = T.XTR
	,	P.[Timestamp] = GETDATE()
	FROM FactPCP P
		INNER JOIN #tmp T
			ON P.CenterID = T.CenterID
			AND P.GenderID = T.GenderID
			AND P.MembershipID = T.MembershipID
			AND P.DateKey = T.DateKey



	--INSERT FactPCP records if they do not exist
	INSERT INTO FactPCP (
		CenterID
	,	GenderID
	,	MembershipID
	,	DateKey
	,	PCP
	,	EXTREME
	,	[Timestamp]
	,	CorporateAdjustmentID
	,	CenterKey
	,	GenderKey
	,	XTR )
	SELECT T.CenterID
	,	T.GenderID
	,	T.MembershipID
	,	T.DateKey
	,	T.PCP
	,	T.EXTREME
	,	GETDATE()
	,	T.CorporateAdjustmentID
	,	T.CenterKey
	,	T.GenderKey
	,	T.XTR
	FROM #tmp T
		LEFT OUTER JOIN FactPCP P
			ON T.CenterID = P.CenterID
			AND T.GenderID = P.GenderID
			AND T.MembershipID = P.MembershipID
			AND T.DateKey = P.DateKey
	WHERE P.ID IS NULL

END
GO
