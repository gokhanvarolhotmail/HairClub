/* CreateDate: 06/13/2017 16:07:23.240 , ModifyDate: 06/13/2017 16:07:23.240 */
GO
/***********************************************************************
PROCEDURE:				[selBusinessSegment]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	cONEct!
AUTHOR: 				RH
IMPLEMENTOR: 			RH
DATE IMPLEMENTED: 		06/13/2017
LAST REVISION DATE: 	06/13/2017
--------------------------------------------------------------------------------------------------------
NOTES: 	This stored procedure was removed.  It is used in the report, rptMembershipExpiration.rdl


--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [selBusinessSegment]
***********************************************************************/
CREATE PROCEDURE [dbo].[selBusinessSegment]


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT BusinessSegmentID
     , BusinessSegmentSortOrder
     , BusinessSegmentDescription
     , BusinessSegmentDescriptionShort
FROM lkpBusinessSegment
ORDER BY BusinessSegmentSortOrder

END
GO
