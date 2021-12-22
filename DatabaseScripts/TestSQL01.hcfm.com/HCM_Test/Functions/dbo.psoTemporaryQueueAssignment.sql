/* CreateDate: 12/17/2013 09:06:40.937 , ModifyDate: 12/17/2013 09:06:40.937 */
GO
CREATE FUNCTION dbo.psoTemporaryQueueAssignment
(
	@DueDateFull DATETIME, @ActionCode NCHAR(10), @LanguageCode NCHAR(10), @CreationDate DATETIME, @CreatedByUserCode NCHAR(20), @AgeRangeCode NCHAR(10)
)
RETURNS NCHAR(10)
AS
BEGIN
	DECLARE @Today DATETIME
	DECLARE @DueDate DATETIME
	SET @Today = dbo.CombineDates(GETDATE(), NULL)
	SET @DueDate = dbo.CombineDates(@DueDateFull, NULL)

	--	Return early if
	--		oncd_activity.due_date is in the future
	--		oncd_activity.creation_date is not yesterday
	--	as those are two criteria that will be used by all of the queues.
	IF (@DueDate > @Today AND @CreationDate <> DATEADD(DAY, -1, @Today))
	BEGIN
		RETURN NULL
	END

	IF (@LanguageCode = 'ENGLISH')
	BEGIN
		IF (@DueDate <= @Today)
		BEGIN
			-- E15O4OY1U1	NO SHOW ENG COMBINED
			IF (@ActionCode = 'NOSHOWCALL')
			BEGIN
				RETURN 'E15O4OY1U1'
			END
			-- HFKLCQTK41	CANCEL CALLS ENG COMBINED
			ELSE IF (@ActionCode = 'CANCELCALL')
			BEGIN
				RETURN 'HFKLCQTK41'
			END
			-- ICIDHM0EW1	Exception Queue
			ELSE IF (@ActionCode = 'EXOUTCALL')
			BEGIN
				RETURN 'ICIDHM0EW1'
			END
			-- K73VZ211T1	Broch Eng by Age
			ELSE IF (@ActionCode = 'BROCHCALL' AND NOT (@CreationDate <> @Today AND @CreatedByUserCode IN ('TM 500','TM 600')))
			BEGIN
				IF (@AgeRangeCode IN ('4','5','6','UNKNOWN') OR @AgeRangeCode IS NULL)
				BEGIN
					RETURN 'K73VZ211T1'
				END
				-- MA4JAEMWX1	Broch Eng Age Remaining
				ELSE IF (@AgeRangeCode NOT IN ('4','5','6','UNKNOWN'))
				BEGIN
					RETURN 'MA4JAEMWX1'
				END
			END
		END
		-- XWBSHLOWW1	NO BUY ENG >15 COMBINED
		ELSE IF (@ActionCode = 'SHNOBUYCAL' AND @DueDate <= DATEADD(DAY, -15, @Today))
		BEGIN
			RETURN 'XWBSHLOWW1'
		END
		-- B1GK18X6N1	INTERNET HOT A11
		IF (@ActionCode = 'BROCHCALL' AND @CreatedByUserCode IN ('TM 500', 'TM 600') AND @CreationDate = DATEADD(DAY, -1, @Today))
		BEGIN
			RETURN 'B1GK18X6N1'
		END
	END
	ELSE IF (@LanguageCode = 'SPANISH')
	BEGIN
		IF (@DueDate <= @Today)
		BEGIN
			-- ATM0JLPHE1	Cancel Calls Spanish
			IF (@ActionCode = 'CANCELCALL')
			BEGIN
				RETURN 'ATM0JLPHE1'
			END
			-- C2RNO5C1L1	No Show Spanish
			ELSE IF (@ActionCode = 'NOSHOWCALL')
			BEGIN
				RETURN 'C2RNO5C1L1'
			END
			ELSE IF (@ActionCode = 'BROCHCALL')
			BEGIN
				-- ROM6ZOTD21	Broch SP Age Remaining
				IF (@AgeRangeCode NOT IN ('4','5','6','UNKNOWN'))
				BEGIN
					RETURN 'ROM6ZOTD21'
				END
				-- CBLFS3NVK1	Broch SP by Age
				ELSE IF (@AgeRangeCode IN ('4','5','6','UNKNOWN') OR @AgeRangeCode IS NULL)
				BEGIN
					RETURN 'CBLFS3NVK1'
				END
			END
		END
		-- SG3AAK8621	Nobuy Spanish
		ELSE IF (@ActionCode = 'SHNOBUYCAL' AND @DueDate <= DATEADD(DAY, -15, @Today))
		BEGIN
			RETURN 'SG3AAK8621'
		END
	END

	RETURN NULL
END
GO
