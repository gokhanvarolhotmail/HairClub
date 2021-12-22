create procedure [sp_MSupd_dbodatOutgoingResponseLog]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 varchar(50) = NULL,
		@c4 varchar(2000) = NULL,
		@c5 varchar(2000) = NULL,
		@c6 datetime = NULL,
		@c7 nvarchar(25) = NULL,
		@c8 datetime = NULL,
		@c9 nvarchar(25) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[datOutgoingResponseLog] set
		[OutgoingResponseID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [OutgoingResponseID] end,
		[OutgoingRequestID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [OutgoingRequestID] end,
		[SeibelID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [SeibelID] end,
		[ErrorMessage] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ErrorMessage] end,
		[ExceptionMessage] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ExceptionMessage] end,
		[CreateDate] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [LastUpdateUser] end
where [OutgoingResponseID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
else
begin
update [dbo].[datOutgoingResponseLog] set
		[OutgoingRequestID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [OutgoingRequestID] end,
		[SeibelID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [SeibelID] end,
		[ErrorMessage] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ErrorMessage] end,
		[ExceptionMessage] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ExceptionMessage] end,
		[CreateDate] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [LastUpdateUser] end
where [OutgoingResponseID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
end
