/* CreateDate: 05/27/2014 10:41:59.230 , ModifyDate: 11/04/2019 08:17:08.630 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
 Procedure Name:            rptTrichoViewComparativeAnalysis
 Procedure Description:     This stored procedure provides the header information for the rptTrichoViewComparativeAnalysis.rdl
 Created By:				Rachelen Hut
 Date Created:              05/12/2014
 Destination Server:        HairclubCMS
 Related Application:       Conect
================================================================================================
**NOTES**
06/03/2014	RH	Changed the OPENQUERY to use synonym table names.
09/19/2014	RH	Changed this stored procedure to support the "comparison" report now named TrichoView Comparative Analysis.
11/17/2014	RH	Changed to only report the consultant for the appointment. (WO#108652)
01/2/2014	RH	Changed code to update statements to find the Latest Consultant and Manager (WO#110163)
02/26/2015	RH	Added Client Address and Phone
04/27/2017  PRM  Updated to reference new datClientPhone table
10/30/2017	RH	Added parameters @FirstName and @LastName (per Salesforce integration)
10/02/2019  SL	Updated to removed commented out code that is referencing OnContact and synonyms
						being deleted (TFS #13144)

================================================================================================
Sample Execution:

EXEC rptTrichoViewComparativeAnalysis '52EE6482-A768-410E-897E-43A5FF4F17C8','F7A7710A-B537-4C04-BF31-D0A6612C54E5','Luz','Logan'

================================================================================================*/

CREATE PROCEDURE [dbo].[rptTrichoViewComparativeAnalysis]
	(@AppointmentGUID UNIQUEIDENTIFIER
	,	@AppointmentGUID2 UNIQUEIDENTIFIER
    ,	@FirstName NVARCHAR(50)
	,	@LastName NVARCHAR(50)
	)

AS
BEGIN

	SET NOCOUNT OFF;

/***************Create temp tables ***************************************************************/

--CREATE TABLE #oncontact
--(	firstname NVARCHAR(50)
--	,	lastname  NVARCHAR(50)
--	,	firstname2 NVARCHAR(50)
--	,	lastname2  NVARCHAR(50)
--)

CREATE TABLE #appt
(	Comparative1 INT
,	Comparative2 INT
	,	AppointmentGUID UNIQUEIDENTIFIER
	,	ClientGUID UNIQUEIDENTIFIER
	,	FirstName NVARCHAR(50)
	,	LastName NVARCHAR(50)
	,	ClientAddress1 NVARCHAR(50)
	,	ClientAddress2 NVARCHAR(50)
	,	ClientCity NVARCHAR(50)
	,	ClientStateDescriptionShort NVARCHAR(10)
	,	ClientPostalCode NVARCHAR(10)
	,	ClientPhone1 NVARCHAR(15)
	,	EmployeeFirstName NVARCHAR(50)
	,	EmployeeLastName NVARCHAR(50)
	,	UserLogin NVARCHAR(50)
	,	CenterDescriptionFullCalc NVARCHAR(103)
	,	CenterDescription NVARCHAR(50)
	,	Address1 NVARCHAR(50)
	,	Address2 NVARCHAR(50)
	,	City NVARCHAR(50)
	,	StateID INT
	,	StateDescriptionShort NVARCHAR(10)
	,	PostalCode NVARCHAR(10)
	,	Phone1 NVARCHAR(15)
	,	ClientHomeCenterDescriptionFullCalc NVARCHAR(103)
	,	AppointmentDate NVARCHAR(20)
	,	ApptTime NVARCHAR(8)

	--SET TWO
	,	AppointmentGUID2 UNIQUEIDENTIFIER
	,	ClientGUID2 UNIQUEIDENTIFIER
	,	FirstName2 NVARCHAR(50)
	,	LastName2 NVARCHAR(50)
	,	EmployeeFirstName2 NVARCHAR(50)
	,	EmployeeLastName2 NVARCHAR(50)
	,	UserLogin2 NVARCHAR(50)
	,	CenterDescriptionFullCalc2 NVARCHAR(103)
	,	CenterDescription2 NVARCHAR(50)
	,	Address1_2 NVARCHAR(50)
	,	Address2_2 NVARCHAR(50)
	,	City2 NVARCHAR(50)
	,	StateID2 INT
	,	StateDescriptionShort2 NVARCHAR(10)
	,	PostalCode2 NVARCHAR(10)
	,	Phone1_2 NVARCHAR(15)
	,	ClientHomeCenterDescriptionFullCalc2 NVARCHAR(103)
	,	AppointmentDate2  NVARCHAR(20)
	,	ApptTime2 NVARCHAR(8)
	)


	/***************************Main Select Statement******************************************************************/
