/* CreateDate: 01/29/2016 11:04:23.867 , ModifyDate: 02/24/2017 17:05:56.523 */
GO
/*
select * from [vw_AreaManager]
*/

CREATE VIEW [dbo].[vw_AreaManager]
AS




SELECT CTR.CenterID
	,	R.RegionID
	,	CTR.CenterTypeID
	,	CTR.CenterDescription
	,	CTR.CenterDescriptionFullCalc
	,	CTR.IsActiveFlag
	,	CMA.CenterManagementAreaID
	,	CMA.CenterManagementAreaDescription AS 'EmployeeFullNameCalc'
	,	CMA.CenterManagementAreaDescription
	,	R.RegionDescription
	,	ISNULL(CMA.CenterManagementAreaSortOrder, 1) AS 'CenterManagementAreaSortOrder'
FROM   cfgCenter CTR
LEFT JOIN dbo.cfgCenterManagementArea CMA
	ON CTR.CenterManagementAreaID = CMA.CenterManagementAreaID
LEFT JOIN lkpRegion R
	ON CTR.RegionID = R.RegionID
LEFT JOIN datEmployee E
	ON CMA.OperationsManagerGUID = E.EmployeeGUID
WHERE CTR.IsActiveFlag = 1
AND CTR.CenterID LIKE '[2]%'
GO
