program Nathan.Firebird.Validator.UnitTestX;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}{$STRONGLINKTYPES ON}
{$R *.dres}

uses
  System.SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ENDIF }
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  DUnitX.TestFramework,
  Firebird.Parser.Tests in 'Tests\Firebird.Parser.Tests.pas',
  Firebird.Scanner.Tests in 'Tests\Firebird.Scanner.Tests.pas',
  Firebird.Scanner.TokenKind.Tests in 'Tests\Firebird.Scanner.TokenKind.Tests.pas',
  Firebird.SyntaxWords.Tests in 'Tests\Firebird.SyntaxWords.Tests.pas',
  Nathan.Firebird.Validator.Syntax.Keywords.Intf in '..\Nathan.Firebird.Validator.Syntax.Keywords.Intf.pas',
  Nathan.Firebird.Validator.Syntax.Keywords.Parser in '..\Nathan.Firebird.Validator.Syntax.Keywords.Parser.pas',
  Nathan.Firebird.Validator.Syntax.Keywords.Scanner in '..\Nathan.Firebird.Validator.Syntax.Keywords.Scanner.pas',
  Nathan.Firebird.Validator.Syntax.Keywords.Token in '..\Nathan.Firebird.Validator.Syntax.Keywords.Token.pas',
  Nathan.Firebird.Validator.Syntax.Keywords.Types in '..\Nathan.Firebird.Validator.Syntax.Keywords.Types.pas',
  Nathan.Resources.ResourceManager in 'Lib\Nathan.Resources.ResourceManager.pas';

var
  runner : ITestRunner;
  results : IRunResults;
  logger : ITestLogger;
  nunitLogger : ITestLogger;
begin
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
  exit;
{$ENDIF}
  try
    //Check command line options, will exit if invalid
    TDUnitX.CheckCommandLine;
    //Create the test runner
    runner := TDUnitX.CreateRunner;
    //Tell the runner to use RTTI to find Fixtures
    runner.UseRTTI := True;
    //tell the runner how we will log things
    //Log to the console window
    logger := TDUnitXConsoleLogger.Create(true);
    runner.AddLogger(logger);
    //Generate an NUnit compatible XML File
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);
    runner.FailsOnNoAsserts := False; //When true, Assertions must be made during tests;

    //Run tests
    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

    {$IFNDEF CI}
    //We don't want this happening when running under CI.
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
    {$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
end.
