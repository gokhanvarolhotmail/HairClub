/* CreateDate: 07/27/2016 14:38:58.077 , ModifyDate: 07/27/2016 14:38:58.127 */
GO
CREATE TABLE [dbo].[lkpScheduleType](
	[ScheduleTypeID] [int] IDENTITY(1,1) NOT NULL,
	[ScheduleTypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
 CONSTRAINT [PK_lkpScheduleType] PRIMARY KEY CLUSTERED
(
	[ScheduleTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpScheduleType] ADD  CONSTRAINT [DF_lkpScheduleType_IsActiveFlag]  DEFAULT ((0)) FOR [IsActiveFlag]
GO
