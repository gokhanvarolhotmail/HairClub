/***********************************************************************

PROCEDURE: 	[spRpt_CMSAutomaticApplicationsDetails]

DESTINATION SERVER:	   HCSQL2\SQL2005

DESTINATION DATABASE: INFOSTORE

AUTHOR: Marlon Burrell

IMPLEMENTOR: Marlon Burrell

DATE IMPLEMENTED: 05/20/2010

--------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------
SAMPLE EXEC:
	EXEC [spRpt_CMSAutomaticApplicationsDetails] '11/01/11', '1/01/12', 230
		07/07/2011 KM (Trackit# - 64457 ) Fixed Centers 220 and 212 testing applications from 1/1 - 3/31
		01/05/2012 KM (Trackit# - 70739) Amended report to use CMS 2.5 transaction date rather than processed Date
		01/017/2012 HD (Trackit# - 70739) Added Already Applied to results and force sort order
--------------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[spRpt_CMSAutomaticApplicationsDetails]
	@StartDate DATETIME
,	@EndDate DATETIME
,	@Center INT
AS
BEGIN

	SET NOCOUNT ON

	SELECT ClientFullNameCalc
	,	CONVERT(VARCHAR, CMS25TransactionDate, 101) AS 'CMS25TransactionDate'
	,	CMS25Transact_no
	,	HairSystemOrderNumber
	--,	ErrorMessage
	,	ErrorType + ': ' + ErrorMessage AS 'ErrorMessage'
	FROM (
		SELECT datClient.ClientFullNameCalc
		,	tmpCMSUpdate.CMS25TransactionDate
		,	tmpCMSUpdate.CMS25Transact_no
		,	tmpCMSUpdate.HairSystemOrderNumber
		,	tmpCMSUpdate.ErrorMessage
		,	CASE WHEN tmpCMSUpdate.ErrorCode = 2 AND tmpCMSUpdate.ErrorMessage LIKE '%APPLIED] stat%' THEN 1 ELSE 0 END AS 'AppliedInCMS'
		,	CASE WHEN tmpCMSUpdate.IsSuccessful = 1 THEN 1 ELSE 0 END AS 'Successful'
		,	CASE WHEN tmpCMSUpdate.ErrorCode = 1 THEN 'Invalid Order #'
				WHEN tmpCMSUpdate.ErrorCode = 3 THEN 'Wrong Center'
				WHEN tmpCMSUpdate.ErrorCode = 4 THEN 'Wrong Client'
				WHEN (tmpCMSUpdate.ErrorCode = 2 AND tmpCMSUpdate.ErrorMessage NOT LIKE '%APPLIED] stat%') THEN 'Invalid Status'
				WHEN (tmpCMSUpdate.ErrorCode = 2 AND tmpCMSUpdate.ErrorMessage LIKE '%APPLIED] stat%') THEN 'Already Applied'
			END AS 'ErrorType'

		,CASE WHEN tmpCMSUpdate.ErrorCode = 1 THEN 1 --'Invalid Order #'
				WHEN tmpCMSUpdate.ErrorCode = 3 THEN 3--'Wrong Center'
				WHEN tmpCMSUpdate.ErrorCode = 4 THEN 4--'Wrong Client'
				WHEN (tmpCMSUpdate.ErrorCode = 2 AND tmpCMSUpdate.ErrorMessage NOT LIKE '%APPLIED] stat%') THEN 2 --'Invalid Status'
				WHEN (tmpCMSUpdate.ErrorCode = 2 AND tmpCMSUpdate.ErrorMessage LIKE '%APPLIED] stat%') THEN 5--'Already Applied'
			END AS 'SortOrder' -- This is to force the order into the same order as the column headers in the report
		FROM [SQL01].HairclubCMS.dbo.tmpCMSUpdate
			INNER JOIN [SQL01].HairclubCMS.dbo.cfgcenter
				ON cfgcenter.CENTERID = tmpcmsupdate.centerid
			INNER JOIN [SQL01].HairclubCMS.dbo.lkpRegion
				ON cfgcenter.RegionID = lkpRegion.RegionID
			LEFT OUTER JOIN [SQL01].HairclubCMS.dbo.datClient
				ON datClient.ClientNumber_Temp = tmpCMSUpdate.Client_no
				AND datClient.CenterID = tmpCMSUpdate.CenterId
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce ON ce.CenterSSID = tmpCMSUpdate.CenterId
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction t--Infostore.dbo.transactions
				ON t.CenterKey = ce.CenterKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc ON sc.SalesCodeKey = t.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod ON sod.SalesOrderDetailKey = t.SalesOrderDetailKey
					AND tmpCMSUpdate.CMS25Transact_no = sod.TransactionNumber_Temp
		WHERE tmpCMSUpdate.CMS25TransactionDate BETWEEN @StartDate AND @EndDate + ' 23:59'
			AND tmpCMSUpdate.CenterID = @Center
			and tmpcmsupdate.centerid <> 999
			and sc.SalesCodeDescriptionShort IN ('NB1A','APP')
	) drvTable
	WHERE
	--AppliedInCMS=0 AND
		Successful=0
	ORDER BY SortOrder, ClientFullNameCalc, CMS25TransactionDate DESC

END
