unit Firebird.Parser.Tests;

interface

uses
  System.Generics.Collections,
  DUnitX.TestFramework,
  Nathan.Firebird.Validator.Syntax.Keywords.Intf;

{$M+}

type
  [TestFixture]
  TTestFirebird25Parser = class
  private
    FCut: IFb25Parser;
    function CreateStubDomainTokens(): TList<IFb25Token>;
    function CreateStubInsertIntoTokens(HowMany: Integer; CorrectArgumentList: Boolean): TList<IFb25Token>;
    function CreateStubInsertIntoTokens2(): TList<IFb25Token>;
  public
    [Setup]
    procedure SetUp();

    [TearDown]
    procedure TearDown();
  published
    [Test]
    procedure Test_PredictiveAnalytics_CreateDomain;

    [Test]
    [TestCase('IsCorrect', 'True')]
    [TestCase('IsIncorrect', 'False')]
    procedure Test_PredictiveAnalytics_InsertInto(Value: Boolean);

    [Test]
    procedure Test_PredictiveAnalytics_With2InsertInto_FirstOk_SecondWrong();
  end;

{$M-}

implementation

uses
  Nathan.Firebird.Validator.Syntax.Keywords.Parser,
  Nathan.Firebird.Validator.Syntax.Keywords.Token,
  Nathan.Firebird.Validator.Syntax.Keywords.Scanner,
  Nathan.Firebird.Validator.Syntax.Keywords.Types;

{ TTestFirebird25Scanner }

procedure TTestFirebird25Parser.SetUp;
begin
  FCut := TFb25Parser.Create;
end;

procedure TTestFirebird25Parser.TearDown;
begin
  if (Assigned(FCut) and Assigned(FCut.Tokens)) then
    FCut.Tokens.Free();

  FCut := nil;
end;

function TTestFirebird25Parser.CreateStubDomainTokens(): TList<IFb25Token>;
begin
  Result := TList<IFb25Token>.Create;
  Result.Add(TFb25Token.Create('CREATE', fb25Starter));
  Result.Add(TFb25Token.Create(' ', fb25Whitespaces));
  Result.Add(TFb25Token.Create('DOMAIN', fb25Operator));
  Result.Add(TFb25Token.Create(' ', fb25Whitespaces));
  Result.Add(TFb25Token.Create('TFLOAT', fb25Variable));
  Result.Add(TFb25Token.Create(' ', fb25Whitespaces));
  Result.Add(TFb25Token.Create('AS', fb25None));
  Result.Add(TFb25Token.Create(' ', fb25Operator));
  Result.Add(TFb25Token.Create('DECIMAL', fb25Operator));
  Result.Add(TFb25Token.Create('(', fb25BracketOpen));
  Result.Add(TFb25Token.Create('15,3', fb25Arguments));
  Result.Add(TFb25Token.Create(')', fb25BracketClose));
  Result.Add(TFb25Token.Create(';', fb25TerminatorCharacter));
end;

function TTestFirebird25Parser.CreateStubInsertIntoTokens(HowMany: Integer; CorrectArgumentList: Boolean): TList<IFb25Token>;
var
  Idx: Integer;
begin
  Result := TList<IFb25Token>.Create;
  for Idx := 0 to HowMany do
  begin
    Result.Add(TFb25Token.Create('INSERT', fb25Operator));
    Result.Add(TFb25Token.Create(' ', fb25Whitespaces));
    Result.Add(TFb25Token.Create('INTO', fb25Operator));
    Result.Add(TFb25Token.Create(' ', fb25Whitespaces));
    Result.Add(TFb25Token.Create('DOKGRP', fb25Variable));
    Result.Add(TFb25Token.Create(' ', fb25Whitespaces));
    Result.Add(TFb25Token.Create('(', fb25BracketOpen));
    Result.Add(TFb25Token.Create('DOG_FNR, DOG_FBEZEICH', fb25Arguments));
    Result.Add(TFb25Token.Create(')', fb25BracketClose));
    Result.Add(TFb25Token.Create(' ', fb25Whitespaces));
    Result.Add(TFb25Token.Create('VALUES', fb25Operator));
    Result.Add(TFb25Token.Create(' ', fb25Whitespaces));
    Result.Add(TFb25Token.Create('(', fb25BracketOpen));

    if CorrectArgumentList then
      Result.Add(TFb25Token.Create('1, ''Werkstatt''', fb25Arguments))
    else
      Result.Add(TFb25Token.Create('1, ''Werkstatt'', ''Werbung''', fb25Arguments));

    Result.Add(TFb25Token.Create(')', fb25BracketClose));
    Result.Add(TFb25Token.Create(';', fb25TerminatorCharacter));
  end;
