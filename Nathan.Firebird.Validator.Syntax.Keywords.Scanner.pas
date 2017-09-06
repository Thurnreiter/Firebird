unit Nathan.Firebird.Validator.Syntax.Keywords.Scanner;

interface

uses
  System.Generics.Collections, //  System.Generics.Defaults,
  Nathan.Firebird.Validator.Syntax.Keywords.Intf,
  Nathan.Firebird.Validator.Syntax.Keywords.Types;

{$M+}

type
  TFb25Scanner = class(TInterfacedObject, IFb25Scanner)
  strict private
    FScanning: string;
    FList: TList<IFb25Token>;
    FCursor: Cardinal;
  private
    function GetStatement(): string;
    procedure SetStatement(const Value: string);

    function GetTokens(): TList<IFb25Token>;

    procedure ScanTokens();

    function IsTerminatorCharacter(const Identifier: string): Boolean;
    function HasOpenBracket(): Boolean;
    function HasWhitespacesWithoutOpenBracket(): Boolean;
    function SearchingKeywords(const Keyword: string; const List: TArray<String>): Boolean;
		function GetIdentifierToken(const Identifier: string): IFb25Token;
  public
    constructor Create();
    destructor Destroy(); override;

    function Execute(): IFb25Scanner;
  end;

{$M-}

implementation

uses
  System.SysUtils,
  Nathan.Firebird.Validator.Syntax.Keywords.Token;

{ **************************************************************************** }

{ TFb25Scanner }

constructor TFb25Scanner.Create;
begin
  inherited;
  FList := TList<IFb25Token>.Create;
end;

destructor TFb25Scanner.Destroy();
begin
  FList.Free;
  inherited;
end;

function TFb25Scanner.GetStatement(): string;
begin
  Result := FScanning;
end;

function TFb25Scanner.GetTokens(): TList<IFb25Token>;
begin
  Result := FList;
end;

procedure TFb25Scanner.SetStatement(const Value: string);
begin
  FScanning := Value;
end;

function TFb25Scanner.IsTerminatorCharacter(const Identifier: string): Boolean;
var
  Idx: Integer;
begin
  for Idx := Low(Firebird25DDLTerminatorCharacter) to High(Firebird25DDLTerminatorCharacter) do
    if Identifier.ToLower.Contains(Firebird25DDLTerminatorCharacter[Idx].ToLower) then
      Exit(True);

  Result := False;
end;

function TFb25Scanner.HasOpenBracket(): Boolean;
var
  Idx: Integer;
begin
  if (not Assigned(FList)) then
    Exit(False);

  Result := False;
  Idx := FList.Count;
  while Idx > 0 do
  begin
    if FList[Idx - 1].Token in [fb25BracketClose] then
      Exit(False);

    if FList[Idx - 1].Token in [fb25BracketOpen] then
      Exit(True);

    Dec(Idx);
  end;
end;

function TFb25Scanner.HasWhitespacesWithoutOpenBracket(): Boolean;
begin
  Result := CharInSet(FScanning[FCursor], [' ', #13, #10, #9]);
  if Result then
    Result := (not HasOpenBracket());
end;

function TFb25Scanner.SearchingKeywords(const Keyword: string; const List: TArray<String>): Boolean;
var
  Idx: Cardinal;
begin
  for Idx := Low(List) to High(List) do
    if Keyword.ToLower.StartsWith(List[Idx].ToLower) then
      Exit(True);

  Result := False;
end;

function TFb25Scanner.GetIdentifierToken(const Identifier: string): IFb25Token;
begin
  if String.IsNullOrWhiteSpace(Identifier) or Identifier.IsEmpty then
    Exit(TFb25Token.Create(Identifier, fb25None));

  //  Has any terminator character?
  if IsTerminatorCharacter(Identifier) then
    Exit(TFb25Token.Create(Identifier, fb25TerminatorCharacter));

  //  Normal or beginning operator...
  if SearchingKeywords(Identifier, Firebird25DDLBeginning) then
    Exit(TFb25Token.Create(Identifier, fb25Starter));

  //  All other keywords...
  if SearchingKeywords(Identifier, Firebird25Keywords) then
    Exit(TFb25Token.Create(Identifier, fb25Operator));

  //  All other reserved keywords...
  if SearchingKeywords(Identifier, Firebird25ReservedWords) then
    Exit(TFb25Token.Create(Identifier, fb25Operator));

  if HasOpenBracket() then
    Result := TFb25Token.Create(Identifier, fb25Arguments)
  else
    Result := TFb25Token.Create(Identifier, fb25Variable);
end;

procedure TFb25Scanner.ScanTokens();
var
  TokenString: string;
  Joiner: TProc<IFb25Token>;
begin
  Joiner :=
    procedure(AToken: IFb25Token)
    begin
      if (AToken.Token <> fb25None) then
        FList.Add(AToken);
    end;

  TokenString := '';
  while (FCursor <= FScanning.Length) do
  begin
    if HasWhitespacesWithoutOpenBracket() then
    begin
      Joiner(GetIdentifierToken(TokenString));
      TokenString := '';

      Joiner(TFb25Token.Create(FScanning[FCursor], fb25Whitespaces));
      Inc(FCursor);
      Continue;
    end;

    if CharInSet(FScanning[FCursor], ['(', '[', '{']) then
    begin
      Joiner(GetIdentifierToken(TokenString));
      TokenString := '';

      Joiner(TFb25Token.Create(FScanning[FCursor], fb25BracketOpen));
      Inc(FCursor);
    end;

    if CharInSet(FScanning[FCursor], [')', ']', '}']) then
    begin
      Joiner(GetIdentifierToken(TokenString));

      Joiner(TFb25Token.Create(FScanning[FCursor], fb25BracketClose));

      Inc(FCursor);
      TokenString := FScanning[FCursor];
      Continue;
    end;

    if IsTerminatorCharacter(FScanning[FCursor]) then
    begin
      if (not (TokenString = FScanning[FCursor])) then
      begin
        Joiner(GetIdentifierToken(TokenString));
        TokenString := '';
      end;

      Joiner(TFb25Token.Create(FScanning[FCursor], fb25TerminatorCharacter));

      Inc(FCursor);
      TokenString := FScanning[FCursor];
      Continue;
    end;

//    if CharInSet(FScanning[FCursor], ['"']) then
//    begin
//      Joiner(TFb25Token.Create(FScanning[FCursor], fb25Apostrophe));
//      Inc(FCursor);
//      Continue;
//    end;

    TokenString := TokenString + FScanning[FCursor];
    Inc(FCursor);
  end;

  if (not TokenString.Trim.IsEmpty) then
    Joiner(GetIdentifierToken(TokenString));
end;

function TFb25Scanner.Execute(): IFb25Scanner;
begin
  if FScanning.IsEmpty then
    Exit;

  FCursor := 1;
  ScanTokens();
  Result := Self;
end;

end.

