/* CreateDate: 11/19/2013 15:29:30.203 , ModifyDate: 04/26/2019 14:52:46.260 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spRpt_ConversionNewBusinessRetentionDetailsPCP
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Conversion Retention
AUTHOR:					Marlon Burrell
IMPLEMENTOR:			Marlon Burrell
DATE IMPLEMENTED:		11/14/2013
------------------------------------------------------------------------
NOTES:

02/06/2014 - DL - The drill down into the 'Active' column for the regional subtotals are pulling incorrect centers (#97344)
11/20/2014 - RH - Added NB_XTRConvCnt
10/26/2016 - RH - (#130802) Added filter SC.SalesCodeKey NOT IN(665,654,393) -- Transfer Out, Removal - New Member
01/13/2017 - RH - (#130802) Changed code to find the transfers separately and then remove them; Added CenterManagementAreaSSID and Description; Added @Filter
03/23/2017 - RH - (#130802) Show clients as presented in the FactPCPDetail table (do not remove transfers - transfers out do not show as Active, transfers in will show automatically)
01/15/2018 - RH - (#145957) Removed Regions for Corporate; added joins on DimCenterType

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_ConversionNewBusinessRetentionDetailsPCP '1/1/2017', '3/22/2017', 0, 0 , 2, 'C', 2

EXEC spRpt_ConversionNewBusinessRetentionDetailsPCP '1/1/2017', '3/22/2017', 281, 0 , 2, 'C', 3



EXEC spRpt_ConversionNewBusinessRetentionDetailsPCP '1/1/2017', '3/22/2017', 6, 0 , 1, 'F', 1
EXEC spRpt_ConversionNewBusinessRetentionDetailsPCP '12/1/2017', '1/1/2018', 2, 0 , 1, 'C', 2
EXEC spRpt_ConversionNewBusinessRetentionDetailsPCP '12/1/2017', '1/1/2018', 209, 0 , 1, 'C', 3
EXEC spRpt_ConversionNewBusinessRetentionDetailsPCP '12/1/2017', '1/1/2018', 745, 0 , 1, 'F', 3
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_ConversionNewBusinessRetentionDetailsPCP]
(	@StartDate	DATETIME
,	@EndDate	DATETIME
,	@CenterSSID INT
,	@GenderSSID INT
,	@ConversionType INT
,	@sType NVARCHAR(1)
,	@Filter INT
)
AS
BEGIN

SET NOCOUNT OFF

/*==============================================================================
	@ConversionType			@Filter
		1 = BIO				1 = By Region
		2 = EXT				2 = By Area
		3 = XTR				3 = By Center
==============================================================================*/


--Declare variables
DECLARE @PCPDate DATETIME


/****************** Initialize variables ***********************************************************************/

SELECT @PCPDate = CONVERT(VARCHAR(25), DATEADD(dd, -(DAY(GETDATE()) - 1), GETDATE()), 101)  --Beginning of this month

/****************** Create temp tables *************************************************************************/


CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	CenterKey INT
,	CenterSSID INT
,	CenterDescriptionNumber VARCHAR(255)
,	CenterTypeDescriptionShort VARCHAR(50)
)

CREATE TABLE #Genders (
	GenderSSID INT
)

CREATE TABLE #Transfers (
		CenterSSID INT
	,   ClientKey INT
	,   ConversionDate DATETIME
	,   NB_BIOConvCnt INT
	,	NB_EXTConvCnt INT
	,	NB_XTRConvCnt INT
	,	TransferOut NVARCHAR(50)
)

/***************** Populate #Centers **********************************************************************/



IF @Filter = 1	AND @sType = 'F'									-- A Region has been selected - Franchises
BEGIN
INSERT  INTO #Centers
		SELECT  DR.RegionSSID AS 'MainGroupID'
		,		DR.RegionDescription AS 'MainGroup'
		,		DC.CenterKey
		,		DC.CenterSSID
		,		DC.CenterDescriptionNumber
		,		DCT.CenterTypeDescriptionShort
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionKey = DR.RegionKey
		WHERE   (DR.RegionSSID = @CenterSSID OR @CenterSSID = 0)
				AND DC.Active = 'Y'
				AND DCT.CenterTypeDescriptionShort IN ('F','JV')
