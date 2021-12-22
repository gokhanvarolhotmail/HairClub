/* CreateDate: 09/20/2018 14:46:22.450 , ModifyDate: 09/20/2018 14:46:22.450 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				pop_pbiClosingByConsultant
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:
AUTHOR:					Rachelen Hut

------------------------------------------------------------------------
CHANGE HISTORY:
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC pop_pbiClosingByConsultant
***********************************************************************/
CREATE PROCEDURE [dbo].[pop_pbiClosingByConsultant]

AS
BEGIN

	SET ARITHABORT OFF
	SET ANSI_WARNINGS OFF



CREATE TABLE #Centers(
	CenterManagementAreaSSID INT
,	CenterManagementAreaDescription NVARCHAR(50)
,	CenterManagementAreaSortOrder INT
,	CenterNumber INT
,	CenterKey INT
,	CenterDescriptionNumber NVARCHAR(104)
,	CenterTypeDescriptionShort NVARCHAR(10)
)


CREATE TABLE #Rolling2Years(
	DateKey INT
,	FullDate DATE
,	FirstDateOfMonth DATE
,	MonthNumber INT
,	YearNumber INT
)


CREATE TABLE #Closing(
	CenterManagementAreaSSID INT NULL
,	CenterManagementAreaDescription NVARCHAR(100) NULL
,	CenterManagementAreaSortOrder INT NULL
,	CenterNumber INT NULL
,	CenterKey INT NULL
,	CenterDescriptionNumber NVARCHAR(103) NULL
,	CenterTypeDescriptionShort NVARCHAR(10) NULL
,	EmployeeKey INT NULL
,	Performer NVARCHAR(150) NULL
,	ActivityDueDate DATETIME NULL
,	ActivitySSID NVARCHAR(10) NULL
,	ActionCode NVARCHAR(50) NULL
,	ResultCode NVARCHAR(50) NULL
,	NoSaleReason NVARCHAR(200) NULL
,	SolutionOffered NVARCHAR(200) NULL
,	PriceQuoted MONEY NULL
,	[Type] NVARCHAR(50) NULL
,	ContactFullName NVARCHAR(200) NULL
,	ContactGender NVARCHAR(200) NULL
)

/*********** Find Centers **************************************************************/

INSERT INTO #Centers
SELECT  CMA.CenterManagementAreaSSID
				,		CMA.CenterManagementAreaDescription
				,		CMA.CenterManagementAreaSortOrder
				,		DC.CenterNumber
				,		DC.CenterKey
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
							ON CMA.CenterManagementAreaSSID = DC.CenterManagementAreaSSID
				WHERE   DCT.CenterTypeDescriptionShort = 'C'
						AND DC.Active = 'Y'

/*********** Find Dates for a rolling 2 years **************************************************************/
INSERT INTO #Rolling2Years
SELECT	DD.DateKey
,	DD.FullDate
,	DD.FirstDateOfMonth
,	DD.MonthNumber
,	DD.YearNumber
FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
WHERE DD.FullDate BETWEEN DATEADD(yy, -2, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))	--First date of year two years ago
	AND DATEADD(MINUTE,-1,(DATEADD(DAY,DATEDIFF(DAY,0,GETDATE()+1),0) ))				--KEEP Today at 11:59PM
GROUP BY DD.DateKey
,	DD.FullDate
,	DD.FirstDateOfMonth
,	DD.MonthNumber
,	DD.YearNumber


/************ Insert into #Closing new data *******************************************************************/
--Find Consultations and BeBacks
INSERT INTO #Closing
SELECT  CenterManagementAreaSSID
,		CenterManagementAreaDescription
,		CenterManagementAreaSortOrder
,		CenterNumber
,		C.CenterKey
,		CenterDescriptionNumber
,		CenterTypeDescriptionShort
,		E.EmployeeKey
,		DAD.Performer
,		DA.ActivityDueDate
,		DA.ActivitySSID
,		ISNULL(DA.ActionCodeDescription, '') AS 'ActionCode'
,		ISNULL(DA.ResultCodeDescription, '') AS 'ResultCode'
,		ISNULL(DAD.NoSaleReason, '') AS 'NoSaleReason'
,		CASE WHEN DAD.SolutionOffered <> '' THEN DAD.SolutionOffered ELSE M.MembershipDescription END AS 'SolutionOffered'
,		CASE WHEN DA.ResultCodeDescription = 'Show Sale' THEN FST.ExtendedPrice
				WHEN DA.ResultCodeDescription = 'Show No Sale' THEN ISNULL(DAD.PriceQuoted, '') ELSE '' END AS 'PriceQuoted'
