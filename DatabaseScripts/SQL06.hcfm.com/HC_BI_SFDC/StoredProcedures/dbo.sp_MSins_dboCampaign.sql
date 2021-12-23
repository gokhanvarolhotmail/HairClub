/* CreateDate: 10/04/2019 14:09:30.223 , ModifyDate: 10/04/2019 14:09:30.223 */
GO
create procedure [sp_MSins_dboCampaign]
    @c1 nvarchar(18),
    @c2 nvarchar(80),
    @c3 bit,
    @c4 nvarchar(18),
    @c5 nvarchar(50),
    @c6 nvarchar(50),
    @c7 nvarchar(50),
    @c8 nvarchar(50),
    @c9 nvarchar(50),
    @c10 nvarchar(50),
    @c11 nvarchar(50),
    @c12 nvarchar(50),
    @c13 nvarchar(50),
    @c14 nvarchar(50),
    @c15 nvarchar(50),
    @c16 nvarchar(50),
    @c17 nvarchar(50),
    @c18 nvarchar(30),
    @c19 nvarchar(50),
    @c20 datetime,
    @c21 datetime,
    @c22 nvarchar(50),
    @c23 nvarchar(50),
    @c24 nvarchar(50),
    @c25 nvarchar(50),
    @c26 nvarchar(50),
    @c27 nvarchar(255),
    @c28 bit,
    @c29 nvarchar(50),
    @c30 nvarchar(50),
    @c31 nvarchar(50),
    @c32 nvarchar(50),
    @c33 nvarchar(50),
    @c34 nvarchar(50),
    @c35 nvarchar(255),
    @c36 nvarchar(50),
    @c37 nvarchar(50),
    @c38 nvarchar(50),
    @c39 nvarchar(50),
    @c40 nvarchar(255),
    @c41 nvarchar(255),
    @c42 nvarchar(255),
    @c43 nvarchar(50),
    @c44 nvarchar(255),
    @c45 int,
    @c46 float,
    @c47 money,
    @c48 money,
    @c49 money,
    @c50 int,
    @c51 int,
    @c52 int,
    @c53 int,
    @c54 int,
    @c55 int,
    @c56 money,
    @c57 money,
    @c58 nvarchar(100),
    @c59 nvarchar(50),
    @c60 nvarchar(100),
    @c61 nvarchar(10),
    @c62 nvarchar(50),
    @c63 nvarchar(50),
    @c64 nvarchar(50),
    @c65 nvarchar(50),
    @c66 nvarchar(50),
    @c67 nvarchar(50),
    @c68 nvarchar(50),
    @c69 nvarchar(255),
    @c70 nvarchar(50),
    @c71 nvarchar(50),
    @c72 nvarchar(50),
    @c73 nvarchar(50),
    @c74 nvarchar(50),
    @c75 nvarchar(50),
    @c76 nvarchar(50),
    @c77 nvarchar(50),
    @c78 nvarchar(50),
    @c79 nvarchar(50),
    @c80 nvarchar(50),
    @c81 nvarchar(50),
    @c82 bit,
    @c83 nvarchar(18),
    @c84 datetime,
    @c85 nvarchar(18),
    @c86 datetime
as
begin
	insert into [dbo].[Campaign] (
		[Id],
		[Name],
		[IsActive],
		[ParentId],
		[Type],
		[PromoCode__c],
		[Channel__c],
		[ShortcodeChannel__c],
		[Language__c],
		[Media__c],
		[ShortcodeMedia__c],
		[Source__c],
		[ShortcodeOrigin__c],
		[Format__c],
		[ShortcodeFormat__c],
		[Goal__c],
		[PromoCodeName__c],
		[SourceCodeNumber__c],
		[Status],
		[StartDate],
		[EndDate],
		[Gender__c],
		[CampaignType__c],
		[CommunicationType__c],
		[TollFreeName__c],
		[TollFreeMobileName__c],
		[URLDomain__c],
		[GenerateCodes__c],
		[SourceCode_L__c],
		[DPNCode__c],
		[DWFCode__c],
		[DWCCode__c],
		[DNIS__c],
		[DNISMobile__c],
		[Referrer__c],
		[SCNumber__c],
		[MPNCode__c],
		[MWFCode__c],
		[MWCCode__c],
		[ACE_Decription__c],
		[Description],
		[WebCode__c],
		[Location__c],
		[PromoCodeDisplay__c],
		[NumberSent],
		[ExpectedResponse],
		[BudgetedCost],
		[ActualCost],
		[ExpectedRevenue],
		[NumberOfResponses],
		[NumberOfLeads],
		[NumberOfConvertedLeads],
		[NumberOfContacts],
		[NumberOfOpportunities],
		[NumberOfWonOpportunities],
		[AmountAllOpportunities],
		[AmountWonOpportunities],
		[Promo_Code_L__c],
		[SourceID_L__c],
		[SourceName_L__c],
		[IsInHouseSourceFlag_L__c],
		[PhoneID_L__c],
		[Number_L__c],
		[NumberTypeID_L__c],
		[NumberType_L__c],
		[MediaID_L__c],
		[Media_L__c],
		[MediaCode_L__c],
		[Notes_L__c],
		[Campaign_Counter__c],
		[Level02LocationCode_L__c],
		[Level02Location_L__c],
		[Level03ID_L__c],
		[Level03LanguageCode_L__c],
		[Level03Language_L__c],
		[Level04ID_L__c],
		[Level04FormatCode_L__c],
		[Level04Format_L__c],
		[Level05ID_L__c],
		[Level05CreativeCode_L__c],
		[Level05Creative_L__c],
		[IsDeleted],
		[CreatedById],
		[CreatedDate],
		[LastModifiedById],
		[LastModifiedDate]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9,
		@c10,
		@c11,
		@c12,
		@c13,
		@c14,
		@c15,
		@c16,
		@c17,
		@c18,
		@c19,
		@c20,
		@c21,
		@c22,
		@c23,
		@c24,
		@c25,
		@c26,
		@c27,
		@c28,
		@c29,
		@c30,
		@c31,
		@c32,
		@c33,
		@c34,
		@c35,
		@c36,
		@c37,
		@c38,
		@c39,
		@c40,
		@c41,
		@c42,
		@c43,
		@c44,
		@c45,
		@c46,
		@c47,
		@c48,
		@c49,
		@c50,
		@c51,
		@c52,
		@c53,
		@c54,
		@c55,
		@c56,
		@c57,
		@c58,
		@c59,
		@c60,
		@c61,
		@c62,
		@c63,
		@c64,
		@c65,
		@c66,
		@c67,
		@c68,
		@c69,
		@c70,
		@c71,
		@c72,
		@c73,
		@c74,
		@c75,
		@c76,
		@c77,
		@c78,
		@c79,
		@c80,
		@c81,
		@c82,
		@c83,
		@c84,
		@c85,
		@c86	)
end
GO