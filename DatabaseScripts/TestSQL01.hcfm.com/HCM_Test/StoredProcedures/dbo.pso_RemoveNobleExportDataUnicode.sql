/* CreateDate: 06/04/2012 10:54:00.240 , ModifyDate: 03/13/2013 12:18:21.077 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 4 June 2012
-- Description:	Removes Unicode from cstd_noble_export_data.
-- =============================================
CREATE PROCEDURE [dbo].[pso_RemoveNobleExportDataUnicode]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    UPDATE cstd_noble_export_data
	SET
		FirstName = dbo.RemoveUnicode(FirstName),
		LastName = dbo.RemoveUnicode(LastName),
		City = dbo.RemoveUnicode(City),
		StateName = dbo.RemoveUnicode(StateName),
		ZipCode = dbo.RemoveUnicode(ZipCode),
		TimeZone = dbo.RemoveUnicode(TimeZone),
		CntryCodePrePri = dbo.RemoveUnicode(CntryCodePrePri),
		AreaCodePri = dbo.RemoveUnicode(AreaCodePri),
		PhoneNumberPri = dbo.RemoveUnicode(PhoneNumberPri),
		PhoneTypeCodePri = dbo.RemoveUnicode(PhoneTypeCodePri),
		CntryCodePreBus = dbo.RemoveUnicode(CntryCodePreBus),
		AreaCodeBus = dbo.RemoveUnicode(AreaCodeBus),
		PhoneNumberBus = dbo.RemoveUnicode(PhoneNumberBus),
		PhoneTypeCodeBus = dbo.RemoveUnicode(PhoneTypeCodeBus),
		CntryCodePreHM = dbo.RemoveUnicode(CntryCodePreHM),
		AreaCodeHM = dbo.RemoveUnicode(AreaCodeHM),
		PhoneNumberHM = dbo.RemoveUnicode(PhoneNumberHM),
		PhoneTypeCodeHM = dbo.RemoveUnicode(PhoneTypeCodeHM),
		CntryCodePreCL = dbo.RemoveUnicode(CntryCodePreCL),
		AreaCodeCL = dbo.RemoveUnicode(AreaCodeCL),
		PhoneNumberCL = dbo.RemoveUnicode(PhoneNumberCL),
		PhoneTypeCodeCL = dbo.RemoveUnicode(PhoneTypeCodeCL),
		CntryCodePreHM2 = dbo.RemoveUnicode(CntryCodePreHM2),
		AreaCodeHM2 = dbo.RemoveUnicode(AreaCodeHM2),
		PhoneNumberHM2 = dbo.RemoveUnicode(PhoneNumberHM2),
		PhoneTypeCodeHM2 = dbo.RemoveUnicode(PhoneTypeCodeHM2),
		PrimaryCenterNum = dbo.RemoveUnicode(PrimaryCenterNum),
		PrimaryCenterName = dbo.RemoveUnicode(PrimaryCenterName),
		AgeRangeDesc = dbo.RemoveUnicode(AgeRangeDesc),
		HairLossAltDesc = dbo.RemoveUnicode(HairLossAltDesc),
		LanguageDesc = dbo.RemoveUnicode(LanguageDesc),
		GenderDesc = dbo.RemoveUnicode(GenderDesc),
		PriSourceCodeDesc = dbo.RemoveUnicode(PriSourceCodeDesc),
		CurrentSourceCode = dbo.RemoveUnicode(CurrentSourceCode),
		PromoCodeDesc = dbo.RemoveUnicode(PromoCodeDesc),
		LeadCreationDate = dbo.RemoveUnicode(LeadCreationDate),
		LastActvityDate = dbo.RemoveUnicode(LastActvityDate),
		LastResultDesc = dbo.RemoveUnicode(LastResultDesc),
		OpenCallActivityId = dbo.RemoveUnicode(OpenCallActivityId),
		ActionCodeDesc = dbo.RemoveUnicode(ActionCodeDesc),
		DueDate = dbo.RemoveUnicode(DueDate),
		StartTime = dbo.RemoveUnicode(StartTime),
		CurrOpenApptDate = dbo.RemoveUnicode(CurrOpenApptDate),
		CurrOpenApptTime = dbo.RemoveUnicode(CurrOpenApptTime),
		DateOfLastAppt = dbo.RemoveUnicode(DateOfLastAppt),
		LastApptResultDesc = dbo.RemoveUnicode(LastApptResultDesc),
		CurrOpenApptType = dbo.RemoveUnicode(CurrOpenApptType),
		LeadCreatedBy = dbo.RemoveUnicode(LeadCreatedBy)

END
GO
