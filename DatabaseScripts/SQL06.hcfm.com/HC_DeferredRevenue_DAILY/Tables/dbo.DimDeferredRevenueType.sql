/* CreateDate: 12/07/2012 10:01:58.833 , ModifyDate: 11/09/2018 15:01:57.357 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimDeferredRevenueType](
	[TypeID] [int] IDENTITY(1,1) NOT NULL,
	[TypeDescription] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SortOrder] [int] NULL
) ON [PRIMARY]
GO
