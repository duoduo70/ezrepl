module ezrepl;

public mixin template DefCommand(
    int args_num_min, int args_num_max, string func_name, string delegate(string[]) func,
    string usage_describe,
    string describe)
{
    mixin("immutable doc_command_" ~ func_name ~ "=" ~ "\"" ~ func_name ~ 
    ":\\n    Usage:\\n        " ~ usage_describe ~ 
    "\\n    Describe:\\n        " ~ describe ~ "\";"
    );
    mixin("
        public string command_" ~ func_name ~ "(string[] args) {
            if (args.length < args_num_min || args.length > args_num_max)
                return \"Wrong number of parameters.\\nUsage:\\n    " ~ 
                    usage_describe ~ "\\nDescribe:\\n    " ~ describe ~ "\"; 
            return " ~ func.stringof ~ "(args);
        }
    ");
}

public string parseCommand(string[] args) {
    if (args.length == 1) return parseAtom(args[0]);
    else return parseNormalCommand(args, args.length);
}

string commandUndefined() {
    return "Undefined Command";
}

string commandReserved() {
    return "Reserved Command";
}

string parseAtom(string command) {
    switch ( command )
    {
    case "help":
        return showDoc();
    case "copyright":
        return commandReserved();
    case "credits":
        return commandReserved();
    case "license":
        return commandReserved();
    default:
        return commandUndefined();
    }
}
