/* CreateDate: 06/12/2013 13:22:45.133 , ModifyDate: 06/12/2013 13:23:08.580 */
GO
/***********************************************************************
PROCEDURE:	spSvc_ClearDataLoadTable

DESTINATION SERVER:	   SQL05

DESTINATION DATABASE: HC_Accounting

AUTHOR: Marlon Burrell

DATE IMPLEMENTED: 06/12/2013

--------------------------------------------------------------------------------------------------------
NOTES:	This procedure clears the DataLoad table to process a new File
--------------------------------------------------------------------------------------------------------

SAMPLE EXEC:
exec spSvc_ClearDataLoadTable
***********************************************************************/
CREATE PROC [dbo].[spSvc_ClearDataLoadTable]
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON

	TRUNCATE TABLE DataLoad
END
GO
