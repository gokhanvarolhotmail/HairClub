/* CreateDate: 03/03/2022 13:54:34.650 , ModifyDate: 03/05/2022 13:04:13.253 */
GO
CREATE TABLE [SFStaging].[OpportunityTeamMember](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[OpportunityId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UserId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Name] [varchar](361) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhotoUrl] [varchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Title] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TeamMemberRole] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OpportunityAccessLevel] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrencyIsoCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [pk_OpportunityTeamMember] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY]
GO
