/*
==============================================================================

PROCEDURE:				[extCommissionGetOverrideReasons]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Get override reasons
==============================================================================
NOTES:
		* 02/19/2013 MVT - Updated to use synonyms
==============================================================================
SAMPLE EXECUTION:
EXEC [extCommissionGetOverrideReasons]
==============================================================================
*/
CREATE PROCEDURE [dbo].[extCommissionGetOverrideReasons] AS
BEGIN
	SET NOCOUNT ON

	SELECT ReasonID
	,	ReasonDescription
	FROM Commission_DimOvererrideReasons_TABLE

END
