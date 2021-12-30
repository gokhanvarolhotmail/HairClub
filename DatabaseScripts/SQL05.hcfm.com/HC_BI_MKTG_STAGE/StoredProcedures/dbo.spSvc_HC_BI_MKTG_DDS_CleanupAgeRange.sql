/* CreateDate: 10/11/2019 10:27:03.387 , ModifyDate: 10/11/2019 10:27:03.387 */
GO
/***********************************************************************
PROCEDURE:				spSvc_HC_BI_MKTG_DDS_CleanupAgeRange
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_BI_MKTG_STAGE
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		10/11/2019
DESCRIPTION:			Used to cleanup the age ranges in the MKTG tables
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_HC_BI_MKTG_DDS_CleanupAgeRange
***********************************************************************/
CREATE PROCEDURE spSvc_HC_BI_MKTG_DDS_CleanupAgeRange
AS
BEGIN

CREATE TABLE #DimContact (
	ContactKey INT
,	ContactSSID NVARCHAR(10)
,	SFDC_LeadID NVARCHAR(18)
,	LeadCreationDate DATETIME
,	LeadStatus NVARCHAR(50)
,	OnContactBirthday DATETIME
,	OnContactAge INT
,	SalesforceBirthday DATETIME
,	SalesforceAge INT
,	SalesforceAgeRange NVARCHAR(50)
,	ClientBirthday DATETIME
,	ClientAge INT
,	Age INT
,   BirthdayCalc DATETIME
,   AgeCalc INT
,   MaxAgeCalc INT
,	AgeRangeKey INT
,	AgeRangeSSID INT
,	AgeRangeDescription NVARCHAR(50)
)

CREATE TABLE #OnContact (
	ContactSSID NVARCHAR(10)
,	Birthday DATETIME
,	Age INT
)

CREATE TABLE #Salesforce (
	ContactSSID NVARCHAR(10)
,	SFDC_LeadID NVARCHAR(18)
,	Birthday DATETIME
,	Age INT
,	AgeRange NVARCHAR(50)
)

CREATE TABLE #Client (
	ContactSSID NVARCHAR(10)
,	SFDC_LeadID NVARCHAR(18)
,	Birthday DATETIME
,	Age INT
)


/* Get BI Leads */
INSERT	INTO #DimContact
		SELECT	dc.ContactKey
		,		dc.ContactSSID
		,		dc.SFDC_LeadID
		,		dc.CreationDate AS 'LeadCreationDate'
		,		dc.ContactStatusSSID AS 'LeadStatus'
		,		NULL AS 'OnContactBirthday'
		,		NULL AS 'OnContactAge'
		,		NULL AS 'SalesforceBirthday'
		,		NULL AS 'SalesforceAge'
		,		NULL AS 'SalesforceAgeRange'
		,		NULL AS 'ClientBirthday'
		,		NULL AS 'ClientAge'
		,		NULL AS 'Age'
		,		NULL AS 'BirthdayCalc'
		,		NULL AS 'AgeCalc'
		,		NULL AS 'MaxAgeCalc'
		,		NULL AS 'AgeRangeKey'
		,		NULL AS 'AgeRangeSSID'
		,		NULL AS 'AgeRangeDescription'
		FROM	HC_BI_MKTG_DDS.bi_mktg_dds.DimContact dc
		WHERE	dc.ContactStatusSSID NOT IN ( 'DELETED', 'MERGED', 'INVALID' )
				AND dc.ContactKey <> -1


CREATE NONCLUSTERED INDEX IDX_DimContact_ContactSSID ON #DimContact ( ContactSSID );
CREATE NONCLUSTERED INDEX IDX_DimContact_SFDC_LeadID ON #DimContact ( SFDC_LeadID );


UPDATE STATISTICS #DimContact;


