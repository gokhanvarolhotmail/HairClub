/* CreateDate: 08/03/2015 18:32:14.807 , ModifyDate: 08/03/2015 18:32:15.573 */
GO
CREATE TABLE [dbo].[lkpCompletedVisitType](
	[CompletedVisitTypeID] [int] IDENTITY(1,1) NOT NULL,
	[CompletedVisitTypeSortOrder] [int] NOT NULL,
	[CompletedVisitTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CompletedVisitTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_lkpCompletedVisitType] PRIMARY KEY CLUSTERED
(
	[CompletedVisitTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
