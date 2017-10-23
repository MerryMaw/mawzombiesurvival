

function DrawTextShadow(Txt, Fnt, x, y, col, Align, scol, sdis)
	DrawText(Txt, Fnt, x-sdis, y+sdis, scol, Align)
	DrawText(Txt, Fnt, x, y, col, Align)
end