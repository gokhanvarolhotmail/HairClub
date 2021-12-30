/* CreateDate: 05/12/2010 11:26:06.253 , ModifyDate: 05/13/2010 14:41:38.560 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimBusinessSegment] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimBusinessSegment]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimBusinessSegment]()
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

 	SET @TableName = N'[bi_cms_dds].[DimBusinessSegment]'


	INSERT INTO @tbl
		SELECT @TableName, BusinessSegmentKey, CAST(BusinessSegmentSSID as varchar(150))
		FROM [bi_health].[synHC_DDS_DimBusinessSegment] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimBusinessSegment] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
