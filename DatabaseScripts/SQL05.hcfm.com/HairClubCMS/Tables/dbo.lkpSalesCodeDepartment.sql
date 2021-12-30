/* CreateDate: 05/05/2020 17:42:37.907 , ModifyDate: 05/05/2020 18:41:03.253 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
