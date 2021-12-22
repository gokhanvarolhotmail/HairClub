/* CreateDate: 11/11/2015 11:36:21.260 , ModifyDate: 11/11/2015 11:36:21.260 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MJW	- Workwise, LLC
-- Create date: 2015-11-06
-- Description:	Update cstd_contact_marketing_score as necessary
-- =============================================
CREATE PROCEDURE [dbo].[psoSetContactMarketingScore]
	-- Add the parameters for the stored procedure here
	@contact_id		nchar(10),
	@marketing_score	decimal(15,4),
	@type_code		nchar(10),
	@user_code		nchar(20)
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM cstd_contact_marketing_score WHERE contact_id = @contact_id)
	BEGIN
		DECLARE @pk uniqueidentifier
		SET @pk = NEWID()

		INSERT INTO cstd_contact_marketing_score (contact_marketing_score_id, contact_id, marketing_score_contact_type_code, marketing_score, creation_date, created_by_user_code, updated_date, updated_by_user_code)
			VALUES (@pk, @contact_id, @type_code, @marketing_score, GETDATE(), @user_code, GETDATE(), @user_code)
	END
	ELSE
		UPDATE cstd_contact_marketing_score SET
			marketing_score = @marketing_score,
			updated_by_user_code = @user_code,
			updated_date = GETDATE()
		WHERE contact_id = @contact_id
END
GO
