unit Nathan.Firebird.Validator.Syntax.Keywords.Parser;

interface

uses
  System.Generics.Collections,
  Nathan.Firebird.Validator.Syntax.Keywords.Intf;

{$M+}

type
  TFb25Parser = class(TInterfacedObject, IFb25Parser)
  strict private
    FTokens: TList<IFb25Token>;
  private
    function GetTokens(): TList<IFb25Token>;
    procedure SetTokens(Value: TList<IFb25Token>);
  public
    function PredictiveAnalytics(): Boolean;
  end;

{$M-}

implementation

uses
  System.SysUtils,
  Nathan.Firebird.Validator.Syntax.Keywords.Types;

{ **************************************************************************** }

{ TFb25Parser }

function TFb25Parser.GetTokens(): TList<IFb25Token>;
begin
  Result := FTokens;
end;

procedure TFb25Parser.SetTokens(Value: TList<IFb25Token>);
begin
  FTokens := Value;
end;

function TFb25Parser.PredictiveAnalytics(): Boolean;
var
  Each: IFb25Token;
  ArgLeft: TArray<string>;
  ArgRight: TArray<string>;
begin
  Result := True;

  //  Check whether all arguments match...
  ArgLeft := nil;
  ArgRight := nil;
  for Each in FTokens do
  begin
    if (Each.Token = TFb25TokenKind.fb25Arguments) then
    begin
      if Assigned(ArgLeft) then
      begin
        ArgRight := Each.Value.Split([',']);
        if Result then
          Result := (High(ArgLeft) = High(ArgRight));
      end
      else
        ArgLeft := Each.Value.Split([',']);
    end;
  end;
end;

end.
