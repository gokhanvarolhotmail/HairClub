/* CreateDate: 09/03/2021 09:37:05.557 , ModifyDate: 09/03/2021 09:37:10.300 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bi_mktg_dds].[DimContactAddress](
	[ContactAddressKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ContactAddressSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddressTypeCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AddressLine1] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddressLine2] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddressLine3] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddressLine4] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AddressLine1Soundex] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AddressLine2Soundex] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[City] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CitySoundex] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[StateCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ZipCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountyCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CountyName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CountryCode] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CountryName] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CountryPrefix] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[TimeZoneCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
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
	[SFDC_LeadAddressID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_PersonAccountID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_DimContactAddress] PRIMARY KEY CLUSTERED
(
	[ContactAddressKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
