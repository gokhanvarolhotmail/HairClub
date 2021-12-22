/* CreateDate: 05/28/2018 22:15:34.537 , ModifyDate: 09/23/2019 12:34:03.337 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkpSerializedInventoryStatus](
	[SerializedInventoryStatusID] [int] IDENTITY(1,1) NOT NULL,
	[SerializedInventoryStatusSortOrder] [int] NOT NULL,
	[SerializedInventoryStatusDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SerializedInventoryStatusDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsAvailableForSale] [bit] NOT NULL,
	[IncludeInInventorySnapshot] [bit] NOT NULL,
	[CanAdjust] [bit] NOT NULL,
	[IsInTransit] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_lkpSerializedInventoryStatus] PRIMARY KEY CLUSTERED
(
	[SerializedInventoryStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
