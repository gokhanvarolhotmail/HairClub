/* CreateDate: 10/03/2019 23:03:39.733 , ModifyDate: 10/03/2019 23:03:39.733 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSins_bi_cms_ddsDimAccumulator]
    @c1 int,
    @c2 int,
    @c3 nvarchar(50),
    @c4 nvarchar(10),
    @c5 int,
    @c6 nvarchar(50),
    @c7 nvarchar(10),
    @c8 int,
    @c9 nvarchar(50),
    @c10 nvarchar(10),
    @c11 int,
    @c12 nvarchar(50),
    @c13 nvarchar(10),
    @c14 tinyint,
    @c15 datetime,
    @c16 datetime,
    @c17 varchar(200),
    @c18 tinyint,
    @c19 int,
    @c20 int,
    @c21 uniqueidentifier
as
begin
	insert into [bi_cms_dds].[DimAccumulator] (
		[AccumulatorKey],
		[AccumulatorSSID],
		[AccumulatorDescription],
		[AccumulatorDescriptionShort],
		[AccumulatorDataTypeSSID],
		[AccumulatorDataTypeDescription],
		[AccumulatorDataTypeDescriptionShort],
		[SchedulerActionTypeSSID],
		[SchedulerActionTypeDescription],
		[SchedulerActionTypeDescriptionShort],
		[SchedulerAdjustmentTypeSSID],
		[SchedulerAdjustmentTypeDescription],
		[SchedulerAdjustmentTypeDescriptionShort],
		[RowIsCurrent],
		[RowStartDate],
		[RowEndDate],
		[RowChangeReason],
		[RowIsInferred],
		[InsertAuditKey],
		[UpdateAuditKey],
		[RowTimeStamp],
		[msrepl_tran_version]
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
		default,
		@c21	)
end
GO
