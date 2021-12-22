/* CreateDate: 02/24/2020 09:00:46.643 , ModifyDate: 03/11/2021 15:38:03.520 */
GO
CREATE TABLE [dbo].[Consultation_Form__c](
	[Id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[OwnerId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Name] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterName__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterID__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Lead__c] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[First_Name__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Last_Name__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Email__c] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Birthdate__c] [datetime] NULL,
	[Gender__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Martial_Status__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Norwood_Scale__c] [int] NULL,
	[Ludwig_Scale__c] [int] NULL,
	[Mailing_Street__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mailing_City__c] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mailing_State__c] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mailing_Postal_Code__c] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mailing_Country__c] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Country_Calling_Codes__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone__c] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Work_Phone__c] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Contact_Information__c] [nvarchar](175) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Communication_Preferences__c] [nvarchar](175) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Marketing_Preference_Call__c] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Transaction_Preference_Call__c] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Personal_Information__c] [nvarchar](175) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Additional_Information__c] [nvarchar](175) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Other_Information__c] [nvarchar](175) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Goal_Of_Visit_Other__c] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Goal_Of_Visit__c] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Hair_Loss_Effects_Other__c] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Hair_Loss_Effects__c] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Hair_Loss_Information__c] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Head_Img_Name__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[How_Long_Thinking__c] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[How_did_you_hear_about_Hair_Club__c] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PDF_URL__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PdfPreview__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Reason_For_Hair_Back__c] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Referred_By__c] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Research_Done__c] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Scale_Hair_Restore__c] [int] NULL,
	[Signatue_Date__c] [datetime] NULL,
	[Signature_IP_Address__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Signature__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Special_Events_Impacted__c] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Steps_Taken__c] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Told_Who__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Tell_Anyone__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Attachment_Id__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Last_Saved_Page_Number__c] [decimal](18, 0) NULL,
	[Date__c] [datetime] NULL,
	[Last_Modified_Online__c] [datetime] NULL,
	[LastActivityDate] [datetime] NULL,
	[LastViewedDate] [datetime] NULL,
	[LastReferencedDate] [datetime] NULL,
	[Is_Completed__c] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime] NULL,
	[LastModifiedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE CLUSTERED INDEX [PK__Consulta__3214EC0761F26689] ON [dbo].[Consultation_Form__c]
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
