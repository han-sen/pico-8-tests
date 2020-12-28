pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

function _init()
	player = {
		x = 112,
		y = 104,
		sprite = 66,
		speed = 1,
		size = 1,
		flip = true,
		dx = 0,
		dy = 0,
		mdx = 2,
		mdy = 3,
		acc = 0.5,
		accy = 4,
		anim = 0,
		running = false,
		jumping = false,
		falling = false,
		landing = false
	}
end

function _update()
	movePlayer()
end

function _draw()
	cls()
	map(0, 0, 0, 0, 128,64)
	drawPlayer()
end

function movePlayer()
	if btn(0) then 
		player.x -= player.speed
	end
	if btn(1) then 
		player.x += player.speed
	end
end

function drawPlayer()
	if btn(1) then 
		player.flip = false
	elseif btn(0) then 
		player.flip = true 
	end
	spr(player.sprite,player.x,player.y, player.size, player.size, player.flip)	
end

__gfx__
00000000000000000000000000111100000000000000000000000000000000000008800000288200101110100000000000000000000000001010010100000000
00000000000000000000000010000001005555000000000000555500000000000080080002888820100100000000000000000000000000000111111000000000
0070070000000000000000001000000105066050005555000526625000555500008888002800e082010100110000000000000000000000001100001100000000
000770000000000000000000100000010560065005066050056e8650052662500802808088000088010010110000000000000000000000000010010000000000
00077000000000000000000010000001056006500560065005688650056e86500866568088888888111000010000000000000000000001000010010000000000
0070070000000000000000001000000105066050056006500526625005688650008508002880e882011000010000000000000000000000000100001000000000
00000000000000000000000010000001005555000506605000555500052662500880288008088080100011000000000000000000000000000101101000000000
00000000000000000000000010000001000000000055550000000000005555000800008000288200101101110000000000000000000000001010010100000000
00010111666666666666666600000000000000000000c0000c000c000000c0c0000000000c000100600000061011110100000000000000011000000010100101
11010101555555555555555500001110011100000c0ccc00000ccc00000c0c00000c0000ccc00000060000600111111000001100000000000000000001111110
011101010000010100000000000000111100000000c6c6c000c6c6c000c6c6c0000000100c00c000006006001100001100000000000000000000000011000011
010111010000010100000000000011100111000006666660066666600666666000000000000000000056c0001010010100100001001111000011110001000010
01110111000001010000000000101111111101000616616006166160061661600566666666666650005160001010010100100001011000101110011000111100
11010111000001010000000011111010010111110566661005666610056666100056666666666500056556001100001100100001110000111000001100000000
01110101000001010000000001100111111001100060060000600600006006000005566666655000560000600101101000100001100000000000000100000000
10011111000001010000000011001018810100110000000000000000000000000000055555500000600000061011110100100001100110000001100100000000
00000000000000000000000000001110d11100000100011100111000000000000000000010111100001111011010010000100101000100000000100000000000
00000000000000000001000000000011110000001011100011000100000000000000000001111110011111100111111001111110000000000000000001111110
00800080000000000000000000000110011000001000100001000010000000000000000011000011110000111100001001000011000000011000000001000011
80080800000000000000000000001011110100001000010001000001000000000000000010100101101001010010010000100100100000111100000100100100
02022200000000000000000000011110011110001000010000100001000000000000000010100101101001010010010000100100111111100111111100100100
02012102000000000001000000111001100111001100001000100001000000000000000011000011110000110100001001000010011000000000011001000010
21211120000000000000000011110010010011110100001000010001000000000000000001011010010110100101101001011010000000000000000001011010
10110101000000000000000000100100001001001100010000010001000000000000000010111101101111011010010000100101000000000000000010100101
00666000000000000000000000000000000000001000010000100001000000000000000000010111111010000000000000000000000000000000000000000000
00666600000000000000000000000000000000001000010000100001000000000000000010001111111100010000000000000000000000000000000000000000
00060606000000000000000000000000000000001000110000100011000000000000000001011110011110100000000000000000000000000000000000000000
60666660000000000000000000000000000000001101111001100111000000000000000000111100001111000000000000000000000000000000000000000000
06666600000000000000000000000000000000000111001111011110000000000000000000001110011100000000000000000000000000000000000000000000
00066000000000000000000000000000000000000111000111001110000000000000000000000111111000000000000000000000000000000000000000000000
00006660000000000000000000000000000000000110000110001100000000000000000000000011110000000000000000000000000000000000000000000000
00000006000000000000000000000000000000000000000100001000000000000000000000000001100000000000000000000000000000000000000000000000
00000000000000000d01c0d0000000000d01c0d0000000000d01c0d00d01c0d00d01c0d000000000000000000000000000000000000000000000000000000000
00000000000000000d5111d00d01c0d00d5111d00d01c0d00d5111d00d5111d00d5111d000000000000000000000000000000000000000000000000000000000
0000000000000000001515000d5111d0001515000d5111d000151500001515000015150000000000000000000000000000000000000000000000000000000000
00000000000000000056660000551500005666000055150000566600005666000056660000000000000000000000000000000000000000000000000000000000
00000000000000000801118000166600080111800016660008011180080111800801118000000000000000000000000000000000000000000000000000000000
00000000000000000f1111f008f1118ff011110008f1118f0f1111f000f111000f1111f000000000000000000000000000000000000000000000000000000000
00000000000000000080080000111100008008000011110000800800000802000020080000000000000000000000000000000000000000000000000000000000
00000000000000000080080000800800080080000080080000800800000802000020080000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000067007600000110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000882000050000500001111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000008802800000000000011011100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000082800280000000001100011100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000080820028001111011000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000800002828851110000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000082510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000001801000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000028855110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000082511000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000001800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000028851000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000082010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0e0e0e0e0e0e0e0e0e0e2222222222220a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e0e0e0e0e0e0e0e2222222222221b00000000000000000000000000001b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e0e0e0e0e0e0e0e2222222222221b00000000000000000000000000001b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e0e0e0e0e0e0e0e2222222222221b0000000000000000002b2c0000001b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e2b130e0e0e0e142c0e2222222222221b000000000000000022393a2200001b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e050e0e050e0e0e2222222222221b00000000000000222200002222001b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e0e1d1e0e0e0e0e2222222222221b00000020200000222218192222001b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e0e2d2e0e0e0e0e2222222222221b0000000a0a0a0a0a0a0a0a0a0a0a1b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e0e0e0e0e0e0e0e2222222222221b00000000000000000000000000001b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e25260e0e25260e0e2222222222221b00000000000000000000001500201b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e35360e0e35360e0e220e292a0e220a0a0a0a0a0a0a0a0a00000a0a0a0a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e0e0e0e0e0e0e0e220e393a0e22000000000000000000000000000a0a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e0e0e0e0e0e0e0e220e00000e22000046000020000000000000000a0a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e0e0e0e0e0e0e0e220e18190e220a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1112111211121112111211121112111200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001e00000f0330f00000000000000d03300000000000a0000d0430000000000000000a0330000000000000000f0230f00000000000000d04300000087000f0000f0230000000000000000a033000000000000000
001e00000870508735040050c03508304083050700400c0500725004000274510300057550e745077450c031083050875503c0503c0509005070350875008500085050754502c050305508405073050575400c05
001e0000325040b5040d50509504085052c5042f504205041c50111514115041c5152c5002e5003350035500355043550436504365041c5012152422514215141d5111b5141e5141d51427501275041d50100504
001e000004407137040f7041370404400054001370406600056000c7400f704137040360003605036050460004407137040f704137041770019700187001970004407137040f7041370413700137050c7340c704
011e00002152422514215141d5111b5141e5141d5141d511000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002150422504215041d5011b504
__music__
03 01020304
02 01020344

