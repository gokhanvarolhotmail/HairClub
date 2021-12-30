/* CreateDate: 08/10/2006 13:53:10.467 , ModifyDate: 01/25/2010 08:11:31.823 */
GO
-- =============================================
-- INSERTS A CLOSING RECORD FROM THE WEB INTERFACE
-- =============================================
CREATE  PROCEDURE spapp_Insert_CenterClosing
	@center int,
	@closedate char(10),
	@fromtime char(5),
	@totime char(5)

AS
	INSERT INTO dbo.Appointments_Special_Closings(
	Center,
	CloseDate,
	FromTime,
	ToTime,
	Active
	)
	VALUES(
	@center,
	CONVERT(char(10), CAST(@closedate AS DATETIME),101),
	@fromtime,
	@totime,
	1
	)
GO
