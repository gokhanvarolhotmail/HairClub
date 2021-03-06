/****** Object:  Table [ODS].[MA_Television]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[MA_Television]
(
	[transactionid] [varchar](8000) NULL,
	[calendardateest] [varchar](8000) NULL,
	[calendartimeest] [varchar](8000) NULL,
	[broadcastdateest] [varchar](8000) NULL,
	[localairtime] [varchar](8000) NULL,
	[purpose] [varchar](8000) NULL,
	[method] [varchar](8000) NULL,
	[channel] [varchar](8000) NULL,
	[medium] [varchar](8000) NULL,
	[company] [varchar](8000) NULL,
	[location] [varchar](8000) NULL,
	[budgettype] [varchar](8000) NULL,
	[budgetname] [varchar](8000) NULL,
	[source] [varchar](8000) NULL,
	[affiliate] [varchar](8000) NULL,
	[station] [varchar](8000) NULL,
	[show] [varchar](8000) NULL,
	[contenttype] [varchar](8000) NULL,
	[content] [varchar](8000) NULL,
	[campaigntype] [varchar](8000) NULL,
	[campaign] [varchar](8000) NULL,
	[isci] [varchar](8000) NULL,
	[masternumber] [varchar](8000) NULL,
	[tfn] [varchar](8000) NULL,
	[sourcecode] [varchar](8000) NULL,
	[promocode] [varchar](8000) NULL,
	[url] [varchar](8000) NULL,
	[agency] [varchar](8000) NULL,
	[region] [varchar](8000) NULL,
	[dmacode] [varchar](8000) NULL,
	[dmaname] [varchar](8000) NULL,
	[audiene] [varchar](8000) NULL,
	[tactic] [varchar](8000) NULL,
	[placement] [varchar](8000) NULL,
	[format] [varchar](8000) NULL,
	[language] [varchar](8000) NULL,
	[grossspend] [varchar](8000) NULL,
	[netspend] [varchar](8000) NULL,
	[impressions18-65] [varchar](8000) NULL,
	[grp] [varchar](8000) NULL,
	[spots] [varchar](8000) NULL,
	[logtype] [varchar](8000) NULL,
	[impressions35+] [varchar](8000) NULL,
	[trp] [varchar](8000) NULL,
	[DWH_LoadDate] [datetime] NULL,
	[FilePath] [varchar](8000) NULL,
	[CADPrice] [money] NULL,
	[Impressions] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
