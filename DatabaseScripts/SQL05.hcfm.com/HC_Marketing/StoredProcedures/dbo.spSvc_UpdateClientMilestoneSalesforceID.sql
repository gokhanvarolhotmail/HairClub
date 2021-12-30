/* CreateDate: 01/30/2020 15:39:32.617 , ModifyDate: 01/30/2020 15:41:42.300 */
GO
/***********************************************************************
PROCEDURE:				spSvc_UpdateClientMilestoneSalesforceID
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Marketing
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		1/30/2020
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_UpdateClientMilestoneSalesforceID '', '', ''
***********************************************************************/
CREATE PROCEDURE spSvc_UpdateClientMilestoneSalesforceID
(
	@WhoId NVARCHAR(18),
	@Type NVARCHAR(50),
	@Id NVARCHAR(18)

)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


UPDATE	cml
SET		Id = @Id
,		cml.LastUpdate = GETDATE()
FROM	datClientMilestoneLog cml
WHERE	cml.WhoId = @WhoId
		AND cml.Type = @Type
		AND cml.Id IS NULL

END
GO
