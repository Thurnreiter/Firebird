unit Firebird.Scanner.Tests;

interface

uses
  System.Classes,
  DUnitX.TestFramework,
  Nathan.Firebird.Validator.Syntax.Keywords.Intf,
  Nathan.Firebird.Validator.Syntax.Keywords.Scanner,
  Nathan.Firebird.Validator.Syntax.Keywords.Types;

const
  InText01 = 'INSERT INTO MARKENDATEN (MAD_FNR, MAD_FKRDNR, MAD_FMARKE, MAD_FORDNER, MAD_FLEADZERO, MAD_FANPASSEN, MAD_FGKKORREKTUR, MAD_FDATATYPE, MAD_FDATUM)'
    + sLineBreak
    + '                 VALUES (43, NULL, ''Peugeot (Franz)'', ''Peugeot'', ''1'', ''0'', ''0'', NULL, NULL);';
  InText02 = 'INSERT INTO MARKENDATEN (MAD_FNR, MAD_FKRDNR, MAD_FMARKE, MAD_FORDNER, MAD_FLEADZERO, MAD_FANPASSEN, MAD_FGKKORREKTUR, MAD_FDATATYPE, MAD_FDATUM)'
    + sLineBreak
    + '                 VALUES (16, NULL, ''FZR, Reussbühl'', ''FZR'', ''0'', ''0'', ''0'', NULL, NULL);';

{$M+}

type
  [TestFixture]
  TTestFirebird25Scanner = class
  private
    FCut: IFb25Scanner;
  public
    [Setup]
    procedure SetUp();

    [TearDown]
    procedure TearDown();
  published
    [Test]
    procedure Test_HasCreated();

    [Test]
    [TestCase('Scanner01', 'CREATE DOMAIN TFLOAT AS' + sLineBreak + 'DECIMAL(15,3);', '|')]
    procedure Test_DontRaise(const Value: string);

    [Test]
    [TestCase('Res01', 'InsertInto01')]
    procedure Test_ExecuteOverResource(const Value: string);

    [Test]
    procedure Test_HasAllTokenFromStatement();

    [Test]
    procedure Test_HasTwoArgumentsTokenFromStatement();

    [Test]
    procedure Test_Execute_CreateGenerator();

    [Test]
    [TestCase('Counter01', 'DECIMAL(15,3);//Comment|6', '|')]
    [TestCase('Counter02', 'CREATE GENERATOR FFT_GNR;|6', '|')]
    [TestCase('Counter03', 'CREATE DOMAIN TFLOAT AS DECIMAL(15,3);|13', '|')]
    [TestCase('Counter04', 'SET GENERATOR BPR_GNR TO 1;|10', '|')]
    [TestCase('Counter05', 'DECIMAL(15,3);|5', '|')]
    [TestCase('Counter06', 'DECIMAL(15,3) ;|6', '|')]
    [TestCase('Counter07', ' DECIMAL(15,3) ; |8', '|')]
    [TestCase('Counter08', ' DECIMAL(15, 3) ; |8', '|')]
    procedure Test_Execute_TokenCounter(const IdentifierValue: string; ExpectedValue: Integer);

    [Test]
    [TestCase('CounterRes01', 'InsertInitalData01,83')]
    [TestCase('CounterRes02', 'InsertInto01,24')]
    procedure Test_Execute_TokenCounter_OverResources(const ResNameValue: string; ExpectedValue: Integer);

    [Test]
    [TestCase('ScannerCounter01', 'CREATE DECIMAL(15, 3);|7', '|')]
    [TestCase('ScannerCounter02', 'CREATE DECIMAL(15,3);|7', '|')]
    [TestCase('ScannerCounter03', 'insert into table (col1, col2) values (val1, val2);|16', '|')]
    [TestCase('ScannerCounter04', 'insert into   table (col1, col2) values (val1, val2);|18', '|')]
    [TestCase('ScannerCounter05', 'select * from config|7', '|')]
    [TestCase('ScannerCounter06', 'select * from config;|8', '|')]
    [TestCase('ScannerCounter07', 'select cfg_fnr from config|7', '|')]
    [TestCase('ScannerCounter08', 'select Count(*) from config|10', '|')]
    [TestCase('ScannerCounter09', 'select Count(*) from config;|11', '|')]
    [TestCase('WithBracketsInText01', InText01 + '|34', '|')]
    [TestCase('WithBracketsInText02', InText02 + '|34', '|')]
    procedure Test_RPN_ReversePolishNotation(const ValueStatement: string; ExpectedValue: Integer);
  end;

{$M-}

implementation

uses
  System.Generics.Collections,
  Nathan.Resources.ResourceManager;

{ TTestFirebird25Scanner }

procedure TTestFirebird25Scanner.SetUp;
begin
  FCut := TFb25Scanner.Create;
end;

procedure TTestFirebird25Scanner.TearDown;
begin
  FCut := nil;
end;

