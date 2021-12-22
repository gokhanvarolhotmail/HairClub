/* CreateDate: 03/24/2015 07:43:43.863 , ModifyDate: 09/26/2016 08:09:21.410 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				[selEFTProcessNACHAFileHeader]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				KPL
IMPLEMENTOR: 			KPL
DATE IMPLEMENTED: 		1/5/2015
LAST REVISION DATE: 	1/5/2015
--------------------------------------------------------------------------------------------------------
NOTES: 	Return file and batch header records from the NACHA File Profile table for the supplied profileIDs
		01/05/2015 - KPL Created Stored Proc
		03/20/2015 - MVT Modified the Batch Effective date to be a Business Day (if it falls on Sat or Sun, we'll output following Monday)
		09/15/2016 - MVT Modified to return Country.
		09/18/2016 - MVT Modified to return File Header Record.
--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [selEFTProcessNACHAFileHeader] 1
***********************************************************************/
CREATE PROCEDURE [dbo].[selEFTProcessNACHAFileHeader]
		@NACHAFileProfileID int

AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	--SET NOCOUNT ON;

	DECLARE @FileData table(NACHAFileProfileID int NOT NULL, FileModifierID nvarchar(1) NOT NULL, LastFileCreationDate datetime NOT NULL)

	UPDATE np SET
		FileHeaderCurrentFileID = CASE WHEN FileHeaderCurrentFileID = 'Z' THEN '0'
									WHEN FileHeaderCurrentFileID = '9' THEN 'A'
									ELSE CHAR(ASCII(FileHeaderCurrentFileID) + 1) END,
		FileHeaderLastFileCreationDate = getdate()
	OUTPUT inserted.NACHAFileProfileID,deleted.FileHeaderCurrentFileID, inserted.FileHeaderLastFileCreationDate
	INTO @FileData
	FROM  cfgConfigurationCenter config
		LEFT JOIN cfgNACHAFileProfile np ON np.NACHAFileProfileID = config.NACHAFileProfileID
	WHERE config.NACHAFileProfileID = @NACHAFileProfileID

SELECT na.[NACHAFileProfileID]
      ,[FileHeaderRecordTypeCode]
	  ,[FileHeaderPriorityCode]
      ,[FileHeaderImmediateDestination]
      ,[FileHeaderImmediateOrigin]
      ,fd.FileModifierID as FileHeaderCurrentFileID
      ,fd.LastFileCreationDate as [FileHeaderLastFileCreationDate]
      ,[FileHeaderRecordSize]
      ,[FileHeaderBlockingFactor]
      ,[FileHeaderFormatCode]
      ,[FileHeaderDestination] + replicate('',23 - len([FileHeaderDestination])) as [FileHeaderDestination]
      ,[FileHeaderCompanyName] + replicate('',23 - len([FileHeaderCompanyName])) as [FileHeaderCompanyName]
	  ,replicate(' ',8) as [FileHeaderReferenceCode]
      ,[BatchHeaderRecordTypeCode]
      ,[BatchHeaderServiceClassCode]
      ,[BatchHeaderCompanyName] + replicate('',16 - len([BatchHeaderCompanyName])) as [BatchHeaderCompanyName]
      ,[BatchHeaderCompanyIdentification]
      ,[BatchHeaderStandardEntryClassCode]
      ,[BatchHeaderCompanyEntryDescription] + replicate('',10 - len([BatchHeaderCompanyEntryDescription])) as [BatchHeaderCompanyEntryDescription]
	  ,getdate() as BatchHeaderCompanyDescriptiveDate
	  ,CASE WHEN DATENAME(dw,DateAdd(day,BatchHeaderEffectiveEntryDateOffsetDays,getdate())) = 'Saturday' THEN DateAdd(day,BatchHeaderEffectiveEntryDateOffsetDays + 2,getdate())
			WHEN DATENAME(dw,DateAdd(day,BatchHeaderEffectiveEntryDateOffsetDays,getdate())) = 'Sunday' THEN DateAdd(day,BatchHeaderEffectiveEntryDateOffsetDays + 1,getdate())
			ELSE DateAdd(day,BatchHeaderEffectiveEntryDateOffsetDays,getdate()) END as BatchHeaderEffectiveEntryDate
	  ,'   ' as BatchHeaderSettlementDate
      ,[BatchHeaderOriginatorStatusCode]
      ,[BatchHeaderOriginatingDFI]
	  ,[EntryDetailRecordTypeCode]
	  ,c.[CountryDescriptionShort]
	  ,[FileRoutingHeaderRecord]
	  ,na.[IsActiveFlag]
  FROM [dbo].[cfgNACHAFileProfile] na
  INNER JOIN @FileData fd on na.NACHAFileProfileID = fd.NACHAFileProfileID
  INNER JOIN lkpCountry c ON na.CountryID = c.CountryID

END
GO
