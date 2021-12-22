CREATE VIEW [dbo].[vwCfgCenter]
AS
SELECT     c.CenterID, lkpC.CountryDescription, lkpR.RegionDescription, lkpCPG.CenterPayGroupDescription,
                      c.CenterDescription, lkpCO.CenterOwnershipDescription, lkpCenter.CenterDescription AS SurgeryHubCenter,
                      lkpCenter2.CenterDescription AS ReportingCenter, e.EmployeeFullNameCalc AS Doctor, lkpTZ.TimeZoneDescription, c.InvoiceCounter, c.Address1,
                      c.Address2, c.Address3, c.City, lkpS.StateDescription, c.PostalCode, c.Phone1, c.Phone2, c.Phone3, c.Phone1TypeID, c.Phone2TypeID,
                      c.Phone3TypeID, c.IsPhone1PrimaryFlag, c.IsPhone2PrimaryFlag, c.IsPhone3PrimaryFlag, c.IsActiveFlag, c.CreateDate, c.CreateUser, c.LastUpdate,
                      c.LastUpdateUser, c.UpdateStamp, c.CenterDescriptionFullCalc
FROM         dbo.cfgCenter AS c LEFT OUTER JOIN
                      dbo.lkpCountry AS lkpC ON lkpC.CountryID = c.CountryID LEFT OUTER JOIN
                      dbo.lkpRegion AS lkpR ON lkpR.RegionID = c.RegionID LEFT OUTER JOIN
                      dbo.lkpCenterPayGroup AS lkpCPG ON lkpCPG.CenterPayGroupID = c.CenterPayGroupID LEFT OUTER JOIN
                      dbo.lkpCenterOwnership AS lkpCO ON lkpCO.CenterOwnershipID = c.CenterOwnershipID LEFT OUTER JOIN
                      dbo.cfgCenter AS lkpCenter ON lkpCenter.CenterID = c.SurgeryHubCenterID LEFT OUTER JOIN
                      dbo.cfgCenter AS lkpCenter2 ON lkpCenter.CenterID = c.ReportingCenterID LEFT OUTER JOIN
                      dbo.datEmployee AS e ON e.EmployeeGUID = c.EmployeeDoctorGUID LEFT OUTER JOIN
                      dbo.lkpTimeZone AS lkpTZ ON lkpTZ.TimeZoneID = c.TimeZoneID LEFT OUTER JOIN
                      dbo.lkpState AS lkpS ON lkpS.StateID = c.StateID
