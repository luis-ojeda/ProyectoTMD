local str = [[<div class="al adr"><span class=adr id=sxaddr dir=ltr><span class=street-address>Av Afrânio Melo Franco</span>, <span class=street-address>209</span> - <span class=locality>Rio de Janeiro</span> - <span class=region>RJ</span>, <span class=postal-code>22430-060</span>, <span class=country-name>Brazil</span></span>&#8206; - <span dir=ltr class=nw><span class=tel id=sxphone>(0xx)21 3183-8215</span></span>&#8206;</div><div class=sa></div><span style=color:#77c><a class=a href=/maps?li=d&amp;hl=en&amp;f=d&amp;iwst]]

local street, city, state, cep, country, fone  =
      str:match ('<div class="al adr">.-'
                  .. '<span class=street%-address>(.-)</span>.-'
                  .. '<span class=locality>(.-)</span>.-'
                  .. '<span class=region>(.-)</span>.-'
                  .. '<span class=postal%-code>(.-)</span>.-'
                  .. '<span class=country%-name>(.-)</span>.-'
                  .. '<span class=tel id=sxphone>(.-)</span>')
print(street, city, state, cep, country, fone)
