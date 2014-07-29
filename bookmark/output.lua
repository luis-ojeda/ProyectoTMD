local TEXT = ''

local dx, dy = canvas:attrSize()
canvas:attrFont('vera', 3*dy/4)
function redraw ()
	canvas:attrColor('black')
	canvas:drawRect('fill', 0,0, dx,dy)

	canvas:attrColor('white')
	canvas:drawText(0,0, TEXT)

	canvas:flush()
end

function dump (evt)
    print("Event in output.lua started:");
    if evt.class ~= nil then print("class:"..evt.class); else print("nil class"); end
    if evt.type ~= nil then print("type:"..evt.type); else print("nil type"); end
    if evt.value ~= nil then print("value:"..evt.value); else print("nil value"); end
    if evt.action ~= nil then print("action:"..evt.action); else print("nil action"); end
    if evt.name ~= nil then print("name:"..evt.name); else print("nil name"); end
    if evt.key ~= nil then print("key:"..evt.key); else print("nil key"); end
    if evt.label ~= nil then print("label:"..evt.label); else print("nil label"); end
end


local function handler (evt)
	dump(evt)
	if evt.class ~= 'ncl' then return end

	if evt.type == 'attribution' then
		if evt.name == 'text' then
			if evt.action == 'start' then
				TEXT = evt.value
				print('TEXT: '..TEXT)

				redraw()

				-- event.post {
	   --              class = 'ncl',
	   --              type  = 'attribution',
	   --              name  = 'text',
	   --              value = TEXT,
	   --              action = 'stop',
	   --          }
			end
		end
	end
	
end

event.register(handler)
