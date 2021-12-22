/*===============================================================================================
-- Procedure Name:			rptRegisterCash
-- Procedure Description:
--
-- Created By:				Rachelen Hut
-- Implemented By:			Rachelen Hut
-- Last Modified By:
--
-- Date Created:			01/23/2014
-- Destination Server:		SQL01
-- Destination Database:	HairClubCMS
-- Related Application:		Conect
--------------------------------------------------------------------------------------------------------
NOTES:

--------------------------------------------------------------------------------------------------------
Sample Execution:
EXEC [rptRegisterCash] 849, '1/15/2014'

================================================================================================*/
CREATE PROCEDURE [dbo].[rptRegisterCash]
(
	@CenterID INT,
	@EndOfDayDate DATETIME
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	SELECT TOP 1 C.CenterDescriptionFullCalc
	,	rl.RegisterID
	,	EOD.EndOfDayDate
	,	RC.HundredCount
	,	RC.FiftyCount
	,	RC.TwentyCount
	,	RC.TenCount
	,	RC.FiveCount
	,	RC.OneCount
	,	RC.DollarCount
	,	RC.HalfDollarCount
	,	RC.QuarterCount
	,	RC.DimeCount
	,	RC.NickelCount
	,	RC.PennyCount
	,	RC.LastUpdate
	,	RC.LastUpdateUser
	,	CAST((RC.HundredCount*100
		+	RC.FiftyCount*50
		+	RC.TwentyCount*20
		+	RC.TenCount*10
		+	RC.FiveCount*5
		+	RC.OneCount*1  -- Paper Dollar
		+	RC.DollarCount*1 -- Coin Dollar
		+	RC.HalfDollarCount*.5
		+	RC.QuarterCount*.25
		+	RC.DimeCount*.10
		+	RC.NickelCount*.05
		+	RC.PennyCount*.01) AS MONEY)AS TotalCash
	FROM	 dbo.datRegisterCash RC
	INNER JOIN dbo.datRegisterTender RT
		ON RT.RegisterTenderGUID = RC.RegisterTenderGUID
	INNER JOIN dbo.datRegisterLog RL
		ON RL.RegisterLogGUID = RT.RegisterLogGUID
	INNER JOIN dbo.datEndOfDay EOD
		ON EOD.EndOfDayGUID = RL.EndOfDayGUID
	INNER JOIN dbo.cfgCenter C
		ON EOD.CenterID = C.CenterID
	WHERE RL.EndOfDayGUID IN(SELECT EndOfDayGUID
							FROM	 dbo.datEndOfDay
							WHERE EndOfDayDate = @EndOfDayDate
							AND CenterID = @CenterID)

END