/* Get related OnContact Leads */
INSERT	INTO #OnContact
		SELECT	onc.ContactSSID
		,		onc.Birthday
		,		onc.Age
		FROM	(
					SELECT	ROW_NUMBER() OVER (PARTITION BY oc.contact_id ORDER BY cad.creation_date DESC) AS 'RowID'
					,		dc.ContactSSID
					,		cad.birthday AS 'Birthday'
					,		cad.age AS 'Age'
					FROM	HCM.dbo.oncd_activity oa
							INNER JOIN HCM.dbo.oncd_activity_contact oac
								ON oac.activity_id = oa.activity_id
							INNER JOIN HCM.dbo.cstd_activity_demographic cad
								ON cad.activity_id = oa.activity_id
							INNER JOIN HCM.dbo.oncd_contact oc
								ON oc.contact_id = oac.contact_id
							INNER JOIN #DimContact dc
								ON dc.ContactSSID = oc.contact_id
					WHERE	oa.result_code IN ( 'SHOWSALE', 'SHOWNOSALE' )
				) onc
		WHERE	onc.RowID = 1


CREATE NONCLUSTERED INDEX IDX_OnContact_ContactSSID ON #OnContact ( ContactSSID );


UPDATE STATISTICS #OnContact;


UPDATE	dc
SET		dc.OnContactBirthday = oc.Birthday
,		dc.OnContactAge = oc.Age
FROM	#DimContact dc
		INNER JOIN #OnContact oc
			ON oc.ContactSSID = dc.ContactSSID


UPDATE STATISTICS #DimContact;


/* Get related Salesforce Leads */
INSERT	INTO #Salesforce
		SELECT	dc.ContactSSID
		,		dc.SFDC_LeadID
		,		l.Birthday__c
		,		l.Age__c
		,		l.AgeRange__c
		FROM	HC_BI_SFDC.dbo.Lead l
				INNER JOIN #DimContact dc
					ON dc.SFDC_LeadID = l.Id


CREATE NONCLUSTERED INDEX IDX_Salesforce_ContactSSID ON #Salesforce ( ContactSSID );
CREATE NONCLUSTERED INDEX IDX_Salesforce_SFDC_LeadID ON #Salesforce ( SFDC_LeadID );


UPDATE STATISTICS #Salesforce;


UPDATE	dc
SET		dc.SalesforceBirthday = s.Birthday
,		dc.SalesforceAge = s.Age
,		dc.SalesforceAgeRange = s.AgeRange
FROM	#DimContact dc
		INNER JOIN #Salesforce s
			ON s.SFDC_LeadID = dc.SFDC_LeadID


UPDATE STATISTICS #DimContact;


/* Get related Client Records */
INSERT	INTO #Client
		SELECT	clt.ContactSSID
		,		clt.SFDC_LeadID
		,		clt.Birthday
		,		clt.Age
		FROM	(
					SELECT	ROW_NUMBER() OVER (PARTITION BY c.ClientGUID ORDER BY c.CreateDate DESC) AS 'RowID'
					,		dc.ContactSSID
					,		dc.SFDC_LeadID
					,		c.DateOfBirth AS 'Birthday'
					,		c.AgeCalc AS 'Age'
					FROM	HairClubCMS.dbo.datClient c
							INNER JOIN #DimContact dc
								ON dc.SFDC_LeadID = c.SalesforceContactID
				) clt
		WHERE	clt.RowID = 1


CREATE NONCLUSTERED INDEX IDX_Client_ContactSSID ON #Client ( ContactSSID );
CREATE NONCLUSTERED INDEX IDX_Client_SFDC_LeadID ON #Client ( SFDC_LeadID );


UPDATE STATISTICS #Client;


UPDATE	dc
SET		dc.ClientBirthday = c.Birthday
,		dc.ClientAge = c.Age
FROM	#DimContact dc
		INNER JOIN #Client c
			ON c.SFDC_LeadID = dc.SFDC_LeadID


UPDATE STATISTICS #DimContact;


/* Age cleanup */
UPDATE	dc
SET		dc.OnContactAge = NULL
FROM	#DimContact dc
WHERE	( dc.OnContactAge <= 1
			OR dc.OnContactAge > 90 )


