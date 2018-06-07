unit Spring.Persistence.Adapters.IBX.Test;

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

  DUnitX.TestFramework,
  Base.Test,

  ORM.Model.EMPLOYEE,
  ORM.Model.COUNTRY,
  ORM.Model.SALARY_HISTORY;

{$M+}

type
  [TestFixture]
  TTestIBXAdapter = class(TTestBaseORM)
  public
    [Test]
    procedure Test_ExecuteScalar();

    [Test]
    procedure Test_ExecuteScalar_TwoTimes();

    [Test]
    procedure Test_ExecuteScalar_WithParams();

    [Test]
    [TestCase('TestFindOne1', '72,Claudia,Sutherland')]
    [TestCase('TestFindOne2', '141,Pierre,Osborne')]
    procedure Test_FindOne_TEmployee(AId: Integer; const AFName, ALName: string);

    [Test]
    procedure Test_FindAll_TEmployee();

    [Test]
    procedure Test_Execute_TCountry();

    [Test]
    procedure Test_InsertsUpdatesAndDeletes_TEmployee();

    [Test]
    procedure Test_CriteriaAPI_LooksLikeLinq_TEmployee();

    [Test]
    procedure Test_FindOne_TCountry();

    [Test]
    procedure Test_FindOne_TSalaryHistory();

    [Test]
    procedure Test_FindOne_TEmployee_TSalaryHistory();

    [Test]
    procedure Test_FindOne_TSalaryHistoryFull();
  end;

{$M-}

implementation

uses
  System.SysUtils;

procedure TTestIBXAdapter.Test_ExecuteScalar;
var
  Actual: Integer;
begin
  Actual := Session.ExecuteScalar<Integer>('SELECT COUNT(*) FROM CUSTOMER', []);
  Assert.AreEqual(15, Actual);
end;

procedure TTestIBXAdapter.Test_ExecuteScalar_TwoTimes;
var
  Actual: Integer;
begin
  Actual := Session.ExecuteScalar<Integer>('SELECT COUNT(*) FROM CUSTOMER', []);
  Assert.AreEqual(15, Actual);

  Actual := Session.ExecuteScalar<Integer>('SELECT COUNT(*) FROM COUNTRY', []);
  Assert.AreEqual(14, Actual);
end;

procedure TTestIBXAdapter.Test_ExecuteScalar_WithParams;
var
  ActualStr: string;
  ActualInt: Integer;
begin
  ActualStr := Session.ExecuteScalar<string>('SELECT CONTACT_FIRST FROM CUSTOMER WHERE CUST_NO = :0;', [1010]);
  Assert.AreEqual('Miwako', ActualStr);

  ActualInt := Session.ExecuteScalar<Integer>('SELECT COUNT(*) FROM CUSTOMER WHERE CUST_NO = :0;', [1012]);
  Assert.AreEqual(1, ActualInt);

  ActualInt := Session.ExecuteScalar<Integer>('SELECT COUNT(*) FROM COUNTRY WHERE COUNTRY LIKE :0;', ['Switzerland']);
  Assert.AreEqual(1, ActualInt);
end;

procedure TTestIBXAdapter.Test_FindOne_TEmployee(AId: Integer; const AFName, ALName: string);
var
  Actual: TEmployee;
begin
  Actual := Session.FindOne<TEmployee>(AId);
  try
    Assert.IsNotNull(Actual);
    Assert.AreEqual(AID, Actual.Id);
    Assert.AreEqual(AFName, Actual.Firstname);
    Assert.AreEqual(ALName, Actual.Lastname);
  finally
    FreeAndNil(Actual);
  end;
end;

procedure TTestIBXAdapter.Test_FindAll_TEmployee;
var
  Actual: IList<TEmployee>;
begin
  Actual := Session.FindAll<TEmployee>;
  Assert.AreEqual(42, Actual.Count);

  Assert.AreEqual(2, Actual[0].Id);
  Assert.AreEqual('Robert', Actual[0].Firstname);
  Assert.AreEqual('Nelson', Actual[0].Lastname);
  Assert.AreEqual('600', Actual[0].DepartmentId);

  Assert.AreEqual(4, Actual[1].Id);
  Assert.AreEqual('Bruce', Actual[1].Firstname);
  Assert.AreEqual('Young', Actual[1].Lastname);
  Assert.AreEqual('621', Actual[1].DepartmentId);
end;

procedure TTestIBXAdapter.Test_Execute_TCountry;
const
  InsertMcd = 'INSERT INTO COUNTRY (COUNTRY, CURRENCY) VALUES (''EURO'', ''EUR'');';
