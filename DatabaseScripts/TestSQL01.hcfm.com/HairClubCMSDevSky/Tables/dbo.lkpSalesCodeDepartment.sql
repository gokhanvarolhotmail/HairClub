/* CreateDate: 09/03/2008 13:13:58.550 , ModifyDate: 12/07/2021 16:20:15.837 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkpSalesCodeDepartment](
	[SalesCodeDepartmentID] [int] NOT NULL,
	[SalesCodeDepartmentSortOrder] [int] NOT NULL,
	[SalesCodeDepartmentDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SalesCodeDepartmentDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SalesCodeDivisionID] [int] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpSalesCodeDepartment] PRIMARY KEY CLUSTERED
(
	[SalesCodeDepartmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpSalesCodeDepartment] ADD  CONSTRAINT [DF_lkpSalesCodeDepartment_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[lkpSalesCodeDepartment]  WITH CHECK ADD  CONSTRAINT [FK_lkpSalesCodeDepartment_lkpSalesCodeDivision] FOREIGN KEY([SalesCodeDivisionID])
REFERENCES [dbo].[lkpSalesCodeDivision] ([SalesCodeDivisionID])
GO
ALTER TABLE [dbo].[lkpSalesCodeDepartment] CHECK CONSTRAINT [FK_lkpSalesCodeDepartment_lkpSalesCodeDivision]
GO
