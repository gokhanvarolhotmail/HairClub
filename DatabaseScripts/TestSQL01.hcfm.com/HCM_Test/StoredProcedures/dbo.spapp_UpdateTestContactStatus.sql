/* CreateDate: 09/28/2007 14:55:01.577 , ModifyDate: 05/01/2010 14:48:10.640 */
GO
-- =============================================
-- Author:			Oncontact PSO Fred Remers
-- Create date: 	9/24/07
-- Description:		Update contact_status_code to 'TEST' for records
--					where first and last name contains the word 'test'
-- =============================================
CREATE PROCEDURE [dbo].[spapp_UpdateTestContactStatus]
AS

BEGIN
	SET NOCOUNT ON;
	update oncd_contact set contact_status_code = 'TEST' where first_name_search like 'TEST%' and last_name_search like 'TEST%'
END
GO
