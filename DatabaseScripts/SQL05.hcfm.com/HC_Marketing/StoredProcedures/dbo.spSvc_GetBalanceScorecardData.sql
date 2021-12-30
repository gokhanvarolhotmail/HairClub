/* CreateDate: 11/16/2019 12:13:39.200 , ModifyDate: 08/27/2020 15:03:10.093 */
GO
/***********************************************************************
PROCEDURE:				spSvc_GetBalanceScorecardData
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Marketing
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		04/28/2020
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_GetBalanceScorecardData 2020
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_GetBalanceScorecardData]
(
	@Year INT
)
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


DECLARE @Column01 NVARCHAR(50) = '1/1/' + CONVERT(NVARCHAR, @Year)
DECLARE @Column02 NVARCHAR(50) = '2/1/' + CONVERT(NVARCHAR, @Year)
DECLARE @Column03 NVARCHAR(50) = '3/1/' + CONVERT(NVARCHAR, @Year)
DECLARE @Column04 NVARCHAR(50) = '4/1/' + CONVERT(NVARCHAR, @Year)
DECLARE @Column05 NVARCHAR(50) = '5/1/' + CONVERT(NVARCHAR, @Year)
DECLARE @Column06 NVARCHAR(50) = '6/1/' + CONVERT(NVARCHAR, @Year)
DECLARE @Column07 NVARCHAR(50) = '7/1/' + CONVERT(NVARCHAR, @Year)
DECLARE @Column08 NVARCHAR(50) = '8/1/' + CONVERT(NVARCHAR, @Year)
DECLARE @Column09 NVARCHAR(50) = '9/1/' + CONVERT(NVARCHAR, @Year)
DECLARE @Column10 NVARCHAR(50) = '10/1/' + CONVERT(NVARCHAR, @Year)
DECLARE @Column11 NVARCHAR(50) = '11/1/' + CONVERT(NVARCHAR, @Year)
DECLARE @Column12 NVARCHAR(50) = '12/1/' + CONVERT(NVARCHAR, @Year)


DECLARE @SQL NVARCHAR(MAX)


SET @SQL = '
			SELECT	s.Organization
			,		s.Level1
			,		s.Level2
			,		s.Level3
			,		s.Level4
			,		s.Level5
			,		s.Level6
			,		s.Period01 AS ''' + @Column01 + '''
			,		s.Period02 AS ''' + @Column02 + '''
			,		s.Period03 AS ''' + @Column03 + '''
			,		s.Period04 AS ''' + @Column04 + '''
			,		s.Period05 AS ''' + @Column05 + '''
			,		s.Period06 AS ''' + @Column06 + '''
			,		s.Period07 AS ''' + @Column07 + '''
			,		s.Period08 AS ''' + @Column08 + '''
			,		s.Period09 AS ''' + @Column09 + '''
			,		s.Period10 AS ''' + @Column10 + '''
			,		s.Period11 AS ''' + @Column11 + '''
			,		s.Period12 AS ''' + @Column12 + '''
			FROM	datScorecard s
			ORDER BY s.OrganizationType
			,		s.SortOrder
			,		s.Organization
			'

EXECUTE(@SQL)

END
GO
