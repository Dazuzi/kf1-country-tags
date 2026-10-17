//============================================================
// Country Tags
// Coded by Marco (2012). Fixed by CFH (2018). Improved by Dazuz (2019-2026).
//============================================================
class CountryTags extends Mutator
	Config(CountryTags);

var() config string CountryTagParsing, HostWanIpAddr;
var() config bool bShortTags;

static function FillPlayInfo(PlayInfo PlayInfo) {
	Super.FillPlayInfo(PlayInfo);
	PlayInfo.AddSetting("Country Tags", "bShortTags",		"Short country tags",	0, 1,	"Check");
	PlayInfo.AddSetting("Country Tags", "CountryTagParsing",	"Name format",		0, 2,	"Text",		"64");
	PlayInfo.AddSetting("Country Tags", "HostWanIpAddr",		"Host's WAN IP",	0, 3,	"Text",		"15");
}

static event string GetDescriptionText(string Property) {
	switch (Property) {
		case "CountryTagParsing":
			return "Naming format. %tag gets replaced with the player's country code and %name with player's name.";
		case "HostWanIpAddr":
			return "Public IP address of the server's network. Players connecting from a LAN or loopback address get its country. Leave empty to disable.";
		case "bShortTags":
			return "When enabled, two letter country tags will be used, instead of three.";
		default:
			return Super.GetDescriptionText(Property);
	}
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant) {
	if (Other.IsA('PlayerController'))
		AddHandler(PlayerController(Other));
	return true;
}

final function AddHandler(PlayerController PC) {
	local ClientHandler C;
	C = Spawn(class'ClientHandler');
	C.Client = PC;
	C.MasterHandler = self;
}

final function string ParseCountryTag(string PlayerName, string CountryTag) {
	return Repl(Repl(CountryTagParsing, "%name", PlayerName), "%tag", CountryTag);
}

defaultproperties {
	CountryTagParsing="[%tag] %name"
	HostWanIpAddr=""
	bShortTags=False
	GroupName="KF-CountryTags"
	FriendlyName="Country Tags"
	Description="Adds country tags to players' names."
}
