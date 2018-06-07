unit Base.Test;

interface

uses
  IBX.IBDatabase,
  Spring.Persistence.Core.ConnectionFactory,
  Spring.Persistence.Core.Interfaces,
  Spring.Persistence.Core.Session,
  Spring.Persistence.Adapters.IBX,
  Spring.Collections,
  Spring.Persistence.SQL.Params,
  Spring.Persistence.Criteria.Interfaces,
  Spring.Persistence.Criteria.Restrictions,
  DUnitX.TestFramework;

{$M+}

type
  [TestFixture]
  TTestBaseORM = class(TObject)
  strict private
    FDatabase: TIBDataBase;
    FConnection: IDBConnection;
    FSession: TSession;
  private const LocalDbName = '.\dummy.fdb';
  private
    procedure CleanDB();
  public
    property Database: TIBDataBase read FDatabase write FDatabase;
    property Connection: IDBConnection read FConnection write FConnection;
    property Session: TSession read FSession write FSession;
  public
    [SetupFixture]
    procedure SetupFixture;

    [TearDownFixture]
    procedure TearDownFixture;

    [Setup]
    procedure Setup;

    [TearDown]
    procedure TearDown;
  end;

{$M-}

implementation

uses
  System.SysUtils,
  System.IOUtils,
  Nathan.Resources.ResourceManager;

procedure TTestBaseORM.SetupFixture;
begin
  CleanDB();
  ResourceManager.SaveToFile('Resource_demo', LocalDbName);
end;

procedure TTestBaseORM.TearDownFixture;
begin
  CleanDB();
end;

procedure TTestBaseORM.Setup;
begin
  //  Create Database and Transaction for Firebird...
  FDatabase := TIBDataBase.Create(nil);
  FDatabase.DatabaseName := LocalDbName;
  FDatabase.Params.Add('user_name=Sysdba');
  FDatabase.Params.Add('password=masterkey');
  FDatabase.Params.Add('lc_ctype=WIN1252');
  FDatabase.LoginPrompt := False;
  //  FDatabase.Connected

  //  Then we need to create our IDBConnection and TSession instances...
  FConnection := TConnectionFactory.GetInstance(dtIBX, FDatabase);

  //  Another option are to create manually...
  //  FConnection := TIBXConnectionAdapter.Create(FDatabase);

  FConnection.AutoFreeConnection := True;
  FConnection.Connect;

  //  TSession is our main work class...
  FSession := TSession.Create(FConnection);
end;

procedure TTestBaseORM.TearDown;
begin
  FSession.Free;
  FConnection := nil;
end;

procedure TTestBaseORM.CleanDB();
begin
  if TFile.Exists(LocalDbName) then
    TFile.Delete(LocalDbName);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestBaseORM);

end.
