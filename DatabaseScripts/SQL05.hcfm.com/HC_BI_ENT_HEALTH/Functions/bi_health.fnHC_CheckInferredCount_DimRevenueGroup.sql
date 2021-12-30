/* CreateDate: 05/12/2010 11:31:22.153 , ModifyDate: 05/13/2010 14:51:35.733 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimRevenueGroup] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimRevenueGroup]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimRevenueGroup]()
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

RETURNS @tbl  TABLE (TableName varchar(150)
					, FieldKey bigint
					, FieldSSID varchar(150)
					)  AS
BEGIN



	DECLARE	  @TableName				varchar(150)	-- Name of table

 	SET @TableName = N'[bi_cms_dds].[DimRevenueGroup]'


	INSERT INTO @tbl
		SELECT @TableName, RevenueGroupKey, CAST(RevenueGroupSSID as varchar(150))
		FROM [bi_health].[synHC_DDS_DimRevenueGroup] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimRevenueGroup] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
