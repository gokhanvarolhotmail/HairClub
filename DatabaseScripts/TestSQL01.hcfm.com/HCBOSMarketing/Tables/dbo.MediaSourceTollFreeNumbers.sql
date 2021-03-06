/* CreateDate: 06/20/2008 11:25:46.583 , ModifyDate: 06/18/2009 12:48:41.590 */
GO
CREATE TABLE [dbo].[MediaSourceTollFreeNumbers](
	[Active] [bit] NULL,
	[NumberID] [int] IDENTITY(1,1) NOT NULL,
	[Number] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceCode] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HCDNIS] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[VendorDNIS] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[VoiceMail] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AirDate] [smalldatetime] NULL,
	[Notes] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[QwestID] [smallint] NULL,
	[NumberTypeID] [tinyint] NULL,
	[VendorDNIS2] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_NumberID] PRIMARY KEY CLUSTERED
(
	[NumberID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_Number] UNIQUE NONCLUSTERED
(
	[Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
