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
    FOnNotify: TFb25ParserNotifyEvent;
  private
    function GetTokens(): TList<IFb25Token>;
    procedure SetTokens(Value: TList<IFb25Token>);

    function GetOnNotify(): TFb25ParserNotifyEvent;
    procedure SetOnNotify(Value: TFb25ParserNotifyEvent);
  public
    //    function PredictiveAnalytics(): Boolean;
    procedure Accept(Visitor: IVisitor);
  end;

  TFb25VisitorArguments = class(TInterfacedObject, IVisitor)
  public
    procedure Visit(Instance: IFb25Parser);
  end;

  TFb25TerminatorCharacters = class(TInterfacedObject, IVisitor)
  public
    procedure Visit(Instance: IFb25Parser);
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

function TFb25Parser.GetOnNotify(): TFb25ParserNotifyEvent;
begin
  Result := FOnNotify;
end;

procedure TFb25Parser.SetTokens(Value: TList<IFb25Token>);
begin
  FTokens := Value;
end;

procedure TFb25Parser.SetOnNotify(Value: TFb25ParserNotifyEvent);
begin
  FOnNotify := Value;
end;

procedure TFb25Parser.Accept(Visitor: IVisitor);
begin
  Visitor.Visit(Self);
end;

{ **************************************************************************** }

{ TFb25VisitorArguments }

procedure TFb25VisitorArguments.Visit(Instance: IFb25Parser);
var
  ListOfTokens: TList<IFb25Token>;

  Each: IFb25Token;
  ArgLeft: TArray<string>;
  ArgRight: TArray<string>;
begin
  ListOfTokens := Instance.Tokens;

  //  Check whether all arguments match...
  ArgLeft := nil;
  ArgRight := nil;
  for Each in ListOfTokens do
  begin
    if (Each.Token = TFb25TokenKind.fb25Arguments) then
    begin
      if Assigned(ArgLeft) then
      begin
        ArgRight := Each.Value.Split([','], '''');
        if (Assigned(Instance.OnNotify) and (not (High(ArgLeft) = High(ArgRight)))) then
          Instance.OnNotify(Each);

        ArgLeft := nil;
        ArgRight := nil;
      end
      else
        ArgLeft := Each.Value.Split([','], '''');
    end;
  end;
end;

{ **************************************************************************** }

{ TFb25TerminatorCharacters }

procedure TFb25TerminatorCharacters.Visit(Instance: IFb25Parser);
var
  ListOfTokens: TList<IFb25Token>;
  Each: IFb25Token;
begin
  ListOfTokens := Instance.Tokens;

  //  Check whether all lines has a terminator character...
  for Each in ListOfTokens do
    if (Each.Token = TFb25TokenKind.fb25TerminatorCharacter)
    and Assigned(Instance.OnNotify) then
      Instance.OnNotify(Each);
end;

end.
