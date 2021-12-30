/* CreateDate: 02/05/2013 14:22:43.620 , ModifyDate: 02/13/2013 16:10:48.537 */
GO
/*
==============================================================================

PROCEDURE:				[spApp_GetOverrideReasons]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Get override reasons
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spApp_GetOverrideReasons]
==============================================================================
*/
CREATE PROCEDURE [dbo].[extCommissionGetOverrideReasons] AS
BEGIN
	SET NOCOUNT ON

	SELECT ReasonID
	,	ReasonDescription
	FROM HC_Commission.dbo.[DimOvererrideReasons]

END
GO
