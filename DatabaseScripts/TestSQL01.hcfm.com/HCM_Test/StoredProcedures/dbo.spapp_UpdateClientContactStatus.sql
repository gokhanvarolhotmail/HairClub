/* CreateDate: 01/22/2008 10:10:17.563 , ModifyDate: 05/01/2010 14:48:10.703 */
GO
-- =============================================
-- Author:			Hair Club - Kevin Murdoch
-- Create date: 	01/22/08
-- Description:		Update contact_status_code to 'CLIENT' for records
--					where Result_code = 'SHOWSALE'
-- =============================================
CREATE PROCEDURE [dbo].[spapp_UpdateClientContactStatus]
AS

BEGIN
	SET NOCOUNT ON;
	UPDATE  [oncd_contact]
	set contact_status_code = 'CLIENT'
	FROM    [oncd_activity]
		INNER JOIN [oncd_activity_contact]
			ON [oncd_activity].[activity_id] = [oncd_activity_contact].[activity_id]
		INNER JOIN [oncd_contact]
			ON [oncd_activity_contact].[contact_id] = [oncd_contact].[contact_id]

WHERE   [oncd_activity].[result_code] = 'SHOWSALE'
			AND [oncd_activity].[due_date] > '01/01/07'
END
GO
