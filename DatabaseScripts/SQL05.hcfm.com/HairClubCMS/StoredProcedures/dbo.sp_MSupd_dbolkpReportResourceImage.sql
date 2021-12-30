/* CreateDate: 05/05/2020 17:42:55.140 , ModifyDate: 05/05/2020 17:42:55.140 */
GO
create procedure [sp_MSupd_dbolkpReportResourceImage]
		@c1 int = NULL,
		@c2 nvarchar(50) = NULL,
		@c3 varbinary(max) = NULL,
		@c4 int = NULL,
		@c5 int = NULL,
		@c6 int = NULL,
		@c7 int = NULL,
		@c8 int = NULL,
		@c9 int = NULL,
		@c10 nvarchar(50) = NULL,
		@c11 int = NULL,
		@c12 int = NULL,
		@c13 int = NULL,
		@c14 bit = NULL,
		@c15 datetime = NULL,
		@c16 nvarchar(25) = NULL,
		@c17 datetime = NULL,
		@c18 nvarchar(25) = NULL,
		@c19 nvarchar(50) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[lkpReportResourceImage] set
		[ReportResourceImageName] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ReportResourceImageName] end,
		[ReportResourceImage] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ReportResourceImage] end,
		[NorwoodScaleID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [NorwoodScaleID] end,
		[LudwigScaleID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [LudwigScaleID] end,
		[ScalpHealthID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [ScalpHealthID] end,
		[ScalpRegionID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [ScalpRegionID] end,
		[EthnicityID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [EthnicityID] end,
		[GenderID] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [GenderID] end,
		[MimeType] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [MimeType] end,
		[SorenessLevelID] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [SorenessLevelID] end,
		[SebumLevelID] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [SebumLevelID] end,
		[FlakingLevelID] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [FlakingLevelID] end,
		[IsActiveFlag] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [IsActiveFlag] end,
		[CreateDate] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [LastUpdateUser] end,
		[RRImageCategory] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [RRImageCategory] end
	where [ReportResourceImageID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ReportResourceImageID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[lkpReportResourceImage]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
