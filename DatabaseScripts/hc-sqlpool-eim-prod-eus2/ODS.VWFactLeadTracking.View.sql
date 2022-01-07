/****** Object:  View [ODS].[VWFactLeadTracking]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [ODS].[VWFactLeadTracking]
AS Select ofl.* from [ODS].[FactLeadTracking] ofl
inner join (Select id, lastmodifieddate, createddate from [ODS].[FactLeadTracking]
group by id, lastmodifieddate, createddate ) as x
on x.id = ofl.id and x.lastmodifieddate = ofl.lastmodifieddate and x.createddate = ofl.createddate;
GO
