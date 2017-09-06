unit Nathan.Firebird.Validator.Syntax.Keywords.Intf;

interface

uses
  System.Generics.Collections,
  Nathan.Firebird.Validator.Syntax.Keywords.Types;

{$M+}

type
  {$REGION 'IFb25Token'}
  IFb25Token = interface
    ['{49F44C5D-CE08-4C77-B33E-6DC1238A9A9F}']
    function GetToken(): TFb25TokenKind;
    function GetValue(): string;

    property Token: TFb25TokenKind read GetToken;
    property Value: string read GetValue;
  end;
  {$ENDREGION}

  {$REGION 'IFb25Scanner'}
  IFb25Scanner = interface
    ['{5D5B1813-B45D-4B04-99CB-2866DDA21049}']
    function GetStatement(): string;
    procedure SetStatement(const Value: string);

    function GetTokens(): TList<IFb25Token>;

    function Execute(): IFb25Scanner;

    property Statement: string read GetStatement write SetStatement;
    property Tokens: TList<IFb25Token> read GetTokens;
  end;
  {$ENDREGION}

  {$REGION 'IFb25Parser'}
  IFb25Parser = interface
    ['{09CA22CD-0900-4D58-8DC5-D567073C5C07}']
    function GetTokens(): TList<IFb25Token>;
    procedure SetTokens(Value: TList<IFb25Token>);

    function PredictiveAnalytics(): Boolean;

    property Tokens: TList<IFb25Token> read GetTokens write SetTokens;
  end;
  {$ENDREGION}

{$M+}

implementation

end.
