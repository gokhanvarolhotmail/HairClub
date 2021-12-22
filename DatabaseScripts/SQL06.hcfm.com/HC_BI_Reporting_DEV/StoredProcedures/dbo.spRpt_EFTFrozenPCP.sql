/* CreateDate: 01/29/2014 16:35:10.213 , ModifyDate: 03/08/2018 14:20:38.130 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spRpt_EFTFrozenPCP
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			PCP Frozen
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		01/29/2014
------------------------------------------------------------------------
NOTES: This stored procedure is for the renamed report, "Frozen Fee Analysis" (PCP_Frozen.rdl)

01/29/2014 - DL - Created procedure (#96888)
02/22/2016 - RH - Added WHERE [Status] <> 'OK' (#121761)
05/31/2017 - RH - Added Area (#137121)
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_EFTFrozenPCP 2, '12/1/2017'
EXEC spRpt_EFTFrozenPCP 8, '12/1/2017'
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_EFTFrozenPCP]
(
	@CenterType INT,
	@Date DATETIME
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


/********************************** Create temp table objects *************************************/

CREATE TABLE #Centers (
	CenterNumber INT
,	CenterDescription VARCHAR(255)
,	CenterTypeDescriptionShort VARCHAR(50)
,	RegionSSID INT
,	RegionDescription VARCHAR(50)
,	RegionSortOrder INT
,	CenterManagementAreaSSID INT
,	CenterManagementAreaDescription VARCHAR(50)
,	CenterManagementAreaSortOrder INT

)

CREATE TABLE #EFTData( CenterNumber INT
,       CenterName NVARCHAR(50)
,		RegionSSID INT
,       RegionDescription NVARCHAR(50)
,		RegionSortOrder INT
,		CenterManagementAreaSSID INT
,		CenterManagementAreaDescription NVARCHAR(50)
,		CenterManagementAreaSortOrder INT
,       Client_no INT
,       First_Name NVARCHAR(50)
,       Last_Name NVARCHAR(50)
,       Fee MONEY
,       Member1_ID INT
,       Member  NVARCHAR(50)
,       Member_Start DATETIME
,       Member_End DATETIME
,       Freeze_Start DATETIME
,       Freeze_End DATETIME
,       balance MONEY
,       Deferred MONEY
,       PaymentsToDate MONEY
,       RefundsToDate INT
,       NetPayments INT
,       DateTest NVARCHAR(50)
,       DeferredTest NVARCHAR(50)
,       [Status] NVARCHAR(50)
,       EFTFreezeReasonDescription NVARCHAR(100)
,		FreeFormEFTFreezeReasonDescription NVARCHAR(400))


/********************************** Get list of centers *************************************/
IF @CenterType = 2
	BEGIN
		INSERT  INTO #Centers
				SELECT  DC.CenterNumber
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				,		NULL AS RegionSSID
				,		NULL AS RegionDescription
				,		NULL AS RegionSortOrder
				,		CMA.CenterManagementAreaSSID
				,		CMA.CenterManagementAreaDescription
				,		CMA.CenterManagementAreaSortOrder
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionKey = DR.RegionKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
							ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
						WHERE  DCT.CenterTypeDescriptionShort = 'C'
							AND DC.Active = 'Y'
	END


IF @CenterType = 8
	BEGIN
		INSERT  INTO #Centers
				SELECT  DC.CenterNumber
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				,		DR.RegionSSID
				,		DR.RegionDescription
				,		DR.RegionSortOrder
				,		NULL AS CenterManagementAreaSSID
				,		NULL AS CenterManagementAreaDescription
				,		NULL AS CenterManagementAreaSortOrder
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionKey = DR.RegionKey
				WHERE  DCT.CenterTypeDescriptionShort IN('F','JV')
						AND DC.Active = 'Y'
	END


/********************************** Get EFT Data *************************************/