,		CASE WHEN FAR.Consultation = 1 THEN 'Consultation'
				WHEN FAR.BeBack = 1 THEN 'BeBack' END AS 'Type'
,		DC.ContactFullName
,		ISNULL(DAD.GenderDescription,DC.ContactGender) AS 'ContactGender'
FROM    HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
		INNER JOIN #Centers C
			ON C.CenterKey = FAR.CenterKey
        INNER JOIN #Rolling2Years ROLL
			ON ROLL.DateKey = FAR.ActivityDueDateKey
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity DA
			ON DA.ActivityKey = FAR.ActivityKey
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact DC
			ON (DC.ContactSSID = DA.ContactSSID OR (DC.ContactSSID IS NULL AND DC.SFDC_LeadID = DA.SFDC_LeadID))
		LEFT JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivityResult DAR
			ON (DAR.ActivitySSID = DA.ActivitySSID OR (DAR.ActivitySSID IS NULL AND DAR.SFDC_TaskID = DA.SFDC_TaskID))
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivityDemographic DAD
			ON (DAD.ActivitySSID = DA.ActivitySSID OR (DAD.ActivitySSID IS NULL AND DAD.SFDC_TaskID = DA.SFDC_TaskID))
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
			ON DAD.Performer = E.EmployeeFullName AND E.IsActiveFlag = 1
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON CLT.contactkey = FAR.ContactKey
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
			ON FST.ContactKey = CLT.contactkey
				AND SalesCodeKey = 467  --INITASG
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON M.MembershipKey = FST.MembershipKey
WHERE   (FAR.Consultation = 1 OR FAR.BeBack = 1)
	AND DA.ResultCodeDescription IN ('Show Sale','Show No Sale')
	AND  M.MembershipDescription <> 'New Client (ShowNoSale)'
UNION
--Find Referrals
SELECT  CenterManagementAreaSSID
,		CenterManagementAreaDescription
,		CenterManagementAreaSortOrder
,		CenterNumber
,		C.CenterKey
,		CenterDescriptionNumber
,		CenterTypeDescriptionShort
,		E.EmployeeKey
,		DAD.Performer
,		DA.ActivityDueDate
,		DA.ActivitySSID
,		ISNULL(DA.ActionCodeDescription, '') AS 'ActionCode'
,		ISNULL(DA.ResultCodeDescription, '') AS 'ResultCode'
,		ISNULL(DAD.NoSaleReason, '') AS 'NoSaleReason'
,		CASE WHEN DAD.SolutionOffered <> '' THEN DAD.SolutionOffered ELSE M.MembershipDescription END AS 'SolutionOffered'
,		CASE WHEN DA.ResultCodeDescription = 'Show Sale' THEN FST.ExtendedPrice
				WHEN DA.ResultCodeDescription = 'Show No Sale' THEN ISNULL(DAD.PriceQuoted, '') ELSE '' END AS 'PriceQuoted'
,		'Referral' AS 'Type'
,		DC.ContactFullName
,		ISNULL(DAD.GenderDescription,DC.ContactGender) AS 'ContactGender'
FROM    HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
        INNER JOIN #Centers C
			ON C.CenterKey = FAR.CenterKey
        INNER JOIN #Rolling2Years ROLL
			ON ROLL.DateKey = FAR.ActivityDueDateKey
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity DA
			ON DA.ActivityKey = FAR.ActivityKey
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact DC
			ON (DC.ContactSSID = DA.ContactSSID OR (DC.ContactSSID IS NULL AND DC.SFDC_LeadID = DA.SFDC_LeadID))
		LEFT JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivityResult DAR
			ON (DAR.ActivitySSID = DA.ActivitySSID OR (DAR.ActivitySSID IS NULL AND DAR.SFDC_TaskID = DA.SFDC_TaskID))
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivityDemographic DAD
			ON (DAD.ActivitySSID = DA.ActivitySSID OR (DAD.ActivitySSID IS NULL AND DAD.SFDC_TaskID = DA.SFDC_TaskID))
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
			ON DAD.Performer = E.EmployeeFullName AND E.IsActiveFlag = 1
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON CLT.contactkey = FAR.ContactKey
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
			ON FST.ContactKey = CLT.contactkey
				AND SalesCodeKey = 467  --INITASG
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON M.MembershipKey = FST.MembershipKey
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity A
					ON FAR.ActivityKey = A.ActivityKey
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource DS
					ON A.SourceSSID = DS.SourceSSID
