/****** Object:  StoredProcedure [dbo].[sp_updateJaneCreativeLead]    Script Date: 1/7/2022 4:05:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_updateJaneCreativeLead] AS begin
    update  [dbo].[DimLead] set originalcampaignkey=3088, originalcampaigncode='701f4000000hKLZAA2'
  where originalsourcecode like 'DGPDSFACELEAD11216%' and originalcampaignkey =-1 and isvalid=1
    end
GO
