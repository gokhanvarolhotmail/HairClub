/* CreateDate: 05/15/2013 13:59:08.280 , ModifyDate: 11/17/2017 10:54:35.433 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				selRequestQueueToProcess

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		05/14/2013

LAST REVISION DATE: 	05/14/2013

--------------------------------------------------------------------------------------------------------
NOTES: 	Return RequestQueue Records to be processed

		05/14/13 - MLM	: Initial Creation
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:a

selRequestQueueToProcess

***********************************************************************/
CREATE PROCEDURE [dbo].[selRequestQueueToProcess]

AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @Consultation varchar(20) = 'Consultation'

	-- Set the IsOutDatedFlag
	Update rq
		SET IsOutDatedFlag = 1
			,LastUpdate = GETUTCDATE()
			,LastUpdateUser = 'sa'
	from datRequestQueue rq
		INNER JOIN datClient c on rq.ClientIdentifier = c.ClientIdentifier
	WHERE rq.ProcessName = @Consultation
		AND c.SiebelID IS NOT NULL
		AND (rq.SiebelID IS NULL OR rtrim(ltrim(rq.SiebelID)) = '')
		AND rq.IsProcessedFlag = 0
		AND rq.IsOutDatedFlag = 0


	--Retrieve the RequestQueueIDs to be processed.
	SELECT rq.RequestQueueID
	FROM datRequestQueue rq
	WHERE (rq.IsProcessedFlag = 0 AND rq.IsOutDatedFlag = 0)
	Order by rq.RequestQueueID

END
GO
