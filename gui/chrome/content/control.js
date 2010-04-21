// window.openDialog('chrome://global/content/config.xul');
// window.openDialog('chrome://mozapps/content/extensions/extensions.xul?type=extensions');
jslib.init(this);
JS_LIB_DEBUG = true;
jslibTurnDumpOn();

try {
	// enablePrivilege is required if not running chrome'd
	// (other tweaks might apply, check out public.mozdev.jslib)
	netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
	include(jslib_socket);
}
catch( e ) { alert( e ); }

var gSocket = new Socket;
var hostElement;
var portElement;
var sendMsg;
var socketResults;
var statusMsg;

function initialize() {
  hostElement = document.getElementById( "host" );
  portElement = document.getElementById( "port" );
  sendMsg = document.getElementById( "sendMsg" );
  socketResults = document.getElementById( "socketResults" );
  statusMsg = document.getElementById("log");
}

function LOG(msg) {
	var d = new Date();

	var year = d.getFullYear();

	var month = d.getMonth()+1;
	if (month < 10) month = "0" + month;
	var day = d.getDate();
	if (day < 10) day = "0" + day;

	var hour = d.getHours();
	if (hour < 10) hour = "0" + hour;
	var min = d.getMinutes();
	if (min < 10) min = "0" + min;

	var s = "["+day+"/"+month+"/"+year+" "+hour+":"+min+"] "+msg+'\n'
	statusMsg.value = s + statusMsg.value;
}

function closeSocket( theSocket ) {
  theSocket.close();
  LOG("socket was closed");
}

function openSocket( theSocket ) {
  if( theSocket.isConnected ) return;
  var host = hostElement.value;
  var port = portElement.value;
  theSocket.open( host, port, true );
  LOG("an attempt was made to open the socket");
}

function receiveSocket( theSocket )	{
	bytesAvailable = theSocket.available();
	if( theSocket.isConnected ) {
    socketData = theSocket.read( bytesAvailable );
    LOG("[Res] "+socketData);
	} else {
		LOG("the socket is closed");
	}
}

function sendSocket( theSocket ) {
  theMsg = sendMsg.value;
  var r = theSocket.write( theMsg+"\n" );
  LOG("[Req] " + theMsg);
}

function testSocket( theSocket ) {
	LOG(theSocket.isAlive()
	? "socket is connected"
	: "socket is not connected" );
}

function availableSocket( theSocket ) {
	LOG( theSocket.isAlive()
	? "socket has " + theSocket.available() + " bytes pending"
	: "socket is not connected" );
}
