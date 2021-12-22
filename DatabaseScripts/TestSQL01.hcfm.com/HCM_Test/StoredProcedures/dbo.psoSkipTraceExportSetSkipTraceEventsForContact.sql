/* CreateDate: 12/04/2015 15:34:10.373 , ModifyDate: 03/22/2016 10:58:43.970 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Workwise, LLC - MJW
-- Create date: 2015-11-10
-- Description:	Add/Update cstd_skip_trace_events as needed
-- =============================================
CREATE PROCEDURE [dbo].[psoSkipTraceExportSetSkipTraceEventsForContact]
	-- Add the parameters for the stored procedure here
	@contact_id				nchar(10),
	@process_address_flag	nchar(1) ,
	@process_phone_flag		nchar(1) ,
	@process_email_flag		nchar(1) ,
	@vendor_code			nchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @begin_today datetime
	DECLARE @address_next_vendor_code nchar(20)
	DECLARE @address_next_vendor_delay_days int
	DECLARE @phone_next_vendor_code nchar(20)
	DECLARE @phone_next_vendor_delay_days int
	DECLARE @email_next_vendor_code nchar(20)
	DECLARE @email_next_vendor_delay_days int

	DECLARE @primary_address_vendor nvarchar(20)
	DECLARE @primary_email_vendor nvarchar(20)
	DECLARE @primary_phone_vendor nvarchar(20)
	DECLARE @primary_address_vendor_delay_days int
	DECLARE @primary_email_vendor_delay_days int
	DECLARE @primary_phone_vendor_delay_days int

	SET @begin_today = CONVERT(datetime,CONVERT(nchar(10),GETDATE(),121))

	SELECT @primary_address_vendor = skip_trace_vendor_code, @primary_address_vendor_delay_days = address_next_vendor_delay_days FROM csta_skip_trace_vendor WHERE address_primary_vendor = 'Y' AND active = 'Y'
	SELECT @primary_email_vendor = skip_trace_vendor_code, @primary_email_vendor_delay_days = email_next_vendor_delay_days FROM csta_skip_trace_vendor WHERE email_primary_vendor = 'Y' AND active = 'Y'
	SELECT @primary_phone_vendor = skip_trace_vendor_code, @primary_phone_vendor_delay_days = phone_next_vendor_delay_days FROM csta_skip_trace_vendor WHERE phone_primary_vendor = 'Y' AND active = 'Y'


	IF NOT @process_address_flag = 'Y' AND NOT @process_phone_flag = 'Y' AND NOT @process_email_flag = 'Y'
		RETURN

    IF NOT EXISTS (SELECT 1 FROM oncd_contact WITH (NOLOCK) WHERE contact_id = @contact_id)
		RETURN

	IF NOT EXISTS (SELECT 1 FROM cstd_contact_skip_trace_events WHERE contact_id = @contact_id)
		INSERT INTO cstd_contact_skip_trace_events (contact_id) VALUES (@contact_id)

	SELECT
		@address_next_vendor_code =			CASE WHEN va.active = 'Y' THEN v.address_next_vendor_code ELSE @primary_address_vendor END,
		@address_next_vendor_delay_days =	CASE WHEN va.active = 'Y' THEN v.address_next_vendor_delay_days ELSE @primary_address_vendor_delay_days END,
		@phone_next_vendor_code =			CASE WHEN vp.active = 'Y' THEN v.phone_next_vendor_code ELSE @primary_phone_vendor END,
		@phone_next_vendor_delay_days =		CASE WHEN vp.active = 'Y' THEN v.phone_next_vendor_delay_days ELSE @primary_phone_vendor_delay_days END,
		@email_next_vendor_code =			CASE WHEN ve.active = 'Y' THEN v.email_next_vendor_code ELSE @primary_email_vendor END,
		@email_next_vendor_delay_days =		CASE WHEN ve.active = 'Y' THEN v.email_next_vendor_delay_days ELSE @primary_email_vendor_delay_days END
	FROM csta_skip_trace_vendor v
	LEFT OUTER JOIN csta_skip_trace_vendor va ON va.skip_trace_vendor_code = v.address_next_vendor_code
	LEFT OUTER JOIN csta_skip_trace_vendor vp ON vp.skip_trace_vendor_code = v.phone_next_vendor_code
	LEFT OUTER JOIN csta_skip_trace_vendor ve ON ve.skip_trace_vendor_code = v.email_next_vendor_code
	WHERE v.skip_trace_vendor_code = @vendor_code

	IF @process_address_flag = 'Y'
		UPDATE cstd_contact_skip_trace_events SET
			last_address_export_date = GETDATE(),
			last_address_export_vendor_code = @vendor_code,
			next_address_export_date = CASE WHEN @address_next_vendor_delay_days IS NULL OR @address_next_vendor_code IS NULL THEN NULL ELSE DATEADD(d, @address_next_vendor_delay_days, @begin_today) END,
			next_address_export_vendor_code = @address_next_vendor_code
			WHERE contact_id = @contact_id

	IF @process_phone_flag = 'Y'
		UPDATE cstd_contact_skip_trace_events SET
			last_phone_export_date = GETDATE(),
			last_phone_export_vendor_code = @vendor_code,
			next_phone_export_date = CASE WHEN @phone_next_vendor_delay_days IS NULL OR @phone_next_vendor_code IS NULL THEN NULL ELSE DATEADD(d, @phone_next_vendor_delay_days, @begin_today) END,
			next_phone_export_vendor_code = @phone_next_vendor_code
			WHERE contact_id = @contact_id

	IF @process_email_flag = 'Y'
		UPDATE cstd_contact_skip_trace_events SET
			last_email_export_date = GETDATE(),
			last_email_export_vendor_code = @vendor_code,
			next_email_export_date = CASE WHEN @email_next_vendor_delay_days IS NULL OR @email_next_vendor_code IS NULL THEN NULL ELSE DATEADD(d, @email_next_vendor_delay_days, @begin_today) END,
			next_email_export_vendor_code = @email_next_vendor_code
			WHERE contact_id = @contact_id

END
GO