procedure TTestFirebird25Scanner.Test_HasCreated;
begin
  Assert.IsNotNull(FCut);
end;

procedure TTestFirebird25Scanner.Test_HasTwoArgumentsTokenFromStatement;
var
  Actual: TList<IFb25Token>;
begin
  FCut.Statement := 'INSERT INTO BELEGTYP (BET_FNR, BET_FBEZEICH) VALUES (10, ''Auftrag'');';
  Actual := FCut.Execute().Tokens;

  Assert.AreEqual('INSERT', Actual[0].Value);
  Assert.AreEqual(fb25Operator, Actual[0].Token);

  Assert.AreEqual(' ', Actual[1].Value);
  Assert.AreEqual(fb25Whitespaces, Actual[1].Token);

  Assert.AreEqual('INTO', Actual[2].Value);
  Assert.AreEqual(fb25Operator, Actual[2].Token);

  Assert.AreEqual(' ', Actual[3].Value);
  Assert.AreEqual(fb25Whitespaces, Actual[3].Token);

  Assert.AreEqual('BELEGTYP', Actual[4].Value);
  Assert.AreEqual(fb25Variable, Actual[4].Token);

  Assert.AreEqual(' ', Actual[5].Value);
  Assert.AreEqual(fb25Whitespaces, Actual[5].Token);

  Assert.AreEqual('(', Actual[6].Value);
  Assert.AreEqual(fb25BracketOpen, Actual[6].Token);

  Assert.AreEqual('BET_FNR, BET_FBEZEICH', Actual[7].Value);
  Assert.AreEqual(fb25Arguments, Actual[7].Token);

  Assert.AreEqual(')', Actual[8].Value);
  Assert.AreEqual(fb25BracketClose, Actual[8].Token);

  Assert.AreEqual(' ', Actual[9].Value);
  Assert.AreEqual(fb25Whitespaces, Actual[9].Token);

  Assert.AreEqual('VALUES', Actual[10].Value);
  Assert.AreEqual(fb25Operator, Actual[10].Token);

  Assert.AreEqual(' ', Actual[11].Value);
  Assert.AreEqual(fb25Whitespaces, Actual[11].Token);

  Assert.AreEqual('(', Actual[12].Value);
  Assert.AreEqual(fb25BracketOpen, Actual[12].Token);

  Assert.AreEqual('10, ''Auftrag''', Actual[13].Value);
  Assert.AreEqual(fb25Arguments, Actual[13].Token);

  Assert.AreEqual(')', Actual[14].Value);
  Assert.AreEqual(fb25BracketClose, Actual[14].Token);

  Assert.AreEqual(';', Actual[15].Value);
  Assert.AreEqual(fb25TerminatorCharacter, Actual[15].Token);

  Assert.AreEqual(16, Actual.Count);
end;

procedure TTestFirebird25Scanner.Test_DontRaise(const Value: string);
begin
  FCut.Statement := Value;
  Assert.WillNotRaiseAny(
    procedure
    begin
      FCut.Execute();
    end);
end;

procedure TTestFirebird25Scanner.Test_ExecuteOverResource(const Value: string);
begin
  FCut.Statement := TResourceManager.GetString(Value);
  Assert.WillNotRaiseAny(
    procedure
    begin
      FCut.Execute();
    end);
end;

procedure TTestFirebird25Scanner.Test_HasAllTokenFromStatement();
var
  Actual: TList<IFb25Token>;
//  ActualValue: string;
//  ActualKind: TFb25TokenKind;
begin
  FCut.Statement := 'CREATE DOMAIN TFLOAT AS' + sLineBreak + 'DECIMAL(15,3);';
  Actual := FCut.Execute().Tokens;

