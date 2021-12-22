/* CreateDate: 01/30/2017 07:43:16.797 , ModifyDate: 01/30/2017 07:43:16.797 */
GO
/*
==============================================================================
PROCEDURE:				extHairClubCMSLeadSearch

DESTINATION SERVER:		SQL03

DESTINATION DATABASE: 	HCM

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		 01/25/2017

LAST REVISION DATE: 	 01/25/2017

==============================================================================
DESCRIPTION:	Used by cONEct! application to access On Contact data.
==============================================================================
NOTES:
		* 01/25/2017 MVT - Created (Moved from CMS DB)

==============================================================================
SAMPLE EXECUTION:
EXEC extHairClubCMSLeadSearch 292, '6/15/2015', '6/17/15', 1
==============================================================================
*/

CREATE PROCEDURE [dbo].[extHairClubCMSLeadSearch]
(
	@CenterNumber varchar(3),
	@LastName varchar(30) = NULL,
	@FirstName varchar(30) = NULL,
	@Phone varchar(10) = NULL,
	@City varchar(30) = NULL,
	@State varchar(2) = NULL,
	@Zip varchar(10) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT DISTINCT LTRIM(RTRIM(li.territory)) AS Territory, LTRIM(RTRIM(li.contact_id)) AS ContactID, LTRIM(RTRIM(li.alt_center)) AS AltCenter,
	    dbo.[pCase](LTRIM(RTRIM(ISNULL(li.last_name,'')))) + ', ' + dbo.[pCase](LTRIM(RTRIM(ISNULL(li.first_name,'')))) AS Name,
	    dbo.[pCase](LTRIM(RTRIM(li.city))) + CASE WHEN (NOT li.state_code IS NULL AND NOT li.city IS NULL) THEN ', ' ELSE ' ' END + LTRIM(RTRIM(li.state_code)) + ' ' + LTRIM(RTRIM(li.zip_code)) AS Address,
	    '(' + LTRIM(RTRIM(li.area_code)) + ') ' + LEFT(LTRIM(li.phone_number), 3) + '-' + RIGHT(RTRIM(li.phone_number), 4) AS Phone,
	    CASE WHEN ISNULL(li.cst_complete_sale, 0) = 0 THEN '' ELSE 'SOLD' END AS SaleStatus,
	    CASE WHEN cc.show_no_show_flag = 'S'
						--OR li.leadSourceCode like 'BOS%'  ***Removed per Michele Santagata
		THEN 'BEBACK' ELSE 'APPOINT' END AS ActionCode,
		accm.[description] AS Accommodation
	FROM lead_info li
			INNER JOIN oncd_contact c ON c.contact_id = li.contact_id
			LEFT JOIN csta_contact_accomodation accm ON accm.contact_accomodation_code = c.cst_contact_accomodation_code
			OUTER APPLY (
					SELECT  comp.contact_id,
							MAX(comp.show_no_show_flag) AS show_no_show_flag
					FROM cstd_contact_completion comp
					WHERE comp.contact_id = li.contact_id
					GROUP BY comp.contact_id
				) cc
	WHERE ( LTRIM(RTRIM(li.territory)) = @CenterNumber OR LTRIM(RTRIM(li.alt_center)) = @CenterNumber )
		AND ( LTRIM(RTRIM(li.contact_status_code)) NOT IN ( 'INVALID', 'TEST' ) )
		AND ( ISNULL(@LastName, '') = '' OR LTRIM(RTRIM(li.last_name)) LIKE @LastName + '%' )
		AND ( ISNULL(@FirstName, '') = '' OR LTRIM(RTRIM(li.first_name)) LIKE @FirstName + '%' )
		AND ( ISNULL(@Phone, '') = '' OR RTRIM(li.area_code) + RTRIM(li.phone_number) = @Phone )
		AND ( ISNULL(@City, '') = '' OR LTRIM(RTRIM(li.city))= @City )
		AND ( ISNULL(@Zip, '') = '' OR LTRIM(RTRIM(li.zip_code))= @Zip )
		AND ( (ISNULL(@State, '') = '') OR ( @CenterNumber = '201' AND LTRIM(RTRIM(li.state_code)) IN ('NY', 'NJ')) OR (@CenterNumber <> '201' AND LTRIM(RTRIM(li.state_code)) = @State) )
	GROUP BY li.territory, li.contact_id, li.alt_center, li.last_name, li.first_name, li.city,
	   li.state_code, li.zip_code, li.area_code, li.phone_number, li.cst_complete_sale, cc.show_no_show_flag,
	   li.leadSourceCode, accm.[description]
	ORDER BY [Name]

END
GO
