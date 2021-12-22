/* CreateDate: 12/04/2015 15:34:09.957 , ModifyDate: 12/04/2015 15:34:09.957 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Workwise, LLC	- MJW
-- Create date: 2015-10-12
-- Description:	Trigger skip trace export generation
--				Generate list of vendors needing processing
-- =============================================
CREATE PROCEDURE [dbo].[psoSkipTraceExport]

AS
BEGIN
	SET NOCOUNT ON

	DECLARE @working_vendor_code nchar(20)

	DECLARE @primary_address_vendor nvarchar(20)
	DECLARE @primary_email_vendor nvarchar(20)
	DECLARE @primary_phone_vendor nvarchar(20)

	SET @primary_address_vendor = (SELECT skip_trace_vendor_code FROM csta_skip_trace_vendor WHERE address_primary_vendor = 'Y' AND active = 'Y')
	SET @primary_email_vendor = (SELECT skip_trace_vendor_code FROM csta_skip_trace_vendor WHERE email_primary_vendor = 'Y' AND active = 'Y')
	SET @primary_phone_vendor = (SELECT skip_trace_vendor_code FROM csta_skip_trace_vendor WHERE phone_primary_vendor = 'Y' AND active = 'Y')

	TRUNCATE TABLE cstd_skip_trace_export_candidates
	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[cstd_skip_trace_export_candidates]') AND name = N'skiptraceexportcandidates_i1')
		DROP INDEX [skiptraceexportcandidates_i1] ON [dbo].[cstd_skip_trace_export_candidates] WITH ( ONLINE = OFF )
	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[cstd_skip_trace_export_candidates]') AND name = N'skiptraceexportcandidates_i2')
		DROP INDEX [skiptraceexportcandidates_i2] ON [dbo].[cstd_skip_trace_export_candidates] WITH ( ONLINE = OFF )


	--DECLARE vendors CURSOR FOR
	INSERT INTO cstd_skip_trace_export_candidates (contact_id, needs_address, needs_phone, needs_email, address_next_vendor_code, phone_next_vendor_code, email_next_vendor_code)
	SELECT u.*
		, CASE WHEN e.contact_id IS NULL THEN @primary_address_vendor WHEN e.next_address_export_date > GETDATE() THEN NULL ELSE next_address_export_vendor_code END AS address_next_vendor_code
		, CASE WHEN e.contact_id IS NULL THEN @primary_phone_vendor WHEN e.next_phone_export_date > GETDATE() THEN NULL ELSE next_phone_export_vendor_code END AS phone_next_vendor_code
		, CASE WHEN e.contact_id IS NULL THEN @primary_email_vendor WHEN e.next_email_export_date > GETDATE() THEN NULL ELSE next_email_export_vendor_code END AS email_next_vendor_code
	FROM
	(
	SELECT DISTINCT t.contact_id, MAX(needs_address) AS needs_address, MAX(needs_phone) AS needs_phone, MAX(needs_email) AS needs_email FROM
	(
	SELECT c.contact_id, 1 AS needs_address, 0 AS needs_email, 0 AS needs_phone
		FROM oncd_contact c WITH (NOLOCK)
	INNER JOIN cstd_skip_trace_export_contact_list cl ON cl.contact_id = c.contact_id
		WHERE NOT EXISTS (SELECT 1 FROM oncd_contact_address WITH (NOLOCK) WHERE contact_id = c.contact_id AND cst_valid_flag = 'Y')
	UNION ALL
	SELECT c.contact_id, 0 AS needs_address, 1 AS needs_email, 0 AS needs_phone
		FROM oncd_contact c WITH (NOLOCK)
	INNER JOIN cstd_skip_trace_export_contact_list cl ON cl.contact_id = c.contact_id
		WHERE NOT EXISTS (SELECT 1 FROM oncd_contact_email WITH (NOLOCK) WHERE contact_id = c.contact_id AND cst_valid_flag = 'Y')
	UNION ALL
	SELECT c.contact_id, 0 AS needs_address, 0 AS needs_email, 1 AS needs_phone
		FROM oncd_contact c WITH (NOLOCK)
	INNER JOIN cstd_skip_trace_export_contact_list cl ON cl.contact_id = c.contact_id
		WHERE NOT EXISTS (SELECT 1 FROM oncd_contact_phone WITH (NOLOCK) WHERE contact_id = c.contact_id AND cst_valid_flag = 'Y')
	) t
	WHERE t.contact_id IN
	(
		SELECT c.contact_id FROM oncd_contact c WITH (NOLOCK)
			INNER JOIN cstd_skip_trace_export_contact_list cl ON cl.contact_id = c.contact_id
		WHERE c.contact_status_code = 'LEAD'
			AND (c.creation_date >= DATEADD(yy,-4,GETDATE())
				OR EXISTS (SELECT 1 FROM oncd_activity_contact ac WITH (NOLOCK) INNER JOIN oncd_activity a WITH (NOLOCK) ON ac.activity_id = a.activity_id WHERE ac.contact_id = c.contact_id AND (a.creation_date > DATEADD(yy,-4,GETDATE()) OR a.updated_date > DATEADD(yy,-4,GETDATE())))
				)
	)
	GROUP BY t.contact_id
	) u
	LEFT OUTER JOIN cstd_contact_skip_trace_events e ON e.contact_id = u.contact_id
	ORDER BY u.contact_id
PRINT 'Select completed at            ' + CONVERT(nchar(23),GETDATE(),121)

	--index for UPDATES
	CREATE NONCLUSTERED INDEX skiptraceexportcandidates_i1 ON cstd_skip_trace_export_candidates(contact_id)
PRINT 'Indexed at                              ' + CONVERT(nchar(23),GETDATE(),121)


	--respect active status of vendor; use primary vendor if not active
	UPDATE c
	SET address_next_vendor_code = @primary_address_vendor
	FROM cstd_skip_trace_export_candidates c
	INNER JOIN csta_skip_trace_vendor v ON v.skip_trace_vendor_code = c.address_next_vendor_code
	WHERE v.active = 'N'

	UPDATE c
	SET phone_next_vendor_code = @primary_phone_vendor
	FROM cstd_skip_trace_export_candidates c
	INNER JOIN csta_skip_trace_vendor v ON v.skip_trace_vendor_code = c.phone_next_vendor_code
	WHERE v.active = 'N'

	UPDATE c
	SET email_next_vendor_code = @primary_email_vendor
	FROM cstd_skip_trace_export_candidates c
	INNER JOIN csta_skip_trace_vendor v ON v.skip_trace_vendor_code = c.email_next_vendor_code
	WHERE v.active = 'N'


	--TransUnion Updates
	--Address must exist to be processed, otherwise skip to next vendor
	UPDATE cstd_skip_trace_export_candidates
	SET address_next_vendor_code = (SELECT address_next_vendor_code FROM csta_skip_trace_vendor WHERE skip_trace_vendor_code = cstd_skip_trace_export_candidates.address_next_vendor_code AND address_next_vendor_code <> 'TRU0000001' AND active = 'Y')
	WHERE address_next_vendor_code = 'TRU0000001' AND
		NOT EXISTS (SELECT 1 FROM oncd_contact_address WHERE contact_id = cstd_skip_trace_export_candidates.contact_id
			AND ((ISNULL(city,'') <> '' AND ISNULL(state_code,'') <> '') OR ISNULL(zip_code,'') <> ''))
	UPDATE cstd_skip_trace_export_candidates
	SET phone_next_vendor_code = (SELECT phone_next_vendor_code FROM csta_skip_trace_vendor WHERE skip_trace_vendor_code = cstd_skip_trace_export_candidates.phone_next_vendor_code AND phone_next_vendor_code <> 'TRU0000001' AND active = 'Y')
	WHERE phone_next_vendor_code = 'TRU0000001' AND
		NOT EXISTS (SELECT 1 FROM oncd_contact_address WHERE contact_id = cstd_skip_trace_export_candidates.contact_id
			AND ((ISNULL(city,'') <> '' AND ISNULL(state_code,'') <> '') OR ISNULL(zip_code,'') <> ''))
	UPDATE cstd_skip_trace_export_candidates
	SET email_next_vendor_code = (SELECT email_next_vendor_code FROM csta_skip_trace_vendor WHERE skip_trace_vendor_code = cstd_skip_trace_export_candidates.email_next_vendor_code AND email_next_vendor_code <> 'TRU0000001' AND active = 'Y')
	WHERE email_next_vendor_code = 'TRU0000001' AND
		NOT EXISTS (SELECT 1 FROM oncd_contact_address WHERE contact_id = cstd_skip_trace_export_candidates.contact_id
			AND ((ISNULL(city,'') <> '' AND ISNULL(state_code,'') <> '') OR ISNULL(zip_code,'') <> ''))

	--End TransUnionUpdates


	UPDATE cstd_skip_trace_export_candidates SET next_vendor_code = CASE WHEN needs_address = 1 AND address_next_vendor_code IS NOT NULL THEN address_next_vendor_code WHEN needs_phone = 1 AND phone_next_vendor_code IS NOT NULL THEN phone_next_vendor_code WHEN needs_email = 1 AND email_next_vendor_code IS NOT NULL THEN email_next_vendor_code END

	CREATE NONCLUSTERED INDEX skiptraceexportcandidates_i2 ON cstd_skip_trace_export_candidates(next_vendor_code)

	SELECT DISTINCT next_vendor_code FROM cstd_skip_trace_export_candidates WHERE next_vendor_code IS NOT NULL
	--OPEN vendors
	--FETCH vendors INTO @working_vendor_code
	--WHILE @@FETCH_STATUS = 0
	--BEGIN
	--	EXEC psoSkipTraceExportForVendor @working_vendor_code

	--	FETCH vendors INTO @working_vendor_code
	--END

	--CLOSE vendors
	--DEALLOCATE vendors

--	EXEC xp_cmdshell 'BCP "SELECT * FROM sys.objects" queryout "\\wwsql2014\mssql\temp.txt" -c -T -t "|"'

END


/****** Object:  StoredProcedure [dbo].[psoSkipTraceExportSetSkipTraceEventsForContact]    Script Date: 12/3/2015 11:55:27 AM ******/
SET ANSI_NULLS ON
GO
