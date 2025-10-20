Class CountryTagsDatabase extends Object
	Config(CountryTagsDB)
	Abstract;

struct FCountryTagEntry {
	var const int S, E;
	var const string C, L;
};

var config array<FCountryTagEntry> C;

static final function string GetCountryTag(int Decimal, bool bShortTags) {
	local int Current, Last, Low, High;
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