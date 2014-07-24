
-- MONKEY: guarda la imagen, posicion inicial y dimensiones
local img = canvas:new('./imagenes/monkey.png')
local dx, dy = img:attrSize()
local monkey = { img=img, x=10, y=10, dx=dx, dy=dy }

-- BANANA: guarda la imagen, posicion inicial y dimensiones
local img = canvas:new('./imagenes/zombie1.png')
local dx, dy = img:attrSize()
local zombie = { img=img, x=150, y=150, dx=dx, dy=dy }


--local t1 = timer.new( 100, mueve_zombie() ) 
            



-- Función de redibujado:
-- Llamada por cada tecla presionada
-- primero el fondo, luego el zombie  y al final el mono
function redraw ()
	canvas:attrColor('black')
	canvas:drawRect('fill', 0,0, canvas:attrSize())
	canvas:compose(zombie.x, zombie.y, zombie.img)
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



function temporizador( )
	-- body
	contador = Timer.new() -- Define un contador.
	while true do
	contador:start() -- Lo pone en marcha.
	repeat
	screen:clear( Color.new(0, 0, 0) )
	tiempoActual = contador:time() -- Lectura.
	screen:print( 0, 0, tiempoActual, Color.new(255,255,255) )
	screen.waitVblankStart()
	screen.flip()

	until tiempoActual > 10000
	contador:stop() -- Lo para.
	contador:reset(0) -- Lo pone a 0.
	screen.waitVblankStart(10)

	end

end




-- Funcion de tratamiento de eventos:
function handler (evt)
	if IGNORE then
		return
	end
--Se crea un timer para mover el zombie





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

    -- redesenha a tela toda
    redraw()
end








event.register(handler)
