/* CreateDate: 03/03/2022 13:54:35.357 , ModifyDate: 03/08/2022 08:42:49.777 */
GO
CREATE TABLE [SFStaging].[ServiceTerritoryMember](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsDeleted] [bit] NULL,
	[MemberNumber] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrencyIsoCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[ServiceTerritoryId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceResourceId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TerritoryType] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EffectiveStartDate] [datetime2](7) NULL,
	[EffectiveEndDate] [datetime2](7) NULL,
	[Street] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[State] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PostalCode] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Country] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Latitude] [decimal](25, 15) NULL,
	[Longitude] [decimal](25, 15) NULL,
	[GeocodeAccuracy] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OperatingHoursId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Role] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_ServiceTerritoryMember] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY]
GO
