/* CreateDate: 01/27/2011 22:24:13.737 , ModifyDate: 02/09/2022 08:24:40.423 */
GO
/***********************************************************************

PROCEDURE:				selADCentersFromUserNameForReporting

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Michael Maass

IMPLEMENTOR: 			Michael Maass

DATE IMPLEMENTED: 		1/14/11

LAST REVISION DATE: 	* 01/14/11 - MLM: Copied selADCentersFromUserNameForReporting and Added rows for
										'JV', 'Franchise', 'Corporate' and 'HQ' to the Results
						* 01/25/11 - MLM: Changed the Stored Procedure to Pass in the EmployeeGUID instead of UserLogin
						* 09/14/2017 - DP: Changed the Order By to CenterDescriptionFullCalc so it sorts alphabetically in report.
						* 09/17/2017 - RH: Removed unused code, Changed to match selADCentersFromUserName

--------------------------------------------------------------------------------------------------------
NOTES: 	Returns the centers the user has access to.
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

selADCentersFromUserNameForReporting 'aptak'

***********************************************************************/

CREATE PROCEDURE [dbo].[selADCentersFromUserNameForReporting] (@User VARCHAR(100))
AS
BEGIN

    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


DECLARE @Center TABLE (
	CenterID INT
,	CenterName NVARCHAR(50)
,	CenterType INT
)


    DECLARE @EmployeeGUID CHAR(36);

    SELECT @EmployeeGUID = EmployeeGUID
    FROM datEmployee
    WHERE UserLogin = 'aptak';

--If they have access to ALL Centers
IF EXISTS ( SELECT DISTINCT
                    ep.ActiveDirectoryGroup
            FROM    lkpSecurityElement se
                    INNER JOIN cfgSecurityGroup sg
                        ON se.SecurityElementID = sg.SecurityElementID
                    INNER JOIN lkpEmployeePosition ep
                        ON sg.EmployeePositionID = ep.EmployeePositionID
                    INNER JOIN cfgEmployeePositionJoin epj
                        ON ep.EmployeePositionID = epj.EmployeePositionID
            WHERE   se.SecurityElementDescriptionShort = 'ctrAll'
                    AND sg.HasAccessFlag = 1
                    AND ISNULL(epj.IsActiveFlag, 0) = 1
                    AND epj.EmployeeGUID = @EmployeeGUID )
BEGIN
	INSERT	INTO @Center
			SELECT  1 AS 'CenterID'
			,       'Corporate Centers' AS 'CenterDescriptionFullCalc'
			,       0 AS 'CenterTypeID'
			UNION
			SELECT  2 AS 'CenterID'
			,       'Franchise Centers' AS 'CenterDescriptionFullCalc'
			,       0 AS 'CenterTypeID'
			UNION
			SELECT  3 AS 'CenterID'
			,       'Joint Ventures' AS 'CenterDescriptionFullCalc'
			,       0 AS 'CenterTypeID'
			UNION
			SELECT  4 AS 'CenterID'
			,       'All Centers' AS 'CenterDescriptionFullCalc'
			,       0 AS 'CenterTypeID'
			UNION
			SELECT  c.CenterID
			,       c.CenterDescriptionFullCalc
			,       c.CenterTypeID
			FROM    cfgCenter c
					INNER JOIN cfgConfigurationCenter cc
						ON c.CenterID = cc.CenterID
					INNER JOIN lkpCenterBusinessType cbt
						ON cc.CenterBusinessTypeID = cbt.CenterBusinessTypeID
			WHERE   c.IsActiveFlag = 1
					AND cbt.CenterBusinessTypeDescriptionShort <> 'Surgery'
END;
ELSE
BEGIN

	--If they only have access to centers assigned to them in AD
	INSERT	INTO @Center
			SELECT  c.CenterID
			,       c.CenterDescriptionFullCalc
			,       c.CenterTypeID
			FROM    cfgCenter c
					INNER JOIN datEmployeeCenter ec
						ON c.CenterID = ec.CenterID
			WHERE   c.IsActiveFlag = 1
					AND ec.EmployeeGUID = @EmployeeGUID
					AND ec.IsActiveFlag = 1
END;


SELECT  c.CenterID
,		c.CenterName AS 'CenterDescriptionFullCalc'
FROM    @Center c
ORDER BY c.CenterType
,		c.CenterName

END;
GO
