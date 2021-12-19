pldi 255 5 mm0
movq mm0 mm7
psrlq 40 mm7
paddb mm0 mm7
psrlw 8 mm0
packuswb mm1 mm0
psrld 16 mm0
movd mm0 mm1
pandn mm1 mm2
pxor mm1 mm2
punpcklbw mm2 mm3
movq mm3 mm4
paddd mm0 mm4
movq mm4 mm5
punpcklwd mm5 mm6