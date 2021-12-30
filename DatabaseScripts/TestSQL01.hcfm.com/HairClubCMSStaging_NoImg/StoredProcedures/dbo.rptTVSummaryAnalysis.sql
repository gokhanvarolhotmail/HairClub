/* CreateDate: 09/17/2014 16:18:52.333 , ModifyDate: 11/04/2019 08:17:08.810 */
GO
/*===============================================================================================
 Procedure Name:            rptTVSummaryAnalysis
 Procedure Description:     This stored procedure provides the header information for the rptTVSummaryAnalysis.rdl
 Created By:				Rachelen Hut
 Date Created:              05/12/2014
 Destination Server:        HairclubCMS
 Related Application:       Conect
================================================================================================
Change History:
06/03/2014	RH	Changed the OPENQUERY to use synonym table names.
09/17/2014	RH	Changed rptTrichoViewComparativeAnalysis to rptTVSummaryAnalysis.
11/17/2014	RH	Changed to only report the consultant for the appointment. (WO#108652)
11/25/2014	RH	Added code to find the Center Manager if the consultant is null. (WO#109052)
1/2/2014	RH	Changed code to update statements to find the Latest Consultant and Manager (WO#110163)
1/20/2015	RH	Added WHERE #appt.LastName IS NULL to UPDATE statement for client (WO#110776)
10/30/2017	RH	Added parameters @FirstName and @LastName (per Salesforce integration)
10/02/2019  SL	Updated to removed commented out code that is referencing OnContact and synonyms
						being deleted (TFS #13144)
================================================================================================
Sample Execution:

EXEC rptTVSummaryAnalysis 'C2190326-4F53-4B4A-8C31-E2E759881B1A','Thomas','Vilardo'


EXEC rptTVSummaryAnalysis '85A9D1C5-8E51-4AFA-93F5-53501B0AE3C0','Orabe','Eliazar'  -- in 239 - Winnipeg

================================================================================================*/

CREATE PROCEDURE [dbo].[rptTVSummaryAnalysis]
	(@AppointmentGUID UNIQUEIDENTIFIER
	,	@FirstName NVARCHAR(50)
	,	@LastName NVARCHAR(50)
	)

AS
BEGIN

/***************Create temp tables ***************************************************************/

--CREATE TABLE #oncontact
--(first_name NVARCHAR(50)
--, last_name  NVARCHAR(50)
--)

CREATE TABLE #appt
(	AppointmentGUID UNIQUEIDENTIFIER
	,	ClientGUID UNIQUEIDENTIFIER
	,	FirstName NVARCHAR(50)
	,	LastName NVARCHAR(50)
	,	Stylist NVARCHAR(100)
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
	,	AppointmentDate DATE
	,	ApptTime NVARCHAR(8)
	)

/*******************************Go to OnContact and get the First Name, Last Name and notes if they are not in the Client table****************************/

DECLARE @SQL NVARCHAR(MAX)
DECLARE @OnContactContactID NCHAR(10)

SET @OnContactContactID = (SELECT OnContactContactID FROM datAppointment
WHERE AppointmentGUID = @AppointmentGUID)

--PRINT @OnContactContactID

	/***************************Main Select Statement******************************************************************/
	INSERT INTO #appt
	SELECT	TOP 1 ap.AppointmentGUID AS 'AppointmentGUID'
		,	ap.ClientGUID  AS 'ClientGUID'
		,	ISNULL(clt.FirstName,@FirstName) AS 'FirstName'
		,	ISNULL(clt.LastName,@LastName) AS 'LastName'
		,	ISNULL(e.EmployeeFullNameCalc, '') AS 'Stylist'
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
		,	ISNULL(LTRIM(RTRIM(ce.Phone1)), '') AS 'Phone1'
		,	ISNULL(cCenter.CenterDescriptionFullCalc, '') AS 'ClientHomeCenterDescriptionFullCalc'
		,	ISNULL(ap.AppointmentDate, '') AS 'AppointmentDate'
		,	ISNULL(ap.ApptTime, '') AS 'ApptTime'

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
	WHERE CMRANK = 1
		AND ap.AppointmentGUID = @AppointmentGUID
	ORDER BY e.EmployeeFullNameCalc, ap.StartTime

		--SELECT * FROM #appt

	/************ Find the latest consultant for the client if the consultant is not on this appointment *****************/

	UPDATE #appt
	SET #appt.UserLogin = E.UserLogin
	,	#appt.EmployeeFirstName = E.FirstName
	,	#appt.EmployeeLastName = E.LastName
	FROM datClientDemographic CD
	INNER JOIN dbo.datEmployee E
		ON CD.LastConsultantGUID = E.EmployeeGUID
	WHERE CD.ClientGUID IN (SELECT ClientGUID FROM dbo.datAppointment WHERE AppointmentGUID = @AppointmentGUID)
	AND #appt.UserLogin IS NULL

		--SELECT * FROM #appt


	/**  If UserLogin is still NULL Update the contact person to the TOP 1 Managing Director *************/

	IF (SELECT UserLogin FROM #appt) IS NULL
	BEGIN
		DECLARE @CenterID INT
		SET @CenterID = (SELECT CenterID FROM dbo.datAppointment WHERE AppointmentGUID = @AppointmentGUID)

		CREATE TABLE #manager(FirstName NVARCHAR(50)
			,	LastName NVARCHAR(50)
			,	UserLogin NVARCHAR(50)
			,	EmployeePositionDescription NVARCHAR(100)
			,	CenterID INT)

		INSERT INTO #manager
		SELECT TOP 1 e.FirstName
			,	e.LastName
			,	e.UserLogin
			,	ep.EmployeePositionDescription
			,	e.CenterID
		FROM datEmployee e
		INNER JOIN cfgEmployeePositionJoin epj
			ON e.EmployeeGUID = epj.EmployeeGUID
		INNER JOIN lkpEmployeePosition ep
			ON epj.EmployeePositionID = ep.EmployeePositionID
		WHERE ep.EmployeePositionDescription = 'Manager'
		AND CenterID = @CenterID
		AND e.IsActiveFlag = 1
		ORDER BY LastName

		UPDATE #appt
		SET #appt.EmployeeFirstName = #manager.FirstName,
		#appt.EmployeeLastName = #manager.LastName,
		#appt.UserLogin = #manager.UserLogin
		FROM #manager
		WHERE #appt.UserLogin IS NULL

	END


	/********** Final Select ********************************************************************************/

	SELECT * FROM #appt


END
GO
