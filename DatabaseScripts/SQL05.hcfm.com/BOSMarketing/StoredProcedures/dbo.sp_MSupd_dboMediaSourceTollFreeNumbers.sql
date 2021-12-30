/* CreateDate: 07/30/2015 15:49:42.253 , ModifyDate: 07/30/2015 15:49:42.253 */
GO
create procedure [sp_MSupd_dboMediaSourceTollFreeNumbers]
		@c1 bit = NULL,
		@c2 int = NULL,
		@c3 varchar(50) = NULL,
		@c4 varchar(50) = NULL,
		@c5 varchar(50) = NULL,
		@c6 varchar(50) = NULL,
		@c7 varchar(50) = NULL,
		@c8 smalldatetime = NULL,
		@c9 varchar(200) = NULL,
		@c10 smallint = NULL,
		@c11 tinyint = NULL,
		@c12 varchar(50) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin
update [dbo].[MediaSourceTollFreeNumbers] set
		[Active] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [Active] end,
		[Number] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [Number] end,
		[SourceCode] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [SourceCode] end,
		[HCDNIS] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [HCDNIS] end,
		[VendorDNIS] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [VendorDNIS] end,
		[VoiceMail] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [VoiceMail] end,
		[AirDate] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [AirDate] end,
		[Notes] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [Notes] end,
		[QwestID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [QwestID] end,
		[NumberTypeID] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [NumberTypeID] end,
		[VendorDNIS2] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [VendorDNIS2] end
where [NumberID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
GO