UPDATE	dc
SET		dc.SalesforceAge = NULL
FROM	#DimContact dc
WHERE	( dc.SalesforceAge <= 1
			OR dc.SalesforceAge > 90 )


UPDATE	dc
SET		dc.ClientAge = NULL
FROM	#DimContact dc
WHERE	( dc.ClientAge <= 1
			OR dc.ClientAge > 90 )


/* Birthday cleanup */
UPDATE	dc
SET		dc.OnContactBirthday = NULL
FROM	#DimContact dc
WHERE	dc.OnContactBirthday IN ( '1900-01-01 00:00:00.000', '2003-01-01 00:00:00.000', '2004-01-01 00:00:00.000', '2008-01-01 00:00:00.000'
								, '2009-01-01 00:00:00.000', '2010-01-01 00:00:00.000', '2011-01-01 00:00:00.000', '2012-01-01 00:00:00.000'
								, '2016-01-01 00:00:00.000', '2017-01-01 00:00:00.000', '2019-01-01 00:00:00.000', '2018-11-27 00:00:00.000'
								, '2018-10-18 00:00:00.000', '2018-12-13 00:00:00.000', '2018-11-28 00:00:00.000', '2018-12-21 00:00:00.000'
								, '2018-12-18 00:00:00.000', '2018-12-07 00:00:00.000', '2018-11-29 00:00:00.000', '2018-12-14 00:00:00.000'
								, '2018-10-01 00:00:00.000', '2018-10-05 00:00:00.000'
								)


UPDATE	dc
SET		dc.SalesforceBirthday = NULL
FROM	#DimContact dc
WHERE	dc.SalesforceBirthday IN ( '1900-01-01 00:00:00.000', '2003-01-01 00:00:00.000', '2004-01-01 00:00:00.000', '2008-01-01 00:00:00.000'
								, '2009-01-01 00:00:00.000', '2010-01-01 00:00:00.000', '2011-01-01 00:00:00.000', '2012-01-01 00:00:00.000'
								, '2016-01-01 00:00:00.000', '2017-01-01 00:00:00.000', '2019-01-01 00:00:00.000', '2018-11-27 00:00:00.000'
								, '2018-10-18 00:00:00.000', '2018-12-13 00:00:00.000', '2018-11-28 00:00:00.000', '2018-12-21 00:00:00.000'
								, '2018-12-18 00:00:00.000', '2018-12-07 00:00:00.000', '2018-11-29 00:00:00.000', '2018-12-14 00:00:00.000'
								, '2018-10-01 00:00:00.000', '2018-10-05 00:00:00.000'
								)


UPDATE	dc
SET		dc.ClientBirthday = NULL
FROM	#DimContact dc
WHERE	dc.ClientBirthday IN ( '1900-01-01 00:00:00.000', '2003-01-01 00:00:00.000', '2004-01-01 00:00:00.000', '2008-01-01 00:00:00.000'
							, '2009-01-01 00:00:00.000', '2010-01-01 00:00:00.000', '2011-01-01 00:00:00.000', '2012-01-01 00:00:00.000'
							, '2016-01-01 00:00:00.000', '2017-01-01 00:00:00.000', '2019-01-01 00:00:00.000', '2018-11-27 00:00:00.000'
							, '2018-10-18 00:00:00.000', '2018-12-13 00:00:00.000', '2018-11-28 00:00:00.000', '2018-12-21 00:00:00.000'
							, '2018-12-18 00:00:00.000', '2018-12-07 00:00:00.000', '2018-11-29 00:00:00.000', '2018-12-14 00:00:00.000'
							, '2018-10-01 00:00:00.000', '2018-10-05 00:00:00.000'
							)


UPDATE	dc
SET		dc.OnContactBirthday = NULL
FROM	#DimContact dc
WHERE	YEAR(dc.OnContactBirthday) >= YEAR(GETDATE())


UPDATE	dc
SET		dc.SalesforceBirthday = NULL
FROM	#DimContact dc
WHERE	YEAR(dc.SalesforceBirthday) >= YEAR(GETDATE())


