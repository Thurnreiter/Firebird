program Nathan.Firebird.Marshmallow.UnitTestsX;

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
  CodeGenerator.IBX.Test in 'CodeGenerator.IBX.Test.pas',
  Spring.Persistence.Adapters.IBX in '..\Persistence\Adapters\Spring.Persistence.Adapters.IBX.pas',
  Persistence.CodeGenerator.Abstract in '..\Persistence\Services\Persistence.CodeGenerator.Abstract.pas',
  Persistence.CodeGenerator.IBX in '..\Persistence\Services\Persistence.CodeGenerator.IBX.pas',
  Base.Test in 'Base.Test.pas',
  Nathan.Resources.ResourceManager in '..\Lib\Nathan.Resources.ResourceManager.pas',
  ORM.Model.EMPLOYEE in '..\Persistence\Models\ORM.Model.EMPLOYEE.pas',
  ORM.Model.SALARY_HISTORY in '..\Persistence\Models\ORM.Model.SALARY_HISTORY.pas',
  Spring.Persistence.Adapters.IBX.Test in 'Spring.Persistence.Adapters.IBX.Test.pas',
  ORM.Model.COUNTRY in '..\Persistence\Models\ORM.Model.COUNTRY.pas';

var
  runner : ITestRunner;
  results : IRunResults;
  logger : ITestLogger;
  nunitLogger : ITestLogger;
begin
  ReportMemoryLeaksOnShutdown := (DebugHook <> 1);
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
