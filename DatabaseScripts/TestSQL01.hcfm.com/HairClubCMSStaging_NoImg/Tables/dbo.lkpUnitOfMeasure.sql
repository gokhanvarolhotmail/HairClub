/* CreateDate: 11/04/2008 12:28:46.533 , ModifyDate: 01/31/2022 08:32:31.753 */
GO
CREATE TABLE [dbo].[lkpUnitOfMeasure](
	[UnitOfMeasureID] [int] NOT NULL,
	[UnitOfMeasureSortOrder] [int] NOT NULL,
	[UnitOfMeasureDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UnitOfMeasureDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpUnitOfMeasure] PRIMARY KEY CLUSTERED
(
	[UnitOfMeasureID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpUnitOfMeasure] ADD  CONSTRAINT [DF_lkpUnitOfMeasure_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