INSERT INTO #appt
        (Comparative1
		,	Comparative2
		,	AppointmentGUID
       , ClientGUID
       , FirstName
       , LastName
	   	,	ClientAddress1
	,	ClientAddress2
	,	ClientCity
	,	ClientStateDescriptionShort
	,	ClientPostalCode
	,	ClientPhone1
       , EmployeeFirstName
       , EmployeeLastName
       , UserLogin
       , CenterDescriptionFullCalc
       , CenterDescription
       , Address1
       , Address2
       , City
       , StateID
       , StateDescriptionShort
       , PostalCode
       , Phone1
       , ClientHomeCenterDescriptionFullCalc
       , AppointmentDate
       , ApptTime
       , AppointmentGUID2
       , ClientGUID2
       , FirstName2
       , LastName2
       , EmployeeFirstName2
       , EmployeeLastName2
       , UserLogin2
       , CenterDescriptionFullCalc2
       , CenterDescription2
       , Address1_2
       , Address2_2
       , City2
       , StateID2
       , StateDescriptionShort2
       , PostalCode2
       , Phone1_2
       , ClientHomeCenterDescriptionFullCalc2
       , AppointmentDate2
       , ApptTime2
        )
	SELECT	1 AS 'Comparative1'
	,	NULL AS 'Comparative2'
		,	ap.AppointmentGUID AS 'AppointmentGUID'
		,	ap.ClientGUID  AS 'ClientGUID'
		,	ISNULL(clt.FirstName,@FirstName) AS 'FirstName'
		,	ISNULL(clt.LastName,@LastName) AS 'LastName'
		,	clt.Address1 AS 'ClientAddress1'
		,	clt.Address2 AS 'ClientAddress2'
		,	clt.City AS 'ClientCity'
		,	st_clt.StateDescriptionShort AS 'ClientStateDescriptionShort'
		,	clt.PostalCode AS 'ClientPostalCode'
		,   (SELECT TOP 1 LEFT(PhoneNumber,3) + '-' + SUBSTRING(PhoneNumber,4,3)  + '-' + RIGHT(PhoneNumber,4) FROM datClientPhone WHERE ClientGUID = clt.ClientGUID ORDER BY ClientPhoneSortOrder) as 'ClientPhone1'
		,	CASE WHEN epj.EmployeePositionID = 4 THEN e.FirstName ELSE NULL END AS 'EmployeeFirstName'
		,	CASE WHEN epj.EmployeePositionID = 4 THEN e.LastName ELSE NULL END AS 'EmployeeLastName'
		,	CASE WHEN epj.EmployeePositionID = 4 THEN e.UserLogin ELSE NULL END AS 'UserLogin'
		,	ISNULL(ce.CenterDescriptionFullCalc, '') AS 'CenterDescriptionFullCalc'
		,	ISNULL(ce.CenterDescription, '') AS 'CenterDescription'
		,	ISNULL(ce.Address1, '') AS 'Address1'
		,	ISNULL(ce.Address2, '') AS 'Address2'
		,	ISNULL(ce.City, '') AS 'City'
		,	ISNULL(ce.StateID, '') AS 'StateID'
		,	ISNULL(st.StateDescriptionShort, '') AS 'StateDescriptionShort'
		,	ISNULL(ce.PostalCode, '') AS 'PostalCode'
		,	ISNULL(ce.Phone1, '') AS 'Phone1'
		,	ISNULL(cCenter.CenterDescriptionFullCalc, '') AS 'ClientHomeCenterDescriptionFullCalc'
		,	ISNULL(ap.AppointmentDate, '') AS 'AppointmentDate'
		,	ISNULL(ap.ApptTime, '') AS 'ApptTime'
		,   NULL
		,   NULL
		,   NULL
		,   NULL
		,   NULL
		,   NULL
		,   NULL
		,   NULL
		,   NULL
		,   NULL
		,   NULL
		,   NULL
		,   NULL
		,   NULL
		,   NULL
		,   NULL
		,   NULL
		,   NULL
		,   NULL


	FROM
	(SELECT app.AppointmentDate
		,	app.AppointmentGUID
		,	app.ClientGUID
		,	app.StartTime
		,	app.CenterID
		,	app.ClientHomeCenterID
		,	app.OnContactActivityID
		,	app.OnContactContactID
		,	LTRIM(RIGHT(CONVERT(VARCHAR(25), app.StartTime, 100), 7)) AS 'ApptTime'
		,	ROW_NUMBER() OVER(PARTITION BY ClientGUID ORDER BY AppointmentDate DESC) CMRANK
		FROM dbo.datAppointment app
		WHERE AppointmentGUID = @AppointmentGUID
		) ap
	LEFT JOIN dbo.datAppointmentEmployee ae
		ON ae.AppointmentGUID = ap.AppointmentGUID
	LEFT JOIN datEmployee e
		ON e.EmployeeGUID = ae.EmployeeGUID
	LEFT JOIN dbo.cfgEmployeePositionJoin epj
		ON ae.EmployeeGUID = epj.EmployeeGUID
	LEFT JOIN dbo.lkpEmployeePosition ep
		ON epj.EmployeePositionID = ep.EmployeePositionID
	LEFT JOIN datClient clt
		ON clt.ClientGUID = ap.ClientGUID
	LEFT JOIN cfgCenter ce
		ON ce.CenterID = ap.CenterID
	LEFT JOIN cfgCenter cCenter
		ON ap.ClientHomeCenterID = cCenter.CenterID
	LEFT JOIN lkpState st
		ON st.StateID = ce.StateID
	LEFT JOIN lkpState st_clt
		ON ce.StateID = st_clt.StateID
	WHERE CMRANK = 1
		AND ap.AppointmentGUID = @AppointmentGUID


