/*===============================================================================================
-- Procedure Name:         spSvc_MarketingAutomatedSurgeryList
-- Procedure Description:  Calculates the closing percente by performer
--
-- Created By:             Marlon Burrell
-- Implemented By:         Marlon Burrell
-- Last Modified By:       Marlon Burrell
--
-- Date Created:           3/17/2010
-- Date Implemented:       3/17/2010
-- Date Last Modified:     1/7/2014
--
-- Destination Server:     SQL06
-- Destination Database:   HC_BI_Reporting
-- Related Application:    Marketing Automated Surgery List
-- ----------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------
	03/22/2011 - MB - Added Center name to output
	01/07/2014 - RMH - Moved the stored procedure to SQL06 and changed the table names.
-- ----------------------------------------------------------------------------------------------
Sample Execution:
	EXEC spSvc_MarketingAutomatedSurgeryList
================================================================================================*/
CREATE PROCEDURE [dbo].[spSvc_MarketingAutomatedSurgeryList] AS
BEGIN

	SET NOCOUNT ON
	SET FMTONLY OFF

	/*
		Declare variables
	*/
	DECLARE @FirstDayOfCurrentMonth DATETIME
	,	@LastDayOfCurrentMonth DATETIME
	,	@TwoMonthsPriorStart DATETIME
	,	@TwoMonthsPriorEnd DATETIME
	,	@EightMonthsPriorStart DATETIME
	,	@EightMonthsPriorEnd DATETIME
	,	@TwelveMonthsPriorStart DATETIME
	,	@TwelveMonthsPriorEnd DATETIME


	/*
		Declare temp tables
	*/
	CREATE TABLE #Procedures(
		[MonthsBack] INT
	,	[Center] INT
	,	[SurgeryDate] DATETIME
	,	[SurgeryType] VARCHAR(25)
	,	[LastName] VARCHAR(50)
	,	[FirstName] VARCHAR(50)
	,	[Address1] VARCHAR(50)
	,	[Address2] VARCHAR(50)
	,	[City] VARCHAR(50)
	,	[State] VARCHAR(25)
	,	[Zip] VARCHAR(10)
	,	[Email] VARCHAR(50)
	,	[Phone1] VARCHAR(25)
	,	[Phone2] VARCHAR(25)
	)

	/*
		Initialize variables
	*/
	SET @FirstDayOfCurrentMonth = CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(GETDATE())) + '/1/' + CONVERT(VARCHAR, YEAR(GETDATE())))
	SET @LastDayOfCurrentMonth = CONVERT(DATETIME, CONVERT(VARCHAR, DATEADD(n, -1, DATEADD(MONTH, 1, @FirstDayOfCurrentMonth)), 101)) + ' 23:59:59'

	SET @TwoMonthsPriorStart = DATEADD(MONTH, -2, @FirstDayOfCurrentMonth)
	SET @TwoMonthsPriorEnd = CONVERT(DATETIME, CONVERT(VARCHAR, DATEADD(n, -1, DATEADD(MONTH, 1, @TwoMonthsPriorStart)), 101)) + ' 23:59:59'

	SET @EightMonthsPriorStart = DATEADD(MONTH, -8, @FirstDayOfCurrentMonth)
	SET @EightMonthsPriorEnd = CONVERT(DATETIME, CONVERT(VARCHAR, DATEADD(n, -1, DATEADD(MONTH, 1, @EightMonthsPriorStart)), 101)) + ' 23:59:59'

	SET @TwelveMonthsPriorStart = DATEADD(MONTH, -12, @FirstDayOfCurrentMonth)
	SET @TwelveMonthsPriorEnd = CONVERT(DATETIME, CONVERT(VARCHAR, DATEADD(n, -1, DATEADD(MONTH, 1, @TwelveMonthsPriorStart)), 101)) + ' 23:59:59'


	/*
		Insert procedures from 2 months back
	*/
	INSERT INTO #Procedures(
		[MonthsBack]
	,	[Center]
	,	[SurgeryDate]
	,	[SurgeryType]
	,	[LastName]
	,	[FirstName]
	,	[Address1]
	,	[Address2]
	,	[City]
	,	[State]
	,	[Zip]
	,	[Email]
	,	[Phone1]
	,	[Phone2])
	SELECT DISTINCT 2 AS 'MonthsBack'
	,	FST.CenterKey AS 'Center'
	,	DD.FullDate AS 'SurgeryDate'
	,	M.MembershipDescription AS 'SurgeryType'
	,	CLT.ClientLastName AS 'LastName'
	,	CLT.ClientFirstName AS 'FirstName'
	,	CLT.ClientAddress1 AS 'Address1'
	,	CLT.ClientAddress2 AS 'Address2'
	,	CLT.City AS 'City'
	,	CLT.StateProvinceDescriptionShort AS 'State'
	,	CLT.PostalCode AS 'Zip'
	,	CLT.ClientEMailAddress AS 'Email'
	,	CLT.ClientPhone1 AS 'Phone1'
	,	CLT.ClientPhone2 AS 'Phone2'
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
            ON FST.ClientMembershipKey = CM.ClientMembershipKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
            ON CM.MembershipKey = M.MembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
	WHERE DD.FullDate BETWEEN @TwoMonthsPriorStart AND @TwoMonthsPriorEnd
		AND M.BusinessSegmentDescription = 'Surgery'
		AND M.MembershipDescription NOT LIKE 'New Client%'



	/*
		Insert procedures from 8 months back
	*/
	INSERT INTO #Procedures(
		[MonthsBack]
	,	[Center]
	,	[SurgeryDate]
	,	[SurgeryType]
	,	[LastName]
	,	[FirstName]
	,	[Address1]
	,	[Address2]
	,	[City]
	,	[State]
	,	[Zip]
	,	[Email]
	,	[Phone1]
	,	[Phone2])
	SELECT DISTINCT 8 AS 'MonthsBack'
	,	FST.CenterKey AS 'Center'
	,	DD.FullDate AS 'SurgeryDate'
	,	M.MembershipDescription AS 'SurgeryType'
	,	CLT.ClientLastName AS 'LastName'
	,	CLT.ClientFirstName AS 'FirstName'
	,	CLT.ClientAddress1 AS 'Address1'
	,	CLT.ClientAddress2 AS 'Address2'
	,	CLT.City AS 'City'
	,	CLT.StateProvinceDescriptionShort AS 'State'
	,	CLT.PostalCode AS 'Zip'
	,	CLT.ClientEMailAddress AS 'Email'
	,	CLT.ClientPhone1 AS 'Phone1'
	,	CLT.ClientPhone2 AS 'Phone2'
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
            ON FST.ClientMembershipKey = CM.ClientMembershipKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
            ON CM.MembershipKey = M.MembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
	WHERE DD.FullDate BETWEEN @EightMonthsPriorStart AND @EightMonthsPriorEnd
		AND M.BusinessSegmentDescription = 'Surgery'
		AND M.MembershipDescription NOT LIKE 'New Client%'



	/*
		Insert procedures from 12 months back
	*/
	INSERT INTO #Procedures(
		[MonthsBack]
	,	[Center]
	,	[SurgeryDate]
	,	[SurgeryType]
	,	[LastName]
	,	[FirstName]
	,	[Address1]
	,	[Address2]
	,	[City]
	,	[State]
	,	[Zip]
	,	[Email]
	,	[Phone1]
	,	[Phone2])
	SELECT DISTINCT 12 AS 'MonthsBack'
	,	FST.CenterKey AS 'Center'
	,	DD.FullDate AS 'SurgeryDate'
	,	M.MembershipDescription AS 'SurgeryType'
	,	CLT.ClientLastName AS 'LastName'
	,	CLT.ClientFirstName AS 'FirstName'
	,	CLT.ClientAddress1 AS 'Address1'
	,	CLT.ClientAddress2 AS 'Address2'
	,	CLT.City AS 'City'
	,	CLT.StateProvinceDescriptionShort AS 'State'
	,	CLT.PostalCode AS 'Zip'
	,	CLT.ClientEMailAddress AS 'Email'
	,	CLT.ClientPhone1 AS 'Phone1'
	,	CLT.ClientPhone2 AS 'Phone2'
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
	    INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
            ON FST.ClientMembershipKey = CM.ClientMembershipKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
            ON CM.MembershipKey = M.MembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
	WHERE DD.FullDate BETWEEN @TwelveMonthsPriorStart AND @TwelveMonthsPriorEnd
		AND M.BusinessSegmentDescription = 'Surgery'
		AND M.MembershipDescription NOT LIKE 'New Client%'


	SELECT P.[MonthsBack]
	,	P.[Center]
	,	CONVERT(NVARCHAR, C.CenterDescriptionNumber) AS 'CenterName'
	,	CONVERT(NVARCHAR, P.[SurgeryDate], 101) AS 'SurgeryDate'
	,	CONVERT(NVARCHAR, P.[SurgeryType]) AS 'SurgeryType'
	,	CONVERT(NVARCHAR, P.[LastName]) AS 'LastName'
	,	CONVERT(NVARCHAR, P.[FirstName]) AS 'FirstName'
	,	CONVERT(NVARCHAR, P.[Address1]) AS 'Address1'
	,	CONVERT(NVARCHAR, P.[Address2]) AS 'Address2'
	,	CONVERT(NVARCHAR, P.[City]) AS 'City'
	,	CONVERT(NVARCHAR, P.[State]) AS 'State'
	,	CONVERT(NVARCHAR, P.[Zip]) AS 'Zip'
	,	CONVERT(NVARCHAR, P.[Email]) AS 'Email'
	,	CONVERT(NVARCHAR, P.[Phone1]) AS 'Phone1'
	,	CONVERT(NVARCHAR, P.[Phone2]) AS 'Phone2'
	FROM #Procedures P
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
            ON P.Center = C.CenterKey

END
