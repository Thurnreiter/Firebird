unit Nathan.Firebird.Validator.Syntax.Keywords.Token;

interface

uses
  Nathan.Firebird.Validator.Syntax.Keywords.Intf,
  Nathan.Firebird.Validator.Syntax.Keywords.Types;

{$M+}

type
  TFb25Token = class(TInterfacedObject, IFb25Token)
  strict private
    FFb25Token: TFb25TokenKind;
    FValue: string;
  private
    function GetToken(): TFb25TokenKind;
    function GetValue(): string;
  public
    constructor Create(const AValue: string; ATokenType: TFb25TokenKind);
  end;

{$M-}

implementation

{ **************************************************************************** }

{ TFb25Token }

constructor TFb25Token.Create(const AValue: string; ATokenType: TFb25TokenKind);
begin
  inherited Create();
  FFb25Token := ATokenType;
  FValue := AValue;
end;

function TFb25Token.GetToken(): TFb25TokenKind;
begin
  Result := FFb25Token;
end;

function TFb25Token.GetValue(): string;
begin
  Result := FValue;
end;

end.
