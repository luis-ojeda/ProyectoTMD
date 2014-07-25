<?xml version="1.0" encoding="ISO-8859-1"?>
<ncl id="nclClicks" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">

<head>

<regionBase>
	<region left="0%" right="0%" top="0%" bottom="0%" id="videoreg" zindex="1"/>
	    <region width="20%"  height="20%"  left="10%"  top="40%" id="rgWin" zindex="3"/>
	    <region left="0%" right="0%" top="0%" bottom="0%" id="rgLua" zindex="2"/>
</regionBase>

<descriptorBase>
    <descriptor id="dsLua" region="rgLua" focusIndex="luaIdx"/>
    <descriptor id="dsWin" region="rgWin"/>
    <descriptor id="videodesc" region="videoreg"/>
</descriptorBase>

<connectorBase>
	<causalConnector id="onBeginStart">
		<simpleCondition role="onBegin"/>
		<simpleAction role="start"/>
	</causalConnector>
</connectorBase>

</head>

<body>
    <port id="entryPoint" component="video"/>

    <media id="video" src="./resources/DC001.mp4" descriptor="videodesc"/>
	<media type="application/x-ginga-settings" id="programSettings">
        <property name="service.currentKeyMaster" value="luaIdx"/>
	</media>

    <media id="lua" src="monkey.lua" descriptor="dsLua">
        <area id="fin"/>
    </media>

    <media id="win" src="win.jpg" descriptor="dsWin"/>

   

 	<link xconnector="onBeginStart">
        <bind role="onBegin" component="video"/>
		<bind role="start" component="lua"/>
	</link>



    <link xconnector="onBeginStart">
        <bind role="onBegin" component="lua" interface="fin"/>
		<bind role="start" component="win"/>
	</link>
</body>

</ncl>
