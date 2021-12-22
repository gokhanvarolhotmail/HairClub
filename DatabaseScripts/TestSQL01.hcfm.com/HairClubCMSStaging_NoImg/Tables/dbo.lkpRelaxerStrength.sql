/* CreateDate: 08/27/2008 12:16:21.590 , ModifyDate: 12/03/2021 10:24:48.733 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkpRelaxerStrength](
	[RelaxerStrengthID] [int] NOT NULL,
	[RelaxerStrengthSortOrder] [int] NOT NULL,
	[RelaxerStrengthDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RelaxerStrengthDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpRelaxerStrength] PRIMARY KEY CLUSTERED
(
	[RelaxerStrengthID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpRelaxerStrength] ADD  CONSTRAINT [DF_lkpRelaxerStrength_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
