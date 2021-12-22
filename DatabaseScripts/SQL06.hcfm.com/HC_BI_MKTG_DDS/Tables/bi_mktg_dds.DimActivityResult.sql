/* CreateDate: 09/03/2021 09:37:05.317 , ModifyDate: 09/03/2021 09:37:09.710 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bi_mktg_dds].[DimActivityResult](
	[ActivityResultKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ActivityResultSSID] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ActivitySSID] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactSSID] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesTypeSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SalesTypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ActionCodeSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ActionCodeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ResultCodeSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ResultCodeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SourceSSID] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsShow] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsSale] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ContractNumber] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ContractAmount] [decimal](15, 4) NOT NULL,
	[ClientNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[InitialPayment] [decimal](15, 4) NOT NULL,
	[NumberOfGraphs] [int] NOT NULL,
	[OrigApptDate] [date] NOT NULL,
	[DateSaved] [date] NOT NULL,
	[RescheduledFlag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RescheduledDate] [date] NOT NULL,
	[SurgeryOffered] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ReferredToDoctor] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[SFDC_TaskID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_LeadID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Accomodation] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_PersonAccountID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_DimActivityResult] PRIMARY KEY CLUSTERED
(
	[ActivityResultKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
