/* CreateDate: 09/22/2008 15:04:30.500 , ModifyDate: 01/25/2010 08:11:31.823 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
-- Procedure Name:			spApp_TREConsultations_GetCenterCountry
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
EXEC spApp_TREConsultations_GetCenterCountry 201
================================================================================================*/
CREATE PROCEDURE [dbo].[spApp_TREConsultations_GetCenterCountry]
(
	@CenterNumber INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Output results.
	SELECT  ISNULL([oca].[country_code], 'US') AS 'country_code'
	FROM    [HCM].[dbo].[oncd_company] oc WITH (NOLOCK)
			INNER JOIN [HCM].[dbo].[oncd_company_address] oca WITH (NOLOCK)
			  ON [oc].[company_id] = [oca].[company_id]
	WHERE   [cst_center_number] = @CenterNumber
END
GO
