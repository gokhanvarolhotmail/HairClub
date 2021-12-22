/* CreateDate: 11/12/2019 09:41:16.173 , ModifyDate: 04/30/2020 11:16:20.467 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spDB_PopulateTrackItData
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Dashboard
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		10/22/2019
DESCRIPTION:			Gets TrackIt Ticket Data from HCSQL7
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spDB_PopulateTrackItData
***********************************************************************/
CREATE PROCEDURE [dbo].[spDB_PopulateTrackItData]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME
DECLARE	@Period DATETIME
DECLARE @PeriodEndDate DATETIME


SET @StartDate = DATEADD(YEAR, DATEDIFF(YEAR, 0, CURRENT_TIMESTAMP), 0)
SET @EndDate = CAST(GETDATE() AS DATE)
SET @Period = DATETIMEFROMPARTS(YEAR(@EndDate), MONTH(@EndDate), 1, 0, 0, 0, 0)
SET @PeriodEndDate = DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, @Period) + 1, 0))


TRUNCATE TABLE dbTicket


INSERT	INTO dbTicket
		SELECT	t.[Ticket ID]
		,		CASE WHEN ( t.Status NOT IN ( 'Closed', 'Canceled' ) AND t.[Open Date & Time] < @Period ) OR ( t.[Close Date & Time] BETWEEN @Period AND @PeriodEndDate ) THEN @Period ELSE t.[Open Date & Time] END AS '[Open Date & Time]'
		,		CASE WHEN ( t.Status NOT IN ( 'Closed', 'Canceled' ) AND t.[Due Date & Time] < @Period ) OR ( t.[Close Date & Time] BETWEEN @Period AND @PeriodEndDate ) THEN @Period ELSE t.[Due Date & Time] END AS '[Due Date & Time]'
		,		t.Requestor
		,		t.Location
		,		t.Department
		,		t.[Assigned To Technician]
		,		t.[Group]
		,		t.[Ticket Summary]
		,		t.[Additional Information]
		,		t.Category
		,		t.[Category Full Path]
		,		t.Priority
		,		t.[Close Date & Time]
		,		CASE WHEN t.Status NOT IN ( 'Closed', 'Canceled' ) THEN 'Open' ELSE 'Closed' END AS 'Status'
		,		o_Tn.Note
		,		CASE WHEN t.Status = 'Closed' AND t.[Close Date & Time] < t.[Due Date & Time] THEN 1 ELSE 0 END AS 'IsClosedBeforeDueDate'
		FROM	HCSQL7.[Track-It]._SMDBA_.Ticket t
				OUTER APPLY (
					SELECT	TOP 1
							tn.Note
					FROM	HCSQL7.[Track-It]._SMDBA_.[Ticket Notes] tn
					WHERE	tn.[Ticket ID] = t.[Ticket ID]
							AND ISNULL(tn.NoteExists, 0) = 1
							AND tn.[Note Type] IN ( 'Technician Note', 'Ticket Resolution' )
					ORDER BY tn.LastModified DESC
				) o_Tn
		WHERE	( t.[Open Date & Time] BETWEEN @StartDate AND @EndDate + ' 23:59:59'
					OR t.[Close Date & Time] BETWEEN @StartDate AND @EndDate + ' 23:59:59'
					OR ( t.Status NOT IN ( 'Closed', 'Canceled' ) AND t.[Close Date & Time] IS NULL ) )
		ORDER BY t.[Open Date & Time]


END
GO
