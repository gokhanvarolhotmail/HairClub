/* CreateDate: 07/30/2015 15:49:42.150 , ModifyDate: 11/08/2018 11:07:20.380 */
GO
CREATE TABLE [dbo].[MediaSourceQwestOptions](
	[QwestID] [smallint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Qwest] [char](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_QwestID] PRIMARY KEY CLUSTERED
(
	[QwestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_Qwest] UNIQUE NONCLUSTERED
(
	[Qwest] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
