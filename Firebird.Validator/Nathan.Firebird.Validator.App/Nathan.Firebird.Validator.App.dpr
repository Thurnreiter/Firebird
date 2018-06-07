program Nathan.Firebird.Validator.App;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.IOUtils,
  Nathan.Firebird.Validator.Syntax.Keywords.Intf,
  Nathan.Firebird.Validator.Syntax.Keywords.Scanner,
  Nathan.Firebird.Validator.Syntax.Keywords.Parser;

var
  AppParamValue: string = '';
  Inconsistencies: string = '';
  Scanner: IFb25Scanner;
  Parser: IFb25Parser;

begin
  try
    if (FindCmdLineSwitch('SQL', AppParamValue)
    and TFile.Exists(AppParamValue)) then
    begin
      Scanner := TFb25Scanner.Create;
      Scanner.Statement := TFile.ReadAllText(AppParamValue);
    end
    else
      raise Exception.Create('File [' + AppParamValue + '] not found.');

    Parser := TFb25Parser.Create;
    Parser.Tokens := Scanner.Execute().Tokens;
    Parser.OnNotify :=
      procedure(Item: IFb25Token)
      begin
        Inconsistencies := Inconsistencies + sLineBreak + Item.Value;
      end;

    Parser.Accept(TFb25VisitorArguments.Create);
    //Parser.Accept(TFb25TerminatorCharacters.Create);

    if (Inconsistencies.Trim.IsEmpty) then
    begin
      Writeln('Not error found. All data are correct.');
    end
    else
    begin
      Writeln('');
      Writeln('Found errors:');
      Writeln(Inconsistencies.Trim);
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

  Writeln('');
  Write('Press [ENTER] to continue...');
  Readln;
end.
