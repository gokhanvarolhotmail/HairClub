/* CreateDate: 01/30/2017 13:49:16.803 , ModifyDate: 07/11/2017 10:43:01.323 */
GO
CREATE PROCEDURE [dbo].[extHairClubCMSLeadSearch]
(
	@CenterNumber nvarchar(10),
	@LastName nvarchar(50) = NULL,
	@FirstName nvarchar(50) = NULL,
	@Phone nvarchar(30) = NULL,
	@City nvarchar(60) = NULL,
	@State nvarchar(20) = NULL,
	@Zip nvarchar(15) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	SET @LastName = ISNULL(@LastName, '');
	SET @FirstName = ISNULL(@FirstName, '');
	SET @Phone = ISNULL(@Phone, '');
	SET @City = ISNULL(@City, '');
	SET @State = ISNULL(@State, '');
	SET @Zip = ISNULL(@Zip, '');

	SELECT
		CASE WHEN co.cst_center_number IS NULL THEN coa.cst_center_number ELSE co.cst_center_number END AS Territory,
		c.contact_id AS ContactID,
		CASE WHEN co.cst_center_number IS NOT NULL THEN coa.cst_center_number ELSE NULL END AS AltCenter,
	    dbo.[pCase](LTRIM(RTRIM(ISNULL(c.last_name,'')))) + ', ' + dbo.[pCase](LTRIM(RTRIM(ISNULL(c.first_name,'')))) AS [Name],
	    dbo.[pCase](LTRIM(RTRIM(ca.city))) +
			CASE
				WHEN (NOT ca.state_code IS NULL AND NOT ca.city IS NULL) THEN ', '
				ELSE ' '
			END +
			ca.state_code + ' ' + LTRIM(RTRIM(ca.zip_code)) AS [Address],
	    '(' + LTRIM(RTRIM(cp.area_code)) + ') ' + LEFT(LTRIM(cp.phone_number), 3) + '-' + RIGHT(RTRIM(cp.phone_number), 4) AS Phone,
	    CASE
			WHEN ISNULL(c.cst_complete_sale, 0) = 0 THEN N''
			ELSE N'SOLD'
		END AS SaleStatus,
	    CASE
			WHEN MAX(comp.show_no_show_flag) = N'S' /* OR li.leadSourceCode like 'BOS%'  ***Removed per Michele Santagata */ THEN N'BEBACK'
			ELSE N'APPOINT'
		END AS ActionCode,
		accm.[description] AS Accommodation
	FROM
		dbo.oncd_contact AS c
	LEFT OUTER JOIN
		dbo.oncd_contact_phone AS cp ON cp.contact_id = c.contact_id AND cp.primary_flag = 'Y'
	LEFT OUTER JOIN
		dbo.oncd_contact_address AS ca ON ca.contact_id = c.contact_id AND ca.primary_flag = 'Y'
	LEFT OUTER JOIN
		dbo.oncd_contact_company AS cc  ON c.contact_id =  cc.contact_id AND  cc.primary_flag <> 'Y'
	LEFT OUTER JOIN
		dbo.oncd_contact_company AS cca ON c.contact_id = cca.contact_id and cca.primary_flag = 'Y'
	LEFT OUTER JOIN
		dbo.oncd_company AS co ON co.company_id = cc.company_id
	LEFT OUTER JOIN
		dbo.oncd_company AS coa ON coa.company_id = cca.company_id
	LEFT JOIN
		csta_contact_accomodation accm ON accm.contact_accomodation_code = c.cst_contact_accomodation_code
	LEFT JOIN
		cstd_contact_completion comp ON comp.contact_id = c.contact_id
	WHERE
		1=1
		AND ( CASE WHEN co.cst_center_number IS NULL THEN coa.cst_center_number ELSE co.cst_center_number END = @CenterNumber OR CASE WHEN co.cst_center_number IS NOT NULL THEN coa.cst_center_number ELSE NULL END = @CenterNumber )
		AND ( c.contact_status_code NOT IN ( N'INVALID', N'TEST' ) )
		AND ( @LastName = '' OR c.last_name LIKE N'[ ]%' + @LastName + '%' OR c.last_name LIKE @LastName + '%' )
		AND ( @FirstName = '' OR c.first_name LIKE N'[ ]%' + @FirstName + '%' OR c.first_name LIKE @FirstName + '%' )
		AND ( @Phone = '' OR RTRIM(cp.area_code) + RTRIM(cp.phone_number) = @Phone )
		AND ( @City = '' OR ca.city LIKE N'[ ]%' + @City + '%' OR ca.city LIKE @City + '%' )
		AND ( @Zip = '' OR ca.zip_code LIKE N'[ ]%' + @Zip + '%' OR ca.zip_code LIKE @Zip + '%' )
		AND ( (@State = '') OR ( @CenterNumber = N'201' AND ca.state_code IN (N'NY', N'NJ')) OR (@CenterNumber <> N'201' AND ca.state_code = @State) )
	GROUP BY
		CASE WHEN co.cst_center_number IS NULL THEN coa.cst_center_number ELSE co.cst_center_number END,
		c.contact_id,
		CASE WHEN co.cst_center_number IS NOT NULL THEN coa.cst_center_number ELSE NULL END,
		c.last_name,
		c.first_name,
		ca.city,
		ca.state_code,
		ca.zip_code,
		cp.area_code,
		cp.phone_number,
		c.cst_complete_sale,
		accm.[description]
	ORDER BY
		[Name]
	OPTION (RECOMPILE)
END
GO
