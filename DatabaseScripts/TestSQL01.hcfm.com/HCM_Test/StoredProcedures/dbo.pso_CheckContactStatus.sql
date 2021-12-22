/* CreateDate: 12/09/2008 00:12:09.877 , ModifyDate: 05/01/2010 14:48:11.557 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Oncontact PSO Fred Remers
-- Create date: 12/04/08
-- Description:	Set contact status based on activity data
-- Updated:	11/03/09 ONC MJW.  Change logic to: If activty type is INBOUND and result is other than PRANK then...
-- =============================================
CREATE PROCEDURE [dbo].[pso_CheckContactStatus] (
	@activity_id nchar(10),
	@action_code nchar(10),
	@result_code nchar(10),
	@contact_id nchar(10)
)
AS

BEGIN
	SET NOCOUNT ON;
	-- Check to make sure that the trigger user exists in onca_user and add it if the user does not
	IF (SELECT user_code FROM onca_user WHERE user_code = 'TRIGGER') IS NULL
	INSERT INTO onca_user (user_code, description, display_name, active) VALUES ('TRIGGER', 'Trigger', 'Trigger', 'N')

	declare @current_status_code nchar(10)

	set @current_status_code = (select contact_status_code from oncd_contact where contact_id = @contact_id)

	-- 11/03/09 ONC MJW if(@action_code = 'INCALL' and (@result_code = 'BROCHURE' or @result_code = 'APPOINT'))
	IF (@action_code = 'INCALL' AND @result_code <> 'PRANK')
	BEGIN
		if(@current_status_code <> 'LEAD')
		BEGIN
			update oncd_contact set
			contact_status_code = 'LEAD',
			status_updated_date = getdate(),
			status_updated_by_user_code = 'TRIGGER'
			where contact_id = @contact_id
		END
	END

	ELSE IF(@result_code = 'SHOWSALE')
	BEGIN
		if(@current_status_code <> 'CLIENT')
		BEGIN
			update oncd_contact set
			contact_status_code = 'CLIENT',
			status_updated_date = getdate(),
			status_updated_by_user_code = 'TRIGGER'
			where contact_id = @contact_id
		END
	END

	ELSE IF(@result_code IN ('PRANK'))
	BEGIN
		if(@current_status_code <> 'INVALID')
		BEGIN
			update oncd_contact set
			contact_status_code = 'INVALID',
			status_updated_date = getdate(),
			status_updated_by_user_code = 'TRIGGER'
			where contact_id = @contact_id
		END
	END

END
GO
