Class CountryTagsDatabase extends Object
	Config(CountryTagsDB)
	Abstract;

struct FCountryTagEntry {
	var const int S, E;
	var const string C, L;
};

var config array<FCountryTagEntry> C;

static final function string GetCountryTag(string IP, string HostWanIpAddr, bool bShortTags) {
	local array<string> Octets;
	local int A, B, Decimal, Current, Last, Low, High;
	Split(IP, ".", Octets);
	A = int(Octets[0]);
	B = int(Octets[1]);
	if (HostWanIpAddr != "" && (A == 10 || A == 127 || (A == 172 && B >= 16 && B < 32) || (A == 192 && B == 168) || (A == 169 && B == 254)))
		return GetCountryTag(HostWanIpAddr, "", bShortTags);
	Decimal = A << 16 | B << 8 | int(Octets[2]);
	High = default.C.Length;
 	for (Current = High / 2; Current != Last; Current = (High + Low) / 2) {
		if (Decimal >= default.C[Current].S && Decimal <= default.C[Current].E) {
			if (bShortTags)
				return default.C[Current].C;
			return default.C[Current].L;
		}
		else if (Decimal < default.C[Current].S)
			High = Current;
		else
			Low = Current;
		Last = Current;
	}
	if (bShortTags)
		return "??";
	return "???";
}