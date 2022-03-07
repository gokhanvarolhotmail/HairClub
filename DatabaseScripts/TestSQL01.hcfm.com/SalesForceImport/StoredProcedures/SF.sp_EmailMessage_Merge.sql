/* CreateDate: 03/04/2022 08:19:54.890 , ModifyDate: 03/04/2022 08:19:54.890 */
GO
CREATE PROCEDURE [SF].[sp_EmailMessage_Merge]
	@ROWCOUNT BIGINT = NULL OUTPUT
AS
SET NOCOUNT ON

SET @ROWCOUNT = 0

IF NOT EXISTS(SELECT 1 FROM [SFStaging].[EmailMessage])
RETURN ;

SET XACT_ABORT ON

BEGIN TRANSACTION

;MERGE [SF].[EmailMessage] AS [t]
USING [SFStaging].[EmailMessage] AS [s]
	ON [t].[Id] = [s].[Id]
WHEN MATCHED THEN
	UPDATE SET
	[t].[ParentId] = [t].[ParentId]
	, [t].[ActivityId] = [t].[ActivityId]
	, [t].[CreatedById] = [t].[CreatedById]
	, [t].[CreatedDate] = [t].[CreatedDate]
	, [t].[LastModifiedDate] = [t].[LastModifiedDate]
	, [t].[LastModifiedById] = [t].[LastModifiedById]
	, [t].[SystemModstamp] = [t].[SystemModstamp]
	, [t].[TextBody] = [t].[TextBody]
	, [t].[HtmlBody] = [t].[HtmlBody]
	, [t].[Headers] = [t].[Headers]
	, [t].[Subject] = [t].[Subject]
	, [t].[FromName] = [t].[FromName]
	, [t].[FromAddress] = [t].[FromAddress]
	, [t].[ValidatedFromAddress] = [t].[ValidatedFromAddress]
	, [t].[ToAddress] = [t].[ToAddress]
	, [t].[CcAddress] = [t].[CcAddress]
	, [t].[BccAddress] = [t].[BccAddress]
	, [t].[Incoming] = [t].[Incoming]
	, [t].[HasAttachment] = [t].[HasAttachment]
	, [t].[Status] = [t].[Status]
	, [t].[MessageDate] = [t].[MessageDate]
	, [t].[IsDeleted] = [t].[IsDeleted]
	, [t].[ReplyToEmailMessageId] = [t].[ReplyToEmailMessageId]
	, [t].[IsExternallyVisible] = [t].[IsExternallyVisible]
	, [t].[MessageIdentifier] = [t].[MessageIdentifier]
	, [t].[ThreadIdentifier] = [t].[ThreadIdentifier]
	, [t].[IsClientManaged] = [t].[IsClientManaged]
	, [t].[RelatedToId] = [t].[RelatedToId]
	, [t].[IsTracked] = [t].[IsTracked]
	, [t].[IsOpened] = [t].[IsOpened]
	, [t].[FirstOpenedDate] = [t].[FirstOpenedDate]
	, [t].[LastOpenedDate] = [t].[LastOpenedDate]
	, [t].[IsBounced] = [t].[IsBounced]
	, [t].[EmailTemplateId] = [t].[EmailTemplateId]
	, [t].[ContentDocumentIds] = [t].[ContentDocumentIds]
	, [t].[BccIds] = [t].[BccIds]
	, [t].[CcIds] = [t].[CcIds]
	, [t].[ToIds] = [t].[ToIds]
WHEN NOT MATCHED THEN
	INSERT(
	[Id]
	, [ParentId]
	, [ActivityId]
	, [CreatedById]
	, [CreatedDate]
	, [LastModifiedDate]
	, [LastModifiedById]
	, [SystemModstamp]
	, [TextBody]
	, [HtmlBody]
	, [Headers]
	, [Subject]
	, [FromName]
	, [FromAddress]
	, [ValidatedFromAddress]
	, [ToAddress]
	, [CcAddress]
	, [BccAddress]
	, [Incoming]
	, [HasAttachment]
	, [Status]
	, [MessageDate]
	, [IsDeleted]
	, [ReplyToEmailMessageId]
	, [IsExternallyVisible]
	, [MessageIdentifier]
	, [ThreadIdentifier]
	, [IsClientManaged]
	, [RelatedToId]
	, [IsTracked]
	, [IsOpened]
	, [FirstOpenedDate]
	, [LastOpenedDate]
	, [IsBounced]
	, [EmailTemplateId]
	, [ContentDocumentIds]
	, [BccIds]
	, [CcIds]
	, [ToIds]
	)
	VALUES(
	[s].[Id]
	, [s].[ParentId]
	, [s].[ActivityId]
	, [s].[CreatedById]
	, [s].[CreatedDate]
	, [s].[LastModifiedDate]
	, [s].[LastModifiedById]
	, [s].[SystemModstamp]
	, [s].[TextBody]
	, [s].[HtmlBody]
	, [s].[Headers]
	, [s].[Subject]
	, [s].[FromName]
	, [s].[FromAddress]
	, [s].[ValidatedFromAddress]
	, [s].[ToAddress]
	, [s].[CcAddress]
	, [s].[BccAddress]
	, [s].[Incoming]
	, [s].[HasAttachment]
	, [s].[Status]
	, [s].[MessageDate]
	, [s].[IsDeleted]
	, [s].[ReplyToEmailMessageId]
	, [s].[IsExternallyVisible]
	, [s].[MessageIdentifier]
	, [s].[ThreadIdentifier]
	, [s].[IsClientManaged]
	, [s].[RelatedToId]
	, [s].[IsTracked]
	, [s].[IsOpened]
	, [s].[FirstOpenedDate]
	, [s].[LastOpenedDate]
	, [s].[IsBounced]
	, [s].[EmailTemplateId]
	, [s].[ContentDocumentIds]
	, [s].[BccIds]
	, [s].[CcIds]
	, [s].[ToIds]
	)
OPTION(RECOMPILE) ;

SET @ROWCOUNT = @@ROWCOUNT ;

TRUNCATE TABLE [SFStaging].[EmailMessage] ;

COMMIT ;
GO
