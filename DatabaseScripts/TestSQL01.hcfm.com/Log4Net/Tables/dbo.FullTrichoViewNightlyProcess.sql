/* CreateDate: 12/20/2016 16:12:03.340 , ModifyDate: 12/20/2016 16:12:03.340 */
GO
CREATE TABLE [dbo].[FullTrichoViewNightlyProcess](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AppointmentGUID] [uniqueidentifier] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
 CONSTRAINT [PK_FullTrichoViewNightlyProcess] PRIMARY KEY CLUSTERED
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
