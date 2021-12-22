/* CreateDate: 10/08/2021 18:57:44.243 , ModifyDate: 10/08/2021 18:57:44.243 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ODS_SF_AssignedResources](
	[Id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsDeleted] [bit] NULL,
	[AssignedResourceNumber] [nvarchar](765) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [datetime2](0) NULL,
	[CreatedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](0) NULL,
	[LastModifiedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](0) NULL,
	[ServiceAppointmentId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceResourceId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsRequiredResource] [bit] NULL,
	[Role] [nvarchar](765) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