INSERT INTO #EFTData
SELECT  #Centers.CenterNumber
,       #Centers.CenterDescription AS 'CenterName'
,		ISNULL(#Centers.RegionSSID,0) as 'RegionSSID'
,       ISNULL(#Centers.RegionDescription,'') as 'RegionDescription'
,		ISNULL(#Centers.RegionSortOrder,0) as 'RegionSortOrder'
,		ISNULL(#Centers.CenterManagementAreaSSID,0) as 'CenterManagementAreaSSID'
,		ISNULL(#Centers.CenterManagementAreaDescription,'') as 'CenterManagementAreaDescription'
,		ISNULL(#Centers.CenterManagementAreaSortOrder,0) as 'CenterManagementAreaSortOrder'
,       CLT.ClientIdentifier AS 'Client_no'
,       CLT.ClientFirstName AS 'First_Name'
,       CLT.ClientLastName AS 'Last_Name'
,       CAST(ROUND(DCM.ClientMembershipMonthlyFee, 2) AS MONEY) AS 'Fee'
,       DM.MembershipKey AS 'Member1_ID'
,       DM.MembershipDescription AS 'Member'
,       DCM.ClientMembershipBeginDate AS 'Member_Start'
,       DCM.ClientMembershipEndDate AS 'Member_End'
,       DCE.Freeze_Start AS 'Freeze_Start'
,       DCE.Freeze_End AS 'Freeze_End'
,       CLT.ClientARBalance AS 'balance'
,       ISNULL(DRBC.Deferred, 0) AS 'Deferred'
,       ISNULL(FDRH.RevenueToDate, 0) AS 'PaymentsToDate'
,       0 AS 'RefundsToDate'
,       ISNULL(FDRH.RevenueToDate, 0) AS 'NetPayments'
,       CASE WHEN CAST(DCE.Freeze_End AS DATETIME) > DATEADD(dd, CAST(( dbo.DIVIDE_DECIMAL(DRBC.Deferred, DCM.ClientMembershipMonthlyFee) * 30 ) AS INT),
                                                                  ( DATEADD(mi, -1, DATEADD(mm, 1, @Date)) )) THEN 'Check Freeze Date'
             ELSE 'OK'
        END AS 'DateTest'
,       CASE WHEN DRBC.Deferred = 0.0 THEN 'Should Not Be Frozen'
             ELSE 'OK'
        END AS 'DeferredTest'
,       CASE WHEN ( CAST(DCE.Freeze_End AS DATETIME) <= DATEADD(dd, CAST(( dbo.DIVIDE_DECIMAL(DRBC.Deferred, DCM.ClientMembershipMonthlyFee) * 30 ) AS INT),
                                                                     ( DATEADD(mi, -1, DATEADD(mm, 1, @Date)) ))
                    AND DRBC.Deferred != 0.0 ) THEN 'OK'
             ELSE 'Review Client'
        END AS 'Status'
,       LFFR.FeeFreezeReasonDescription AS 'EFTFreezeReasonDescription'
,		ISNULL(DCE.FeeFreezeReasonDescription, '') AS 'FreeFormEFTFreezeReasonDescription'
FROM    SQL05.HairClubCMS.dbo.datClientEFT DCE
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
            ON DCE.ClientGUID = CLT.ClientSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			on CLT.CenterSSID = C.CenterSSID
        INNER JOIN #Centers
            ON C.CenterNumber = #Centers.CenterNumber
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
            ON DCE.ClientMembershipGUID = DCM.ClientMembershipSSID
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
            ON DCM.MembershipKey = DM.MembershipKey
        LEFT OUTER JOIN ( SELECT    DRH.ClientKey
                          ,         SUM(DRH.Deferred) AS 'Deferred'
                          ,         0 AS 'RefundsToDate'
                          ,         SUM(DRH.RevenueToDate) AS 'PaymentsToDate'
                          FROM      HC_DeferredRevenue.dbo.FactDeferredRevenueHeader DRH
                          GROUP BY  DRH.ClientKey
                        ) DRBC
            ON CLT.ClientKey = DRBC.ClientKey
        LEFT OUTER JOIN HC_DeferredRevenue.dbo.FactDeferredRevenueHeader FDRH
            ON DCM.ClientMembershipKey = FDRH.ClientMembershipKey
        LEFT OUTER JOIN SQL05.HairClubCMS.dbo.lkpFeeFreezeReason LFFR
            ON DCE.FeeFreezeReasonId = LFFR.FeeFreezeReasonID
WHERE   @Date BETWEEN DCM.ClientMembershipBeginDate AND DCM.ClientMembershipEndDate
        AND @Date BETWEEN DCE.Freeze_Start AND DCE.Freeze_End

SELECT * FROM #EFTData WHERE [Status] <> 'OK'



END
GO
