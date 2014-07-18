
-- MONKEY: guarda la imagen, posicion inicial y dimensiones
local img = canvas:new('monkey.png')
local dx, dy = img:attrSize()
local monkey = { img=img, x=10, y=10, dx=dx, dy=dy }

-- BANANA: guarda la imagen, posicion inicial y dimensiones
local img = canvas:new('banana.png')
local dx, dy = img:attrSize()
local banana = { img=img, x=150, y=150, dx=dx, dy=dy,dir_x = 5 ,dir_y= 10 } --x,y = posicion y dir_x,dir_y = direccion de movimiento


--obtiene valores de la region
local width, height = canvas:attrSize()   -- pega as dimensões da região
local fx, fy = width, height 
local fondo = { x=0, y=0, dx=fx, dy=fy } -- genera una area en la cual este contenido todo 

-- Función de redibujado:
-- Llamada por cada tecla presionada
-- primero el fondo, luego la banana y al final el mono
function redraw ()
	canvas:attrColor('white')
	canvas:drawRect('fill', 0,0, canvas:attrSize())
	canvas:compose(banana.x, banana.y, banana.img)
	canvas:compose(monkey.x, monkey.y, monkey.img)
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

	local dir_x = 10
	local dir_y = 10


	local ax1, ay1 = banana.x , banana.y   --puntos superiores del objeto
	local ax2, ay2 = ax1+ banana.dx , ay1 + banana.dy --puntos inferiores del objeto
	local bx1, by1 = fondo.x, fondo.y    --punto superio del fondo
	local bx2, by2 = bx1 + fondo.dx, by1 + fondo.dy --punto inferior del fondo

	if ax1 <= bx1 then  --pared
		banana.dir_x = -banana.dir_x
	end
	if ax2 >= bx2 then
		banana.dir_x = -banana.dir_x
	end
	if ay1 <= by1 then
		banana.dir_y = -banana.dir_y
	end
	if ay2 >= by2 then
		banana.dir_y = -banana.dir_y
	end


	banana.y = banana.y + banana.dir_y
	banana.x = banana.x + banana.dir_x
	

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
				choque()
				 redraw()
				 temporizador( )
			end)
	end
end




-- evaluar si el mono está sobre la banana

function choque(  )
	-- body
	if collide(monkey, banana) then
			-- si lo está, señal de finalizacion
			event.post {
                class  = 'ncl',
                type   = 'presentation',
                label  = 'fin',
                action = 'start',
            }
			-- e ignora os eventos posteriores
			IGNORE = true
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
			monkey.y = monkey.y - 10
		elseif evt.key == 'CURSOR_DOWN' then
			monkey.y = monkey.y + 10
		elseif evt.key == 'CURSOR_LEFT' then
			monkey.x = monkey.x - 10
		elseif evt.key == 'CURSOR_RIGHT' then
			monkey.x = monkey.x + 10
		end

        -- evaluar si el mono está sobre la banana
		--choque()
	end

    -- redesenha a tela toda
    --redraw()
end

event.register(handler)
