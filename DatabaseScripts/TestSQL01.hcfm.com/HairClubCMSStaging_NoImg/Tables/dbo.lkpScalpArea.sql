/* CreateDate: 05/06/2014 09:10:03.880 , ModifyDate: 12/03/2021 10:24:48.617 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkpScalpArea](
	[ScalpAreaID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ScalpAreaSortOrder] [int] NOT NULL,
	[ScalpAreaDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ScalpAreaDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[DescriptionResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_lkpScalpArea_1] PRIMARY KEY CLUSTERED
(
	[ScalpAreaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpScalpArea] ADD  CONSTRAINT [DF_lkpScalpArea_IsActiveFlag_1]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
