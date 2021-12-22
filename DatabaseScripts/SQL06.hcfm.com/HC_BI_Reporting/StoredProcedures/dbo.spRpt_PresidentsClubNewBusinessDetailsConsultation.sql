/* CreateDate: 10/04/2013 09:07:41.097 , ModifyDate: 08/20/2019 16:59:40.777 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spRpt_PresidentsClubNewBusinessDetailsConsultation
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			President's Club
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		10/04/2013
------------------------------------------------------------------------
NOTES:

10/29/2013 - DL - (#93183) Fixed issue where user was unable to drill-down on an old consultant
12/29/2015 - RH - (#121868) BOSAppt was changed to a Consultation per MO
05/19/2017 - RH - (#138367) Changed "performer" field name to "EmployeeInitials", changed @Performer to @EmployeeKey; changed logic for consultations
11/28/2017 - RH - (#144997) Changed logic to join on DimActivityDemographic to find the Performer (Salesforce Integration issue)
05/17/2018 - RH - (#150159) Added CenterNumber to pull Colorado Springs
08/20/2019 - RH - Changed join on DimContact to SFDC_LeadID and join on DimActivityDemographic to SFDC_TaskID
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_PresidentsClubNewBusinessDetailsConsultation '8/1/2018', '8/31/2018', 238

EXEC spRpt_PresidentsClubNewBusinessDetailsConsultation '8/1/2018', '8/31/2018', 238, 15991


***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_PresidentsClubNewBusinessDetailsConsultation]
(
	@StartDate DATETIME
,	@EndDate DATETIME
,	@center INT
,	@EmployeeKey INT = NULL
)
AS
BEGIN


SET FMTONLY OFF;
SET NOCOUNT OFF;


/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
	CenterSSID INT
,	CenterNumber INT
)


/********************************** Get Center/Region Data *************************************/
IF @Center > 200		--By Centers
    BEGIN
        INSERT  INTO #Centers
                SELECT  DC.CenterSSID, DC.CenterNumber
                FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
                        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
                            ON DC.RegionSSID = DR.RegionKey
                        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
                            ON DC.CenterTypeKey = DCT.CenterTypeKey
                WHERE   DC.CenterNumber = @Center
                        AND DC.Active = 'Y'
    END
ELSE
    BEGIN				--By CenterManagementAreas
        INSERT  INTO #Centers
                SELECT  DC.CenterSSID, DC.CenterNumber
                FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
                        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
                            ON CMA.CenterManagementAreaSSID = DC.CenterManagementAreaSSID
                        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
                            ON DC.CenterTypeKey = DCT.CenterTypeKey
                WHERE   CMA.CenterManagementAreaSSID = @Center
                        AND DC.Active = 'Y'
    END


/************************* Get Completion/ Consultation Data *************************************/

SELECT  DC.CenterNumber AS 'Center'
,       DC.CenterDescriptionNumber AS 'CenterName'
,       DAC.ContactFullName AS 'ClientName'
,		DAC.ContactFullName
,       DA.ActivityDueDate AS 'date'
,       DA.ResultCodeSSID AS 'Resultcode'
,       DA.ActionCodeSSID AS 'act_code'
,       DAD.NoSaleReason AS 'No_Sale_Reason'
,		POS.EmployeeKey
,       POS.EmployeeFullName
,		POS.EmployeePositionDescription
FROM    HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity DA
        INNER JOIN #Centers C
            ON DA.CenterSSID = C.CenterNumber  --DimActivity uses CenterSSID = 238 for Colorado Springs
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
            ON C.CenterNumber = DC.CenterNumber
        INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact DAC
            ON DA.SFDC_LeadID = DAC.SFDC_LeadID
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivityDemographic DAD
            ON DA.SFDC_TaskID = DAD.SFDC_TaskID
		LEFT OUTER JOIN  HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
			ON DA.ActivityKey = FAR.ActivityKey
        OUTER APPLY(SELECT TOP 1 EmployeeKey, EmployeeFullName, EP.EmployeePositionDescription
					FROM HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
					LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePositionJoin EPJ
						ON E.EmployeeSSID = EPJ.EmployeeGUID
					LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePosition EP
						ON EPJ.EmployeePositionID = EP.EmployeePositionSSID
					WHERE E.EmployeeFullName = DAD.Performer
					ORDER BY EP.EmployeePositionSortOrder) POS

WHERE   DA.ActivityDueDate BETWEEN @StartDate AND @EndDate
		AND (FAR.Consultation = 1)
		AND DA.ResultCodeSSID <> 'NOSHOW'
		AND ( @EmployeeKey IS NULL
            OR POS.EmployeeKey = @EmployeeKey )


END
GO