WHERE  DS.Media IN ('Referrals', 'Referral')
		AND (FAR.BOSRef = 1 OR
			 FAR.BOSOthRef = 1 OR
			 FAR.HCRef = 1)
		AND FAR.BOSAppt <> 1
		AND DA.ResultCodeDescription IN ('Show Sale','Show No Sale')
		AND  M.MembershipDescription <> 'New Client (ShowNoSale)'


--merge records with Target and Source --Populate the table dbo.pbiClosingByConsultant

MERGE dbo.pbiClosingByConsultant AS Target
USING (SELECT CenterManagementAreaSSID
,	CenterManagementAreaDescription
,	CenterManagementAreaSortOrder
,	CenterNumber
,	CenterKey
,	CenterDescriptionNumber
,	CenterTypeDescriptionShort
,	EmployeeKey
,	Performer
,	ActivityDueDate
,	ActivitySSID
,	ActionCode
,	ResultCode
,	NoSaleReason
,	SolutionOffered
,	PriceQuoted
,	[Type]
,	ContactFullName
,	ContactGender
FROM #Closing
GROUP BY CenterManagementAreaSSID
,	CenterManagementAreaDescription
,	CenterManagementAreaSortOrder
,	CenterNumber
,	CenterKey
,	CenterDescriptionNumber
,	CenterTypeDescriptionShort
,	EmployeeKey
,	Performer
,	ActivityDueDate
,	ActivitySSID
,	ActionCode
,	ResultCode
,	NoSaleReason
,	SolutionOffered
,	PriceQuoted
,	[Type]
,	ContactFullName
,	ContactGender) AS Source
ON (Target.CenterManagementAreaSSID = Source.CenterManagementAreaSSID
		AND Target.CenterManagementAreaDescription = Source.CenterManagementAreaDescription
		AND Target.CenterManagementAreaSortOrder = Source.CenterManagementAreaSortOrder
		AND Target.CenterNumber = Source.CenterNumber
		AND Target.CenterKey = Source.CenterKey
		AND Target.CenterDescriptionNumber = Source.CenterDescriptionNumber
		AND Target.CenterTypeDescriptionShort = Source.CenterTypeDescriptionShort
		AND Target.EmployeeKey = Source.EmployeeKey
		AND Target.Performer = Source.Performer
		AND Target.ActivityDueDate = Source.ActivityDueDate
		AND Target.ActivitySSID = Source.ActivitySSID
		AND Target.ActionCode = Source.ActionCode
		AND Target.ResultCode = Source.ResultCode
		AND Target.ContactFullName = Source.ContactFullName
		 )
WHEN MATCHED THEN
UPDATE SET Target.NoSaleReason = Source.NoSaleReason
,	Target.SolutionOffered = Source.SolutionOffered
,	Target.PriceQuoted = Source.PriceQuoted
,	Target.[Type] = Source.[Type]
,	Target.ContactFullName = Source.ContactFullName
,	Target.ContactGender = Source.ContactGender

WHEN NOT MATCHED BY TARGET THEN
	INSERT(CenterManagementAreaSSID
,	CenterManagementAreaDescription
,	CenterManagementAreaSortOrder
,	CenterNumber
,	CenterKey
,	CenterDescriptionNumber
,	CenterTypeDescriptionShort
,	EmployeeKey
,	Performer
,	ActivityDueDate
,	ActivitySSID
,	ActionCode
,	ResultCode
,	NoSaleReason
,	SolutionOffered
,	PriceQuoted
,	[Type]
,	ContactFullName
,	ContactGender)

	VALUES(Source.CenterManagementAreaSSID
,	Source.CenterManagementAreaDescription
,	Source.CenterManagementAreaSortOrder
,	Source.CenterNumber
,	Source.CenterKey
,	Source.CenterDescriptionNumber
,	Source.CenterTypeDescriptionShort
,	Source.EmployeeKey
,	Source.Performer
,	Source.ActivityDueDate
,	Source.ActivitySSID
,	Source.ActionCode
,	Source.ResultCode
,	Source.NoSaleReason
,	Source.SolutionOffered
,	Source.PriceQuoted
,	Source.[Type]
,	Source.ContactFullName
,	Source.ContactGender )
;


END
GO
