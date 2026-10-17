class ClientHandler extends Info;

var PlayerController Client;
var CountryTags MasterHandler;
var bool bHasInitialized;
var string MyCountry, OldClientName;

function PostBeginPlay() {
	SetTimer(0.1, false);
}

function Timer() {
	if (Client == none) {
		Destroy();
		return;
	}
	if (!bHasInitialized) {
		if (!GetClientCountry())
			return;
		bHasInitialized = true;
		SetTimer(2 + FRand(), true);
	}
	if (Client.PlayerReplicationInfo != none && Client.PlayerReplicationInfo.PlayerName != OldClientName) {
		OldClientName = MasterHandler.ParseCountryTag(Client.PlayerReplicationInfo.PlayerName, MyCountry);
		Client.PlayerReplicationInfo.PlayerName = OldClientName;
		Client.PlayerReplicationInfo.NetUpdateTime = Level.TimeSeconds - 1;
	}
}

final function bool GetClientCountry() {
	local string IP;
	if (NetConnection(Client.Player) == none) {
		Destroy();
		return false;
	}
	IP = Client.GetPlayerNetworkAddress();
	MyCountry = Class'CountryTagsDatabase'.Static.GetCountryTag(Left(IP, InStr(IP, ":")), MasterHandler.HostWanIpAddr, MasterHandler.bShortTags);
	return true;
}
