
local img = canvas:new('monkey.png')
local dx, dy = img:attrSize()
--local info = { img=img, x=fx -50, y=fy -50, dx=dx, dy=dy }
local width, height = canvas:attrSize()   -- pega as dimensões da região
local Bx, By = width, height 
local IGNORE = false 

local easter_egg_activate = 0
--variable para mantener el tiempo de reproduccion del archivo y poder manejar las propagandas
local tiempo = {horas= 0, minutos= 0, segundos= 0, milisegundos= 0}

-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--
--																					fUNCIONES GLOBALES
--
--
-----------------------------------------------------------------------------------------------------------------------------------------------------------------




--variable encargada de definir el tiempo en que se pasa  a modo reclame
local tiempo_reclame={
						horas_inicio= 0+0, 
						horas_fin= 0+0, 
						minutos_inicio= 0+0, 
						minutos_fin= 0+0, 
						segundos_inicio= 30+0, 
						segundos_fin= 31+0,
						milisegundos_inicio= 0+0,
						milisegundos_fin= 0+0
					}

--funcion destinada a saber si se esta en periodo de reclame sie esta en reclame es verdadero sino es falso
function compara_tiempo_reclame( )
	if 	(tiempo_reclame.horas_inicio <= tiempo.horas)  and (tiempo.horas <=tiempo_reclame.horas_fin) then
		if 	(tiempo_reclame.minutos_inicio <= tiempo.minutos)  and (tiempo.minutos <=tiempo_reclame.minutos_fin) then
			if 	(tiempo_reclame.segundos_inicio <= tiempo.segundos)  and (tiempo.segundos <=tiempo_reclame.segundos_fin) then
				return true
			end
		end
	end
	return false
end




function redraw ()
	if easter_egg_activate == 0 then
		if compara_tiempo_reclame()  then
			redraw_pong()
		else
			redraw_detective()
		end
	else
			redraw_easter_egg()
	end
end


-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--
--																				EASTER EGG
--
--
-----------------------------------------------------------------------------------------------------------------------------------------------------------------



-- MONKEY: guarda la imagen, posicion inicial y dimensiones
local img = canvas:new('monkey.png')
local dx, dy = img:attrSize()
local monkey = { img=img, x=10, y=10, dx=dx, dy=dy }

-- BANANA: guarda la imagen, posicion inicial y dimensiones
local img = canvas:new('banana.png')
local dx, dy = img:attrSize()
local banana = { img=img, x=150, y=150, dx=dx, dy=dy,dir_x = 5 ,dir_y= 10 } --x,y = posicion y dir_x,dir_y = direccion de movimiento


--canvas:drawRect (mode, x, y, w, h)
--crea la pocicion inicial del las paletas del pong
local x = 200 --posicion inicial del cuadro de juego
local y = 100 --posicion inicial del cuadro de juego
local width =400  	--ancho  del cuadro de juego
local height = 400  --alto  del cuadro de juego
local fx, fy = width, height 
local fondo = { x=0, y=0, dx=fx, dy=fy } -- genera una area en la cual este contenido todo 

-- Función de redibujado:
-- Llamada por cada tecla presionada
-- primero el fondo, luego la banana y al final el mono
function redraw_easter_egg ()
	canvas:clear()
	canvas:attrColor('white',x,y,fx,fy)
	canvas:drawRect('fill', x,y, fx,fy)
	canvas:compose(x + banana.x, y + banana.y, banana.img)
	canvas:compose(x + monkey.x, y + monkey.y, monkey.img)
	canvas:attrColor(0xBF,0xBF,0xBF,0x00)
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

function timer_easter_egg( )
	-- body
	mover_objeto( )
	choque()
end





-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--
--																					PONG
--
--
-----------------------------------------------------------------------------------------------------------------------------------------------------------------

--canvas:drawRect (mode, x, y, w, h)
--crea la pocicion inicial del las paletas del pong
local x = 500 --posicion inicial del cuadro de juego
local y = 300 --posicion inicial del cuadro de juego
local width =200  	--ancho  del cuadro de juego
local height = 200  --alto  del cuadro de juego
local fx, fy = width, height 
local pong_user = { x= 10, y=10, dx=20, dy=50 }
local pong_cpu = { x=fx-30, y=10, dx=20, dy=50 }

local puntos= {usuario = 0, CPU = 0}


--obtiene valores de la region
--local width, height = canvas:attrSize()   -- pega as dimensões da região
--local fx, fy = width, height 
local fondo = { x=0, y=0, dx=fx-10, dy=fy -10} -- genera una area en la cual este contenido todo 

local pelota = { x=fx/2, y=fy/2, dx=20, dy=20 , dir_x = -10 ,dir_y= 10 }



function timer_pong( ... )
	-- body
	mover_pelota( )
	mover_pong_cpu()
	rebote_paleta()
	puntaje()
end



function redraw_pong()
	canvas:clear()

	canvas:attrColor('white')
	canvas:drawRect('fill', x,y,fx,fy)
	canvas:attrColor('black')
	canvas:drawRect ('fill', x + pelota.x, y + pelota.y, pelota.dx,pelota.dy)
	canvas:drawRect ('fill', x + pong_user.x, y + pong_user.y, pong_user.dx,pong_user.dy)
	canvas:drawRect ('fill', x + pong_cpu.x, y + pong_cpu.y, pong_cpu.dx,pong_cpu.dy)
	canvas:attrFont("vera", 24)
	canvas:drawText(x + 40, y + 10, tostring (puntos.usuario) )
	canvas:drawText(x + fx-40, y + 10, tostring (puntos.CPU) )
	canvas:attrColor(0xBF,0xBF,0xBF,0x00)
	--canvas:drawText(fx/2,fy/2-30, tostring (tiempo.segundos))   ---para realizar pruebas
	--canvas:drawText(fx/2,fy/2, compara_tiempo_reclame())			-- para realizar pruebas
	canvas:flush()
