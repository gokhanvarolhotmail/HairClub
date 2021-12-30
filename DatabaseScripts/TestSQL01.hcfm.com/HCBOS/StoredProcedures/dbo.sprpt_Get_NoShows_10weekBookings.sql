/* CreateDate: 09/19/2006 15:00:00.500 , ModifyDate: 01/25/2010 08:11:31.807 */
GO
CREATE     PROCEDURE  sprpt_Get_NoShows_10weekBookings

	@weekofDate datetime,

	@SentEmail bit = 1,

	@Gender varchar(10) = NULL



AS


/* sprpt_Get_NoShows_10weekBookings '3/17/2006', 0

**  Non-cursor method to cycle through the NoShowDaily table and get

**  the weekly follow through of noshows

** Revision History:

** ------------------------------------------------------------------

**  Date       Name      Description     	Project

** ------------------------------------------------------------------

**  09/18/06  HABELOW   CREATE     		No Show Emails

**  09/18/06  HABELOW   Added while loop

**  09/20/06  HABELOW	Added Parameters for filtering

*/



SET NOCOUNT ON



-- declare all variables!

DECLARE @startDate datetime

DECLARE @weekNo int

DECLARE @counter int

DECLARE @Total int

DECLARE @isBounced int

DECLARE @NetNoshows int

DECLARE @BookedAppts int

DECLARE @Show int

DECLARE @WeekTable table

	(

	weekNo	varchar(6)

,	Total	int

,	Bounced	int

,	Net	int

,	Appt	int

,	ApptRate smallmoney

,	Show	int

,	ShowRate smallmoney

	)



-- initialize variables

SET @weekNo = DATEPART(wk, @weekofDate)

SET @counter = 1



-- bounced will always be the number from the sent emails. Report displays + or -

SELECT 	@isBounced = ISNULL(SUM(CASE WHEN isBounced = 1 THEN 1 ELSE 0 END), 0)

FROM dbo.NoShowsDaily

WHERE noShowWeek = @weekNo

--AND HasEmail = 1

AND SentEmail = 1

AND Gender = COALESCE(@Gender, Gender)



-- get the first week data to be passed to the next week's data

SELECT	@Total = COUNT(recordId)

,	@NetNoshows =

	CASE WHEN @SentEmail = 1 THEN

		 COUNT(recordId) - @isBounced

	ELSE

		COUNT(recordId) + @isBounced

	END

,	@BookedAppts = SUM(CASE WHEN BookedWeekNumber = @counter THEN 1 ELSE 0 END)

,	@Show = SUM(CASE WHEN isShow = 1 AND BookedWeekNumber = @counter THEN 1 ELSE 0 END)


FROM dbo.NoShowsDaily

WHERE noShowWeek = @weekNo

--AND HasEmail = 1

AND SentEmail = @SentEmail

AND Gender = COALESCE(@Gender, Gender)






-- Make sure the table has data.

IF ISNULL(@Total,0) = 0

   BEGIN

	    INSERT INTO @WeekTable

            SELECT 'N/A' , 0, 0, 0, 0, 0, 0, 0

	    SELECT * FROM @WeekTable

            RETURN

   END

-- start the main processing loop.

WHILE @counter <= 10

   BEGIN

	INSERT INTO @WeekTable

	SELECT 	'Week' +  CONVERT(varchar,@counter) as WeekNo

	,	@Total as Total

	,	@isBounced as Bounced

	,	@NetNoshows AS Net

	,	@BookedAppts as Appt

	,	HCM.dbo.Divide(

		CAST (@BookedAppts AS DECIMAL(5,0) ), CAST (@NetNoshows AS DECIMAL(5,0))

		) as ApptRate

	,	@Show as Show

	,	HCM.dbo.Divide(

		CAST (@Show AS DECIMAL(5,0) ), CAST(@BookedAppts AS DECIMAL(5,0) )

		)



	-- Reset the total

	SELECT @Total = NULL

 	-- get the net values for the next week

	SELECT @Total = @NetNoshows - @BookedAppts

	-- reset the bounced to 0

	SELECT @isBounced = NULL

	-- set bounced to 0 because bounced will always = 0 after first week

	SELECT @isBounced = 0

	-- reset the net

	SELECT @NetNoshows = NULL

	-- set the net = total because bounced will always = 0 after first week

	SELECT @NetNoshows = @Total

	-- increment the counter

	SELECT @counter = @counter + 1

	-- reset the booked appts

	SELECT @BookedAppts = NULL

	-- reset the shows

	SELECT @Show = NULL

	-- set the booked appts and shows for next  BookedWeekNumber

	SELECT @BookedAppts = SUM(CASE WHEN BookedWeekNumber = @counter THEN 1 ELSE 0 END)

	,	@Show = SUM(CASE WHEN isShow = 1 AND BookedWeekNumber = @counter THEN 1 ELSE 0 END)

	FROM dbo.NoShowsDaily

	WHERE noShowWeek = @weekNo

	--AND HasEmail = 1

	AND SentEmail = @SentEmail

	AND Gender = COALESCE(@Gender, Gender)

  END

SELECT * FROM @WeekTable
GO
