CREATE TABLE [dbo].[lkpPaymentPlanStatus](
	[PaymentPlanStatusID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[PaymentPlanStatusSortOrder] [int] NOT NULL,
	[PaymentPlanStatusDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PaymentPlanStatusDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_lkpPaymentPlanStatus] PRIMARY KEY CLUSTERED
(
	[PaymentPlanStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpPaymentPlanStatus] ADD  DEFAULT ((1)) FOR [IsActiveFlag]
