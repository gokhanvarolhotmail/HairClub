/* CreateDate: 06/30/2014 07:10:21.657 , ModifyDate: 12/03/2021 10:24:48.717 */
GO
CREATE TABLE [dbo].[lkpNorwoodScale](
	[NorwoodScaleID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[BOSNorwoodScaleCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[NorwoodScaleSortOrder] [int] NOT NULL,
	[NorwoodScaleDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[NorwoodScaleDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[NorwoodScaleDescriptionLong] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AlternateShortDescription] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DescriptionLongResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_lkpNorwoodScale] PRIMARY KEY CLUSTERED
(
	[NorwoodScaleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpNorwoodScale] ADD  CONSTRAINT [DF_lkpNorwoodScale_NorwoodScaleDescriptionLong]  DEFAULT ('') FOR [NorwoodScaleDescriptionLong]
GO
