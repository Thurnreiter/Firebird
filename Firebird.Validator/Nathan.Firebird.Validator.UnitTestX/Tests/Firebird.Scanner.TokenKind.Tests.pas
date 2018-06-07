unit Firebird.Scanner.TokenKind.Tests;

interface

uses
  DUnitX.TestFramework,
  Nathan.Firebird.Validator.Syntax.Keywords.Intf,
  Nathan.Firebird.Validator.Syntax.Keywords.Types;

{$M+}

type
  [TestFixture]
  TTestFb25Token = class
  private
    FCut: IFb25Token;
  public
    [Setup]
    procedure SetUp();

    [TearDown]
    procedure TearDown();
  published
    [Test]
    [TestCase('Prop01', 'Nathan,fb25None')]
    [TestCase('Prop02', 'CREATE,fb25CREATE')]
    [TestCase('Prop03', '^,fb25Roof')]
    procedure Test_Properties(const Value: string; ATokenKind: TFb25TokenKind);
  end;

{$M-}

implementation

uses
  Nathan.Firebird.Validator.Syntax.Keywords.Token,
  Nathan.Firebird.Validator.Syntax.Keywords.Scanner;

{ TTestFb25Token }

procedure TTestFb25Token.SetUp;
begin
  FCut := nil;
end;

procedure TTestFb25Token.TearDown;
begin
  FCut := nil;
end;

procedure TTestFb25Token.Test_Properties(const Value: string; ATokenKind: TFb25TokenKind);
begin
  FCut := TFb25Token.Create(Value, ATokenKind);
  Assert.AreEqual(Value, FCut.Value);
  Assert.AreEqual(ATokenKind, FCut.Token);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestFb25Token, 'TokenKind');

end.
