/***********************************************************************

PROCEDURE:				mtnConfigurationCenterUpdateEFTDate

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		 2/1/2012

LAST REVISION DATE: 	 2/1/2012

--------------------------------------------------------------------------------------------------------
NOTES:
		* 6/20/12 MLM - Created stored proc
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC mtnConfigurationCenterUpdateEFTDate

***********************************************************************/
CREATE PROCEDURE [dbo].[mtnConfigurationCenterUpdateEFTDate]
	@CenterId int
AS
BEGIN
	SET NOCOUNT ON


	Update cfgConfigurationCenter
		SET LastClientEFTUpdate = GETDATE()
		,LastUpdate = GETUTCDATE()
		,lastUpdateUser = convert(nvarchar,'sa')
	FROM cfgConfigurationCenter
	WHERE CenterID = @CenterId

END
