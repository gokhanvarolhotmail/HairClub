/* CreateDate: 06/04/2009 05:34:02.020 , ModifyDate: 11/22/2011 09:04:37.047 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================================
-- Author:		Oncontact PSO Fred Remers
-- Description:	Check source code. If source code is in provided list, revert back
--              to most recent incall activity source code not in the list. If still
--              no source code, revert back to contact's original source code
--
-- Update Date: 24 September 2009
-- By:          Oncontact PSO Fred Remers
-- Description: Add promo code to newly generated activities based on source code.
--	            Check activities with a null source code.
--	            a. If action code is RECOVERY, TXTCONFIRM, BEBACK, or APPOINT, check activities for valid source code and
--                 use if found. If not found, check contact for valid source code and use if found. If
--                 not found, use action code as source code.
--
-- Update Date: 1 October 2009
-- By:          Oncontact PSO Fred Remers
-- Description: uncommented: and oncd_activity.cst_activity_type_code = 'INBOUND'
--
-- Update Date: 23 November 2009
-- By:          Oncontact PSO Naftali Kalter
-- Description: commented: and oncd_activity.activity_type_code = 'INBOUND'
--              Added: and oncd_activity.action_code = 'INCALL'
--
-- Update Date: 20 October 2011
-- Description: Updated formatting.
--              Change to enforce a Source on the Activity unless unavoidable.
-- =============================================================================
CREATE PROCEDURE [dbo].[pso_CheckSourceCode] (
	@activity_id NCHAR(10)
)
AS

BEGIN
	SET NOCOUNT ON;
	IF ( (SELECT TRIGGER_NESTLEVEL() ) <= 1 )
	BEGIN

		-- Check to make sure that the trigger user exists in onca_user and add it if the user does not
		IF (SELECT user_code FROM onca_user WHERE user_code = 'TRIGGER') IS NULL
			INSERT INTO onca_user (user_code, description, display_name, active) VALUES ('TRIGGER', 'Trigger', 'Trigger', 'N')

		DECLARE @currentSourceCode	NCHAR(20)
		DECLARE @newSourceCode		NCHAR(20)
		DECLARE @promoSourceCode	NCHAR(20)
		DECLARE @contactId			NCHAR(10)
		DECLARE @actionCode			NCHAR(20)
		DECLARE @promotionCode		NCHAR(10)
		DECLARE @newPromotionCode	NCHAR(10)

		SET @currentSourceCode = (	SELECT
										source_code
									FROM oncd_activity
									WHERE
										activity_id = @activity_id)

		IF (@currentSourceCode IN ('TEXT RESC','RESCHEDULE','RESCHEDULE2','RESCHEDULE SPANISH','RESCHEDULE SPANISH2','SPAN TRAN','APS REQUESTS','CALLER ID','RELOCATION','ONCALL','OUTCALL','Unknown'))
		BEGIN
			SET @contactId =	(	SELECT
										contact_id
									FROM oncd_activity_contact
									WHERE
										activity_id = @activity_id)

			SET @newSourceCode = (	SELECT TOP 1
										source_code
									FROM oncd_activity
									INNER JOIN oncd_activity_contact ON
										oncd_activity_contact.activity_id = oncd_activity.activity_id AND
										oncd_activity_contact.contact_id = @contactId
									WHERE
										oncd_activity.source_code NOT IN ('TEXT RESC','RESCHEDULE','RESCHEDULE2','RESCHEDULE SPANISH','RESCHEDULE SPANISH2','SPAN TRAN','APS REQUESTS','CALLER ID','RELOCATION','ONCALL','OUTCALL','Unknown') AND
										oncd_activity.action_code = 'INCALL' AND
										oncd_activity.source_code IS NOT NULL
									ORDER BY
										oncd_activity.creation_date DESC)

			IF (@newSourceCode IS NULL)
			BEGIN
				SET @newSourceCode = (	SELECT TOP 1
											source_code
										FROM oncd_contact_source
										WHERE
											contact_id = @contactId AND
  											source_code NOT IN ('TEXT RESC','RESCHEDULE','RESCHEDULE2','RESCHEDULE SPANISH','RESCHEDULE SPANISH2','SPAN TRAN','APS REQUESTS','CALLER ID','RELOCATION','ONCALL','OUTCALL','Unknown') AND
  											source_code IS NOT NULL
  										ORDER BY
  											primary_flag DESC,
  											sort_order ASC)
			END
		END
		ELSE IF (@currentSourceCode IS NULL)
		BEGIN
			SET @actionCode = (	SELECT
									action_code
								FROM oncd_activity
								WHERE
									activity_id = @activity_id)

			IF (@actionCode IN ('RECOVERY', 'TXTCONFIRM', 'BEBACK', 'APPOINT'))
			BEGIN
				SET @contactId = (	SELECT
										contact_id
									FROM oncd_activity_contact
									WHERE
										activity_id = @activity_id)

				IF (@contactId IS NOT NULL)
				BEGIN
					SET @newSourceCode = (	SELECT TOP 1
												source_code
											FROM oncd_activity
											INNER JOIN oncd_activity_contact ON
												oncd_activity_contact.activity_id = oncd_activity.activity_id AND
												oncd_activity_contact.contact_id = @contactId
											WHERE
												oncd_activity.source_code NOT IN ('TEXT RESC','RESCHEDULE','RESCHEDULE2','RESCHEDULE SPANISH','RESCHEDULE SPANISH2','SPAN TRAN','APS REQUESTS','CALLER ID','RELOCATION','ONCALL','OUTCALL','Unknown') AND
												oncd_activity.action_code = 'INCALL' AND
												oncd_activity.source_code IS NOT NULL
											ORDER BY
												oncd_activity.creation_date desc)

					IF (@newSourceCode IS NULL)
					BEGIN
						SET @newSourceCode = (	SELECT TOP 1
													source_code
												FROM oncd_contact_source
												WHERE
													contact_id = @contactId AND
  													source_code NOT IN ('TEXT RESC','RESCHEDULE','RESCHEDULE2','RESCHEDULE SPANISH','RESCHEDULE SPANISH2','SPAN TRAN','APS REQUESTS','CALLER ID','RELOCATION','ONCALL','OUTCALL','Unknown') AND
  													source_code IS NOT NULL
  												ORDER BY
  													primary_flag DESC,
  													sort_order ASC)
					END

					IF (@newSourceCode IS NULL)
					BEGIN
						SET @newSourceCode = @actionCode
					END
				END
			END
		END

		IF (@newSourceCode IS NOT NULL)
		BEGIN
			UPDATE oncd_activity
			SET
				source_code = @newSourceCode
			WHERE
				activity_id = @activity_id
		END
		--ELSE
		--BEGIN
		--	INSERT INTO cstd_sql_job_log (name, message)
		--	VALUES ('pso_CheckSourceCode','No Source found for Activity: ' + @activity_id)
		--END
	END
END
GO
