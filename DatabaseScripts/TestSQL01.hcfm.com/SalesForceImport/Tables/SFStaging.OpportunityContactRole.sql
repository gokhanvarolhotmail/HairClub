/* CreateDate: 03/03/2022 13:54:34.460 , ModifyDate: 03/03/2022 22:19:08.923 */
GO
CREATE TABLE [SFStaging].[OpportunityContactRole](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[OpportunityId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Role] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsPrimary] [bit] NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[IsDeleted] [bit] NULL,
	[CurrencyIsoCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_OpportunityContactRole] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY]
GO
