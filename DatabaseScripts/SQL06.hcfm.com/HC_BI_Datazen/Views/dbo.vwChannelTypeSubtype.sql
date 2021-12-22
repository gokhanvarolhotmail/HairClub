/* CreateDate: 05/02/2016 13:57:58.043 , ModifyDate: 03/03/2017 08:44:52.007 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					[vwChannelTypeSubtype]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		05/02/2016
------------------------------------------------------------------------
NOTES:
------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM [vwChannelTypeSubtype]
***********************************************************************/
CREATE VIEW [dbo].[vwChannelTypeSubtype]
AS


SELECT [ChannelID]
      ,[Channel]
      ,[TypeID]
      ,[Type]
      ,[SubtypeID]
      ,[Subtype]
      ,CTS.[SourceKey]
	  ,	S.SourceName

  FROM [HC_BI_MKTG_DDS].[bi_mktg_dds].[vwChannelTypeSubtype] CTS
  INNER JOIN [HC_BI_MKTG_DDS].[bi_mktg_dds].DimSource S
	ON CTS.SourceKey = S.SourceKey
GO
