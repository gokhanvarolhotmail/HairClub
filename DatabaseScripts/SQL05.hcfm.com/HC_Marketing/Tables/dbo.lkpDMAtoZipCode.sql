/* CreateDate: 07/08/2020 08:25:12.113 , ModifyDate: 07/08/2020 08:25:12.113 */
GO
CREATE TABLE [dbo].[lkpDMAtoZipCode](
	[DMACode] [int] NULL,
	[ZipCode] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DMA_Name_Nielsen] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DMA_Name_Internal] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DMA_Name_Alternate] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DMA_Adintel] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL
) ON [PRIMARY]
GO
