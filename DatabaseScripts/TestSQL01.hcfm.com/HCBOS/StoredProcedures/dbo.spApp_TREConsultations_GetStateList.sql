/* CreateDate: 09/22/2008 15:07:21.517 , ModifyDate: 01/25/2010 08:11:31.760 */
GO
/*===============================================================================================
-- Procedure Name:			spApp_TREConsultations_GetStateList
-- Procedure Description:
--
-- Created By:				Dominic Leiba
-- Implemented By:			Dominic Leiba
-- Last Modified By:		Dominic Leiba
--
-- Date Created:			7/29/2008
-- Date Implemented:		7/29/2008
-- Date Last Modified:		7/29/2008
--
-- Destination Server:		HCSQL3\SQL2005
-- Destination Database:	BOS
-- Related Application:		The Right Experience
--
-- ----------------------------------------------------------------------------------------------
-- Notes:
-- ----------------------------------------------------------------------------------------------
--
Sample Execution:
--
EXEC spApp_TREConsultations_GetStateList 'US'
================================================================================================*/
CREATE PROCEDURE [dbo].[spApp_TREConsultations_GetStateList]
(
	@CountryCode VARCHAR(2)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT  [state_code] AS 'ID'
	,       [description] AS 'Description'
	FROM    [HCM].[dbo].[onca_state]
	WHERE   [country_code] = @CountryCode
			AND [active] = 'Y'
END
GO
