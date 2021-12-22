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
