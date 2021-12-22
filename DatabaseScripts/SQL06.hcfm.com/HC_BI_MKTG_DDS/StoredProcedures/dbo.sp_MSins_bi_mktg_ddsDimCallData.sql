create procedure [dbo].[sp_MSins_bi_mktg_ddsDimCallData]
    @c1 int,
    @c2 nvarchar(50),
    @c3 nvarchar(50),
    @c4 nvarchar(10),
    @c5 date,
    @c6 varchar(8),
    @c7 nvarchar(15),
    @c8 nvarchar(50),
    @c9 nvarchar(15),
    @c10 nvarchar(18),
    @c11 nvarchar(30),
    @c12 nvarchar(100),
    @c13 nvarchar(18),
    @c14 nvarchar(30),
    @c15 nvarchar(100),
    @c16 nvarchar(15),
    @c17 nvarchar(50),
    @c18 nvarchar(15),
    @c19 nvarchar(18),
    @c20 nvarchar(18),
    @c21 nvarchar(18),
    @c22 nvarchar(30),
    @c23 nvarchar(100),
    @c24 nvarchar(50),
    @c25 nvarchar(15),
    @c26 nvarchar(50),
    @c27 nvarchar(50),
    @c28 nvarchar(10),
    @c29 int,
    @c30 int,
    @c31 binary(8),
    @c32 nvarchar(20),
    @c33 nvarchar(105)
as
begin
	insert into [bi_mktg_dds].[DimCallData] (
		[CallRecordKey],
		[CallRecordSSID],
		[OriginalCallRecordSSID],
		[CenterSSID],
		[CallDate],
		[CallTime],
		[CallTypeSSID],
		[CallTypeDescription],
		[CallTypeGroup],
		[InboundCampaignID],
		[InboundSourceSSID],
		[InboundSourceDescription],
		[LeadCampaignID],
		[LeadSourceSSID],
		[LeadSourceDescription],
		[CallStatusSSID],
		[CallStatusDescription],
		[CallPhoneNo],
		[SFDC_LeadID],
		[SFDC_TaskID],
		[TaskCampaignID],
		[TaskSourceSSID],
		[TaskSourceDescription],
		[UsedBy],
		[AdditionalCallStatusSSID],
		[AdditionalCallStatusDescription],
		[UserSSID],
		[NobleUserSSID],
		[IsViableCall],
		[CallLength],
		[RowTimeStamp],
		[TollFreeNumber],
		[UserFullName]
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
		@c33	)
end
