/* CreateDate: 08/27/2008 12:21:32.797 , ModifyDate: 05/26/2020 10:48:58.737 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkpSalesCodeDivision](
	[SalesCodeDivisionID] [int] NOT NULL,
	[SalesCodeDivisionSortOrder] [int] NOT NULL,
	[SalesCodeDivisionDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SalesCodeDivisionDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpSalesCodeDivision] PRIMARY KEY CLUSTERED
(
	[SalesCodeDivisionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpSalesCodeDivision] ADD  CONSTRAINT [DF_lkpSalesCodeDivision_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
