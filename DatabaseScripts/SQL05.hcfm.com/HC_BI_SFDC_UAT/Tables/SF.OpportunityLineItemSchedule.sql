/* CreateDate: 03/07/2022 10:57:19.313 , ModifyDate: 03/07/2022 10:57:19.313 */
GO
CREATE TABLE [SF].[OpportunityLineItemSchedule](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[OpportunityLineItemId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Type] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Revenue] [decimal](16, 2) NULL,
	[Quantity] [decimal](16, 2) NULL,
	[Description] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ScheduleDate] [date] NULL,
	[CurrencyIsoCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[IsDeleted] [bit] NULL
) ON [PRIMARY]
GO
