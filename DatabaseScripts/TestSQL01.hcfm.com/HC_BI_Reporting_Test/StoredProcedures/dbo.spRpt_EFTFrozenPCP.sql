/* CreateDate: 01/29/2014 16:35:10.213 , ModifyDate: 03/15/2018 09:33:05.017 */
GO
/******************************************************************************************************************************
PROCEDURE:				spRpt_EFTFrozenPCP
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			PCP Frozen
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		01/29/2014
--------------------------------------------------------------------------------------------------------------------------------
NOTES: This stored procedure is for the renamed report, "Frozen Fee Analysis"

01/29/2014 - DL - Created procedure (#96888)
02/22/2016 - RH - Added WHERE [Status] <> 'OK' (#121761)
05/31/2017 - RH - Added Area (#137121)
03/14/2018 - RH - (#145957) Changed CenterSSID to CenterNumber, Combined Region and Area into one MainGroup; @AdjustedDate added to find Status and DateTest since there was an arithmetic overflow error
--------------------------------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_EFTFrozenPCP 2, '2/1/2018'
EXEC spRpt_EFTFrozenPCP 8, '2/1/2018'
********************************************************************************************************************************/
CREATE PROCEDURE [dbo].[spRpt_EFTFrozenPCP]
(
	@CenterType INT,
	@Date DATETIME
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;

/**************************** Find @AdjustedDate to use in the formulas for DateTest and Status *********************************/

DECLARE @AdjustedDate DATETIME
SET @AdjustedDate = DATEADD(mi, -1, DATEADD(mm, 1, @Date))
PRINT @AdjustedDate


/********************************** Create temp table objects *********************************************************************/

CREATE TABLE #Centers (
	CenterNumber INT
,	CenterDescription VARCHAR(255)
,	CenterTypeDescriptionShort VARCHAR(50)
,	MainGroupSSID INT
,	MainGroupDescription VARCHAR(50)
,	MainGroupSortOrder INT
)

CREATE TABLE #EFTData(
		CenterNumber INT
,       CenterName NVARCHAR(50)
,		MainGroupSSID INT
,		MainGroupDescription VARCHAR(50)
,		MainGroupSortOrder INT
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
,       DeferredTest NVARCHAR(50)
,       EFTFreezeReasonDescription NVARCHAR(100)
,		FreeFormEFTFreezeReasonDescription NVARCHAR(400)
,		Number INT )


/********************************** Get list of centers ********************************************************************/
IF @CenterType = 2
	BEGIN
		INSERT  INTO #Centers
				SELECT  DC.CenterNumber
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				,		CMA.CenterManagementAreaSSID AS 'MainGroupSSID'
				,		CMA.CenterManagementAreaDescription AS 'MainGroupDescription'
				,		CMA.CenterManagementAreaSortOrder AS 'MainGroupSortOrder'
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
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
				,		DR.RegionSSID AS 'MainGroupSSID'
				,		DR.RegionDescription AS 'MainGroupDescription'
				,		DR.RegionSortOrder AS 'MainGroupSortOrder'
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionKey = DR.RegionKey
				WHERE  DCT.CenterTypeDescriptionShort IN('F','JV')
						AND DC.Active = 'Y'
	END


/********************************** Get EFT Data ***************************************************************************/

INSERT INTO #EFTData
SELECT  C.CenterNumber
,       C.CenterDescription AS 'CenterName'
,		ISNULL(#Centers.MainGroupSSID,'') AS 'MainGroupSSID'
,       ISNULL(#Centers.MainGroupDescription,'') as 'MainGroupDescription'
,		ISNULL(#Centers.MainGroupSortOrder,0) as 'MainGroupSortOrder'
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
,       CASE WHEN DRBC.Deferred = 0.0 THEN 'Should Not Be Frozen'
             ELSE 'OK'
        END AS 'DeferredTest'
,       LFFR.FeeFreezeReasonDescription AS 'EFTFreezeReasonDescription'
,		ISNULL(DCE.FeeFreezeReasonDescription, '') AS 'FreeFormEFTFreezeReasonDescription'
,	CAST(( dbo.DIVIDE_DECIMAL(DRBC.Deferred, DCM.ClientMembershipMonthlyFee) * 30 ) AS INT) AS 'Number'
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

/***************** Find "TestDate" to use in the DateTest and Status statements *****************************************/

SELECT CenterNumber,
       CenterName,
       MainGroupSSID,
       MainGroupDescription,
       MainGroupSortOrder,
       Client_no,
       First_Name,
       Last_Name,
       Fee,
       Member1_ID,
       Member,
       Member_Start,
       Member_End,
       Freeze_Start,
       Freeze_End,
       balance,
       Deferred,
       PaymentsToDate,
       RefundsToDate,
       NetPayments,
       DeferredTest,
	   DATEADD(dd, CASE WHEN Number> 360 THEN 360 ELSE Number END, @AdjustedDate) AS 'TestDate', --This has been rewritten since there was an error "Arithmetic overflow"
       EFTFreezeReasonDescription,
       FreeFormEFTFreezeReasonDescription
INTO #EFTTestDate
FROM #EFTData

/***************** Find the DateTest and Status ***************************************************************************/

SELECT CenterNumber,
       CenterName,
       MainGroupSSID,
       MainGroupDescription,
       MainGroupSortOrder,
       Client_no,
       First_Name,
       Last_Name,
       Fee,
       Member1_ID,
       Member,
       Member_Start,
       Member_End,
       Freeze_Start,
       Freeze_End,
       balance,
       Deferred,
       PaymentsToDate,
       RefundsToDate,
       NetPayments,
       DeferredTest,
       TestDate,
       EFTFreezeReasonDescription,
       FreeFormEFTFreezeReasonDescription
,       CASE WHEN Freeze_End  > TestDate THEN 'Check Freeze Date'
             ELSE 'OK'
        END AS 'DateTest'
,       CASE WHEN (Freeze_End <= TestDate AND Deferred <> 0.0 ) THEN 'OK'
             ELSE 'Review Client'
        END AS 'Status'
INTO #Final
FROM #EFTTestDate

/************************* Final select ************************************************************************************************/

SELECT * FROM #Final
WHERE [Status] <> 'OK'


END
GO