UPDATE	dc
SET		dc.ClientBirthday = NULL
FROM	#DimContact dc
WHERE	YEAR(dc.ClientBirthday) >= YEAR(GETDATE())


UPDATE	dc
SET		dc.SalesforceAge = CASE WHEN dc.SalesforceAgeRange = 'Under 18' THEN 17
							WHEN dc.SalesforceAgeRange = '18 to 24' THEN 18
							WHEN dc.SalesforceAgeRange = '25 to 34' THEN 25
							WHEN dc.SalesforceAgeRange = '35 to 44' THEN 35
							WHEN dc.SalesforceAgeRange = '45 to 54' THEN 45
							WHEN dc.SalesforceAgeRange = '55 to 64' THEN 55
							WHEN dc.SalesforceAgeRange = '65 +' THEN 65
							ELSE 0
						END
FROM	#DimContact dc
WHERE	ISNULL(dc.SalesforceAgeRange, 'Unknown') <> 'Unknown'
		AND dc.SalesforceAge IS NULL


/* Update Age and BirthdayCalc values */
UPDATE	dc
SET		dc.BirthdayCalc = COALESCE(dc.ClientBirthday, dc.SalesforceBirthday, dc.OnContactBirthday)
,		dc.Age = ISNULL(COALESCE(dc.ClientAge, dc.SalesforceAge, dc.OnContactAge), 0)
FROM	#DimContact dc


/* Cleanup AgeCalc */
UPDATE	dc
SET		dc.Age = 0
FROM	#DimContact dc
WHERE	( dc.Age <= 1
			OR dc.Age > 90 )


UPDATE	dc
SET		dc.AgeCalc = CASE WHEN DATEPART(MONTH, BirthdayCalc) < DATEPART(MONTH, GETDATE())
							OR	DATEPART(MONTH, BirthdayCalc) = DATEPART(MONTH, GETDATE())
								AND DATEPART(DAY, BirthdayCalc) <= DATEPART(DAY, GETDATE()) THEN DATEDIFF(YEAR, BirthdayCalc, GETDATE())
						ELSE DATEDIFF(YEAR, BirthdayCalc, GETDATE()) - (1)
					END
FROM	#DimContact dc
WHERE	dc.BirthdayCalc IS NOT NULL


UPDATE	dc
SET		dc.AgeCalc = 0
FROM	#DimContact dc
WHERE	dc.AgeCalc IS NULL


UPDATE	dc
SET		dc.AgeCalc = dc.Age
FROM	#DimContact dc
WHERE	( dc.AgeRangeKey IS NULL
			OR dc.AgeRangeSSID IS NULL
			OR dc.AgeRangeDescription IS NULL )
		AND dc.Age <> ISNULL(dc.AgeCalc, 0)
		AND dc.AgeCalc = 0


UPDATE	dc
SET		dc.AgeCalc = dc.Age
FROM	#DimContact dc
WHERE	dc.Age > dc.AgeCalc


UPDATE	dc
SET		dc.MaxAgeCalc = CASE WHEN ISNULL(dc.OnContactAge, 0) > ISNULL(dc.SalesforceAge, 0) THEN
								CASE WHEN ISNULL(dc.OnContactAge, 0) > ISNULL(dc.ClientAge, 0) THEN ISNULL(dc.OnContactAge, 0)
									ELSE ISNULL(dc.ClientAge, 0)
								END
							WHEN ISNULL(dc.SalesforceAge, 0) > ISNULL(dc.ClientAge, 0) THEN ISNULL(dc.SalesforceAge, 0)
							ELSE ISNULL(dc.ClientAge, 0)
						END
FROM	#DimContact dc


/* Update AgeRange values */
UPDATE	dc
SET		dc.AgeRangeKey = -1
,		dc.AgeRangeSSID = '-2'
,		dc.AgeRangeDescription = 'Unknown'
FROM	#DimContact dc
WHERE	ISNULL(dc.AgeCalc, 0) = 0
		AND ISNULL(dc.SalesforceAgeRange, 'Unknown') = 'Unknown'


