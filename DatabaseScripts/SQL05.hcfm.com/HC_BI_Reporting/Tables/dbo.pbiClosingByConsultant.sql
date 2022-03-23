/* CreateDate: 09/20/2018 13:50:00.243 , ModifyDate: 09/20/2018 13:50:00.243 */
GO
CREATE TABLE [dbo].[pbiClosingByConsultant](
	[CenterManagementAreaSSID] [int] NULL,
	[CenterManagementAreaDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterManagementAreaSortOrder] [int] NULL,
	[CenterNumber] [int] NULL,
	[CenterKey] [int] NULL,
	[CenterDescriptionNumber] [nvarchar](103) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeeKey] [int] NULL,
	[Performer] [nvarchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivityDueDate] [datetime] NULL,
	[ActivitySSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActionCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ResultCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NoSaleReason] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SolutionOffered] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PriceQuoted] [money] NULL,
	[Type] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactFullName] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactGender] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
