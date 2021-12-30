/* CreateDate: 02/01/2013 10:02:58.137 , ModifyDate: 06/18/2014 01:38:25.557 */
GO
CREATE TABLE [dbo].[DimCommissionType](
	[CommissionTypeID] [int] NOT NULL,
	[SortOrder] [int] NULL,
	[CommissionTypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CommissionTypeDescriptionShort] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Role] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Grouping] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BeginDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
 CONSTRAINT [PK_DimCommissionType] PRIMARY KEY CLUSTERED
(
	[CommissionTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
