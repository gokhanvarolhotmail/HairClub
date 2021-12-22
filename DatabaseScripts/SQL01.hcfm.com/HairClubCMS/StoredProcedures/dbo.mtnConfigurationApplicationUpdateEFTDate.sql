/***********************************************************************

PROCEDURE:				mtnConfigurationApplicationUpdateEFTDate

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		 2/1/2012

LAST REVISION DATE: 	 2/1/2012

--------------------------------------------------------------------------------------------------------
NOTES:
		* 2/1/12 MLM - Created stored proc
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC mtnConfigurationApplicationUpdateEFTDate

***********************************************************************/
CREATE PROCEDURE [dbo].[mtnConfigurationApplicationUpdateEFTDate]
AS
BEGIN
	SET NOCOUNT ON


	Update cfgConfigurationApplication
		SET LastUpdateClientEFT = GETDATE()
		,LastUpdate = GETUTCDATE()
		,lastUpdateUser = convert(nvarchar,'sa')
	FROM cfgConfigurationApplication

END
