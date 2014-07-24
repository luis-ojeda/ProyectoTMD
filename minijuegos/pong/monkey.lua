
--canvas:drawRect (mode, x, y, w, h)
--crea la pocicion inicial del las paletas del pong
local width, height = canvas:attrSize()   -- pega as dimensões da região
local fx, fy = width, height 
local pong_user = { x=10, y=10, dx=20, dy=50 }
local pong_cpu = { x=fx-30, y=10, dx=20, dy=50 }

local puntos= {usuario = 0, CPU = 0}

local pelota = { x=fx/2, y=fy/2, dx=20, dy=20 , dir_x = -10 ,dir_y= 10 }


--obtiene valores de la region
--local width, height = canvas:attrSize()   -- pega as dimensões da região
--local fx, fy = width, height 
local fondo = { x=0, y=0, dx=fx-10, dy=fy -10} -- genera una area en la cual este contenido todo 

-- Función de redibujado:
-- Llamada por cada tecla presionada
-- primero el fondo, luego la banana y al final el mono
function redraw ()
	canvas:attrColor('white')
	canvas:drawRect('fill', 0,0, canvas:attrSize())
	canvas:attrColor('black')
	canvas:drawRect ('fill', pelota.x, pelota.y, pelota.dx,pelota.dy)
	canvas:drawRect ('fill', pong_user.x, pong_user.y, pong_user.dx,pong_user.dy)
	canvas:drawRect ('fill', pong_cpu.x, pong_cpu.y, pong_cpu.dx,pong_cpu.dy)
	canvas:attrFont("vera", 24)
	canvas:drawText(40, 10, tostring (puntos.usuario) )
	canvas:drawText(fx-40, 10, tostring (puntos.CPU) )
	canvas:flush()
end

-- Funcao de colisión:
-- llamada por cada tecla presionada
-- evalúa si el mono está encima de la banana
function collide (A, B)
	local ax1, ay1 = A.x, A.y
	local ax2, ay2 = ax1+A.dx, ay1+A.dy
	local bx1, by1 = B.x, B.y
	local bx2, by2 = bx1+B.dx, by1+B.dy

	if ax1 > bx2 then
		return false
	elseif bx1 > ax2 then
		return false
	elseif ay1 > by2 then
		return false
	elseif by1 > ay2 then
		return false
	end

	return true
end

local IGNORE = false

--funcion que mueve el objeto a trapar
local function mover_objeto( )
	-- body
	local dir_x = 20
	local dir_y = 20
	local ax1, ay1 = pelota.x , pelota.y   --puntos superiores del objeto
	local ax2, ay2 = ax1+ pelota.dx , ay1 + pelota.dy --puntos inferiores del objeto
	local bx1, by1 = fondo.x, fondo.y    --punto superio del fondo
	local bx2, by2 = bx1 + fondo.dx, by1 + fondo.dy --punto inferior del fondo

	if ax1 <= bx1 then  --pared
		pelota.dir_x = -pelota.dir_x
	end
	if ax2 >= bx2 then
		pelota.dir_x = -pelota.dir_x
	end
	if ay1 <= by1 then
		pelota.dir_y = -pelota.dir_y
	end
	if ay2 >= by2 then
		pelota.dir_y = -pelota.dir_y
	end
	pelota.y = pelota.y + pelota.dir_y
	pelota.x = pelota.x + pelota.dir_x
end

function mover_pong_cpu()
	-- body
	--pong_cpu = { x=fx-30, y=10, dx=20, dy=50 }
	if (pelota.y <=  fy - pong_cpu.dy) and  ( pelota.y >= fy - fondo.dy )then
	pong_cpu.y = pelota.y
	end
end

function rebote_paleta()


	if (pong_user.x + pong_user .dx) == pelota.x then  --pared
		if (pong_user.y <= pelota.y) and ((pong_user.y + pong_user .dy) >= pelota.y) then 
		pelota.dir_x = -pelota.dir_x
		end
	end
	if (pong_cpu.x ) == (pelota.x + pelota.dx) then  --pared
		if (pong_cpu.y <= pelota.y) and ((pong_cpu.y + pong_cpu .dy) >= pelota.y) then 
		pelota.dir_x = -pelota.dir_x
		end
	end
	
end




function puntaje()
	local dir_x = 20
	local dir_y = 20 
	local ax1, ay1 = pelota.x , pelota.y   --puntos superiores del objeto
	local ax2, ay2 = ax1+ pelota.dx , ay1 + pelota.dy --puntos inferiores del objeto
	local bx1, by1 = fondo.x, fondo.y    --punto superio del fondo
	local bx2, by2 = bx1 + fondo.dx, by1 + fondo.dy --punto inferior del fondo

	if ax1 <= bx1 then  --pared de la derecha
		--puntaje para el cpu
		puntos.CPU = puntos.CPU + 1 
		pelota.x = fx/2
		pelota.y = fy/2
	end
	if ax2 >= bx2 then --pared de la izquierda
		--puntaje para el usuario
		puntos.usuario = puntos.usuario  + 1 
		pelota.x = fx/2
		pelota.y = fy/2
	end
	
end

local x = 100
-- Timer  de X segundo 

local TIMER = nil
local function temporizador ()
	if IGNORE then
		return 
	else
		return event.timer(x,
			function()
				mover_objeto( )
				mover_pong_cpu()
				rebote_paleta()
				puntaje()
				redraw()
				temporizador( )
			end)
	end
end




temporizador( )


-- Funcion de tratamiento de eventos:
function handler (evt)
	if IGNORE then
		return
	end
	
	-- Sólo eventos de tecla son de interes
	if evt.class == 'key' and evt.type == 'press'
	then
		-- Solo las flechas que mueven al mono
		if evt.key == 'CURSOR_UP' then
			pong_user.y = pong_user.y - 10
		elseif evt.key == 'CURSOR_DOWN' then
			pong_user.y = pong_user.y + 10
		end

        -- evaluar si el mono está sobre la banana
		--choque()
	end

    -- redesenha a tela toda
    --redraw()
end

event.register(handler)
