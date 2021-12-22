/* CreateDate: 02/18/2013 06:40:48.983 , ModifyDate: 12/03/2021 10:24:48.653 */
GO
CREATE TABLE [dbo].[lkpScalpPreparation](
	[ScalpPreparationID] [int] NOT NULL,
	[ScalpPreparationSortOrder] [int] NOT NULL,
	[ScalpPreparationDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ScalpPreparationDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpScalpPreparation] PRIMARY KEY CLUSTERED
(
	[ScalpPreparationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
