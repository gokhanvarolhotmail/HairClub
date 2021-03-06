/* CreateDate: 05/28/2018 22:17:57.727 , ModifyDate: 12/29/2021 15:38:46.230 */
GO
CREATE TABLE [dbo].[lkpInventoryAuditBatchStatus](
	[InventoryAuditBatchStatusID] [int] IDENTITY(1,1) NOT NULL,
	[InventoryAuditBatchStatusSortOrder] [int] NOT NULL,
	[InventoryAuditBatchStatusDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[InventoryAuditBatchStatusDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_lkpInventoryAuditBatchStatus] PRIMARY KEY CLUSTERED
(
	[InventoryAuditBatchStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
