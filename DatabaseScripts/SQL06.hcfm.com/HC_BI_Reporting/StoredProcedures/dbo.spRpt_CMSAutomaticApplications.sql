/* CreateDate: 09/19/2012 11:07:32.807 , ModifyDate: 09/19/2012 11:07:32.807 */
GO
/***********************************************************************
PROCEDURE: 	[spRpt_CMSAutomaticApplications]
DESTINATION SERVER:	   HCSQL2\SQL2005
DESTINATION DATABASE: INFOSTORE
AUTHOR: Marlon Burrell
IMPLEMENTOR: Marlon Burrell
DATE IMPLEMENTED: 05/20/2010
--------------------------------------------------------------------------------------------------------
NOTES:
	07/07/2011 KM (Trackit# - 64457 ) Fixed Centers 220 and 212 testing applications from 1/1 - 3/31
	01/05/2012 KM (Trackit# - 70739) Amended report to use CMS 2.5 transaction date rather than processed Date
										Excluded 'REDO' transactions from
	01/017/2012 HD (Trackit# - 70739) Added Already Applied to results and force sort order
--------------------------------------------------------------------------------------------------------
SAMPLE EXEC:
EXEC [spRpt_CMSAutomaticApplications] '09/01/12', '10/31/12 23:59'
--------------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[spRpt_CMSAutomaticApplications]
	@StartDate DATETIME
,	@EndDate DATETIME
AS
BEGIN

	SET NOCOUNT ON

	SELECT cfgcenter.CenterOwnershipID
	,	lkpRegion.RegionDescription
	,	cfgcenter.CenterDescriptionFullCalc
	,	cfgCenter.CenterID
	,	SUM(CASE WHEN tmpCMSUpdate.ErrorCode = 1 THEN 1 ELSE 0 END) AS 'HSO Invalid'
	,	SUM(CASE WHEN (tmpCMSUpdate.ErrorCode = 2 AND tmpCMSUpdate.ErrorMessage NOT LIKE '%APPLIED] stat%') THEN 1 ELSE 0 END) AS 'Invalid Status'
	,	SUM(CASE WHEN tmpCMSUpdate.ErrorCode = 3 THEN 1 ELSE 0 END) AS 'Wrong Center'
	,	SUM(CASE WHEN tmpCMSUpdate.ErrorCode = 4 THEN 1 ELSE 0 END) AS 'Wrong Client'
	,	SUM(CASE WHEN tmpCMSUpdate.ErrorCode = 2 AND tmpCMSUpdate.ErrorMessage LIKE '%APPLIED] stat%' THEN 1 ELSE 0 END) AS 'Applied in CMS 4.2'
	,	SUM(CASE WHEN tmpCMSUpdate.IsSuccessful = 1 THEN 1 ELSE 0 END) AS 'Successful'
	,COUNT(sod.TransactionNumber_Temp) AS 'Total Applied in 2.5'
    ,lkpCenterType.CenterTypeDescription AS 'CenterType'
	FROM [SQL01].HairclubCMS.dbo.tmpCMSUpdate
		INNER JOIN [SQL01].HairclubCMS.dbo.cfgcenter
			ON cfgcenter.CENTERID = tmpcmsupdate.centerid
			INNER JOIN [SQL01].HairClubCMS.dbo.lkpCenterType
                ON lkpCenterType.CenterTypeID = cfgcenter.CenterTypeID
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

	WHERE tmpcmsupdate.centerid <> 999
			and tmpCMSUpdate.CMS25TransactionDate BETWEEN @StartDate AND @EndDate + ' 23:59'
			and sc.SalesCodeDescriptionShort in ('NB1A','APP')
	GROUP BY cfgcenter.CenterOwnershipID
	,	lkpRegion.RegionDescription
	,	cfgcenter.CenterDescriptionFullCalc
	,	cfgCenter.CenterID
	,	lkpCenterType.CenterTypeDescription
	ORDER BY lkpCenterType.CenterTypeDescription
	,	cfgcenter.CenterOwnershipID
	,	lkpRegion.RegionDescription
	,	cfgcenter.CenterDescriptionFullCalc

END
GO
