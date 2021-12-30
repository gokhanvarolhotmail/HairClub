/* CreateDate: 07/29/2014 19:00:47.447 , ModifyDate: 08/05/2014 10:19:19.027 */
GO
/***********************************************************************
PROCEDURE:				extHairClubCMSUpdateActvityDemographicScale
DESTINATION SERVER:		SQL03
DESTINATION DATABASE:	HCM
AUTHOR:					Kris Larsen
IMPLEMENTOR:			Kris Larsen
DATE IMPLEMENTED:		07/18/2014
------------------------------------------------------------------------
NOTES:
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC extHairClubCMSUpdateActvityDemographicScale
***********************************************************************/
CREATE PROCEDURE [dbo].[extHairClubCMSUpdateActvityDemographicScale]
(
	@ActivityID VARCHAR(50) = NULL,
	@Gender CHAR(1),
	@ScaleID VARCHAR(50) = NULL,
	@UpdatedBy VARCHAR(50)
)
AS
SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @p_UpdatedBy NCHAR(20) = CAST(@UpdatedBy AS NCHAR(20))

-- Update Activity Demographics
IF ISNULL(@ActivityID, '') <> ''
   BEGIN
			-- IF Activity Demographic Record Exists then update existing activity demographic record
			IF EXISTS ( SELECT    activity_id
						FROM      cstd_activity_demographic
						WHERE     activity_id = @ActivityID )
				BEGIN
					if @Gender = 'M'
						UPDATE   cstd_activity_demographic
						SET      norwood = @ScaleID,
							     ludwig = null
						WHERE    activity_id = @ActivityID
					else
						UPDATE   cstd_activity_demographic
						SET      ludwig = @ScaleID,
						         norwood = null
						WHERE    activity_id = @ActivityID

					IF @@ERROR <> 0
						BEGIN
							ROLLBACK TRANSACTION
							RETURN @@ERROR
						END
				END

			-- IF Activity Demographic Record Does Not Exist then create new activity demographic record
			ELSE
				BEGIN
					DECLARE @ActivityDemographicID VARCHAR(25)

					EXEC onc_create_primary_key 10, 'cstd_activity_demographic', 'activity_demographic_id', @ActivityDemographicID OUTPUT, 'ONC'


					DECLARE @p_CenterID NCHAR(20)

					SET @p_CenterID = (SELECT OA.created_by_user_code FROM oncd_activity OA WHERE OA.activity_id = @ActivityID)


					INSERT  INTO cstd_activity_demographic
							(
								activity_demographic_id
							,	activity_id
							,	gender
							,	birthday
							,	occupation_code
							,	ethnicity_code
							,	maritalstatus_code
							,	norwood
							,	ludwig
							,	age
							,	creation_date
							,	created_by_user_code
							,	updated_date
							,	updated_by_user_code
							,	performer
							,	price_quoted
							,	solution_offered
							,	no_sale_reason
							,	disc_style
							)
					VALUES   (
								@ActivityDemographicID
							,	@ActivityID
							,	'?'
							,	'2003-01-01'
							,	'0'
							,	'0'
							,	'0'
							,	case WHEN @Gender = 'M' then @ScaleID else NULL END
							,   case WHEN @Gender = 'F' then @ScaleID else NULL END
							,	0
							,	GETDATE()
							,	@p_CenterID
							,	GETDATE()
							,	@p_CenterID
							,	NULL
							,	0.00
							,	NULL
							,	NULL
							,	NULL )

					IF @@ERROR <> 0
						BEGIN
							ROLLBACK TRANSACTION
							RETURN @@ERROR
						END
				END

   END

COMMIT TRANSACTION
GO
