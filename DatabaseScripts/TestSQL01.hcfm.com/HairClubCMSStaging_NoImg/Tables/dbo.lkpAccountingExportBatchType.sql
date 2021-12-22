/* CreateDate: 12/31/2010 13:21:02.433 , ModifyDate: 12/03/2021 10:24:48.573 */
GO
CREATE TABLE [dbo].[lkpAccountingExportBatchType](
	[AccountingExportBatchTypeID] [int] NOT NULL,
	[AccountingExportBatchTypeSortOrder] [int] NOT NULL,
	[AccountingExportBatchTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AccountingExportBatchTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpAccountingExportBatchType] PRIMARY KEY CLUSTERED
(
	[AccountingExportBatchTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpAccountingExportBatchType] ADD  DEFAULT ((0)) FOR [IsActiveFlag]
GO
