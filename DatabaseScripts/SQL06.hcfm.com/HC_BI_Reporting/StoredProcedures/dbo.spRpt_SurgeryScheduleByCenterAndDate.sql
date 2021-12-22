/*===============================================================================================
-- Procedure Name:			spRpt_SurgeryScheduleByCenterAndDate
-- Procedure Description:
--
-- Created By:				Dominic Leiba
-- Implemented By:			Marlon Burrell
-- Last Modified By:		Kevin Murdoch
--
-- Date Created:			4/24/2009
-- Date Implemented:		4/24/2009
-- Date Last Modified:		07/11/11
--
-- Destination Server:		SQL06
-- Destination Database:	HC_BI_Reporting
-- Related Application:		Surgery Schedule Report
--
-- ----------------------------------------------------------------------------------------------
-- Notes:
--
-- 05/07/2009 - DL	--> Changed [AppointmentDate] column format to MM/DD/YYY
-- 07/11/2011 - KM  --> Modified report to come from new BI environment
-- ----------------------------------------------------------------------------------------------
--
Sample Execution:
--
EXEC spRpt_SurgeryScheduleByCenterAndDate 301, '4/1/2011', '4/30/2011'
================================================================================================*/
CREATE PROCEDURE [dbo].[spRpt_SurgeryScheduleByCenterAndDate]
(
	@CenterNumber INT,
	@StartDate DATETIME,
	@EndDate DATETIME
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT  CAST(CONVERT(VARCHAR(11), [AppointmentDate], 101) AS DATETIME) AS 'AppointmentDate'
	,       [StartTime]
	,       [EndTime]
	,       [ClientFullNameAltCalc] AS 'Client'
	,       [SalesCodeDescription] AS 'Description'
	,       [Duration]
	,       [MembershipDescription] AS 'Membership'
	,       [Grafts]
	,       [Balance]
	--,       [OptionToMaximize]
	,       CASE WHEN [CheckInTime] IS NULL THEN ''
				 ELSE '*'
			END AS 'CheckedIn'
	,       CASE WHEN [CheckOutTime] IS NULL THEN ''
				 ELSE '*'
			END AS 'CheckedOut'
	FROM    [vwAppointments]
	WHERE   [CenterID] = @CenterNumber
			AND [AppointmentDate] BETWEEN @StartDate AND @EndDate
	ORDER BY [AppointmentDate]
	,       [StartTime]
END
