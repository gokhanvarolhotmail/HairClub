/* CreateDate: 05/12/2010 11:30:12.560 , ModifyDate: 05/13/2010 14:49:23.817 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimIncomeRange] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimIncomeRange]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimIncomeRange]()
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

 	SET @TableName = N'[bi_cms_dds].[DimIncomeRange]'


	INSERT INTO @tbl
		SELECT @TableName, IncomeRangeKey, CAST(IncomeRangeSSID as varchar(150))
		FROM [bi_health].[synHC_DDS_DimIncomeRange] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimIncomeRange] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
