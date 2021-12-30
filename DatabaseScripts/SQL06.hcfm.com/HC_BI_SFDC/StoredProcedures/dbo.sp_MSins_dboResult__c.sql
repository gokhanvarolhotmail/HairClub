/* CreateDate: 10/04/2019 14:09:30.447 , ModifyDate: 10/04/2019 14:09:30.447 */
GO
create procedure [sp_MSins_dboResult__c]
    @c1 int,
    @c2 nvarchar(50),
    @c3 nchar(10),
    @c4 bit,
    @c5 nvarchar(18),
    @c6 datetime,
    @c7 nvarchar(18),
    @c8 datetime,
    @c9 nvarchar(50)
as
begin
	insert into [dbo].[Result__c] (
		[Id],
		[Result__c],
		[ONC_ResultCode],
		[IsActiveFlag],
		[CreatedById],
		[CreatedDate],
		[LastModifiedById],
		[LastModifiedDate],
		[ONC_ResultCodeDescription]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9	)
end
GO
