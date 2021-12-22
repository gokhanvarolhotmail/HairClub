/* CreateDate: 08/27/2008 11:27:12.560 , ModifyDate: 12/07/2021 16:20:15.987 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkpAdhesiveSolvent](
	[AdhesiveSolventID] [int] NOT NULL,
	[AdhesiveSolventSortOrder] [int] NOT NULL,
	[AdhesiveSolventDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AdhesiveSolventDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpAdhesiveSolvent] PRIMARY KEY CLUSTERED
(
	[AdhesiveSolventID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpAdhesiveSolvent] ADD  CONSTRAINT [DF_lkpAdhesiveSolvent_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
