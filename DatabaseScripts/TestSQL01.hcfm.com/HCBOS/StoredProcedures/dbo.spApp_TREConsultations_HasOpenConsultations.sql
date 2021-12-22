/* CreateDate: 09/22/2008 15:07:36.547 , ModifyDate: 01/25/2010 08:11:31.760 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
-- Procedure Name:			spApp_TREConsultations_HasOpenConsultations
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
--
-- 03/13/2009 - FR	--> Removed view. Redesigned. Implemented 3/16/2009
--
-- 09/11/2009 - DL	--> Joined on oncd_activity_contact to eliminate instances where activities
					--> with no associated contacts where being counted as open activities which
					--> would result in the center not being able to complete today's activities.
-- ----------------------------------------------------------------------------------------------
--
Sample Execution:
--
EXEC spApp_TREConsultations_HasOpenConsultations 214, '9/14/2008', '10/13/2008'
================================================================================================*/
CREATE PROCEDURE [dbo].[spApp_TREConsultations_HasOpenConsultations]
(
	@CenterNumber INT,
	@StartDate DATETIME,
	@EndDate DATETIME
)
AS
BEGIN
IF EXISTS ( SELECT TOP 1
                    a.activity_id
            FROM    [HCM].[dbo].oncd_activity a WITH ( NOLOCK )
                    INNER JOIN [HCM].[dbo].oncd_activity_company ac WITH ( NOLOCK )
                    ON ac.activity_id = a.activity_id
                       AND a.due_date BETWEEN @StartDate AND @EndDate
                       AND a.action_code IN ( 'APPOINT', 'INHOUSE', 'BEBACK' )
                       AND ( a.result_code IS NULL
                             OR a.result_code = '' )
                       AND ( a.completion_date IS NULL )
                    INNER JOIN [HCM].[dbo].oncd_company co WITH ( NOLOCK )
                    ON co.company_id = ac.company_id
                       AND co.cst_center_number = @CenterNumber
                    INNER JOIN [HCM].[dbo].[oncd_activity_contact] oac WITH ( NOLOCK )
                    ON a.[activity_id] = oac.[activity_id]
                       AND oac.[primary_flag] = 'Y'
)
  BEGIN
    SELECT  1 AS 'HasOpenConsultations'
  END
ELSE
  BEGIN
    SELECT  0 AS 'HasOpenConsultations'
  END
END
GO
