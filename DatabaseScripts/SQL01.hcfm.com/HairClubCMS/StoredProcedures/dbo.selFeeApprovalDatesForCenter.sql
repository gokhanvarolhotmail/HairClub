/***********************************************************************
PROCEDURE:				[selFeeApprovalDatesForCenter]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				Mike Tovbin
IMPLEMENTOR: 			Mike Tovbin
DATE IMPLEMENTED: 		04/19/2012
LAST REVISION DATE: 	10/02/2012
--------------------------------------------------------------------------------------------------------
NOTES: 	Return process dates for previous, current and next month paycycles.
		04/19/2012 - MT Created Stored Proc
		05/21/2012 - MT Modified the # of days prior to Pay Cycle Date center can approve.
		07/13/2012 - MT Modified the # of days to 6
		09/28/2012 - MT fixed the issue where 4 days were being subtracted from today's date.
		10/02/2012 - MT Updated so that previous pay cycle date is included if it has not been approved and
					it's within "CanApproveDays" buffer.
		11/01/2012 - MLM Fixed Issue when Today's date is the First.
		02/10/2014 - MLM Added cfgCenterFeePayCycle check
		02/22/2021 - AP Fix cyclePay Date when the month is february to prevent errors with day 30 TFS#14826 - 14844

--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [selFeeApprovalDatesForCenter] 825
***********************************************************************/
CREATE PROCEDURE [dbo].[selFeeApprovalDatesForCenter]
	@CenterId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	DECLARE @CanApproveDays as Int
	SET @CanApproveDays = 6  -- Number of days prior to pay cycle date center can approve

	-- create temp table for each EFT profile
	DECLARE @CenterPayCycleDates TABLE
	(
		FeePayCycleId Int NOT NULL,
		FeePayCycleDate Date NOT NULL,
		IsWaitingApproval Bit NOT NULL,
		IsCurrentPayCycle Bit NOT NULL,
		CanApprove Bit NOT NULL
	)

	DECLARE @TodayDate AS Date, @PreviousPayCycleDate AS Date
	SET @TodayDate = CONVERT(Date, GETDATE(), 101)

	-- Determine Previous Pay Cycle Date
	IF (SELECT Count(*) FROM lkpFeePayCycle p inner join cfgCenterFeePayCycle c on c.FeePayCycleID = p.FeePayCycleID WHERE c.CenterID = @CenterId AND p.FeePayCycleValue = DAY(@TodayDate)) > 0
		SET @PreviousPayCycleDate =
				(SELECT TOP(1)
				CASE When MONTH(@TodayDate) = 2 and p.FeePayCycleValue > 28 Then CONVERT(Date, Convert(nvarchar(2), MONTH(DATEADD(MONTH,-1,@TodayDate))) + '/28/' + Convert(nvarchar(4), YEAR(DATEADD(MONTH,-1,@TodayDate))), 101)
				ELSE CONVERT(Date, Convert(nvarchar(2), MONTH(DATEADD(MONTH,-1,@TodayDate))) + '/' + Convert(nvarchar(2), p.FeePayCycleValue) + '/' + Convert(nvarchar(4), YEAR(DATEADD(MONTH,-1,@TodayDate))), 101)
				END

					FROM lkpFeePayCycle p
						inner join cfgCenterFeePayCycle c on p.FeePayCycleID = c.FeePayCycleID
					WHERE p.FeePayCycleValue < DAY(DATEADD(day,-1,@TodayDate))
						AND c.CenterID = @CenterId
					ORDER By p.FeePayCycleValue desc)
	ELSE IF (SELECT Count(*) FROM lkpFeePayCycle p inner join cfgCenterFeePayCycle c on c.FeePayCycleID = p.FeePayCycleID WHERE c.CenterID = @CenterId AND p.FeePayCycleValue < DAY(@TodayDate)) > 0
			SET @PreviousPayCycleDate =
				(SELECT TOP(1)
				CASE When MONTH(@TodayDate) = 2 and p.FeePayCycleValue > 28 Then CONVERT(Date, Convert(nvarchar(2), MONTH(@TodayDate)) + '/28/' + Convert(nvarchar(4), YEAR(@TodayDate)), 101)
				ELSE CONVERT(Date, Convert(nvarchar(2), MONTH(@TodayDate)) + '/' + Convert(nvarchar(2), p.FeePayCycleValue) + '/' + Convert(nvarchar(4), YEAR(@TodayDate)), 101)
				END

					FROM lkpFeePayCycle p
						inner join cfgCenterFeePayCycle c on p.FeePayCycleID = c.FeePayCycleID
					WHERE p.FeePayCycleValue < DAY(@TodayDate)
						AND c.CenterID = @CenterId
					ORDER By p.FeePayCycleValue desc)
	ELSE
		SET @PreviousPayCycleDate =
				(SELECT TOP(1)

				CASE When MONTH(@TodayDate) = 2 and p.FeePayCycleValue > 28 Then CONVERT(Date, Convert(nvarchar(2), MONTH(DATEADD(MONTH,-1,@TodayDate))) + '/28/' + Convert(nvarchar(4), YEAR(DATEADD(MONTH,-1,@TodayDate))), 101)
				ELSE CONVERT(Date, Convert(nvarchar(2), MONTH(DATEADD(MONTH,-1,@TodayDate))) + '/' + Convert(nvarchar(2), p.FeePayCycleValue) + '/' + Convert(nvarchar(4), YEAR(DATEADD(MONTH,-1,@TodayDate))), 101)
				END

					FROM lkpFeePayCycle p
						inner join cfgCenterFeePayCycle c on p.FeePayCycleID = c.FeePayCycleID
					WHERE p.FeePayCycleValue < DAY(@TodayDate)
						AND c.CenterID = @CenterId
					ORDER By p.FeePayCycleValue desc)

	-- Check if Previous Pay Cycle Date is within the "CanApproveDays" buffer and fee batch has not been approved for that date, include in the result
	IF(ABS(DATEDIFF(Day,@TodayDate,@PreviousPayCycleDate)) <= @CanApproveDays)
		INSERT INTO @CenterPayCycleDates (FeePayCycleId, FeePayCycleDate, IsWaitingApproval, IsCurrentPayCycle, CanApprove)
			SELECT TOP(1)
				p.FeePayCycleId,
				CASE When MONTH(@PreviousPayCycleDate) = 2 and p.FeePayCycleValue > 28 Then CONVERT(Date, Convert(nvarchar(2), MONTH(@PreviousPayCycleDate)) + '/28/' + Convert(nvarchar(4), YEAR(@PreviousPayCycleDate)), 101)
				ELSE CONVERT(Date, Convert(nvarchar(2), MONTH(@PreviousPayCycleDate)) + '/' + Convert(nvarchar(2), p.FeePayCycleValue) + '/' + Convert(nvarchar(4), YEAR(@PreviousPayCycleDate)), 101)
				END,

				1, 0, 0
			FROM lkpFeePayCycle p
				 inner join cfgCenterFeePayCycle c on p.FeePayCycleID = c.FeePayCycleID
				LEFT JOIN datCenterFeeBatch cfb ON cfb.FeePayCycleID = p.FeePayCycleID
						AND cfb.CenterId = @CenterId
						AND cfb.FeeMonth = Convert(int, MONTH(@PreviousPayCycleDate))
						AND cfb.FeeYear = Convert(int, YEAR(@PreviousPayCycleDate))
				LEFT JOIN lkpCenterFeeBatchStatus stat ON cfb.CenterFeeBatchStatusId = stat.CenterFeeBatchStatusId
			WHERE p.FeePayCycleValue = DAY(@PreviousPayCycleDate)
				AND (cfb.CenterFeeBatchGUID IS NULL OR stat.CenterFeeBatchStatusDescriptionShort = 'WAITING')
				AND c.centerID = @CenterId



	-- Insert all history records that have not been Exported.
	INSERT INTO @CenterPayCycleDates (FeePayCycleId, FeePayCycleDate, IsWaitingApproval, IsCurrentPayCycle, CanApprove)
		SELECT
			p.FeePayCycleId,
			CASE When b.FeeMonth = 2 and p.FeePayCycleValue > 28 Then CONVERT(Date, Convert(nvarchar(2), b.FeeMonth) + '/28/' + Convert(nvarchar(4), b.FeeYear), 101)
				ELSE CONVERT(Date, Convert(nvarchar(2), b.FeeMonth) + '/' + Convert(nvarchar(2), p.FeePayCycleValue) + '/' + Convert(nvarchar(4), b.FeeYear), 101)
				END,
			CASE WHEN b.ApprovedDate IS NULL THEN 1
				ELSE  0 END,
			0, 0
		FROM datCenterFeeBatch b
			INNER JOIN lkpFeePayCycle p ON b.FeePayCycleId = p.FeePayCycleId
		WHERE b.CenterId = @CenterId AND b.IsExported = 0
			AND
				CASE When b.FeeMonth = 2 and p.FeePayCycleValue > 28 Then CONVERT(Date, Convert(nvarchar(2), b.FeeMonth) + '/28/' + Convert(nvarchar(4), b.FeeYear), 101)
				ELSE CONVERT(Date, Convert(nvarchar(2), b.FeeMonth) + '/' + Convert(nvarchar(2), p.FeePayCycleValue) + '/' + Convert(nvarchar(4), b.FeeYear), 101)
				END < @TodayDate
		Order By b.ApprovedDate desc, b.CreateDate desc



	-- Insert current
	IF (SELECT Count(*) FROM lkpFeePayCycle  p inner join cfgCenterFeePayCycle c on c.FeePayCycleID = p.FeePayCycleID WHERE c.CenterID = @CenterId AND p.FeePayCycleValue >= DAY(@TodayDate)) > 0
		INSERT INTO @CenterPayCycleDates (FeePayCycleId, FeePayCycleDate, IsWaitingApproval, IsCurrentPayCycle, CanApprove)
			SELECT TOP(1)
				p.FeePayCycleId,
				CASE When MONTH(@TodayDate) = 2 and p.FeePayCycleValue > 28 Then CONVERT(Date, Convert(nvarchar(2), MONTH(@TodayDate)) + '/28/' + Convert(nvarchar(4), YEAR(@TodayDate)), 101)
				ELSE CONVERT(Date, Convert(nvarchar(2), MONTH(@TodayDate)) + '/' + Convert(nvarchar(2), p.FeePayCycleValue) + '/' + Convert(nvarchar(4), YEAR(@TodayDate)), 101)
				END,
				1, 1, 0
			FROM lkpFeePayCycle p
				inner join cfgCenterFeePayCycle c on p.FeePayCycleID = c.FeePayCycleID
			WHERE p.FeePayCycleValue >= DAY(@TodayDate)
				AND c.CenterID = @CenterId
			ORDER By p.FeePayCycleValue asc
	ELSE
		INSERT INTO @CenterPayCycleDates (FeePayCycleId, FeePayCycleDate, IsWaitingApproval, IsCurrentPayCycle, CanApprove)
			SELECT TOP(1)
				p.FeePayCycleId,
				CASE When MONTH(@TodayDate) = 2 and p.FeePayCycleValue > 28 Then CONVERT(Date, Convert(nvarchar(2), MONTH(DATEADD(MONTH,1,@TodayDate))) + '/28/' + Convert(nvarchar(4), YEAR(DATEADD(MONTH,1,@TodayDate))), 101)
				ELSE CONVERT(Date, Convert(nvarchar(2), MONTH(DATEADD(MONTH,1,@TodayDate))) + '/' + Convert(nvarchar(2), p.FeePayCycleValue) + '/' + Convert(nvarchar(4), YEAR(DATEADD(MONTH,1,@TodayDate))), 101)
				END,
				1, 1, 0
			FROM lkpFeePayCycle p
				inner join cfgCenterFeePayCycle c on p.FeePayCycleID = c.FeePayCycleID
			WHERE p.FeePayCycleValue > 0
				AND c.CenterID = @CenterId
			ORDER By p.FeePayCycleValue asc


	DECLARE @CurrentPayCycleDate AS Date
	DECLARE @CurrentPayCycleDay AS INT

	SELECT @CurrentPayCycleDate =c.FeePayCycleDate FROM @CenterPayCycleDates c WHERE c.IsCurrentPayCycle = 1

	SET @CurrentPayCycleDay = DAY(@CurrentPayCycleDate)

	IF	MONTH(@CurrentPayCycleDate)= 2 AND DAY(@CurrentPayCycleDate)=28
	    SET @CurrentPayCycleDay = 30

	--Insert Next
	IF (SELECT Count(*) FROM lkpFeePayCycle  p inner join cfgCenterFeePayCycle c on c.FeePayCycleID = p.FeePayCycleID WHERE c.CenterID = @CenterId AND p.FeePayCycleValue > @CurrentPayCycleDay) > 0
		INSERT INTO @CenterPayCycleDates (FeePayCycleId, FeePayCycleDate, IsWaitingApproval, IsCurrentPayCycle, CanApprove)
			SELECT TOP(1)
				p.FeePayCycleId,

				CASE When MONTH(@CurrentPayCycleDate) = 2 and p.FeePayCycleValue > 28 Then CONVERT(Date, Convert(nvarchar(2), MONTH(@CurrentPayCycleDate)) + '/28/' + Convert(nvarchar(4), YEAR(@CurrentPayCycleDate)), 101)
				ELSE CONVERT(Date, Convert(nvarchar(2), MONTH(@CurrentPayCycleDate)) + '/' + Convert(nvarchar(2), p.FeePayCycleValue) + '/' + Convert(nvarchar(4), YEAR(@CurrentPayCycleDate)), 101)
				END,
				1, 0, 0
			FROM lkpFeePayCycle p
				inner join cfgCenterFeePayCycle c on p.FeePayCycleID = c.FeePayCycleID
			WHERE p.FeePayCycleValue > DAY(@CurrentPayCycleDate)
				AND c.CenterID = @CenterId
			ORDER By p.FeePayCycleValue asc
	ELSE
		INSERT INTO @CenterPayCycleDates (FeePayCycleId, FeePayCycleDate, IsWaitingApproval, IsCurrentPayCycle, CanApprove)
			SELECT TOP(1)
				p.FeePayCycleId,

				CASE When MONTH(@CurrentPayCycleDate) = 2 and p.FeePayCycleValue > 28 Then CONVERT(Date, Convert(nvarchar(2), MONTH(DATEADD(MONTH,1,@CurrentPayCycleDate))) + '/28/' + Convert(nvarchar(4), YEAR(DATEADD(MONTH,1,@CurrentPayCycleDate))), 101)
				ELSE CONVERT(Date, Convert(nvarchar(2), MONTH(DATEADD(MONTH,1,@CurrentPayCycleDate))) + '/' + Convert(nvarchar(2), p.FeePayCycleValue) + '/' + Convert(nvarchar(4), YEAR(DATEADD(MONTH,1,@CurrentPayCycleDate))), 101)
				END,
				1, 0, 0
			FROM lkpFeePayCycle p
				inner join cfgCenterFeePayCycle c on p.FeePayCycleID = c.FeePayCycleID
			WHERE p.FeePayCycleValue > 0
				AND c.CenterID = @CenterID
			ORDER By p.FeePayCycleValue asc

	UPDATE @CenterPayCycleDates
		SET CanApprove = CASE WHEN IsWaitingApproval = 1 AND (FeePayCycleDate < @TodayDate OR (FeePayCycleDate >= @TodayDate AND DATEDIFF(Day,@TodayDate,FeePayCycleDate) <= @CanApproveDays))
				THEN 1 ELSE 0 END

	SELECT
		c.FeePayCycleId,
		c.FeePayCycleDate,
		c.CanApprove,
		c.IsCurrentPayCycle
	FROM @CenterPayCycleDates c
	ORDER BY c.FeePayCycleDate asc

END
