CREATE TABLE [dbo].[FactCommissionCancelDetail](
	[CancelDetailKey] [int] IDENTITY(1,1) NOT NULL,
	[CancelHeaderKey] [int] NOT NULL,
	[CommissionHeaderKey] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateDate] [datetime] NOT NULL,
	[UpdateUser] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_FactCommissionCancelDetail] PRIMARY KEY CLUSTERED
(
	[CancelDetailKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