end;

function TTestFirebird25Parser.CreateStubInsertIntoTokens2(): TList<IFb25Token>;
begin
  Result := TList<IFb25Token>.Create;

  Result.Add(TFb25Token.Create('INSERT', fb25Operator));
  Result.Add(TFb25Token.Create(' ', fb25Whitespaces));
  Result.Add(TFb25Token.Create('INTO', fb25Operator));
  Result.Add(TFb25Token.Create(' ', fb25Whitespaces));
  Result.Add(TFb25Token.Create('DOKGRP', fb25Variable));
  Result.Add(TFb25Token.Create(' ', fb25Whitespaces));
  Result.Add(TFb25Token.Create('(', fb25BracketOpen));
  Result.Add(TFb25Token.Create('DOG_FNR, DOG_FBEZEICH', fb25Arguments));
  Result.Add(TFb25Token.Create(')', fb25BracketClose));
  Result.Add(TFb25Token.Create(' ', fb25Whitespaces));
  Result.Add(TFb25Token.Create('VALUES', fb25Operator));
  Result.Add(TFb25Token.Create(' ', fb25Whitespaces));
  Result.Add(TFb25Token.Create('(', fb25BracketOpen));
  Result.Add(TFb25Token.Create('1, ''Werkstatt''', fb25Arguments));
  Result.Add(TFb25Token.Create(')', fb25BracketClose));
  Result.Add(TFb25Token.Create(';', fb25TerminatorCharacter));

  Result.Add(TFb25Token.Create(' ', fb25Whitespaces));

  Result.Add(TFb25Token.Create('INSERT', fb25Operator));
  Result.Add(TFb25Token.Create(' ', fb25Whitespaces));
  Result.Add(TFb25Token.Create('INTO', fb25Operator));
  Result.Add(TFb25Token.Create(' ', fb25Whitespaces));
  Result.Add(TFb25Token.Create('DOKGRP', fb25Variable));
  Result.Add(TFb25Token.Create(' ', fb25Whitespaces));
  Result.Add(TFb25Token.Create('(', fb25BracketOpen));
  Result.Add(TFb25Token.Create('DOG_FNR, DOG_FBEZEICH', fb25Arguments));
  Result.Add(TFb25Token.Create(')', fb25BracketClose));
  Result.Add(TFb25Token.Create(' ', fb25Whitespaces));
  Result.Add(TFb25Token.Create('VALUES', fb25Operator));
  Result.Add(TFb25Token.Create(' ', fb25Whitespaces));
  Result.Add(TFb25Token.Create('(', fb25BracketOpen));
  Result.Add(TFb25Token.Create('2, ''Werkstatt'', ''Werbung''', fb25Arguments));
  Result.Add(TFb25Token.Create(')', fb25BracketClose));
  Result.Add(TFb25Token.Create(';', fb25TerminatorCharacter));
end;

procedure TTestFirebird25Parser.Test_PredictiveAnalytics_CreateDomain;
var
  Actual: Boolean;
begin
  FCut.Tokens := CreateStubDomainTokens();
  Actual := FCut.PredictiveAnalytics();
  Assert.IsTrue(Actual);
end;

procedure TTestFirebird25Parser.Test_PredictiveAnalytics_InsertInto(Value: Boolean);
begin
  FCut.Tokens := CreateStubInsertIntoTokens(2, Value);
  Assert.AreEqual(Value, FCut.PredictiveAnalytics());
end;

procedure TTestFirebird25Parser.Test_PredictiveAnalytics_With2InsertInto_FirstOk_SecondWrong();
begin
  FCut.Tokens := CreateStubInsertIntoTokens2();
  Assert.IsFalse(FCut.PredictiveAnalytics());
end;

initialization
  TDUnitX.RegisterTestFixture(TTestFirebird25Parser, 'Parser');

end.
