--strayhorn
--by Mike Hansen

x=64
y=64

function _update()
 if (btn(0)) then x-=1 end
 if (btn(1)) then x+=1 end
 if (btn(2)) then y-=1 end
 if (btn(3)) then y+=1 end
end

function _draw()
 rectfill(0,0,127,127,5)
 circfill(x,y,7,14)
end
