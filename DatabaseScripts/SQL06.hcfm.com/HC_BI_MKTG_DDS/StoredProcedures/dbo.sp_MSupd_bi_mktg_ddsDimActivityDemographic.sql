/* CreateDate: 09/03/2021 09:37:05.250 , ModifyDate: 09/03/2021 09:37:05.250 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSupd_bi_mktg_ddsDimActivityDemographic]
		@c1 int = NULL,
		@c2 varchar(10) = NULL,
		@c3 varchar(10) = NULL,
		@c4 varchar(10) = NULL,
		@c5 char(1) = NULL,
		@c6 varchar(50) = NULL,
		@c7 varchar(10) = NULL,
		@c8 varchar(50) = NULL,
		@c9 varchar(10) = NULL,
		@c10 varchar(50) = NULL,
		@c11 varchar(10) = NULL,
		@c12 varchar(50) = NULL,
		@c13 date = NULL,
		@c14 int = NULL,
		@c15 varchar(10) = NULL,
		@c16 varchar(50) = NULL,
		@c17 varchar(50) = NULL,
		@c18 varchar(50) = NULL,
		@c19 varchar(50) = NULL,
		@c20 varchar(50) = NULL,
		@c21 varchar(50) = NULL,
		@c22 money = NULL,
		@c23 varchar(100) = NULL,
		@c24 varchar(200) = NULL,
		@c25 date = NULL,
		@c26 tinyint = NULL,
		@c27 datetime = NULL,
		@c28 datetime = NULL,
		@c29 varchar(200) = NULL,
		@c30 tinyint = NULL,
		@c31 int = NULL,
		@c32 int = NULL,
		@c33 nvarchar(10) = NULL,
		@c34 nvarchar(18) = NULL,
		@c35 nvarchar(18) = NULL,
		@c36 nvarchar(18) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(5)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [bi_mktg_dds].[DimActivityDemographic] set
		[ActivityDemographicSSID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ActivityDemographicSSID] end,
		[ActivitySSID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ActivitySSID] end,
		[ContactSSID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ContactSSID] end,
		[GenderSSID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [GenderSSID] end,
		[GenderDescription] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [GenderDescription] end,
		[EthnicitySSID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [EthnicitySSID] end,
		[EthnicityDescription] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [EthnicityDescription] end,
		[OccupationSSID] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [OccupationSSID] end,
		[OccupationDescription] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [OccupationDescription] end,
		[MaritalStatusSSID] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [MaritalStatusSSID] end,
		[MaritalStatusDescription] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [MaritalStatusDescription] end,
		[Birthday] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [Birthday] end,
		[Age] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [Age] end,
		[AgeRangeSSID] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [AgeRangeSSID] end,
		[AgeRangeDescription] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [AgeRangeDescription] end,
		[HairLossTypeSSID] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [HairLossTypeSSID] end,
		[HairLossTypeDescription] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [HairLossTypeDescription] end,
		[NorwoodSSID] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [NorwoodSSID] end,
		[LudwigSSID] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [LudwigSSID] end,
		[Performer] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [Performer] end,
		[PriceQuoted] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [PriceQuoted] end,
		[SolutionOffered] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [SolutionOffered] end,
		[NoSaleReason] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [NoSaleReason] end,
		[DateSaved] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [DateSaved] end,
		[RowIsCurrent] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [RowIsCurrent] end,
		[RowStartDate] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [RowStartDate] end,
		[RowEndDate] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [RowEndDate] end,
		[RowChangeReason] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [RowChangeReason] end,
		[RowIsInferred] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [RowIsInferred] end,
		[InsertAuditKey] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [UpdateAuditKey] end,
		[DiscStyleSSID] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [DiscStyleSSID] end,
		[SFDC_TaskID] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [SFDC_TaskID] end,
		[SFDC_LeadID] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [SFDC_LeadID] end,
		[SFDC_PersonAccountID] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [SFDC_PersonAccountID] end
	where [ActivityDemographicKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ActivityDemographicKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_mktg_dds].[DimActivityDemographic]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
