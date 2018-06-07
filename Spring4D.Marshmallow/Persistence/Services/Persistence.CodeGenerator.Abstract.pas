unit Persistence.CodeGenerator.Abstract;

interface

uses
  System.SysUtils,
  System.Generics.Collections;

{$M+}

type
  ICodeGenerator<T: class> = interface
    ['{6CC6482F-0257-4836-AA18-B07D984301EF}']
    function GetDatabase(): T;
    procedure SetDatabase(value: T);

    function GetTablesWithField(): TDictionary<string, string>;
    procedure SetTablesWithField(value: TDictionary<string, string>);

    procedure Generate();
    procedure SaveTo(AProc: TProc<string>);

    property Database: T read GetDatabase write SetDatabase;
    property TablesWithField: TDictionary<string, string> read GetTablesWithField write SetTablesWithField;
  end;

  TCodeGenerator<T: class> = class(TInterfacedObject, ICodeGenerator<T>)
  strict private
    FDatabase: T;
    FTablesWithField: TDictionary<string, string>;
  private
    function GetDatabase(): T;
    procedure SetDatabase(value: T);

    function GetTablesWithField(): TDictionary<string, string>;
    procedure SetTablesWithField(value: TDictionary<string, string>);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Generate(); virtual;
    procedure SaveTo(AProc: TProc<string>); virtual;

    property Database: T read GetDatabase write SetDatabase;
    property TablesWithField: TDictionary<string, string> read GetTablesWithField write SetTablesWithField;
  end;

{$M-}

implementation

{ TCodeGenerator<T> }

constructor TCodeGenerator<T>.Create;
begin
  inherited;
  FTablesWithField := TDictionary<string, string>.Create;
end;

destructor TCodeGenerator<T>.Destroy;
begin
  FTablesWithField.Clear;
  FTablesWithField.Free;
  inherited;
end;

function TCodeGenerator<T>.GetDatabase: T;
begin
  Result := FDatabase;
end;

function TCodeGenerator<T>.GetTablesWithField: TDictionary<string, string>;
begin
  Result := FTablesWithField;
end;

procedure TCodeGenerator<T>.SetDatabase(value: T);
begin
  FDatabase := Value;
end;

procedure TCodeGenerator<T>.SetTablesWithField(value: TDictionary<string, string>);
begin
  FTablesWithField := value;
end;

procedure TCodeGenerator<T>.Generate;
begin
  if (not Assigned(FDatabase)) then
    raise EArgumentNilException.Create('No Database found!');
end;

procedure TCodeGenerator<T>.SaveTo(AProc: TProc<string>);
var
  Item: TPair<string, string>;
begin
  for Item in FTablesWithField do
    AProc(Item.Value);
end;

end.

