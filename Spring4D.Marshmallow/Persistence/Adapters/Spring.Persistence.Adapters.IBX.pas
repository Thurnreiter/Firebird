unit Spring.Persistence.Adapters.IBX;

{******************************************************************************}
{                                                                              }
{  Licensed under the Apache License, Version 2.0 (the "License");             }
{  you may not use this file except in compliance with the License.            }
{  You may obtain a copy of the License at                                     }
{                                                                              }
{      http://www.apache.org/licenses/LICENSE-2.0                              }
{                                                                              }
{  Unless required by applicable law or agreed to in writing, software         }
{  distributed under the License is distributed on an "AS IS" BASIS,           }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    }
{  See the License for the specific language governing permissions and         }
{  limitations under the License.                                              }
{                                                                              }
{******************************************************************************}
{                                                                              }
{  Samples:                                                                    }
{  https://bitbucket.org/soundvibe/marshmallow/wiki/Home                       }
{                                                                              }
{  Is Marshmallow and Spring.Persistence.Mapping.RttiExplorer Thread-Safe?     }
{  https://bitbucket.org/sglienke/spring4d/issues/109/is-marshmallow-and       }
{  https://groups.google.com/forum/#!topic/spring4d/DHocqjxty88                }
{  https://groups.google.com/forum/#!searchin/spring4d/ManyToOne|sort:date/spring4d/sNQ8_W2jPgE/vXhNDt1yDAAJ
{  https://groups.google.com/forum/#!searchin/spring4d/ManyToOne%7Csort:date
{  https://github.com/ezequieljuliano/DelphiLaboratory/blob/master/SpringAndDMVC/Client/Core/Template/Crud.Model.pas
{  https://github.com/ezequieljuliano/DelphiLaboratory/blob/master/SpringAndDMVC/Server/Persistence/DAL.Connection.pas

{  https://martinfowler.com/eaaCatalog/optimisticOfflineLock.html
{  https://martinfowler.com/eaaCatalog/pessimisticOfflineLock.html
{                                                                              }
{******************************************************************************}

{$I Spring.inc}

interface

uses
  System.SysUtils,

  IBX.IB,
  IBX.IBDatabase,
  IBX.IBCustomDataSet,

  Spring.Collections,
  Spring.Persistence.Core.Base,
  Spring.Persistence.Core.Exceptions,
  Spring.Persistence.Core.Interfaces,
  //  Spring.Persistence.SQL.Generators.Ansi,
  Spring.Persistence.SQL.Params;

type
  EIBXAdapterException = class(EORMAdapterException);

  /// <summary>
  ///   Represents IBX resultset.
  /// </summary>
  TIBXResultSetAdapter = class(TDriverResultSetAdapter<TIBDataSet>)
  public
    constructor Create(const dataSet: TIBDataSet; const exceptionHandler: IORMExceptionHandler);
  end;

  /// <summary>
  ///   Represents IBX statement.
  /// </summary>
  TIBXStatementAdapter = class(TDriverStatementAdapter<TIBDataSet>)
  public
    destructor Destroy; override;

    procedure SetSQLCommand(const commandText: string); override;
    procedure SetParam(const param: TDBParam);
    procedure SetParams(const params: IEnumerable<TDBParam>); override;
    function Execute: NativeUInt; override;
    function ExecuteQuery(serverSideCursor: Boolean = True): IDBResultSet; override;
  end;

  /// <summary>
  ///   Represents IBX connection.
  /// </summary>
  TIBXConnectionAdapter = class(TDriverConnectionAdapter<TIBDataBase>)
  public
    constructor Create(const connection: TIBDataBase); override;
    destructor Destroy; override;

    procedure AfterConstruction; override;
    procedure Connect; override;
    procedure Disconnect; override;
    function IsConnected: Boolean; override;
    function CreateStatement: IDBStatement; override;
    function BeginTransaction: IDBTransaction; override;
  end;

  /// <summary>
  ///   Represents IBX transaction.
  /// </summary>
  TIBXTransactionAdapter = class(TDriverTransactionAdapter<TIBTransaction>)
  protected
    function InTransaction: Boolean; override;
  public
    constructor Create(const transaction: TIBTransaction; const exceptionHandler: IORMExceptionHandler); override;
    destructor Destroy; override;

    procedure Commit; override;
    procedure Rollback; override;
  end;

  TIBXExceptionHandler = class(TORMExceptionHandler)
  protected
    function GetAdapterException(const exc: Exception; const defaultMsg: string): Exception; override;
  end;

implementation

uses
  Spring.Persistence.Core.ConnectionFactory,
  Spring.Persistence.Core.ResourceStrings,

  //  Spring.Persistence.SQL.Generators.Firebird,
  Spring.Persistence.SQL.Interfaces;

{$REGION 'TIBXResultSetAdapter'}

constructor TIBXResultSetAdapter.Create(const dataSet: TIBDataSet; const exceptionHandler: IORMExceptionHandler);
begin
  //  dataset.OnClose := etmStayIn; // Means, keep transaction without commit or rollback...
  //  Next I have to see if or how this works with IBX.
  inherited Create(dataSet, exceptionHandler);
end;

{$ENDREGION}


{$REGION 'TIBXStatementAdapter'}

destructor TIBXStatementAdapter.Destroy;
begin
  Statement.Free;
  inherited Destroy;
end;

function TIBXStatementAdapter.Execute: NativeUInt;
begin
  inherited;

  try
    Statement.Prepare;
    Statement.ExecSQL;
    Result := Statement.RowsAffected;
//    if Statement.Transaction = Statement.DataBase.Transactions[0] then
//      Statement.Transaction.Commit
//    else
//      Statement.Transaction.CommitRetaining;
  except
    raise HandleException;
  end;
end;

function TIBXStatementAdapter.ExecuteQuery(serverSideCursor: Boolean): IDBResultSet;
var
  Idx: Integer;
  query: TIBDataSet;
  adapter: TIBXResultSetAdapter;
begin
  inherited;

  query := TIBDataSet.Create(nil);
  Query.Database := Statement.DataBase;
  Query.Transaction := Statement.Transaction;
  if not Query.Transaction.InTransaction then
    Query.Transaction.StartTransaction;

  query.DisableControls;
  query.UniDirectional := True;
  query.SelectSQL.Text := Statement.SelectSQL.Text;

  for Idx := 0 to Statement.Params.Count - 1 do
    query.Params[Idx].AsVariant := Statement.Params[Idx].AsVariant;

  try
    query.Open;
    adapter := TIBXResultSetAdapter.Create(query, ExceptionHandler);
    Result := adapter;
  except
    on E: Exception do
    begin
      query.Free;
      raise HandleException(Format(SCannotOpenQuery, [E.Message]));
    end;
  end;
end;

procedure TIBXStatementAdapter.SetSQLCommand(const commandText: string);
begin
  inherited;
  Statement.SelectSQL.Text := commandText;
end;

procedure TIBXStatementAdapter.SetParam(const param: TDBParam);
var
  paramName: string;
begin
  paramName := param.Name;

  // strip leading : in param name because UIB does not like them
  if param.Name.StartsWith(':') then
    paramName := param.Name.Substring(1);

  Statement.ParamByName(paramName).AsVariant := param.ToVariant;
end;

procedure TIBXStatementAdapter.SetParams(const params: IEnumerable<TDBParam>);
begin
  inherited;
  params.ForEach(SetParam);
end;

{$ENDREGION}


{$REGION 'TIBXConnectionAdapter'}

constructor TIBXConnectionAdapter.Create(const connection: TIBDataBase);
var
  transaction: TIBTransaction;
begin
  Create(connection, TIBXExceptionHandler.Create);
  if connection.TransactionCount = 0 then
  begin
    transaction := TIBTransaction.Create(nil);
    transaction.DefaultDatabase := connection;

    //  Add me...
    transaction.DefaultAction := TARollback;
    transaction.Params.Add('concurrency');
    transaction.Params.Add('nowait');
  end;
end;

destructor TIBXConnectionAdapter.Destroy;
begin
  //  if Assigned(Connection) then
  //    for Idx := Connection.TransactionCount - 1 downto 0 do
  //      Connection.Transactions[Idx].Free;

  inherited Destroy;
end;

procedure TIBXConnectionAdapter.AfterConstruction;
begin
  inherited;
  QueryLanguage := qlFirebird;
end;

function TIBXConnectionAdapter.BeginTransaction: IDBTransaction;
var
  transaction: TIBTransaction;
begin
  if Assigned(Connection) then
  try
    Connection.Connected := True;

    transaction := TIBTransaction.Create(nil);
    transaction.DefaultDatabase := Connection;
    transaction.DefaultAction := TARollback;
    transaction.Params.Add('concurrency');
    transaction.Params.Add('nowait');
    transaction.StartTransaction;

    Result := TIBXTransactionAdapter.Create(transaction, ExceptionHandler);
  except
    raise HandleException;
  end
  else
    Result := nil;
end;

procedure TIBXConnectionAdapter.Connect;
begin
  if Assigned(Connection) then
    try
      Connection.Connected := True;
    except
      raise HandleException;
    end;
end;

function TIBXConnectionAdapter.CreateStatement: IDBStatement;
var
  statement: TIBDataSet;
  adapter: TIBXStatementAdapter;
begin
  if Assigned(Connection) then
  begin
    statement := TIBDataSet.Create(nil);
    statement.Database := Connection;
    statement.Transaction := Connection.Transactions[Connection.TransactionCount - 1];
    //    statement.Transaction.StartTransaction();
    adapter := TIBXStatementAdapter.Create(statement, ExceptionHandler);
    adapter.ExecutionListeners := ExecutionListeners;
    Result := adapter;
  end
  else
    Result := nil;
end;

procedure TIBXConnectionAdapter.Disconnect;
begin
  if Assigned(Connection) then
    try
      Connection.Connected := False;
    except
      raise HandleException;
    end;
end;

function TIBXConnectionAdapter.IsConnected: Boolean;
begin
  Result := Assigned(Connection) and Connection.Connected;
end;

{$ENDREGION}


{$REGION 'TIBXTransactionAdapter'}

constructor TIBXTransactionAdapter.Create(const transaction: TIBTransaction; const exceptionHandler: IORMExceptionHandler);
begin
  inherited Create(transaction, exceptionHandler);

  //  fTransaction.DefaultAction := etmRollback;

  //  Add me...
  //  transaction.DefaultDatabase := fDatabase;
  transaction.DefaultAction := TARollback;
  //  transaction.Params.Add('concurrency');
  //  transaction.Params.Add('nowait');

  if not InTransaction then
    try
      fTransaction.StartTransaction;
    except
      raise HandleException;
    end;
end;

destructor TIBXTransactionAdapter.Destroy;
begin
  fTransaction.Free;
  inherited Destroy;
end;

procedure TIBXTransactionAdapter.Commit;
begin
  if Assigned(fTransaction) then
    try
      fTransaction.Commit;
    except
      raise HandleException;
    end;
end;

function TIBXTransactionAdapter.InTransaction: Boolean;
begin
  Result := fTransaction.InTransaction;
end;

procedure TIBXTransactionAdapter.Rollback;
begin
  if Assigned(fTransaction) then
    try
      fTransaction.RollBack;
    except
      raise HandleException;
    end;
end;

{$ENDREGION}


{$REGION 'TIBXExceptionHandler'}

function TIBXExceptionHandler.GetAdapterException(const exc: Exception; const defaultMsg: string): Exception;
begin
  //  if exc is EUIBError then
  //    Result := EIBXAdapterException.Create(defaultMsg, EUIBError(exc).ErrorCode)
  //  else
  //    Result := nil;

  if exc is EIBInterBaseError then
    Result := EIBXAdapterException.Create(defaultMsg, EIBInterBaseError(exc).IBErrorCode)
  else
    Result := nil;
end;

{$ENDREGION}

initialization
  TConnectionFactory.RegisterConnection<TIBXConnectionAdapter>(dtIBX);

end.
