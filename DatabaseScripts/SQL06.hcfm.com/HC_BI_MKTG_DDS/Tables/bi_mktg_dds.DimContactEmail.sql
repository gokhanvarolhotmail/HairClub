/* CreateDate: 09/03/2021 09:37:05.720 , ModifyDate: 09/03/2021 09:37:10.930 */
GO
CREATE TABLE [bi_mktg_dds].[DimContactEmail](
	[ContactEmailKey] [int] NOT NULL,
	[ContactEmailSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmailTypeCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Email] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PrimaryFlag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[SFDC_LeadID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_LeadEmailID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactEmailHashed] [varbinary](128) NULL,
	[SFDC_PersonAccountID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_DimContactEmail] PRIMARY KEY CLUSTERED
(
	[ContactEmailKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