UNION

		SELECT	NULL AS 'Comparative1'
		,	2 AS 'Comparative2'
		,	NULL AS 'AppointmentGUID'
		,	NULL AS 'ClientGUID'
		,	NULL AS 'FirstName'
		,	NULL AS 'LastName'
		,	NULL AS 'ClientAddress1'
		,	NULL AS 'ClientAddress2'
		,	NULL AS 'ClientCity'
		,	NULL AS 'ClientStateDescriptionShort'
		,	NULL AS 'ClientPostalCode'
		,	NULL AS 'ClientPhone1'
		,	NULL AS 'EmployeeFirstName'
		,	NULL AS 'EmployeeLastName'
		,	NULL AS 'UserLogin'
		,	NULL AS 'CenterDescriptionFullCalc'
		,	NULL AS 'CenterDescription'
		,	NULL AS 'Address1'
		,	NULL AS 'Address2'
		,	NULL AS 'City'
		,	NULL AS 'StateID'
		,	NULL AS 'StateDescriptionShort'
		,	NULL AS 'PostalCode'
		,	NULL AS 'Phone1'
		,	NULL AS 'ClientHomeCenterDescriptionFullCalc'
		,	NULL AS 'AppointmentDate'
		,	NULL AS 'ApptTime'
		,	ap.AppointmentGUID AS 'AppointmentGUID2'
		,	ap.ClientGUID  AS 'ClientGUID2'
		,	ISNULL(clt.FirstName,@FirstName) AS 'FirstName2'
		,	ISNULL(clt.LastName,@LastName) AS 'LastName2'
		,	CASE WHEN epj.EmployeePositionID = 4 THEN e.FirstName ELSE NULL END AS 'EmployeeFirstName2'
		,	CASE WHEN epj.EmployeePositionID = 4 THEN e.LastName ELSE NULL END AS 'EmployeeLastName2'
		,	CASE WHEN epj.EmployeePositionID = 4 THEN e.UserLogin ELSE NULL END AS 'UserLogin2'
		,	ISNULL(ce.CenterDescriptionFullCalc, '') AS 'CenterDescriptionFullCalc2'
		,	ISNULL(ce.CenterDescription, '') AS 'CenterDescription2'
		,	ISNULL(ce.Address1, '') AS 'Address1_2'
		,	ISNULL(ce.Address2, '') AS 'Address2_2'
		,	ISNULL(ce.City, '') AS 'City2'
		,	ISNULL(ce.StateID, '') AS 'StateID2'
		,	ISNULL(st.StateDescriptionShort, '') AS 'StateDescriptionShort2'
		,	ISNULL(ce.PostalCode, '') AS 'PostalCode2'
		,	ISNULL(ce.Phone1, '') AS 'Phone1_2'
		,	ISNULL(cCenter.CenterDescriptionFullCalc, '') AS 'ClientHomeCenterDescriptionFullCalc2'
		,	ISNULL(ap.AppointmentDate, '') AS 'AppointmentDate2'
		,	ISNULL(ap.ApptTime, '') AS 'ApptTime2'

	FROM (
		SELECT app.AppointmentDate
		,	app.AppointmentGUID
		,	app.ClientGUID
		,	app.StartTime
		,	app.CenterID
		,	app.ClientHomeCenterID
		,	app.OnContactActivityID
		,	app.OnContactContactID
		,	LTRIM(RIGHT(CONVERT(VARCHAR(25), app.StartTime, 100), 7)) AS 'ApptTime'
		,	ROW_NUMBER() OVER(PARTITION BY ClientGUID ORDER BY AppointmentDate DESC) CMRANK
		FROM dbo.datAppointment app
		WHERE AppointmentGUID = @AppointmentGUID2
		) ap
	LEFT JOIN dbo.datAppointmentEmployee ae
		ON ae.AppointmentGUID = ap.AppointmentGUID
	LEFT JOIN datEmployee e
		ON e.EmployeeGUID = ae.EmployeeGUID
	LEFT JOIN dbo.cfgEmployeePositionJoin epj
		ON ae.EmployeeGUID = epj.EmployeeGUID
	LEFT JOIN dbo.lkpEmployeePosition ep
		ON epj.EmployeePositionID = ep.EmployeePositionID
	LEFT JOIN datClient clt
		ON clt.ClientGUID = ap.ClientGUID
	LEFT JOIN cfgCenter ce
		ON ce.CenterID = ap.CenterID
	LEFT JOIN cfgCenter cCenter
		ON ap.ClientHomeCenterID = cCenter.CenterID
	LEFT JOIN lkpState st
		ON st.StateID = ce.StateID
	LEFT JOIN lkpState st_clt
		ON ce.StateID = st_clt.StateID
	WHERE CMRANK = 1
		AND ap.AppointmentGUID = @AppointmentGUID2


	/*******************************Go to OnContact and get the First Name, Last Name and notes from the LEAD data is there is none ****************************/

	--DECLARE @OnContactContactID NCHAR(10)
	--DECLARE @OnContactContactID2 NCHAR(10)

	--SET @OnContactContactID = (SELECT OnContactContactID FROM datAppointment
	--							WHERE AppointmentGUID = @AppointmentGUID)

	--SET @OnContactContactID2 = (SELECT OnContactContactID FROM datAppointment
	--							WHERE AppointmentGUID = @AppointmentGUID2)

	--PRINT @OnContactContactID
	--PRINT @OnContactContactID2

	--SELECT * FROM #oncontact

	----Comparative 1
	--IF (SELECT TOP 1 FirstName FROM #appt WHERE Comparative1 = 1) IS NULL
	--BEGIN
	--	UPDATE #appt
	--	SET #appt.FirstName = #oncontact.firstname
	--	,	#appt.LastName = #oncontact.lastname
	--	FROM #oncontact
	--	WHERE Comparative1 = 1

	--END

	----Comparative 2
	--IF (SELECT TOP 1 FirstName2 FROM #appt WHERE Comparative2 = 2) IS NULL
	--BEGIN
	--	UPDATE #appt
	--	SET #appt.FirstName2 = #oncontact.firstname2
	--	,	#appt.LastName2 = #oncontact.lastname2
	--	FROM #oncontact
	--	WHERE Comparative2 = 2

	--END

	/**************************UPDATE with the Latest Consultant if there is no consultant ********************************************************/

	UPDATE #appt
	SET #appt.UserLogin = E.UserLogin
	,	#appt.EmployeeFirstName = E.FirstName
	,	#appt.EmployeeLastName = E.LastName
	FROM datClientDemographic CD
	INNER JOIN dbo.datEmployee E
		ON CD.LastConsultantGUID = E.EmployeeGUID
	WHERE CD.ClientGUID IN (SELECT ClientGUID FROM dbo.datAppointment WHERE AppointmentGUID = @AppointmentGUID)
	AND #appt.UserLogin IS NULL


	UPDATE #appt
	SET #appt.UserLogin2 = E.UserLogin
	,	#appt.EmployeeFirstName2 = E.FirstName
	,	#appt.EmployeeLastName2 = E.LastName
	FROM datClientDemographic CD
	INNER JOIN dbo.datEmployee E
		ON CD.LastConsultantGUID = E.EmployeeGUID
	WHERE CD.ClientGUID IN (SELECT ClientGUID FROM dbo.datAppointment WHERE AppointmentGUID = @AppointmentGUID2)
		AND #appt.UserLogin2 IS NULL


	/**************************UPDATE with the Manager if there is no consultant ********************************************************/

	DECLARE @CenterID INT
	SET @CenterID = (SELECT CenterID FROM dbo.datAppointment WHERE AppointmentGUID = @AppointmentGUID)

	UPDATE #appt
	SET #appt.EmployeeFirstName = emp.FirstName
		,	#appt.EmployeeLastName = emp.LastName
		,	#appt.UserLogin = emp.UserLogin
	FROM datEmployee emp
	INNER JOIN cfgEmployeePositionJoin epj
		ON emp.EmployeeGUID = epj.EmployeeGUID
	INNER JOIN lkpEmployeePosition ep
		ON epj.EmployeePositionID = ep.EmployeePositionID
	WHERE ep.EmployeePositionDescription = 'Manager'
	AND emp.CenterID = @CenterID
	AND emp.IsActiveFlag = 1
	AND #appt.UserLogin IS NULL

	DECLARE @CenterID2 INT
	SET @CenterID2 = (SELECT CenterID FROM dbo.datAppointment WHERE AppointmentGUID = @AppointmentGUID2)

	UPDATE #appt
	SET #appt.EmployeeFirstName2 = emp.FirstName
		,	#appt.EmployeeLastName2 = emp.LastName
		,	#appt.UserLogin2 = emp.UserLogin
	FROM datEmployee emp
	INNER JOIN cfgEmployeePositionJoin epj
		ON emp.EmployeeGUID = epj.EmployeeGUID
	INNER JOIN lkpEmployeePosition ep
		ON epj.EmployeePositionID = ep.EmployeePositionID
	WHERE ep.EmployeePositionDescription = 'Manager'
	AND emp.CenterID = @CenterID2
	AND emp.IsActiveFlag = 1
	AND #appt.UserLogin2 IS NULL

	/***********************SELECT * FROM #appt*******************************************************************************************/

	SELECT * FROM
		(SELECT Comparative1 = (SELECT TOP 1 Comparative1 FROM #appt WHERE Comparative1 IS NOT NULL)
		,	Comparative2 = (SELECT TOP 1 Comparative2 FROM #appt WHERE Comparative2 IS NOT NULL)
		,	AppointmentGUID = (SELECT TOP 1 AppointmentGUID FROM #appt WHERE AppointmentGUID IS NOT NULL)
		,	ClientGUID = (SELECT TOP 1 ClientGUID FROM #appt WHERE ClientGUID IS NOT NULL)
		,	FirstName = (SELECT TOP 1 FirstName FROM #appt WHERE FirstName IS NOT NULL)
		,	LastName = (SELECT TOP 1 LastName FROM #appt WHERE LastName IS NOT NULL)
		,	ClientAddress1 = (SELECT TOP 1 ClientAddress1 FROM #appt WHERE ClientAddress1 IS NOT NULL)
		,	ClientAddress2 = (SELECT TOP 1 ClientAddress2 FROM #appt WHERE ClientAddress2 IS NOT NULL)
		,	ClientCity = (SELECT TOP 1 ClientCity FROM #appt WHERE ClientCity IS NOT NULL)
		,	ClientStateDescriptionShort = (SELECT TOP 1 ClientStateDescriptionShort FROM #appt WHERE ClientStateDescriptionShort IS NOT NULL)
		,	ClientPostalCode = (SELECT TOP 1 ClientPostalCode FROM #appt WHERE ClientPostalCode IS NOT NULL)
		,	ClientPhone1 = (SELECT TOP 1 ClientPhone1 FROM #appt WHERE ClientPhone1 IS NOT NULL)
		   , EmployeeFirstName = (SELECT TOP 1 EmployeeFirstName FROM #appt WHERE EmployeeFirstName IS NOT NULL)
		   , EmployeeLastName = (SELECT TOP 1 EmployeeLastName FROM #appt WHERE EmployeeLastName IS NOT NULL)
		   , UserLogin = (SELECT TOP 1 UserLogin FROM #appt WHERE UserLogin IS NOT NULL)
		   , CenterDescriptionFullCalc = (SELECT TOP 1 CenterDescriptionFullCalc FROM #appt WHERE CenterDescriptionFullCalc IS NOT NULL)
		   , CenterDescription = (SELECT TOP 1 CenterDescription FROM #appt WHERE CenterDescription IS NOT NULL)
		   , Address1 = (SELECT TOP 1 Address1 FROM #appt WHERE Address1 IS NOT NULL)
		   , Address2 = (SELECT TOP 1 Address2 FROM #appt WHERE Address2 IS NOT NULL)
		   , City = (SELECT TOP 1 City FROM #appt WHERE City IS NOT NULL)
		   , StateID = (SELECT TOP 1 StateID FROM #appt WHERE StateID IS NOT NULL)
		   , StateDescriptionShort = (SELECT TOP 1 StateDescriptionShort FROM #appt WHERE StateDescriptionShort IS NOT NULL)
		   , PostalCode = (SELECT TOP 1 PostalCode FROM #appt WHERE PostalCode IS NOT NULL)
		   , Phone1 = (SELECT TOP 1 Phone1 FROM #appt WHERE Phone1 IS NOT NULL)
		   , ClientHomeCenterDescriptionFullCalc = (SELECT TOP 1 ClientHomeCenterDescriptionFullCalc FROM #appt WHERE ClientHomeCenterDescriptionFullCalc IS NOT NULL)
		   , AppointmentDate = (SELECT TOP 1 AppointmentDate FROM #appt WHERE AppointmentDate IS NOT NULL)
		   , ApptTime = (SELECT TOP 1 ApptTime FROM #appt WHERE ApptTime IS NOT NULL)
		   , AppointmentGUID2 = (SELECT TOP 1 AppointmentGUID2 FROM #appt WHERE AppointmentGUID2 IS NOT NULL)
		   , ClientGUID2 = (SELECT TOP 1 ClientGUID2 FROM #appt WHERE ClientGUID2 IS NOT NULL)
		   , FirstName2 = (SELECT TOP 1 FirstName2 FROM #appt WHERE FirstName2 IS NOT NULL)
		   , LastName2 = (SELECT TOP 1 LastName2 FROM #appt WHERE LastName2 IS NOT NULL)
		   , EmployeeFirstName2 = (SELECT TOP 1 EmployeeFirstName2 FROM #appt WHERE EmployeeFirstName2 IS NOT NULL)
		   , EmployeeLastName2 = (SELECT TOP 1 EmployeeLastName2 FROM #appt WHERE EmployeeLastName2 IS NOT NULL)
		   , UserLogin2 = (SELECT TOP 1 UserLogin2 FROM #appt WHERE UserLogin2 IS NOT NULL)
		   , CenterDescriptionFullCalc2 = (SELECT TOP 1 CenterDescriptionFullCalc2 FROM #appt WHERE CenterDescriptionFullCalc2 IS NOT NULL)
		   , CenterDescription2 = (SELECT TOP 1 CenterDescription2 FROM #appt WHERE CenterDescription2 IS NOT NULL)
		   , Address1_2 = (SELECT TOP 1 Address1_2 FROM #appt WHERE Address1_2 IS NOT NULL)
		   , Address2_2 = (SELECT TOP 1 Address2_2 FROM #appt WHERE Address2_2 IS NOT NULL)
		   , City2 = (SELECT TOP 1 City2 FROM #appt WHERE City2 IS NOT NULL)
		   , StateID2 = (SELECT TOP 1 StateID2 FROM #appt WHERE StateID2 IS NOT NULL)
		   , StateDescriptionShort2 = (SELECT TOP 1 StateDescriptionShort2 FROM #appt WHERE StateDescriptionShort2 IS NOT NULL)
		   , PostalCode2 = (SELECT TOP 1 PostalCode2 FROM #appt WHERE PostalCode2 IS NOT NULL)
		   , Phone1_2 = (SELECT TOP 1 Phone1_2 FROM #appt WHERE Phone1_2 IS NOT NULL)
		   , ClientHomeCenterDescriptionFullCalc2 = (SELECT TOP 1 ClientHomeCenterDescriptionFullCalc2 FROM #appt WHERE ClientHomeCenterDescriptionFullCalc2 IS NOT NULL)
		   , AppointmentDate2 = (SELECT TOP 1 AppointmentDate2 FROM #appt WHERE AppointmentDate2 IS NOT NULL)
		   , ApptTime2 = (SELECT TOP 1 ApptTime2 FROM #appt WHERE ApptTime2 IS NOT NULL)

		   FROM #appt) q
	   GROUP BY Comparative1
		,	Comparative2
		,	AppointmentGUID
       , ClientGUID
       , FirstName
       , LastName
	   ,	ClientAddress1
		,	ClientAddress2
		,	ClientCity
		,	ClientStateDescriptionShort
		,	ClientPostalCode
		,	ClientPhone1
		, EmployeeFirstName
       , EmployeeLastName
       , UserLogin
       , CenterDescriptionFullCalc
       , CenterDescription
       , Address1
       , Address2
       , City
       , StateID
       , StateDescriptionShort
       , PostalCode
       , Phone1
       , ClientHomeCenterDescriptionFullCalc
       , AppointmentDate
       , ApptTime
       , AppointmentGUID2
       , ClientGUID2
       , FirstName2
       , LastName2
       , EmployeeFirstName2
       , EmployeeLastName2
       , UserLogin2
       , CenterDescriptionFullCalc2
       , CenterDescription2
       , Address1_2
       , Address2_2
       , City2
       , StateID2
       , StateDescriptionShort2
       , PostalCode2
       , Phone1_2
       , ClientHomeCenterDescriptionFullCalc2
       , AppointmentDate2
       , ApptTime2

END
GO
