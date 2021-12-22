/* CreateDate: 04/09/2009 18:42:39.510 , ModifyDate: 02/18/2013 19:04:03.450 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwSecurityByEmployeePosition]
AS
SELECT     TOP (100) PERCENT ep.EmployeePositionID, ep.EmployeePositionDescription, se.SecurityElementID, se.SecurityElementDescription,
                      sg.HasAccessFlag
FROM         dbo.lkpSecurityElement AS se LEFT OUTER JOIN
                      dbo.cfgSecurityGroup AS sg ON se.SecurityElementID = sg.SecurityElementID LEFT OUTER JOIN
                      dbo.lkpEmployeePosition AS ep ON sg.EmployeePositionID = ep.EmployeePositionID
ORDER BY ep.EmployeePositionID, se.SecurityElementID
GO
