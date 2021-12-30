/* CreateDate: 09/22/2008 15:07:43.877 , ModifyDate: 10/12/2009 18:58:08.573 */
GO
/*===============================================================================================
-- Procedure Name:			spApp_TREConsultations_LeadSearch
-- Procedure Description:
--
-- Created By:				Dominic Leiba
-- Implemented By:			Dominic Leiba
-- Last Modified By:		Dominic Leiba
--
-- Date Created:			7/29/2008
-- Date Implemented:		7/29/2008
-- Date Last Modified:		7/29/2008
--
-- Destination Server:		HCSQL3\SQL2005
-- Destination Database:	BOS
-- Related Application:		The Right Experience
--
-- ----------------------------------------------------------------------------------------------
-- Notes:
--
-- 03/12/2009 - DL	--> Joined on [cstd_contact_completion] table to check the total number of days
					--> since a lead's last SHOW.
					--> This was used to determine if a lead was an APPOINT (last SHOW was greater than 45 days)
					--> or BEBACK (last SHOW was within 45 days).
-- 05/06/2009 - DL	--> Removed the 45 day rule amendment as per request from MO.
-- 05/07/2009 - DL	--> NOSHOWs were being counted as BEBACKs. This was incorrect.
					--> Changed logic to only count leads who have had a SHOW as a BEBACK.
-- 05/07/2009 - DL	--> Added [contact_status_code] column to the [lead_info] view.
					--> Excluded leads with a status code of INVALID or TEST from query results.
-- 10/09/2009 - DL	--> Trimmed first name and last name
-- ----------------------------------------------------------------------------------------------
--
Sample Execution:
--
EXEC spApp_TREConsultations_LeadSearch '261', 'Mote', 'Wayne', '', '', 'LA', ''
================================================================================================*/
CREATE PROCEDURE [dbo].[spApp_TREConsultations_LeadSearch]
(
	@CenterNumber VARCHAR(3),
	@LastName VARCHAR(30) = NULL,
	@FirstName VARCHAR(30) = NULL,
	@Phone VARCHAR(10) = NULL,
	@City VARCHAR(30) = NULL,
	@State VARCHAR(2) = NULL,
	@Zip VARCHAR(10) = NULL
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--==============================================================================
	-- STEP 1: 	Build Filter Criteria
	--==============================================================================
	DECLARE @SearchCriteria VARCHAR(5000)

	SELECT @SearchCriteria = ' WHERE (LTRIM(RTRIM([lead_info].[territory])) = ''' + @CenterNumber + ''' OR LTRIM(RTRIM([lead_info].[alt_center])) = ''' + @CenterNumber + ''')'
	SELECT  @SearchCriteria = @SearchCriteria + ' AND LTRIM(RTRIM([lead_info].[contact_status_code])) NOT IN ( ''INVALID'', ''TEST'' )'

	-- Last Name.
	IF ISNULL(@LastName, '') <> ''
	  BEGIN
		SELECT  @SearchCriteria = @SearchCriteria + ' AND LTRIM(RTRIM([lead_info].[last_name])) LIKE ''' + @LastName + '%'''
	  END

	-- First Name.
	IF ISNULL(@FirstName, '') <> ''
	  BEGIN
		SELECT  @SearchCriteria = @SearchCriteria + ' AND LTRIM(RTRIM([lead_info].[first_name])) LIKE ''' + @FirstName + '%'''
	  END

	-- Phone.
	IF ISNULL(@Phone, '') <> ''
	  BEGIN
		SELECT  @SearchCriteria = @SearchCriteria + ' AND RTRIM([lead_info].[area_code]) + RTRIM([lead_info].[phone_number]) = ''' + @Phone + ''''
	  END

	-- City.
	IF ISNULL(@City, '') <> ''
	  BEGIN
		SELECT  @SearchCriteria = @SearchCriteria + ' AND LTRIM(RTRIM([lead_info].[city])) = ''' + @City + ''''
	  END

	-- State.
	IF @CenterNumber = '201' AND ISNULL(@State, '') <> ''
	  BEGIN
		SELECT  @SearchCriteria = @SearchCriteria + ' AND LTRIM(RTRIM([lead_info].[state_code])) IN ( ''NY'', ''NJ'' )'
	  END
	ELSE
	  BEGIN
		SELECT  @SearchCriteria = @SearchCriteria + ' AND LTRIM(RTRIM([lead_info].[state_code])) = ''' + @State + ''''
	  END

	-- Zip.
	IF ISNULL(@Zip, '') <> ''
	  BEGIN
		SELECT  @SearchCriteria = @SearchCriteria + ' AND LTRIM(RTRIM([lead_info].[zip_code])) = ''' + @Zip + ''''
	  END

	--==============================================================================
	-- STEP 2: 	Build SQL Query
	--==============================================================================
	DECLARE @SQL VARCHAR(5000)

	SELECT @SQL = 'SELECT DISTINCT '
	SELECT @SQL = @SQL + ' LTRIM(RTRIM([lead_info].[territory])) AS ''Territory'','
	SELECT @SQL = @SQL + ' LTRIM(RTRIM([lead_info].[contact_id])) AS ''ContactID'','
	SELECT @SQL = @SQL + ' LTRIM(RTRIM([lead_info].[alt_center])) AS ''AltCenter'','
	SELECT @SQL = @SQL + ' [dbo].[pCase](LTRIM(RTRIM(ISNULL([lead_info].[last_name],'''')))) + '', '' + [dbo].[pCase](LTRIM(RTRIM(ISNULL([lead_info].[first_name],'''')))) AS ''Name'','
	SELECT @SQL = @SQL + ' [dbo].[pCase](LTRIM(RTRIM([lead_info].[city]))) + '' '' + LTRIM(RTRIM([lead_info].[state_code])) + '' '' + LTRIM(RTRIM([lead_info].[zip_code])) AS ''Address'','
	SELECT @SQL = @SQL + ' ''('' + LTRIM(RTRIM([lead_info].[area_code])) + '') '' + LEFT(LTRIM([lead_info].[phone_number]), 3) + ''-'' + RIGHT(RTRIM([lead_info].[phone_number]), 4) AS ''Phone'','
	SELECT @SQL = @SQL + ' CASE WHEN ISNULL([lead_info].[cst_complete_sale], 0) = 0 THEN '''' '
	SELECT @SQL = @SQL + ' ELSE ''SOLD'' '
	SELECT @SQL = @SQL + ' END AS ''SaleStatus'','
	SELECT @SQL = @SQL + ' CASE WHEN [cstd_contact_completion].[show_no_show_flag] = ''S'' THEN ''BEBACK'' '
	SELECT @SQL = @SQL + ' ELSE ''APPOINT'' '
	SELECT @SQL = @SQL + ' END AS ''ActionCode'' '
	SELECT @SQL = @SQL + ' FROM [HCM].[dbo].[lead_info]'
	SELECT @SQL = @SQL + ' LEFT OUTER JOIN ( SELECT  [contact_id]'
	SELECT @SQL = @SQL + ' ,       MAX([show_no_show_flag]) AS ''show_no_show_flag'' '
	SELECT @SQL = @SQL + ' FROM    [HCM].[dbo].[cstd_contact_completion]'
	SELECT @SQL = @SQL + ' GROUP BY [contact_id] ) cstd_contact_completion '
	SELECT @SQL = @SQL + ' ON [lead_info].[contact_id] = [cstd_contact_completion].[contact_id]'
	SELECT @SQL = @SQL + @SearchCriteria
	SELECT @SQL = @SQL + ' GROUP BY [lead_info].[territory],'
	SELECT @SQL = @SQL + ' [lead_info].[contact_id],'
	SELECT @SQL = @SQL + ' [lead_info].[alt_center],'
	SELECT @SQL = @SQL + ' [lead_info].[last_name],'
	SELECT @SQL = @SQL + ' [lead_info].[first_name],'
	SELECT @SQL = @SQL + ' [lead_info].[city],'
	SELECT @SQL = @SQL + ' [lead_info].[state_code],'
	SELECT @SQL = @SQL + ' [lead_info].[zip_code],'
	SELECT @SQL = @SQL + ' [lead_info].[area_code],'
	SELECT @SQL = @SQL + ' [lead_info].[phone_number],'
	SELECT @SQL = @SQL + ' [lead_info].[cst_complete_sale],'
	SELECT @SQL = @SQL + ' [cstd_contact_completion].[show_no_show_flag]'
	SELECT @SQL = @SQL + ' ORDER BY [Name]'

	--==============================================================================
	-- STEP 3: 	Output results
	--==============================================================================
	EXEC(@SQL)
END
GO
