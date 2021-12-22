/* CreateDate: 12/28/2016 07:03:10.680 , ModifyDate: 12/28/2016 07:03:10.680 */
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