//  ActualValue := Actual[0].Value;
//  ActualValue := Actual[1].Value;
//  ActualValue := Actual[2].Value;
//  ActualValue := Actual[3].Value;
//  ActualValue := Actual[4].Value;
//  ActualValue := Actual[5].Value;
//  ActualValue := Actual[6].Value;
//  ActualValue := Actual[7].Value;
//  ActualValue := Actual[8].Value;
//  ActualValue := Actual[9].Value;
//  ActualValue := Actual[10].Value;
//  ActualValue := Actual[11].Value;
//  ActualValue := Actual[12].Value;
//  ActualValue := Actual[13].Value;
//
//  ActualKind := Actual[0].Token;
//  ActualKind := Actual[1].Token;
//  ActualKind := Actual[2].Token;
//  ActualKind := Actual[3].Token;
//  ActualKind := Actual[4].Token;
//  ActualKind := Actual[5].Token;
//  ActualKind := Actual[6].Token;
//  ActualKind := Actual[7].Token;
//  ActualKind := Actual[8].Token;
//  ActualKind := Actual[9].Token;
//  ActualKind := Actual[10].Token;
//  ActualKind := Actual[11].Token;
//  ActualKind := Actual[12].Token;
//  ActualKind := Actual[13].Token;

  Assert.AreEqual('CREATE', Actual[0].Value);
  Assert.AreEqual(fb25Starter, Actual[0].Token);

  Assert.AreEqual(' ', Actual[1].Value);
  Assert.AreEqual(fb25Whitespaces, Actual[1].Token);

  Assert.AreEqual('DOMAIN', Actual[2].Value);
  Assert.AreEqual(fb25Operator, Actual[2].Token);

  Assert.AreEqual(' ', Actual[3].Value);
  Assert.AreEqual(fb25Whitespaces, Actual[3].Token);

  Assert.AreEqual('TFLOAT', Actual[4].Value);
  Assert.AreEqual(fb25Variable, Actual[4].Token);

  Assert.AreEqual(' ', Actual[5].Value);
  Assert.AreEqual(fb25Whitespaces, Actual[5].Token);

  Assert.AreEqual('AS', Actual[6].Value);
  Assert.AreEqual(fb25Operator, Actual[6].Token);

  Assert.AreEqual(#$D, Actual[7].Value);
  Assert.AreEqual(fb25Whitespaces, Actual[7].Token);

  Assert.AreEqual(#$A, Actual[8].Value);
  Assert.AreEqual(fb25Whitespaces, Actual[8].Token);

  Assert.AreEqual('DECIMAL', Actual[9].Value);
  Assert.AreEqual(fb25Operator, Actual[9].Token);

  Assert.AreEqual('(', Actual[10].Value);
  Assert.AreEqual(fb25BracketOpen, Actual[10].Token);

  Assert.AreEqual('15,3', Actual[11].Value);
  Assert.AreEqual(fb25Arguments, Actual[11].Token);

  Assert.AreEqual(')', Actual[12].Value);
  Assert.AreEqual(fb25BracketClose, Actual[12].Token);

  Assert.AreEqual(';', Actual[13].Value);
  Assert.AreEqual(fb25TerminatorCharacter, Actual[13].Token);

  Assert.AreEqual(14, Actual.Count);
end;

procedure TTestFirebird25Scanner.Test_Execute_CreateGenerator;
var
  Actual: TList<IFb25Token>;
begin
  FCut.Statement := 'CREATE GENERATOR FFT_GNR;';
  Actual := FCut.Execute().Tokens;

  Assert.AreEqual('CREATE', Actual[0].Value);
  Assert.AreEqual(fb25Starter, Actual[0].Token);

  Assert.AreEqual(' ', Actual[1].Value);
  Assert.AreEqual(fb25Whitespaces, Actual[1].Token);

  Assert.AreEqual('GENERATOR', Actual[2].Value);
  Assert.AreEqual(fb25Operator, Actual[2].Token);

  Assert.AreEqual(' ', Actual[3].Value);
  Assert.AreEqual(fb25Whitespaces, Actual[3].Token);

  Assert.AreEqual('FFT_GNR', Actual[4].Value);
  Assert.AreEqual(fb25Variable, Actual[4].Token);

  Assert.AreEqual(';', Actual[5].Value);
  Assert.AreEqual(fb25TerminatorCharacter, Actual[5].Token);

  Assert.AreEqual(6, Actual.Count);
end;

procedure TTestFirebird25Scanner.Test_Execute_TokenCounter(const IdentifierValue: string; ExpectedValue: Integer);
begin
  FCut.Statement := IdentifierValue;
  Assert.AreEqual(ExpectedValue, FCut.Execute().Tokens.Count);
end;

procedure TTestFirebird25Scanner.Test_Execute_TokenCounter_OverResources(const ResNameValue: string; ExpectedValue: Integer);
var
  Each: IFb25Token;
  ActualValue: string;
  ActualTokens: TList<IFb25Token>;
begin
  FCut.Statement := TResourceManager.GetString(ResNameValue);
  ActualTokens := FCut.Execute().Tokens;
  for Each in ActualTokens do
  begin
    ActualValue := Each.Value;
    Assert.AreNotEqual('', ActualValue);
    Assert.AreNotEqual('', Each.Value);
  end;

  Assert.AreEqual(ExpectedValue, ActualTokens.Count);
end;

procedure TTestFirebird25Scanner.Test_RPN_ReversePolishNotation(
  const ValueStatement: string; ExpectedValue: Integer);
var
  Tokens: TList<IFb25Token>;
  Each: IFb25Token;
  ActualValue: string;
  ActualKind: TFb25TokenKind;
begin
  FCut.Statement := ValueStatement;
  Tokens := FCut.Execute().Tokens;

  for Each in Tokens do
  begin
    ActualValue := Each.Value;
    ActualKind := Each.Token;
    Assert.AreNotEqual('', ActualValue);
    Assert.AreNotEqual(TFb25TokenKind.fb25None, ActualKind);
  end;

  Assert.AreEqual(ExpectedValue, Tokens.Count);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestFirebird25Scanner, 'Scanner');

end.
