/* CreateDate: 02/18/2013 06:59:50.653 , ModifyDate: 02/18/2013 19:11:13.287 */
GO
/*===============================================================================================
-- Procedure Name:			rptEndOfDayRecapNotes
-- Procedure Description:
--
-- Created By:				Hdu
-- Implemented By:			Hdu
-- Last Modified By:		Hdu
--
-- Date Created:			10/11/2012
-- Destination Server:		SQL01
-- Destination Database:	HairClubCMS
-- Related Application:		CMS
--------------------------------------------------------------------------------------------------------
NOTES:

	10/17/12	MLM		Modified the table Structure to tied RegisterLog to RegisterClose
	01/28/13	MLM		Modified the Report to match the new Table structure
	02/06/13	MLM		Modified to Match New Specifications
--------------------------------------------------------------------------------------------------------
Sample Execution:
EXEC [rptEndOfDayRecapNotes] 201, '2012-10-12', 0
================================================================================================*/
CREATE PROCEDURE [dbo].[rptEndOfDayRecapNotes]
(
	@CenterID INT,
	@EndOfDayDate DATETIME,
	@BusinessSegments INT = 0 -- 0 All, 1 Non-Surgery, 2 Surgery
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

DECLARE @EndDate DATETIME

SELECT @EndDate = CONVERT(VARCHAR(10), @EndOfDayDate, 120) + ' 23:59:59'

SELECT
      eod.CloseNote
      ,eod.CloseDate CloseDate
      ,eod.EndOfDayGUID
FROM datEndOfDay eod
INNER JOIN (
	SELECT bs.BusinessSegmentDescriptionShort, so.EndOfDayGUID
	,ROW_NUMBER() OVER(PARTITION BY so.EndOfDayGUID ORDER BY sot.CreateDate) RANKING
	FROM dbo.datSalesOrderTender sot
			LEFT JOIN dbo.datSalesOrder so ON so.SalesOrderGUID = sot.SalesOrderGUID
			LEFT JOIN datClientMembership cm ON cm.ClientMembershipGUID = so.ClientMembershipGUID
				LEFT JOIN cfgMembership m ON m.MembershipID = cm.MembershipID
					LEFT JOIN [dbo].[lkpBusinessSegment] bs ON bs.BusinessSegmentID = m.BusinessSegmentID
	WHERE so.EndOfDayGUID IS NOT NULL
) e ON e.EndOfDayGUID = eod.EndOfDayGUID
	AND RANKING = 1

WHERE eod.EndOfDayDate BETWEEN @EndOfDayDate AND @EndDate
AND (
	@BusinessSegments = 0
	OR (@BusinessSegments = 1 AND e.BusinessSegmentDescriptionShort IN ('BIO','EXT'))
	OR (@BusinessSegments = 2 AND e.BusinessSegmentDescriptionShort IN ('SUR'))
)
AND eod.CenterID = @CenterID AND eod.CloseNote IS NOT NULL AND DATALENGTH(eod.CloseNote) > 0

END
GO
