using aroop;
using shotodol;

internal class RulesCommand : Command {
	public override int act_on(ArrayList<txt> tokens, StandardIO io) {
		io.say_static("We are working ..");
		return 0;
	}
}
