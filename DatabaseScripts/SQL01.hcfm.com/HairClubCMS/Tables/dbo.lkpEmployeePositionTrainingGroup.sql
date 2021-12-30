/* CreateDate: 12/15/2017 16:17:24.397 , ModifyDate: 12/15/2017 16:17:39.317 */
GO
CREATE TABLE [dbo].[lkpEmployeePositionTrainingGroup](
	[EmployeePositionTrainingGroupID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[EmployeePositionTrainingGroupSortOrder] [int] NOT NULL,
	[EmployeePositionTrainingGroupDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[EmployeePositionTrainingGroupDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_lkpEmployeePositionTrainingGroup] PRIMARY KEY CLUSTERED
(
	[EmployeePositionTrainingGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
