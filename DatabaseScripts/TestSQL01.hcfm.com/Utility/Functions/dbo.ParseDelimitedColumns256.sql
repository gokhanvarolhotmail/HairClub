/* CreateDate: 02/24/2022 11:44:30.217 , ModifyDate: 02/24/2022 11:44:30.217 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[ParseDelimitedColumns256](@record [nvarchar](max), @delim [nvarchar](255))
RETURNS  TABLE (
	[Cnt] [int] NULL,
	[C1] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C2] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C3] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C4] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C5] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C6] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C7] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C8] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C9] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C10] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C11] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C12] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C13] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C14] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C15] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C16] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C17] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C18] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C19] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C20] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C21] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C22] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C23] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C24] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C25] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C26] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C27] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C28] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C29] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C30] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C31] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C32] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C33] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C34] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C35] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C36] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C37] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C38] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C39] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C40] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C41] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C42] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C43] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C44] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C45] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C46] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C47] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C48] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C49] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C50] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C51] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C52] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C53] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C54] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C55] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C56] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C57] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C58] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C59] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C60] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C61] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C62] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C63] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C64] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C65] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C66] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C67] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C68] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C69] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C70] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C71] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C72] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C73] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C74] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C75] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C76] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C77] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C78] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C79] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C80] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C81] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C82] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C83] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C84] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C85] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C86] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C87] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C88] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C89] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C90] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C91] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C92] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C93] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C94] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C95] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C96] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C97] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C98] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C99] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C100] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C101] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C102] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C103] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C104] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C105] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C106] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C107] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C108] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C109] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C110] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C111] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C112] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C113] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C114] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C115] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C116] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C117] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C118] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C119] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C120] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C121] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C122] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C123] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C124] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C125] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C126] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C127] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C128] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C129] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C130] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C131] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C132] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C133] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C134] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C135] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C136] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C137] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C138] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C139] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C140] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C141] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C142] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C143] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C144] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C145] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C146] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C147] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C148] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C149] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C150] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C151] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C152] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C153] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C154] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C155] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C156] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C157] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C158] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C159] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C160] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C161] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C162] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C163] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C164] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C165] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C166] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C167] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C168] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C169] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C170] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C171] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C172] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C173] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C174] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C175] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C176] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C177] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C178] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C179] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C180] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C181] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C182] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C183] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C184] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C185] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C186] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C187] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C188] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C189] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C190] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C191] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C192] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C193] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C194] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C195] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C196] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C197] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C198] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C199] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C200] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C201] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C202] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C203] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C204] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C205] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C206] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C207] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C208] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C209] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C210] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C211] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C212] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C213] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C214] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C215] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C216] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C217] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C218] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C219] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C220] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C221] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C222] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C223] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C224] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C225] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C226] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C227] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C228] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C229] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C230] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C231] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C232] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C233] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C234] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C235] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C236] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C237] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C238] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C239] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C240] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C241] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C242] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C243] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C244] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C245] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C246] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C247] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C248] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C249] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C250] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C251] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C252] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C253] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C254] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C255] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[C256] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [StringUtilClr].[StringUtilClr.ParseDelimitedColumns256class].[ParseDelimitedColumns256]
GO