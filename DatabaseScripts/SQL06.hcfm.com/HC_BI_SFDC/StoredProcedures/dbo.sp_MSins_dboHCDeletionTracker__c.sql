/* CreateDate: 10/04/2019 14:09:30.323 , ModifyDate: 10/04/2019 14:09:30.323 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSins_dboHCDeletionTracker__c]
    @c1 nvarchar(18),
    @c2 uniqueidentifier,
    @c3 nvarchar(18),
    @c4 bit,
    @c5 nvarchar(80),
    @c6 datetime,
    @c7 nvarchar(18),
    @c8 datetime,
    @c9 nvarchar(18),
    @c10 nvarchar(50),
    @c11 nvarchar(18),
    @c12 nvarchar(18),
    @c13 nvarchar(18),
    @c14 bit,
    @c15 bit,
    @c16 bit,
    @c17 nvarchar(2000),
    @c18 datetime
as
begin
	insert into [dbo].[HCDeletionTracker__c] (
		[Id],
		[SessionID],
		[OwnerId],
		[IsDeleted],
		[Name],
		[CreatedDate],
		[CreatedById],
		[LastModifiedDate],
		[LastModifiedById],
		[ObjectName__c],
		[DeletedId__c],
		[DeletedById__c],
		[MasterRecordId__c],
		[ToBeProcessed__c],
		[IsProcessed],
		[IsError],
		[ErrorMessage],
		[LastProcessedDate__c]
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
		@c18	)
end
GO
