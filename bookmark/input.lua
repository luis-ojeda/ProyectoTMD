text = nil
local TEXT = ''
local CHAR = ''

local KEY, IDX = nil, -1
local MAP = {
	  ['1'] = { '1', '.', ',' }
	, ['2'] = { 'a', 'b', 'c', '2' }
	, ['3'] = { 'd', 'e', 'f', '3' }
	, ['4'] = { 'g', 'h', 'i', '4' }
	, ['5'] = { 'j', 'k', 'l', '5' }
	, ['6'] = { 'm', 'n', 'o', '6' }
	, ['7'] = { 'p', 'q', 'r', 's', '7' }
	, ['8'] = { 't', 'u', 'v', '8' }
	, ['9'] = { 'w', 'x', 'y', 'z', '9' }
	, ['0'] = { '0' }
}

local UPPER = false
local case = function (c)
	return (UPPER and string.upper(c)) or c
end

local dx, dy = canvas:attrSize()
canvas:attrFont('vera', 3*dy/4)
function redraw ()
	canvas:attrColor('black')
	canvas:drawRect('fill', 0,0, dx,dy)

	canvas:attrColor('white')
	canvas:drawText(0,0, TEXT..case(CHAR)..'|')

	canvas:flush()
end

local evt = {
    class = 'ncl',
    type  = 'attribution',
    name  = 'text',
}

local function setText (new, outside)
	TEXT = new or TEXT..case(CHAR)
	text = TEXT
	CHAR, UPPER = '', false
	KEY, IDX = nil, -1

	-- notifica o documento NCL
	if not outside then
		evt.value = TEXT
	    print("Here!"..evt.value);
	    event.post {
    		class = 'ncl',
    		type  = 'attribution',
    		name  = 'text',
    		action = 'start',
    		value = TEXT,
		}

	    event.post {
    		class = 'ncl',
    		type  = 'attribution',
    		name  = 'text',
    		action = 'stop',
    		value = TEXT,
		}

		--evt.action = 'start'; event.post(evt)
		--evt.action = 'stop';  event.post(evt)
	end
end

local TIMER = nil
local function timeout ()
	return event.timer(1000,
		function()
			if KEY then
				setText()
			end
		end)
end


function dump (evt)
    print("Event in input.lua started:");
    if evt.class ~= nil then print("class:"..evt.class); else print("nil class"); end
    if evt.type ~= nil then print("type:"..evt.type); else print("nil type"); end
    if evt.value ~= nil then print("value:"..evt.value); else print("nil value"); end
    if evt.action ~= nil then print("action:"..evt.action); else print("nil action"); end
    if evt.name ~= nil then print("name:"..evt.name); else print("nil name"); end
    if evt.key ~= nil then print("key:"..evt.key); else print("nil key"); end
    if evt.label ~= nil then print("label:"..evt.label); else print("nil label"); end
end


local function nclHandler (evt)
	dump(evt)
	if evt.class ~= 'ncl' then return end

	if evt.type == 'attribution' then
		if evt.name == 'text' then
			setText(evt.value, true)
		end
	end

	redraw()
	return true
end
event.register(nclHandler)

local sel = {
    class = 'ncl',
    type  = 'presentation',
    label = 'select',
}

local function keyHandler (evt)
	dump(evt)
	if evt.class ~= 'key' then return end
	if evt.type ~= 'press' then return true end
	local key = evt.key

	-- SELECT
	if (key == 'ENTER') then
		setText()
		sel.action = 'start'; event.post(sel)
		sel.action = 'stop';  event.post(sel)

	-- BACKSPACE
	elseif (key == 'CURSOR_LEFT') then
		setText( (KEY and TEXT) or string.sub(TEXT, 1, -2) )

	-- UPPER
	elseif (key == 'CURSOR_UP') then
		UPPER = not UPPER

	-- SPACE
	elseif (key == 'CURSOR_RIGHT') then
		setText( (not KEY) and (TEXT..' ') )

	-- NUMBER
	elseif _G.tonumber(key) then
		if KEY and (KEY ~= key) then
			setText()
		end
		IDX = (IDX + 1) % #MAP[key]
		CHAR = MAP[key][IDX+1]
		KEY = key
	end

	if TIMER then TIMER() end
	TIMER = timeout()
	redraw()
	return true
end
event.register(keyHandler)
