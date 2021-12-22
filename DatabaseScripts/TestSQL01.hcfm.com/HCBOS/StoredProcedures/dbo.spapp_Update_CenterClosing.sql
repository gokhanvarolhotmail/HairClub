/* CreateDate: 08/10/2006 13:53:12.327 , ModifyDate: 01/25/2010 08:11:31.730 */
GO
CREATE  PROCEDURE dbo.spapp_Update_CenterClosing
	@closingID integer,
	@closedate char(10),
	@fromtime char(5),
	@totime char(5),
	@active bit
AS
	UPDATE dbo.Appointments_Special_Closings
	SET 	CloseDate = CONVERT(char(10), CAST(@closedate AS DATETIME),101)
	,	fromtime = @fromtime
	,	totime = @totime
	,	active = @active
	WHERE closingID = @closingID
GO