UPDATE	dc
SET		dc.AgeRangeKey = ar.AgeRangeKey
,		dc.AgeRangeSSID = ar.AgeRangeSSID
,		dc.AgeRangeDescription = ar.AgeRangeDescription
FROM	#DimContact dc
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAgeRange ar
			ON ar.AgeRangeDescription = dc.SalesforceAgeRange
WHERE	ISNULL(dc.AgeCalc, 0) = 0
		AND ISNULL(dc.SalesforceAgeRange, 'Unknown') <> 'Unknown'


UPDATE	dc
SET		dc.AgeRangeKey = ar.AgeRangeKey
,		dc.AgeRangeSSID = ar.AgeRangeSSID
,		dc.AgeRangeDescription = ar.AgeRangeDescription
FROM	#DimContact dc
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAgeRange ar
			ON dc.AgeCalc BETWEEN ar.BeginAge AND ar.EndAge
WHERE	ISNULL(dc.AgeCalc, 0) <> 0


UPDATE	dc
SET		dc.AgeRangeKey = ar.AgeRangeKey
,		dc.AgeRangeSSID = ar.AgeRangeSSID
,		dc.AgeRangeDescription = ar.AgeRangeDescription
FROM	#DimContact dc
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAgeRange ar
			ON ar.AgeRangeDescription = dc.SalesforceAgeRange
WHERE	dc.Age = 0
		AND ISNULL(dc.SalesforceAgeRange, 'Unknown') <> 'Unknown'
		AND dc.SalesforceAgeRange <> dc.AgeRangeDescription
		AND dc.AgeRangeSSID = 1


UPDATE	c
SET		c.AgeRangeKey = ar.AgeRangeKey
,		c.AgeRangeSSID = ar.AgeRangeSSID
,		c.AgeRangeDescription = ar.AgeRangeDescription
FROM	#DimContact c
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact dc
			ON dc.ContactKey = c.ContactKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAgeRange ar
			ON ar.AgeRangeDescription = c.SalesforceAgeRange
WHERE	( dc.ContactAgeRangeSSID <> c.AgeRangeSSID
			OR dc.ContactAgeRangeDescription <> c.AgeRangeDescription )
		AND c.AgeRangeKey = 1
		AND c.SalesforceAge > c.AgeCalc


UPDATE	c
SET		c.AgeRangeKey = ar.AgeRangeKey
,		c.AgeRangeSSID = ar.AgeRangeSSID
,		c.AgeRangeDescription = ar.AgeRangeDescription
FROM	#DimContact c
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact dc
			ON dc.ContactKey = c.ContactKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAgeRange ar
			ON c.MaxAgeCalc BETWEEN ar.BeginAge AND ar.EndAge
WHERE	( dc.ContactAgeRangeSSID <> c.AgeRangeSSID
			OR dc.ContactAgeRangeDescription <> c.AgeRangeDescription )
		AND c.MaxAgeCalc > c.AgeCalc


UPDATE	dc
SET		dc.ContactAgeRangeSSID = c.AgeRangeSSID
,		dc.ContactAgeRangeDescription = c.AgeRangeDescription
FROM	HC_BI_MKTG_DDS.bi_mktg_dds.DimContact dc
		INNER JOIN #DimContact c
			ON c.ContactKey = dc.ContactKey
WHERE	( dc.ContactAgeRangeSSID <> c.AgeRangeSSID
			OR dc.ContactAgeRangeDescription <> c.AgeRangeDescription )


UPDATE	fl
SET		fl.AgeRangeKey = ar.AgeRangeKey
FROM	HC_BI_MKTG_DDS.bi_mktg_dds.FactLead fl
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact dc
			ON dc.ContactKey = fl.ContactKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAgeRange ar
			ON ar.AgeRangeSSID = dc.ContactAgeRangeSSID
WHERE	fl.AgeRangeKey <> ar.AgeRangeKey

END
GO
