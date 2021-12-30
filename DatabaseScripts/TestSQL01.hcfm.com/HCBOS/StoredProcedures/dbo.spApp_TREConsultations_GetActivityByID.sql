/* CreateDate: 09/22/2008 15:04:14.140 , ModifyDate: 01/25/2010 08:11:31.823 */
GO
/*===============================================================================================
-- Procedure Name:			spApp_TREConsultations_GetActivityByID
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
EXEC spApp_TREConsultations_GetActivityByID 'WGRLRIBGC1'
================================================================================================*/
CREATE PROCEDURE [dbo].[spApp_TREConsultations_GetActivityByID]
(
	@ActivityID VARCHAR(50)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Output results.
	SELECT  CONVERT(VARCHAR(10), a.due_date, 101) + ' ' + a.start_time AS 'Appt'
	,       dbo.pCase(LTRIM(RTRIM(info.last_name))) + ', ' + dbo.pCase(LTRIM(RTRIM(info.first_name))) AS 'Name'
	FROM    [HCM].[dbo].lead_info info WITH (NOLOCK)
			INNER JOIN [HCM].[dbo].oncd_activity_contact ac WITH (NOLOCK)
			  ON ac.contact_id = info.contact_id
				AND ac.primary_flag = 'Y'
			INNER JOIN [HCM].[dbo].oncd_activity a WITH (NOLOCK)
			  ON a.activity_id = ac.activity_id
	WHERE   a.[activity_id] = @ActivityID
END
GO
