/* CreateDate: 10/03/2019 23:03:40.377 , ModifyDate: 10/03/2019 23:03:45.903 */
GO
CREATE TABLE [bi_cms_dds].[DimEmployeePosition](
	[EmployeePositionKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[EmployeePositionSSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[EmployeePositionDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[EmployeePositionDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[EmployeePositionSortOrder] [int] NULL,
	[ActiveDirectoryGroup] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsAdministratorFlag] [bit] NULL,
	[IsEmployeeOneFlag] [bit] NULL,
	[IsEmployeeTwoFlag] [bit] NULL,
	[IsEmployeeThreeFlag] [bit] NULL,
	[IsEmployeeFourFlag] [bit] NULL,
	[CanScheduleFlag] [bit] NULL,
	[ApplicationTimeoutMinutes] [int] NULL,
	[UseDefaultCenterFlag] [bit] NULL,
	[IsSurgeryCenterEmployeeFlag] [bit] NULL,
	[IsNonSurgeryCenterEmployeeFlag] [bit] NULL,
	[Active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DimEmployeePosition] PRIMARY KEY CLUSTERED
(
	[EmployeePositionKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
) ON [FG1]
GO
