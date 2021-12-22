/* CreateDate: 05/28/2018 22:17:57.707 , ModifyDate: 09/23/2019 12:34:03.330 */
GO
CREATE TABLE [dbo].[lkpInventoryNotScannedReason](
	[InventoryNotScannedReasonID] [int] IDENTITY(1,1) NOT NULL,
	[InventoryNotScannedReasonSortOrder] [int] NOT NULL,
	[InventoryNotScannedReasonDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[InventoryNotScannedReasonDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsNoteRequired] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_lkpInventoryNotScannedReason] PRIMARY KEY CLUSTERED
(
	[InventoryNotScannedReasonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