end





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
function mover_pelota( )
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

-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--
--																					Detective
--
-----------------------------------------------------------------------------------------------------------------------------------------------------------------

local mostrar_info = -1

local parametros_cuadro_texto={x = 40, y=40, w=100, h=200}

--imagen del boton de info
local img = canvas:new('./imagenes/boton_info.gif')
local dx, dy = img:attrSize()
local info_boton = { img=img, x= 50, y=By -50 }


function redraw_detective()
	
	canvas:clear()
	canvas:compose(info_boton.x, info_boton.y, info_boton.img)
	canvas:attrColor(0xBF,0xBF,0xBF,0x00)
	if mostrar_info == 1 then

		canvas:attrColor(0xBF,0xBF,0xBF,0xF0)
		canvas:drawRect('fill', parametros_cuadro_texto.x , parametros_cuadro_texto.y , parametros_cuadro_texto.w , parametros_cuadro_texto.h )
		canvas:attrColor('black')
		canvas:attrFont("vera", 12)
		--insertarla informacion que se desea mostrar puede tener el texto un largo maximo de 12 caracteres
		canvas:drawText(parametros_cuadro_texto.x + 5 , parametros_cuadro_texto.y + 5, "a12345678901\n23456")   ---para realizar pruebas
		canvas:attrColor(0xBF,0xBF,0xBF,0x00)
		--canvas:drawText(fx/2,fy/2, compara_tiempo_reclame())			-- para realizar pruebas
		
	else
		--canvas:attrColor(0,0,0,0)
		--canvas:attrColor("red",0x00)
		--canvas:drawRect('fill', 10 , 10,20,30)
		
	end
	canvas:flush()
end


redraw_detective()



-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--
--																					Funciones de tiempo
--
--
-----------------------------------------------------------------------------------------------------------------------------------------------------------------

--funcion encargada de generar un timer cada X milisegundos

local frecuencia_reloj  = 100
-- Timer  de X milisegundo 

local TIMER = nil
function temporizador ()
	if IGNORE then
		return 
	else
		return event.timer(frecuencia_reloj,
			function()
				if easter_egg_activate == 0 then
					timer_pong()
				else
					timer_easter_egg()
				end
				redraw()
				reloj()
				temporizador( )

			end)
	end
end

--funcion encargada de llevar un reloj de la aplicacion

function reloj(  )
	-- body
	tiempo.milisegundos = tiempo.milisegundos + frecuencia_reloj 
	if tiempo.milisegundos >= 1000 then
		tiempo.milisegundos = 0

		tiempo.segundos = tiempo.segundos +1
		if tiempo.segundos >= 60 then
			tiempo.segundos = 0

			tiempo.minutos = tiempo.segundos +1
			if tiempo.minutos >=60 then 
				tiempo.minutos =0 

				tiempo.horas = tiempo.horas + 1
				if tiempo.horas >=24 then 
					tiempo.horas = 0
				end
			end
		end
	end

end

temporizador( )

-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--
--																					Manejo de eventos de tecla
--
--
-----------------------------------------------------------------------------------------------------------------------------------------------------------------

function teclas_pong( evt)
	-- body
	-- Sólo eventos de tecla son de interes
	if evt.class == 'key' and evt.type == 'press'
	then
		-- Solo las flechas que mueven la paleta
		
		if evt.key == 'CURSOR_UP' then
			if ( (pong_user.y - 10 ) >= 0 )then
				pong_user.y = pong_user.y - 10
			end
		elseif evt.key == 'CURSOR_DOWN' then
			if ( (pong_user.y +10 ) <= ( fy - pong_user.dy ) )then
				pong_user.y = pong_user.y + 10
			end
		end

        -- evaluar si el mono está sobre la banana
		--choque()
	end
end

function teclas_info( evt)
	 --Sólo eventos de tecla son de interes
	if evt.class == 'key' and evt.type == 'press'
	then
		-- Solo las flechas que muestra la info
		if evt.key == 'CURSOR_UP' then
			
			mostrar_info= -mostrar_info
		end
		if evt.key == 'CURSOR_DOWN' then
			
			easter_egg_activate = 1
		end
	end
end

function teclas_easter_egg( evt)
	-- Sólo eventos de tecla son de interes
	if evt.class == 'key' and evt.type == 'press'
	then
		-- Solo las flechas que mueven al mono
		if evt.key == 'CURSOR_UP' then
			if ( (monkey.y - 10 ) >= 0 )then
				monkey.y = monkey.y - 10
			end
		elseif evt.key == 'CURSOR_DOWN' then
			if ( (monkey.y +10 ) <= ( fy - monkey.dy ) )then
				monkey.y = monkey.y + 10
			end
		elseif evt.key == 'CURSOR_LEFT' then
			if ( (monkey.x - 10 ) >=  0 )then
				monkey.x = monkey.x - 10
			end
		elseif evt.key == 'CURSOR_RIGHT' then
			if ( (monkey.x +10 ) <= ( fx - monkey.dx ) )then
				monkey.x = monkey.x + 10
			end
		end

        -- evaluar si el mono está sobre la banana
		--choque()
	end

end

-- Funcion de tratamiento de eventos:
function handler (evt)
	if IGNORE then
		return
	end
	if easter_egg_activate == 0 then
		if compara_tiempo_reclame() then
			teclas_pong(evt)
		else
			teclas_info(evt)
		end
	else 
		teclas_easter_egg(evt)
	end

    -- redesenha a tela toda
    --redraw()
end

event.register(handler)
