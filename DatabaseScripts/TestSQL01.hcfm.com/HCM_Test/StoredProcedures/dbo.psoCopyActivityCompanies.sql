/* CreateDate: 01/03/2013 10:22:39.177 , ModifyDate: 01/03/2013 10:22:39.177 */
GO
-- =============================================
-- Create date: 29 October 2012
-- Description:	Copies the Activity Company records from one Activity to
--				another Activity.
-- =============================================
CREATE PROCEDURE [dbo].[psoCopyActivityCompanies]
	@OriginalActivityId	NCHAR(10),	-- The Activity to copy the assigned Companies from.
	@NewActivityId		NCHAR(10),	-- The Activity to copy the assigned Companies to.
	@UserCode			NCHAR(20)	-- The User to create the Activity Company records.
AS
BEGIN
	DECLARE @ActivityCompanyId NCHAR(10)
	DECLARE @CompanyId NCHAR(10)
	DECLARE @Attendance NCHAR(1)
	DECLARE @SortOrder INT
	DECLARE @PrimaryFlag NCHAR(1)

	DECLARE activityCompanyCursor CURSOR FOR
		SELECT company_id, attendance, sort_order, primary_flag
		FROM oncd_activity_company
		WHERE activity_id = @OriginalActivityId

	OPEN activityCompanyCursor
	FETCH NEXT FROM activityCompanyCursor
	INTO @CompanyId, @Attendance, @SortOrder, @PrimaryFlag

	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		EXEC onc_create_primary_key 10, 'oncd_activity_company', 'activity_company_id', @ActivityCompanyId OUTPUT, ''

		INSERT INTO oncd_activity_company(
			activity_company_id,
			activity_id,
			company_id,
			assignment_date,
			attendance,
			sort_order,
			creation_date,
			created_by_user_code,
			primary_flag)
		VALUES(
			@ActivityCompanyId,
			@NewActivityId,
			@CompanyId,
			GETDATE(),
			@Attendance,
			@SortOrder,
			GETDATE(),
			@UserCode,
			@PrimaryFlag)

		FETCH NEXT FROM activityCompanyCursor
		INTO @CompanyId, @Attendance, @SortOrder, @PrimaryFlag
	END
	CLOSE activityCompanyCursor
	DEALLOCATE activityCompanyCursor
END
GO
