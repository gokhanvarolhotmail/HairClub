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
