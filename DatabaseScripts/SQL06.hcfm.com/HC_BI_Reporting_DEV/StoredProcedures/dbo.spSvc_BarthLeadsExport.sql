/***********************************************************************
PROCEDURE:				spSvc_BarthLeadsExport
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		04/10/2014
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_BarthLeadsExport NULL, NULL
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_BarthLeadsExport]
(
	@StartDate DATETIME = NULL
,	@EndDate DATETIME = NULL
)
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


/********************************** Get Lead Data *************************************/
IF ( @StartDate IS NULL OR @EndDate IS NULL )
   BEGIN
		SET @StartDate = DATEADD(dd, -21, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
		SET @EndDate = DATEADD(dd, -1, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
   END


SELECT  CTR.CenterSSID
,		CTR.CenterDescriptionNumber AS 'CenterDescription'
,		CONVERT(VARCHAR(10), DC.ContactSSID) AS 'LeadID'
,		CONVERT(DATETIME, CONVERT(CHAR(10), DD.FullDate, 101)) AS 'CreateDate'
,       CONVERT(CHAR(5), CONVERT(VARCHAR, DTOD.Time24, 108)) AS 'CreateTime'
,       REPLACE(DC.ContactFirstName, ',', ' ') AS 'FirstName'
,       REPLACE(DC.ContactLastName, ',', ' ') AS 'LastName'
,       REPLACE(DCA.AddressLine1, ',', ' ') AS 'AddressLine1'
,       REPLACE(DCA.AddressLine2, ',', ' ') AS 'AddressLine2'
,       DCA.StateCode AS 'State'
,       REPLACE(DCA.City, ',', ' ') AS 'City'
,       CONVERT(NCHAR(15), DCA.ZipCode) AS 'Zip'
,		DG.GenderKey
,		DG.GenderSSID
,       CONVERT(NCHAR(10), UPPER(DG.GenderDescription)) AS 'Gender'
,       ISNULL(CAST(DCP.AreaCode AS VARCHAR(3)) + CAST(DCP.PhoneNumber AS VARCHAR(7)), 9999999999) AS 'Phone'
,       LEFT(REPLACE(DCE.Email, ',', '.'), 250) AS 'Email'
,		DS.SourceKey
,       CONVERT(NCHAR(20), DS.SourceSSID) AS 'Source'
,		DPC.PromotionCodeKey
,		DPC.PromotionCodeSSID AS 'PromotionCode'
,       LTRIM(RTRIM(dbo.FormatPhoneForMediaExport(DS.Number))) AS '800 Number'
,       DC.ContactAffiliateID AS 'AffiliateID'
,       DS.Media AS 'Media Type'
,       DS.Level02Location AS 'Location'
,       DS.Level03Language AS 'Language'
,       DS.Level04Format AS 'Format'
,       DS.Level05Creative AS 'Creative'
,		DC.DoNotSolicitFlag
,		DC.DoNotCallFlag
,		DC.DoNotEmailFlag
,		DC.DoNotMailFlag
,		DC.DoNotTextFlag
,       CONVERT(NCHAR(10), UPPER(DC.ContactStatusDescription)) AS 'LeadStatus'
FROM    HC_BI_MKTG_DDS.bi_mktg_dds.FactLead FL
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FL.LeadCreationDateKey = DD.DateKey
        INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact DC
            ON FL.ContactKey = DC.ContactKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
            ON FL.CenterKey = CTR.CenterKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
            ON CTR.RegionKey = DR.RegionKey
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimTimeOfDay DTOD
            ON FL.LeadCreationTimeKey = DTOD.TimeOfDayKey
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContactAddress DCA
            ON DC.ContactSSID = DCA.ContactSSID
               AND DCA.PrimaryFlag = 'Y'
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContactPhone DCP
            ON DC.ContactSSID = DCP.ContactSSID
               AND DCP.PrimaryFlag = 'Y'
        LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimGender DG
            ON FL.GenderKey = DG.GenderKey
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource DS
            ON FL.SourceKey = DS.SourceKey
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimPromotionCode DPC
            ON FL.PromotionCodeKey = DPC.PromotionCodeKey
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContactEmail DCE
            ON DC.ContactSSID = DCE.ContactSSID
               AND DCE.PrimaryFlag = 'Y'
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
        AND DC.ContactSSID NOT IN ( '0CBO1J3ITX', '0ZSGQ9WITX', '4GKD9USITX', 'ASO0GUZITX', 'E5568BCVP1', 'I094226ITX', 'N5H9LFXITX', 'WRA09ABITX' )
		AND CTR.CenterSSID IN ( 807, 804, 821, 745, 748, 806, 811, 805, 817, 746, 814, 747, 820, 822 )
ORDER BY DC.ContactSSID

END
