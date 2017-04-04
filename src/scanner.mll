(* Ocamllex scanner for MicroC *)

{ open Parser }


let escape = '\\' ['\\' ''' '"' 'n' 'r' 't']
let ascii = ([' '-'!' '#'-'[' ']'-'~'])
let string_t = '"' ( (ascii | escape)*) '"'


rule token = parse
  [' ' '\t' '\r' '\n']  { token lexbuf } (* Whitespace *)
| "/*"                  { comment lexbuf }           (* Comments *)
| '('                   { LPAREN }
| ')'                   { RPAREN }
| '{'                   { LBRACE }
| '}'                   { RBRACE }
| ';'                   { SEMI }
| ','                   { COMMA }
| '+'                   { PLUS }
| '-'                   { MINUS }
| '*'                   { TIMES }
| '/'                   { DIVIDE }
| '='                   { ASSIGN }
| "=="                  { EQ }
| "!="                  { NEQ }
| '<'                   { LT }
| "<="                  { LEQ }
| ">"                   { GT }
| ">="                  { GEQ }
| "&&"                  { AND }
| "||"                  { OR }
| "!"                   { NOT }
| "if"                  { IF }
| "else"                { ELSE }
| "for"                 { FOR }
| "while"               { WHILE }
| "return"              { RETURN }
| "int"                 { INT }
| "bool"                { BOOL }
| "void"                { VOID }
| "true"                { TRUE }
| "false"               { FALSE }
| "pipe"                { PIPE }
| "function"            { FUNCTION }
| "struct"              { STRUCT }
| "list"                { LIST }
| string_t as str       { STR_LIT(str) }
| ['0'-'9']+ as lxm     { LITERAL(int_of_string lxm) }
| ['a'-'z' 'A'-'Z']['a'-'z' 'A'-'Z' '0'-'9' '_']* as lxm { ID(lxm) }
| eof { EOF }
| _ as char { raise (Failure("illegal character " ^ Char.escaped char)) }

and comment = parse
  "*/" { token lexbuf }
| _    { comment lexbuf }
