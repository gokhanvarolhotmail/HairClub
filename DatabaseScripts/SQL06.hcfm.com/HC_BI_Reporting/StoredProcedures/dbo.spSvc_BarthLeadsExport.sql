/* CreateDate: 04/10/2014 12:15:43.327 , ModifyDate: 10/25/2021 15:02:30.150 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSvc_BarthLeadsExport
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		04/10/2014
------------------------------------------------------------------------
NOTES:

09/14/2020	KMurdoch	Removed reference to OnContactSSID
09/15/2020  KMurdoch	Added commented code to derive email/phone from HC_BI_SFDC
09/18/2020	DLeiba		Added code to account for SFDC_PersonAccountID
01/14/2021  KMurdoch    Modified selection to include records modified as well
03/10/2021  DLeiba	    Removed modification made by KMurdoch to include updated
						lead records in the feed. This change was resulting in missing
						records when they were being imported on the Barth side.
07/01/2021	EmmaNuel
			Nicolas		Update SP with information from NewEnviorment
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_BarthLeadsExport NULL, NULL
--***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_BarthLeadsExport]
	(
		@StartDate DATETIME = NULL
	,	@EndDate DATETIME = NULL
	)
AS

BEGIN

	SET FMTONLY OFF;
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	/********************************** Get Lead Data *************************************/
	IF (@StartDate IS NULL OR @EndDate IS NULL)
			BEGIN
				SET @StartDate = DATEADD(dd, -31, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
				SET @EndDate = DATEADD(dd, -1, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
			END

	/********************************** Temporal Tables Creation **************************/
	CREATE TABLE #Lead
	(
		CenterSSID           INT,
		CenterDescription    NVARCHAR(50),
		ContactSSID          VARCHAR(10),
		CreateDate           DATETIME,
		CreateTime           CHAR(5),
		FirstName            NVARCHAR(50),
		LastName             NVARCHAR(50),
		GenderKey            INT,
		GenderSSID           NVARCHAR(10),
		Gender               NCHAR(10),
		SourceKey            INT,
		Source               NCHAR(20),
		PromotionCodeKey     INT,
		PromotionCodeSSID    NVARCHAR(50),
		Number               NVARCHAR(50),
		AffiliateID          NVARCHAR(150),
		MediaType            NVARCHAR(50),
		Location             NVARCHAR(50),
		Language             NVARCHAR(50),
		Format               NVARCHAR(50),
		Creative             NVARCHAR(50),
		DoNotSolicitFlag     VARCHAR(1),
		DoNotCallFlag        VARCHAR(1),
		DoNotEmailFlag       VARCHAR(1),
		DoNotMailFlag        VARCHAR(1),
		DoNotTextFlag        VARCHAR(1),
		LeadStatus           NCHAR(10),
		SFDC_LeadID          NVARCHAR(18),
		SFDC_PersonAccountID NVARCHAR(18),
		ZipCode              NVARCHAR(50),
		GCLID                NVARCHAR(100),
		Street               NVARCHAR(250),
		City                 NVARCHAR(60),
		StateCode            NVARCHAR(50),
		State                NVARCHAR(80),
		PostalCode           NVARCHAR(50),
		CountryCode          NVARCHAR(50),
		Country              NVARCHAR(80),
		email					NVARCHAR(255),
		phone				NVARCHAR(50),
		IsDuplicateByName   bit
	)
	CREATE TABLE #LeadAddress
	(
		RowID        INT,
		ContactSSID  VARCHAR(10),
		SFDC_LeadID  NVARCHAR(18),
		AddressLine1 NVARCHAR(250),
		AddressLine2 NVARCHAR(250),
		State        NVARCHAR(50),
		City         NVARCHAR(60),
		Zip          NVARCHAR(50)
	)
	CREATE TABLE #LeadPhone
	(
		RowID       INT,
		ContactSSID VARCHAR(10),
		SFDC_LeadID NVARCHAR(18),
		Phone       VARCHAR(10)
	)
	CREATE  TABLE #LeadEmail
	(
		RowID       INT,
		ContactSSID VARCHAR(10),
		SFDC_LeadID NVARCHAR(18),
		Email       NVARCHAR(250)
	)

	/* Get Leads created between the specified time period */

	INSERT INTO #Lead
	SELECT ctr.CenterSSID
		, ctr.CenterDescriptionNumber                                     AS 'CenterDescription'
		, null															  AS 'ContactSSID'
		, CONVERT(datetime, CONVERT(CHAR(10), l.CreatedDate, 101))		  AS 'CreateDate'
		, CONVERT(CHAR(5), CONVERT(VARCHAR, l.CreatedDate, 108))		  AS 'CreateTime'
		, ISNULL(LTRIM(RTRIM(REPLACE(REPLACE(
											REPLACE(CAST(l.FirstName AS NVARCHAR(50)), '?', ''),
											'  ',
											''),
									',', ' '))),
				'')                                                       AS 'FirstName'
		, ISNULL(LTRIM(RTRIM(REPLACE(REPLACE(
											REPLACE(CAST(l.LastName AS NVARCHAR(50)), '?', ''),
											'  ',
											''),
									',', ' '))),
				'')														   AS 'LastName'
		, dg.GenderKey
		, dg.GenderSSID
		, CONVERT(NCHAR(10), UPPER(dg.GenderDescription))                  AS 'Gender'
		, coalesce(ds.SourceKey,ds2.SourceKey,'-1')						   AS 'SourceKey'
		, CONVERT(NCHAR(20), coalesce(l.RecentSourceCode__c,ds.SourceSSID,dcp.SourceCode,'15982'))  AS 'Source'
		, ISNULL(dpc.PromotionCodeKey,dcp.PromotioKey)
		, ISNULL(dpc.PromotionCodeSSID,dcp.PromoCode)                      AS 'PromotionCode'
		, REPLACE(REPLACE(REPLACE(ds.Number, '(', ''), ')', ''), '-', ' ') AS '800 Number'
		, dc.ContactAffiliateID                                            AS 'AffiliateID'
		, COALESCE(dcp.CampaignMedia,ds.Media,'Unknown')                  AS 'Media Type'
		, COALESCE( dcp.CampaignLocation,ds.Level02Location,'Unknown')     AS 'Location'
		, COALESCE( dcp.[CampaignLanguage],ds.Level03Language,'Unknown')   AS 'Language'
		, COALESCE( dcp.CampaignFormat,ds.Level04Format,'Unknown')         AS 'Format'
		, COALESCE(l.LeadSource,ds.Level05Creative, ds2.Level05Creative)                  AS 'Creative'
		, l.DoNotContact__c
		, l.DoNotCall
		, l.DoNotEmail__c
		, l.DoNotMail__c
		, l.DoNotText__c
		, CONVERT(NCHAR(10), UPPER(l.Status))								AS 'LeadStatus'
		, ISNULL(l.Id, '')													AS 'SFDC_LeadID'
		, ISNULL(l.ConvertedContactId, '')									AS 'SFDC_PersonAccountID'
		, ISNULL(zc.Name, '')												AS 'ZipCode'
		, ISNULL(l.GCLID__c, '')
		, REPLACE(ISNULL(l.Street, ''), ',', ' ')
		, REPLACE(ISNULL(l.City, ''), ',', ' ')
		, REPLACE(ISNULL(l.StateCode, ''), ',', ' ')
		, REPLACE(ISNULL(l.State, ''), ',', ' ')
		, REPLACE(ISNULL(l.PostalCode, ''), ',', ' ')
		, REPLACE(ISNULL(l.CountryCode, ''), ',', ' ')
		, REPLACE(ISNULL(l.Country, ''), ',', ' ')
		, l.Email
		, l.Phone
		, l.IsDuplicateByName
	FROM HC_BI_SFDC.dbo.Lead l
		LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr WITH (NOLOCK)
				ON ctr.CenterNumber = l.CenterNumber__c AND ctr.Active = 'Y'
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact dc
				ON l.Id = dc.SFDC_LeadID AND dc.ContactStatusDescription <> 'Merged'
		LEFT OUTER JOIN HC_BI_SFDC.dbo.ZipCode__c zc
				ON zc.Id = l.ZipCode__c
		LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimGender dg WITH (NOLOCK)
				ON dg.GenderDescription = l.Gender__c
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource ds WITH (NOLOCK)
				ON ds.SourceSSID = l.RecentSourceCode__c
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimPromotionCode dpc WITH (NOLOCK)
				ON dpc.PromotionCodeSSID = ds.PromoCode
		LEFT OUTER JOIN HC_BI_SFDC.Synapse_pool.LeadsWithOutCampaign lwoc
				ON lwoc.ID = l.Id
		LEFT OUTER JOIN HC_BI_SFDC.Synapse_pool.DimCampaign dcp
				ON dcp.CampaignId = ISNULL(l.OriginalCampaignID__c,lwoc.NewCampaignId)
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource ds2 WITH (NOLOCK)
				ON ds2.SourceSSID = dcp.SourceCode
	WHERE (ctr.CenterSSID IN (745, 746, 747, 748, 804, 805, 806, 807, 811, 814, 817, 820, 821, 822)
		OR  (ctr.CenterSSID = 100 AND ds.OwnerType IN ('Barth', 'Jane Creative')))
		AND  l.CreatedDate BETWEEN @StartDate AND @EndDate + ' 23:59:59'
		AND ((l.LastName NOT BETWEEN '0000000001' AND '9999999999' AND ISNULL(l.FirstName, '') <> '')
		OR  (l.LastName NOT BETWEEN '0000000001' AND '9999999999' AND ISNULL(l.FirstName, '') = '')
		OR  (ISNULL(l.LastName, '') <> '' AND ISNULL(l.FirstName, '') <> ''))
		AND isValid = 1 AND l.IsDeleted = 0

	/************************************* Data Set  Out ******************************************/

	SELECT l.CenterSSID,
		l.CenterDescription
		,
		l.SFDC_LeadID                                                                      AS 'LeadID',
		l.CreateDate,
		l.CreateTime,
		CAST(LTRIM(RTRIM(REPLACE(REPLACE(l.FirstName, '?', ''), '  ', ' '))) AS VARCHAR(50)) AS 'FirstName',
		CAST(LTRIM(RTRIM(REPLACE(REPLACE(l.LastName, '?', ''), '  ', ' '))) AS VARCHAR(50))  AS 'LastName',
		l.Street                                                                             AS 'AddressLine1',
		''						                                                             AS 'AddressLine2',
		l.StateCode																			 AS 'State',
		l.City                                                                               AS 'City',
		l.PostalCode																		 AS 'Zip',
		l.GenderKey,
		l.GenderSSID,
		l.Gender,
		ISNULL(l.Phone, '')                                                                  AS 'Phone',
		l.Email,
		l.SourceKey,
		l.Source,
		l.PromotionCodeKey,
		l.PromotionCodeSSID,
		l.Number                                                                             AS '800 Number',
		l.AffiliateID,
		l.MediaType                                                                          AS 'Media Type',
		l.Location,
		l.Language,
		l.Format,
		l.Creative,
		l.DoNotSolicitFlag,
		l.DoNotCallFlag,
		l.DoNotEmailFlag,
		l.DoNotMailFlag,
		l.DoNotTextFlag,
		l.LeadStatus,
		l.SFDC_LeadID,
		l.GCLID,
		l.SFDC_PersonAccountID,
		l.IsDuplicateByName
	FROM #Lead l

 END
GO
