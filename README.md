# Firebird
This repository currently contains 2 projects for the Firebird database with Delphi.

# 1. Firebird Syntax Validator
Firebird Validator Project incl. Test.<br>
Firebird Validator is a project for parsing SQL and DDL under Firebird. In the first step, I put the commands into individual tokens. This is done by the scanner. In the second step, the parser is to validate the token. The parser is still in work.
<br><br>
The reason for the project was that the statements were always flawed and this was too late.

# 2. Firebird Syntax Validator
Adapter for ORM Spring4D with Marshmellow to IBX.<br>
The adapter with UID works fine, but I mostly use IBX and didn't want to change the driver. So I had to implement an adapter for IBX, which also served for learning purposes. The project I haven't finished and has some flaws, but I'm on it.
