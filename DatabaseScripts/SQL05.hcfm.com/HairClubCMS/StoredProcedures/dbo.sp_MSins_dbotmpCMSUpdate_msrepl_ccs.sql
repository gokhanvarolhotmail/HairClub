/* CreateDate: 02/27/2017 09:26:21.783 , ModifyDate: 02/27/2017 09:26:21.783 */
GO
create procedure [dbo].[sp_MSins_dbotmpCMSUpdate_msrepl_ccs]
		@c1 int,
		@c2 int,
		@c3 int,
		@c4 nvarchar(25),
		@c5 int,
		@c6 datetime,
		@c7 datetime,
		@c8 bit,
		@c9 nvarchar(max),
		@c10 int,
		@c11 datetime,
		@c12 nvarchar(25),
		@c13 datetime,
		@c14 nvarchar(25)
as
begin
if exists (select *
             from [dbo].[tmpCMSUpdate]
            where [CMSUpdateId] = @c1)
begin
update [dbo].[tmpCMSUpdate] set
		[CenterId] = @c2,
		[Client_no] = @c3,
		[HairSystemOrderNumber] = @c4,
		[CMS25Transact_no] = @c5,
		[CMS25TransactionDate] = @c6,
		[ProcessedDate] = @c7,
		[IsSuccessful] = @c8,
		[ErrorMessage] = @c9,
		[ErrorCode] = @c10,
		[CreateDate] = @c11,
		[CreateUser] = @c12,
		[LastUpdate] = @c13,
		[LastUpdateUser] = @c14
where [CMSUpdateId] = @c1
end
else
begin
	insert into [dbo].[tmpCMSUpdate](
		[CMSUpdateId],
		[CenterId],
		[Client_no],
		[HairSystemOrderNumber],
		[CMS25Transact_no],
		[CMS25TransactionDate],
		[ProcessedDate],
		[IsSuccessful],
		[ErrorMessage],
		[ErrorCode],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser]
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
    @c14	)
end
end
GO
