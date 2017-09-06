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
    procedure Test_FirstTestWithVisitorPattern();

    [Test]
    procedure Test_CreateDomain_IsCorrect();

    [Test]
    [TestCase('IsCorrect', 'True')]
    [TestCase('IsIncorrect', 'False')]
    procedure Test_InsertInto(Value: Boolean);

    [Test]
    procedure Test_HasTerminatatorCharacters();

    [Test]
    procedure Test_SimpleTestWithAllVisitors();

    [Test]
    procedure Test_HowToMockAFb25Parser();
  end;

{$M-}

implementation

uses
  System.Rtti,
  Delphi.Mocks,
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

procedure TTestFirebird25Parser.Test_FirstTestWithVisitorPattern();
var
  ActualOnEventCounter: Integer;
begin
  //  Arrange,
  ActualOnEventCounter := 0;
  FCut.Tokens := CreateStubInsertIntoTokens2();
  FCut.OnNotify :=
    procedure(Item: IFb25Token)
    begin
      Inc(ActualOnEventCounter);
      Assert.AreEqual('2, ''Werkstatt'', ''Werbung''', Item.Value);
      Assert.AreEqual(fb25Arguments, Item.Token);
    end;

  //  Act
  FCut.Accept(TFb25VisitorArguments.Create);

  //  Assert
  Assert.AreEqual(1, ActualOnEventCounter);
end;

procedure TTestFirebird25Parser.Test_CreateDomain_IsCorrect();
var
  ActualOnEventCounter: Integer;
begin
  //  Arrange,
  ActualOnEventCounter := 0;
  FCut.Tokens := CreateStubDomainTokens();
  FCut.OnNotify :=
    procedure(Item: IFb25Token)
    begin
      Inc(ActualOnEventCounter);
    end;

  //  Act
  FCut.Accept(TFb25VisitorArguments.Create);

  //  Assert
  Assert.AreEqual(0, ActualOnEventCounter);
end;

procedure TTestFirebird25Parser.Test_InsertInto(Value: Boolean);
var
  ActualOnEventCounter: Integer;
begin
  //  Arrange,
  ActualOnEventCounter := 0;
  FCut.Tokens := CreateStubInsertIntoTokens(2, Value);
  FCut.OnNotify :=
    procedure(Item: IFb25Token)
    begin
      Inc(ActualOnEventCounter);
    end;

  //  Act
  FCut.Accept(TFb25VisitorArguments.Create);

  //  Assert
  if Value then
    Assert.AreEqual(0, ActualOnEventCounter)    //  Don't find any error...
  else
    Assert.AreNotEqual(0, ActualOnEventCounter) //  Find any error...
end;

procedure TTestFirebird25Parser.Test_HasTerminatatorCharacters();
var
  ActualOnEventCounter: Integer;
begin
  //  Arrange,
  ActualOnEventCounter := 0;
  FCut.Tokens := CreateStubInsertIntoTokens2();
  FCut.OnNotify :=
    procedure(Item: IFb25Token)
    begin
      Inc(ActualOnEventCounter);
    end;

  //  Act
  FCut.Accept(TFb25TerminatorCharacters.Create);

  //  Assert
  Assert.AreEqual(2, ActualOnEventCounter);
end;

procedure TTestFirebird25Parser.Test_SimpleTestWithAllVisitors;
var
  ActualOnEventCounter: Integer;
begin
  //  Arrange,
  ActualOnEventCounter := 0;
  FCut.Tokens := CreateStubInsertIntoTokens2();
  FCut.OnNotify :=
    procedure(Item: IFb25Token)
    begin
      Inc(ActualOnEventCounter);
    end;

  //  Act
  FCut.Accept(TFb25VisitorArguments.Create);
  FCut.Accept(TFb25TerminatorCharacters.Create);

  //  Assert
  //  1 x Argumentserror, 2 x Terminator Characters...
  Assert.AreEqual(3, ActualOnEventCounter);
end;

procedure TTestFirebird25Parser.Test_HowToMockAFb25Parser();
var
  Cut: TMock<IFb25Parser>;
  Vis: IVisitor;
  Event: TFb25ParserNotifyEvent;
  ActualOnEventCounter: Integer;
begin
  Event :=
    procedure(Token: IFb25Token)
    begin
      Inc(ActualOnEventCounter);
    end;

  ActualOnEventCounter := 0;
  Cut := TMock<IFb25Parser>.Create;
  Cut.Setup.WillReturn(CreateStubInsertIntoTokens2()).When.Tokens;
  Cut.Setup.WillReturn((TValue.From<TFb25ParserNotifyEvent>(Event))).When.OnNotify;
  //  Cut.Instance.OnNotify := Event;

  Vis := TFb25TerminatorCharacters.Create;
  Vis.Visit(Cut);

  Assert.AreEqual(2, ActualOnEventCounter);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestFirebird25Parser, 'Parser');

end.
