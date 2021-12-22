CREATE VIEW [dbo].[vwSecurityByEmployeePosition]
AS
SELECT     TOP (100) PERCENT ep.EmployeePositionID, ep.EmployeePositionDescription, se.SecurityElementID, se.SecurityElementDescription,
                      sg.HasAccessFlag
FROM         dbo.lkpSecurityElement AS se LEFT OUTER JOIN
                      dbo.cfgSecurityGroup AS sg ON se.SecurityElementID = sg.SecurityElementID LEFT OUTER JOIN
                      dbo.lkpEmployeePosition AS ep ON sg.EmployeePositionID = ep.EmployeePositionID
ORDER BY ep.EmployeePositionID, se.SecurityElementID
