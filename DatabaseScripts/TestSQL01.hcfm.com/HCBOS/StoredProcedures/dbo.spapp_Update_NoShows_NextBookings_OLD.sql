/* CreateDate: 09/18/2006 16:13:35.923 , ModifyDate: 01/25/2010 08:11:31.807 */
GO
CREATE   PROCEDURE  [dbo].[spapp_Update_NoShows_NextBookings_OLD]

AS

/*

**  Non-cursor method to cycle through the NoShowDaily table and update booking date for each new appt.

**  after the no show

** Revision History:

** ------------------------------------------------------------------

**  Date       Name      Description     	Project

** ------------------------------------------------------------------

**  09/15/06  HABELOW   CREATE     		No Show Emails

**  09/18/06  HABELOW   Added while loop

*/



SET NOCOUNT ON

-- declare all variables!

DECLARE	@iReturnCode       	int,

            	@iNextRowId   		int,

            	@iCurrentRowId	     	int,

            	@iLoopControl      	int,

           		@recordId   		int,

	   	@NoShowDate		datetime,

	    	@ResultDate		datetime,

	    	@NextApptDate		datetime,

	    	@IsShow		int




-- Initialize variables!

SELECT @iLoopControl = 1

SELECT @iNextRowId = MIN(RowId)

FROM   dbo.NoShowsDaily

WHERE  NextApptDateBooked IS NULL





-- Make sure the table has data.

IF ISNULL(@iNextRowId,0) = 0

   BEGIN

            SELECT 'No data in found in table!'

            RETURN

   END

-- Retrieve the first row

SELECT		@iCurrentRowId   = RowId,

                	@recordId = recordId,

		@NoShowDate = NoShowDate

FROM             	dbo.NoShowsDaily

WHERE            	RowId = @iNextRowId








-- start the main processing loop.

WHILE @iLoopControl = 1

   BEGIN

     -- get the first result date after the initial no show

     -- that results in an appt booking.

	SELECT @ResultDate = MIN(result_date) from HCM.dbo.gmin_mngr mngr

	WHERE mngr.recordid = @recordId

	AND mngr.result_date > @NoShowDate

	AND result_code IN ('R1', 'A21', 'A31', 'R1-A31', 'R4')


	-- update the table with the booking date and the week after the no show

	-- week 1 is the same week.  Check to see if not null first

	IF (@ResultDate IS NOT NULL)

	BEGIN

	    	UPDATE [dbo].[NoShowsDaily]

		SET 	NextApptDateBooked  = @ResultDate

		, 	BookedWeekNumber = (DATEPART(wk, @ResultDate) - DATEPART(wk, @NoShowDate) + 1 )

		WHERE RowId = @iCurrentRowId


		-- get the next appt date after the booking date and the show result

		SELECT @NextApptDate = MIN(date_),

			@IsShow = HCM.dbo.IsShow(result_code)

		FROM HCM.dbo.gmin_mngr mngr

		WHERE mngr.recordid = @recordId

		AND mngr.date_ >= CAST(CONVERT(varchar, @ResultDate, 107) as datetime)

		AND HCM.dbo.IsAppt(mngr.act_code) = 1

		GROUP BY mngr.Result_code


		-- update the booking with the show result

		UPDATE [dbo].[NoShowsDaily]

		SET IsShow = @IsShow

		WHERE RowId = @iCurrentRowId

	END

     -- Reset looping variables.

            SELECT   @iNextRowId = NULL

            -- get the next iRowId

            SELECT   @iNextRowId = MIN(RowId)

            FROM     dbo.NoShowsDaily

            WHERE    RowId > @iCurrentRowId

	    AND  NextApptDateBooked IS NULL


            -- did we get a valid next row id?

            IF ISNULL(@iNextRowId,0) = 0

               BEGIN

                        BREAK

               END

            -- get the next row.

            SELECT		@iCurrentRowId =   RowId,

                    		@recordId = recordId,

		    	@NoShowDate = NoShowDate

            FROM    	dbo.NoShowsDaily

	WHERE   	RowId = @iNextRowId


   END

RETURN
GO
