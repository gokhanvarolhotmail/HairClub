/* CreateDate: 12/11/2012 14:57:18.853 , ModifyDate: 12/11/2012 14:57:18.853 */
GO
/*
==============================================================================
PROCEDURE:				extOnContactLeadSearch

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Dominic Leiba

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		 7/29/2008

LAST REVISION DATE: 	 5/7/2010

==============================================================================
DESCRIPTION:	Interface with OnContact database
==============================================================================
NOTES:
		* 5/7/2010 PRM - Copied from TRE stored proc: spApp_TREConsultations_LeadSearch
		* 5/12/2010 CV - Removed the logic to execute a string and converted it to a normal TSQL statement

==============================================================================
SAMPLE EXECUTION:
EXEC extOnContactLeadSearch '261', 'Mote', 'Wayne', '', '', 'LA', ''
==============================================================================
*/

CREATE PROCEDURE [dbo].[extOnContactLeadSearch]
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
	SET NOCOUNT ON

	SELECT DISTINCT LTRIM(RTRIM(li.territory)) AS Territory, LTRIM(RTRIM(li.contact_id)) AS ContactID, LTRIM(RTRIM(li.alt_center)) AS AltCenter,
	    dbo.[pCase](LTRIM(RTRIM(ISNULL(li.last_name,'')))) + ', ' + dbo.[pCase](LTRIM(RTRIM(ISNULL(li.first_name,'')))) AS Name,
	    dbo.[pCase](LTRIM(RTRIM(li.city))) + CASE WHEN (NOT li.state_code IS NULL AND NOT li.city IS NULL) THEN ', ' ELSE ' ' END + LTRIM(RTRIM(li.state_code)) + ' ' + LTRIM(RTRIM(li.zip_code)) AS Address,
	    '(' + LTRIM(RTRIM(li.area_code)) + ') ' + LEFT(LTRIM(li.phone_number), 3) + '-' + RIGHT(RTRIM(li.phone_number), 4) AS Phone,
	    CASE WHEN ISNULL(li.cst_complete_sale, 0) = 0 THEN '' ELSE 'SOLD' END AS SaleStatus,
	    CASE WHEN cc.show_no_show_flag = 'S' THEN 'BEBACK' ELSE 'APPOint' END AS ActionCode
	FROM HCMSkylineTest..lead_info li
			LEFT JOIN ( SELECT  contact_id, MAX(show_no_show_flag) AS show_no_show_flag
					FROM HCMSkylineTest..cstd_contact_completion
					GROUP BY contact_id ) cc ON li.contact_id = cc.contact_id
	WHERE ( LTRIM(RTRIM(li.territory)) = @CenterNumber OR LTRIM(RTRIM(li.alt_center)) = @CenterNumber )
		AND ( LTRIM(RTRIM(li.contact_status_code)) NOT IN ( 'INVALID', 'TEST' ) )
		AND ( ISNULL(@LastName, '') = '' OR LTRIM(RTRIM(li.last_name)) LIKE @LastName + '%' )
		AND ( ISNULL(@FirstName, '') = '' OR LTRIM(RTRIM(li.first_name)) LIKE @FirstName + '%' )
		AND ( ISNULL(@Phone, '') = '' OR RTRIM(li.area_code) + RTRIM(li.phone_number) = @Phone )
		AND ( ISNULL(@City, '') = '' OR LTRIM(RTRIM(li.city))= @City )
		AND ( ISNULL(@Zip, '') = '' OR LTRIM(RTRIM(li.zip_code))= @Zip )
		AND ( (ISNULL(@State, '') = '') OR ( @CenterNumber = '201' AND LTRIM(RTRIM(li.state_code)) IN ('NY', 'NJ')) OR (@CenterNumber <> '201' AND LTRIM(RTRIM(li.state_code)) = @State) )
	GROUP BY li.territory, li.contact_id, li.alt_center, li.last_name, li.first_name, li.city,
	   li.state_code, li.zip_code, li.area_code, li.phone_number, li.cst_complete_sale, cc.show_no_show_flag
	ORDER BY [Name]
END
GO
