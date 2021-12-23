/* CreateDate: 02/24/2020 09:00:10.633 , ModifyDate: 02/24/2020 09:00:10.633 */
GO
create procedure [dbo].[sp_MSins_dboSurvey_Response__c]
    @c1 nvarchar(18),
    @c2 nvarchar(255),
    @c3 nvarchar(18),
    @c4 nvarchar(255),
    @c5 nvarchar(18),
    @c6 nvarchar(255),
    @c7 nvarchar(255),
    @c8 nvarchar(105),
    @c9 nvarchar(255),
    @c10 nvarchar(255),
    @c11 nvarchar(255),
    @c12 nvarchar(255),
    @c13 nvarchar(255),
    @c14 nvarchar(255),
    @c15 nvarchar(255),
    @c16 nvarchar(255),
    @c17 ntext,
    @c18 nvarchar(255),
    @c19 nvarchar(18),
    @c20 nvarchar(18),
    @c21 datetime,
    @c22 datetime,
    @c23 nvarchar(255),
    @c24 nvarchar(255),
    @c25 nvarchar(18),
    @c26 nvarchar(255),
    @c27 nvarchar(50),
    @c28 nvarchar(18),
    @c29 nvarchar(255),
    @c30 nvarchar(18),
    @c31 int,
    @c32 int,
    @c33 int,
    @c34 int,
    @c35 int,
    @c36 int,
    @c37 int,
    @c38 int,
    @c39 int,
    @c40 int,
    @c41 int,
    @c42 int,
    @c43 int,
    @c44 int,
    @c45 int,
    @c46 int,
    @c47 int,
    @c48 int,
    @c49 int,
    @c50 int,
    @c51 int,
    @c52 nvarchar(255),
    @c53 int,
    @c54 nvarchar(255),
    @c55 int,
    @c56 ntext,
    @c57 int,
    @c58 nvarchar(255),
    @c59 nvarchar(255),
    @c60 int,
    @c61 int,
    @c62 int,
    @c63 nvarchar(255),
    @c64 int,
    @c65 int,
    @c66 int,
    @c67 int,
    @c68 int,
    @c69 nvarchar(255),
    @c70 int,
    @c71 nvarchar(255),
    @c72 ntext,
    @c73 int,
    @c74 int,
    @c75 nvarchar(255),
    @c76 ntext,
    @c77 int,
    @c78 nvarchar(255),
    @c79 int,
    @c80 nvarchar(255),
    @c81 int,
    @c82 ntext,
    @c83 int,
    @c84 int,
    @c85 nvarchar(255),
    @c86 nvarchar(255),
    @c87 int,
    @c88 int,
    @c89 int,
    @c90 int,
    @c91 int,
    @c92 int,
    @c93 int,
    @c94 int,
    @c95 int,
    @c96 int,
    @c97 int,
    @c98 int,
    @c99 int,
    @c100 int,
    @c101 int,
    @c102 nvarchar(255),
    @c103 int,
    @c104 nvarchar(255),
    @c105 nvarchar(255),
    @c106 nvarchar(255),
    @c107 nvarchar(255),
    @c108 nvarchar(255),
    @c109 nvarchar(255),
    @c110 nvarchar(255),
    @c111 nvarchar(18),
    @c112 datetime,
    @c113 nvarchar(18),
    @c114 datetime
as
begin
	insert into [dbo].[Survey_Response__c] (
		[Id],
		[Lead__c],
		[Lead_Id__c],
		[Contact__c],
		[Contact_Id__c],
		[First_Name__c],
		[Last_Name__c],
		[Email__c],
		[City__c],
		[Postal_Code__c],
		[Region_Code__c],
		[Region_Name__c],
		[Country_Code__c],
		[Country_Name__c],
		[Survey_Name__c],
		[Name],
		[Full_Text__c],
		[Trigger_Task_Id__c],
		[OwnerId],
		[RecordTypeId],
		[Start_Time__c],
		[Completion_Time__c],
		[Status__c],
		[Review_Status__c],
		[Reviewed_By__c],
		[API_ID__c],
		[Case__c],
		[Case_Id__c],
		[Chat_Transcript__c],
		[Chat_Transcript_Id__c],
		[GF1_10__c],
		[GF1_20__c],
		[GF1_30__c],
		[GF1_40__c],
		[GF1_50__c],
		[GF1_60__c],
		[GF1_70__c],
		[GF1_80__c],
		[GF1_90__c],
		[GF1_100__c],
		[GF2_10__c],
		[GF2_20__c],
		[GF2_30__c],
		[GF2_40__c],
		[GF2_50__c],
		[GF2_60__c],
		[GF2_70__c],
		[GF2_80__c],
		[GF2_90__c],
		[GF310__c],
		[GF3100__c],
		[GF3110__c],
		[GF3120__c],
		[GF3130__c],
		[GF3140__c],
		[GF3150__c],
		[GF3160__c],
		[GF3170__c],
		[GF3180__c],
		[GF3190__c],
		[GF320__c],
		[GF3200__c],
		[GF3210__c],
		[GF3220__c],
		[GF3230__c],
		[GF330__c],
		[GF340__c],
		[GF350__c],
		[GF360__c],
		[GF370__c],
		[GF380__c],
		[GF390__c],
		[GF410__c],
		[GF4100__c],
		[GF4110__c],
		[GF4120__c],
		[GF4130__c],
		[GF4140__c],
		[GF4150__c],
		[GF4160__c],
		[GF4170__c],
		[GF4180__c],
		[GF4190__c],
		[GF420__c],
		[GF4200__c],
		[GF4210__c],
		[GF4220__c],
		[GF4230__c],
		[GF4240__c],
		[GF4250__c],
		[GF4260__c],
		[GF4270__c],
		[GF4280__c],
		[GF4290__c],
		[GF430__c],
		[GF4300__c],
		[GF4310__c],
		[GF4320__c],
		[GF440__c],
		[GF450__c],
		[GF460__c],
		[GF470__c],
		[GF480__c],
		[GF490__c],
		[gf_id__c],
		[gf_unique__c],
		[IP_Address__c],
		[Language__c],
		[Link_to_Response__c],
		[Link_to_Summary_Report__c],
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
		@c86,
		@c87,
		@c88,
		@c89,
		@c90,
		@c91,
		@c92,
		@c93,
		@c94,
		@c95,
		@c96,
		@c97,
		@c98,
		@c99,
		@c100,
		@c101,
		@c102,
		@c103,
		@c104,
		@c105,
		@c106,
		@c107,
		@c108,
		@c109,
		@c110,
		@c111,
		@c112,
		@c113,
		@c114	)
end
GO