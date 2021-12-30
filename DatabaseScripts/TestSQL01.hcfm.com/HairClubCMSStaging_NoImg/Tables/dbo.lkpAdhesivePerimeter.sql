/* CreateDate: 08/27/2008 11:26:31.160 , ModifyDate: 12/28/2021 09:20:54.510 */
GO
CREATE TABLE [dbo].[lkpAdhesivePerimeter](
	[AdhesivePerimeterID] [int] NOT NULL,
	[AdhesivePerimeterSortOrder] [int] NOT NULL,
	[AdhesivePerimeterDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AdhesivePerimeterDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpAdhesivePerimeter] PRIMARY KEY CLUSTERED
(
	[AdhesivePerimeterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpAdhesivePerimeter] ADD  CONSTRAINT [DF_lkpAdhesivePerimeter_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
