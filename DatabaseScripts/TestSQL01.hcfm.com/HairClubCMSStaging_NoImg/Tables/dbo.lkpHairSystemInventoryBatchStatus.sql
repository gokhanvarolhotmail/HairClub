/* CreateDate: 04/08/2015 07:53:06.197 , ModifyDate: 12/03/2021 10:24:48.617 */
GO
CREATE TABLE [dbo].[lkpHairSystemInventoryBatchStatus](
	[HairSystemInventoryBatchStatusID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairSystemInventoryBatchStatusSortOrder] [int] NOT NULL,
	[HairSystemInventoryBatchStatusDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemInventoryBatchStatusDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_lkpHairSystemInventoryBatchStatusID] PRIMARY KEY CLUSTERED
(
	[HairSystemInventoryBatchStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
