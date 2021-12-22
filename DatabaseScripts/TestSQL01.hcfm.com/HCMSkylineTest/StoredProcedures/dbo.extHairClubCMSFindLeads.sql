/* CreateDate: 11/05/2015 11:12:22.540 , ModifyDate: 11/05/2015 11:12:22.540 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================
PROCEDURE:				extHairClubCMSFindLeads

DESTINATION SERVER:		SQL03

DESTINATION DATABASE: 	HCM

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		 01/06/2014

LAST REVISION DATE: 	 01/06/2014

==============================================================================
DESCRIPTION:	Used by cONEct! application to access On Contact Leads
==============================================================================
NOTES:
		* 01/06/2014 MVT - Created (Moved from CMS DB)
		* 11/05/2015 MVT - Modified to return lead as BeBack if lead source starts with 'BOS'

==============================================================================
SAMPLE EXECUTION:
EXEC [extHairClubCMSFindLeads] '292', 'smith', NULL, NULL, NULL, NULL, NULL
==============================================================================
*/

CREATE PROCEDURE [dbo].[extHairClubCMSFindLeads]
(
	@CenterNumber varchar(3),
	@LastName varchar(30) = '',
	@FirstName varchar(30) = '',
	@Phone varchar(10) = '',
	@City varchar(30) = '',
	@State varchar(2) = '',
	@Zip varchar(10) = ''
)
AS
BEGIN
	SET NOCOUNT ON

	SET @LastName = ISNULL(@LastName,'')
	SET @FirstName = ISNULL(@FirstName,'')
	SET @Phone = ISNULL(@Phone,'')
	SET @City = ISNULL(@City,'')
	SET @State = ISNULL(@State,'')
	SET @Zip = ISNULL(@Zip,'')


	SELECT
		DISTINCT
		CASE WHEN co.cst_center_number IS NULL THEN LTRIM(RTRIM(coa.cst_center_number)) ELSE LTRIM(RTRIM(co.cst_center_number)) END AS Territory,
		LTRIM(RTRIM(c.contact_id)) AS ContactID,
		CASE WHEN co.cst_center_number IS NOT NULL THEN LTRIM(RTRIM(coa.cst_center_number)) ELSE NULL END AS AltCenter,
	    dbo.[pCase](LTRIM(RTRIM(ISNULL(c.last_name,'')))) + ', ' + dbo.[pCase](LTRIM(RTRIM(ISNULL(c.first_name,'')))) AS Name,
	    dbo.[pCase](LTRIM(RTRIM(ca.city))) + CASE WHEN (NOT ca.state_code IS NULL AND NOT ca.city IS NULL) THEN ', ' ELSE ' ' END + LTRIM(RTRIM(ca.state_code)) + ' ' + LTRIM(RTRIM(ca.zip_code)) AS Address,
	    '(' + LTRIM(RTRIM(cp.area_code)) + ') ' + LEFT(LTRIM(cp.phone_number), 3) + '-' + RIGHT(RTRIM(cp.phone_number), 4) AS Phone,
	    CASE WHEN ISNULL(c.cst_complete_sale, 0) = 0 THEN '' ELSE 'SOLD' END AS SaleStatus,
	    CASE WHEN ccomp.show_no_show_flag = 'S' OR cs.source_code like 'BOS%' THEN 'BEBACK' ELSE 'APPOINT' END AS ActionCode
	FROM dbo.oncd_contact AS c
            LEFT OUTER JOIN dbo.oncd_contact_phone AS cp ON cp.contact_id = c.contact_id
                                                            AND cp.primary_flag = 'Y'
            LEFT OUTER JOIN dbo.oncd_contact_address AS ca ON ca.contact_id = c.contact_id
                                                              AND ca.primary_flag = 'Y'
            LEFT OUTER JOIN dbo.oncd_contact_company AS cc ON cc.contact_id = c.contact_id
                                              AND cc.primary_flag <> 'Y'
			LEFT OUTER JOIN dbo.oncd_contact_source AS cs ON cs.contact_id = c.contact_id
                                              AND cs.primary_flag <> 'Y'
            --LEFT OUTER JOIN dbo.oncd_contact_company AS cca ON --c.contact_id = cca.contact_id and
            --                                                   cca.contact_company_id = ( SELECT TOP ( 1 )
            --                                                                                            contact_company_id
            --                                                                                  FROM      dbo.oncd_contact_company
            --                                                                                  WHERE     ( contact_id = c.contact_id )
            --                                                                                            AND ( primary_flag = 'Y' )
            --                                                                                )
			OUTER APPLY (
				SELECT TOP(1) *
				FROM      dbo.oncd_contact_company
                WHERE     contact_id = c.contact_id
						AND  primary_flag = 'Y' ) cca
            LEFT OUTER JOIN dbo.oncd_company AS co ON co.company_id = cc.company_id
            LEFT OUTER JOIN dbo.oncd_company AS coa ON coa.company_id = cca.company_id
            LEFT OUTER JOIN dbo.cstd_company_zip_code AS cz ON coa.company_id = cz.company_id
                                               AND cz.zip_from = ca.zip_code
			OUTER APPLY (
				SELECT  contact_id, MAX(show_no_show_flag) AS show_no_show_flag
					FROM cstd_contact_completion
					WHERE contact_id = c.contact_id
					GROUP BY contact_id ) ccomp

			--LEFT JOIN ( SELECT  contact_id, MAX(show_no_show_flag) AS show_no_show_flag
			--		FROM cstd_contact_completion
			--		WHERE contact_id = c.contact_id
			--		GROUP BY contact_id ) ccomp ON c.contact_id = ccomp.contact_id
	WHERE ( LTRIM(RTRIM(co.cst_center_number)) = @CenterNumber OR LTRIM(RTRIM(coa.cst_center_number)) = @CenterNumber )
		AND ( LTRIM(RTRIM(c.contact_status_code)) NOT IN ( 'INVALID', 'TEST' ) )
		AND ( @LastName = '' OR LTRIM(RTRIM(c.last_name)) LIKE @LastName + '%' )
		AND ( @FirstName = '' OR LTRIM(RTRIM(c.first_name)) LIKE @FirstName + '%' )
		AND ( @Phone = '' OR RTRIM(cp.area_code) + RTRIM(cp.phone_number) = @Phone )
		AND ( @City = '' OR LTRIM(RTRIM(ca.city))= @City )
		AND ( @Zip = '' OR LTRIM(RTRIM(ca.zip_code))= @Zip )
		AND ( (@State = '') OR ( @CenterNumber = '201' AND LTRIM(RTRIM(ca.state_code)) IN ('NY', 'NJ')) OR (@CenterNumber <> '201' AND LTRIM(RTRIM(ca.state_code)) = @State) )
	GROUP BY co.cst_center_number, coa.cst_center_number,  c.contact_id, c.last_name, c.first_name, ca.city,
	   ca.state_code, ca.zip_code, cp.area_code, cp.phone_number, c.cst_complete_sale, ccomp.show_no_show_flag, cs.source_code
	ORDER BY [Name]
END
GO
