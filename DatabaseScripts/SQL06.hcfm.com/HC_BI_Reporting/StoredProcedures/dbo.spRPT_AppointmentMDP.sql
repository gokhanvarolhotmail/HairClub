/* CreateDate: 10/03/2019 07:13:33.177 , ModifyDate: 10/17/2019 09:33:00.687 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				[spRPT_AppointmentMDP]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					James Lee
------------------------------------------------------------------------
NOTES:
------------------------------------------------------------------------
CHANGE HISTORY:
09/30/2019 - JL - (TrackIT#13169) Create Procedure
10/17/2019 - JL - (TrackIT#13247) Include all center - original request was only for Delray Beach
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRPT_AppointmentMDP] '1080'
***********************************************************************/
CREATE PROCEDURE [dbo].[spRPT_AppointmentMDP]
(
	@Center VARCHAR(50)
)
AS
	SET NOCOUNT ON


select AppointmentDate,
	   LTRIM(RIGHT(CONVERT(varchar, StartTime, 100),7)) AS StartTime,  --convert military time
	   LTRIM(RIGHT(CONVERT(varchar, EndTime, 100),7))   AS EndTime,    --convert military time
	   Duration,
	   CenterID,
	   CenterDescriptionFullCalc,
	   FirstName,
	   LastName,
	   ClientFullNameAltCalc,
	   Phone,
	   ContractPaidAmount,
	   Balance

from   vwAppointments
where  salescodedescription in ('Restorative Service','Restorative Service - Initial','RestorInk Service') and
	   --centerid = @Center  and
	   AppointmentDate between GETDATE() and DATEADD(week,1,GETDATE())
order by CenterDescriptionFullCalc, LTRIM(RIGHT(CONVERT(varchar, StartTime, 100),7)), LastName
GO