END
ELSE
IF @Filter = 2	AND @sType = 'C'									-- An Area has been selected.
BEGIN
INSERT  INTO #Centers
		SELECT  CMA.CenterManagementAreaSSID AS 'MainGroupID'
		,		CMA.CenterManagementAreaDescription AS 'MainGroup'
		,		DC.CenterKey
		,		DC.CenterSSID
		,		DC.CenterDescriptionNumber
		,		DCT.CenterTypeDescriptionShort
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionKey = DR.RegionKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
					ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
		WHERE   (DC.CenterManagementAreaSSID = @CenterSSID OR @CenterSSID = 0)
				AND DC.Active = 'Y'
				AND DCT.CenterTypeDescriptionShort = 'C'
END
ELSE
IF @Filter = 3	AND @sType = 'C'									-- A Corporate Center has been selected.
BEGIN
INSERT  INTO #Centers
		SELECT  DC.CenterSSID AS 'MainGroupID'
		,		DC.CenterDescriptionNumber AS 'MainGroup'
		,		DC.CenterKey
		,		DC.CenterSSID
		,		DC.CenterDescriptionNumber
		,		DCT.CenterTypeDescriptionShort
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
					ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
		WHERE   (DC.CenterSSID = @CenterSSID OR @CenterSSID = 0)
				AND DC.Active = 'Y'
END
IF @Filter = 3	AND @sType = 'F'									-- A Franchise Center has been selected.
BEGIN
INSERT  INTO #Centers
		SELECT  DC.CenterSSID AS 'MainGroupID'
		,		DC.CenterDescriptionNumber AS 'MainGroup'
		,		DC.CenterKey
		,		DC.CenterSSID
		,		DC.CenterDescriptionNumber
		,		DCT.CenterTypeDescriptionShort
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
					ON R.RegionKey = DC.RegionKey
		WHERE   (DC.CenterSSID = @CenterSSID OR @CenterSSID = 0)
				AND DC.Active = 'Y'
END


/***************** Populate #Genders **********************************************************************/

IF @GenderSSID IN (1,2)
	BEGIN
		INSERT INTO #Genders
		SELECT @GenderSSID
	END
ELSE
	BEGIN
		INSERT INTO #Genders (GenderSSID) VALUES (1)
		INSERT INTO #Genders (GenderSSID) VALUES (2)
	END


/*==============================================================================
Get conversions for dates specified
==============================================================================*/
SELECT  FST.ClientKey, FST.CenterKey
INTO    #Conversions
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FST.OrderDateKey = DD.DateKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
            ON FST.CenterKey = DC.CenterKey
        INNER JOIN #Centers C
            ON FST.CenterKey = C.CenterKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
            ON FST.ClientKey = CLT.ClientKey
        INNER JOIN #Genders G
            ON ISNULL(CLT.GenderSSID, 1) = G.GenderSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON FST.SalesCodeKey = SC.SalesCodeKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
        AND ( CASE WHEN @ConversionType = 1 THEN FST.NB_BIOConvCnt
					WHEN @ConversionType = 2 THEN FST.NB_EXTConvCnt
					ELSE FST.NB_XTRConvCnt
              END ) >= 1

--SELECT * FROM #Conversions WHERE ClientKey = 334641
/*==============================================================================
Final Select
==============================================================================*/
SELECT  C.MainGroup
,		C.MainGroupID
,       C.CenterDescriptionNumber AS 'Center'
,       CONVERT(VARCHAR, CLT.ClientIdentifier) + ' - ' + CLT.ClientFullName AS 'ClientName'
,       CLT.ClientGenderDescription
,       M.MembershipDescription AS 'Membership'
,       @PCPDate AS 'PCPDate'
FROM    HC_Accounting.dbo.FactPCPDetail PD
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON PD.DateKey = DD.DateKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
            ON PD.CenterKey = DC.CenterKey
        INNER JOIN #Centers C
            ON PD.CenterKey = C.CenterKey
        INNER JOIN #Conversions CONV
            ON PD.CenterKey = CONV.CenterKey
				AND PD.ClientKey = CONV.ClientKey
        --INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
        --    ON CONV.CenterKey = DC.CenterKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
            ON PD.ClientKey = CLT.ClientKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
            ON PD.MembershipKey = M.MembershipKey
WHERE   MONTH(DD.FullDate) = MONTH(@PCPDate)
        AND YEAR(DD.FullDate) = YEAR(@PCPDate)



END
GO
