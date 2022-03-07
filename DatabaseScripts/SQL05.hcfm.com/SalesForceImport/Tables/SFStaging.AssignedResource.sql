/* CreateDate: 03/03/2022 13:54:33.577 , ModifyDate: 03/05/2022 13:04:26.920 */
GO
CREATE TABLE [SFStaging].[AssignedResource](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsDeleted] [bit] NULL,
	[AssignedResourceNumber] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[ServiceAppointmentId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceResourceId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsRequiredResource] [bit] NULL,
	[Role] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EventId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceResourceId__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_AssignedResource] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY]
GO