var
  Actual: NativeUInt;
begin
  Actual := Session.Execute(InsertMcd, []);
  Assert.AreEqual(1, Actual);

  Actual := Session.ExecuteScalar<Integer>('SELECT COUNT(*) FROM COUNTRY', []);
  Assert.AreEqual(15, Actual);
end;

procedure TTestIBXAdapter.Test_InsertsUpdatesAndDeletes_TEmployee;
var
  Actual: TEmployee;
begin
  Connection.AddExecutionListener(
    procedure(const command: string; const params: IEnumerable<TDBParam>)
    begin
      Assert.AreNotEqual('', command);
    end);

  Actual := TEmployee.Create;
  try
    Actual.Firstname := 'Nathan';
    Actual.Lastname := 'Thurnreiter';
    Actual.PhoneExt := '221';
    Actual.HireDate := Now();
    Actual.DepartmentId := '622';
    Actual.JobCode := 'Eng';
    Actual.JobGrande := 5;
    Actual.JobCountry := 'USA';
    Actual.Salary := 32000;

    //  most of the time you should use save, which will automatically insert or update your PODO based on it's state...
    Session.Save(Actual);

    //  explicitly inserts customer into the database...
    //  don't call again, after save...
    //  Session.Insert(Actual);

    Actual.JobCode := 'CEO';

    //  explicitly updates customer's name in the database...
    Session.Update(Actual);

    //  deletes customer from the database...
    Session.Delete(Actual);
  finally
    FreeAndNil(Actual);
  end;

  Actual := Session.FindOne<TEmployee>(146);
  Assert.IsNull(Actual);
end;

procedure TTestIBXAdapter.Test_CriteriaAPI_LooksLikeLinq_TEmployee;
var
  Actual: IList<TEmployee>;
  Linq: ICriteria<TEmployee>;
begin
  Linq := Session.CreateCriteria<TEmployee>;
  Actual := Linq.Add(
    Restrictions.Eq('JOB_CODE', 'Eng')
    ).ToList;
  Assert.AreEqual(15, Actual.Count);
end;

procedure TTestIBXAdapter.Test_FindOne_TCountry;
var
  Actual: TCountry;
begin
  //  Actual := Session.SingleOrDefault<TArbeit>('SELECT * FROM ARBEIT WHERE ARB_FNR=:0', [365]);
  Actual := Session.FindOne<TCountry>('Switzerland');
  try
    Assert.IsNotNull(Actual);
    Assert.AreEqual('Switzerland', Actual.Country);
    Assert.AreEqual('SFranc', Actual.Currency);
  finally
    Actual.Free;
  end;
end;

procedure TTestIBXAdapter.Test_FindOne_TSalaryHistory;
var
  Actual: TSalaryHistory;
begin
  Actual := Session.FindOne<TSalaryHistory>(105);
  try
    Assert.IsNotNull(Actual);
    Assert.AreEqual(105, Actual.Id);
    Assert.AreEqual(220000, Actual.OldSalary, 1);
    Assert.AreEqual(-3.25, Actual.PercentChange, 1);
    Assert.AreEqual(212850, Actual.NewSalary, 1);
  finally
    Actual.Free;
  end;
end;

procedure TTestIBXAdapter.Test_FindOne_TEmployee_TSalaryHistory;
var
  Actual: TEmployee;
begin
  Actual := Session.FindOne<TEmployee>(105);
  try
    Assert.IsNotNull(Actual);
    Assert.AreEqual(105, Actual.Id);
    Assert.AreEqual('Oliver H.', Actual.Firstname);
    Assert.AreEqual('Bender', Actual.Lastname);

    Assert.AreEqual(1, Actual.SalaryHistory.Count);
    Assert.AreEqual(220000, Actual.SalaryHistory[0].OldSalary, 1);
  finally
    Actual.Free;
  end;
end;

procedure TTestIBXAdapter.Test_FindOne_TSalaryHistoryFull;
var
  Actual: TSalaryHistory;
begin
  Actual := Session.FindOne<TSalaryHistory>(121);
  try
    Assert.IsNotNull(Actual);
    Assert.AreEqual(121, Actual.ID);
    Assert.AreEqual('20.12.1993', DateToStr(Actual.ChangeDate));
    Assert.AreEqual('elaine', Actual.UpdaterId);
    Assert.AreEqual(90000000, Actual.OldSalary, 1);
    Assert.AreEqual(10, Actual.PercentChange, 1);
    Assert.AreEqual(99000000, Actual.NewSalary, 1);
  finally
    Actual.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestIBXAdapter);

end.
