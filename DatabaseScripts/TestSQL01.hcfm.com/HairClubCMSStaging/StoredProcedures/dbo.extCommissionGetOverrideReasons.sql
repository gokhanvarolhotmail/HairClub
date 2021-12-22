/* CreateDate: 02/18/2013 07:40:33.900 , ModifyDate: 03/04/2013 22:17:56.017 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
