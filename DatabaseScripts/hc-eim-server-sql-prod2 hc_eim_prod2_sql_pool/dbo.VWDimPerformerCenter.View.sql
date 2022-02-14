/****** Object:  View [dbo].[VWDimPerformerCenter]    Script Date: 2/14/2022 11:44:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VWDimPerformerCenter] AS select a.*,b.CenterTypeDescription,b.CenterTypeDescriptionShort,b.CenterNumber,b.CenterGeographykey,b.Region1,b.Region2,b.CenterDescription,b.IsActiveFlag as IsCenterActive
from dbo.DimSystemUser a
left join dbo.DimCenter b on a.CenterId = b.CenterID and b.IsDeleted = 0;
GO
