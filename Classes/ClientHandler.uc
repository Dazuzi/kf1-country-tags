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
	local array<string> Octets;
	local string IP;
	local int Decimal;
	if (NetConnection(Client.Player) == none) {
		Destroy();
		return false;
	}
	IP = Client.GetPlayerNetworkAddress();
	IP = Left(IP,InStr(IP,":"));
	if (IP == MasterHandler.HostLanIpAddr)
		IP = MasterHandler.HostWanIpAddr;
	Split(IP, ".", Octets);
	Decimal = int(Octets[0]) * 256 ** 2 + int(Octets[1]) * 256 + int(Octets[2]);
	MyCountry = Class'CountryTagsDatabase'.Static.GetCountryTag(Decimal, MasterHandler.bShortTags);
	return true;
}
