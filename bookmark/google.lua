require 'tcp'

function dump (evt)
    print("Event in google.lua started:");
    if evt.class ~= nil then print("class:"..evt.class); else print("nil class"); end
    if evt.type ~= nil then print("type:"..evt.type); else print("nil type"); end
    if evt.value ~= nil then print("value:"..evt.value); else print("nil value"); end
    if evt.action ~= nil then print("action:"..evt.action); else print("nil action"); end
    if evt.name ~= nil then print("name:"..evt.name); else print("nil name"); end
    if evt.key ~= nil then print("key:"..evt.key); else print("nil key"); end
    if evt.label ~= nil then print("label:"..evt.label); else print("nil label"); end
    if evt.error ~= nil then print("error:"..evt.error); else print("nil error"); end
    if evt.connection ~= nil then print("connection:"..evt.connection); else print("nil connection"); end
end

local current_word = ''

function tcp_handler(evt)

    if evt.class == 'tcp' then
        dump(evt)
        -- In case of successful connection
        if evt.type == 'connect' and evt.connection ~= nil then
            -- Then, send request
            event.post {
                class = 'tcp',
                type = 'data',
                connection = evt.connection, 
                value = 'GET /search?ie=UTF-8&sourceid=navclient&gfns=1&q='..current_word..'\n',
                timeout = '10000', 
            }
            return
        -- Data received:
        elseif evt.type == 'data' and evt.connection ~= nil then
            result = evt.value
            --result = string.match(result, 'Location: http://(.-)\r?\n') or 'No encontrado.'
            result = string.match(result, 'Location: (.-)\r?\n') or 'No encontrado.'
            print('Entra; result ='..result)

            event.post {
                class = 'ncl',
                type  = 'attribution',
                name  = 'result',
                value = result,
                action = 'start',
            }

            event.post {
                class = 'ncl',
                type  = 'attribution',
                name  = 'result',
                value = result,
                action = 'stop',
            }

            event.post {
               class = 'tcp',
                type = 'disconnect',
                connection = evt.connection, 
            }
            return

        elseif evt.error ~= nil then
            print('Error: '..evt.error);
        end
    end
end

event.register(tcp_handler)


function handler(evt)
    dump(evt)
    
	if evt.class  ~= 'ncl'         then return end
    if evt.type   ~= 'attribution' then return end
    if evt.action ~= 'start'       then return end
    if evt.name   ~= 'search'      then return end


    evt.action = 'stop'; 
    current_word = evt.value

    print("Here!"..evt.value);

    event.post {
        class = 'tcp',
        type = 'connect',
        host = 'www.google.com', 
        port = 80,
    }

end

event.register(handler)
