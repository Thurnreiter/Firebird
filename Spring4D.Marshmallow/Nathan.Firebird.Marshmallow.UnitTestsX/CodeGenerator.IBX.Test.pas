unit CodeGenerator.IBX.Test;

interface

uses
  DUnitX.TestFramework,
  Base.Test;

{$M+}

type
  [TestFixture]
  TTestCodeGeneratorIBX = class(TTestBaseORM)
  public
    [Test]
    procedure Test_InterfaceWithIBX();

    [Test]
    procedure Test_StartingIBXImpl();

    [Test]
    procedure Test_StartingIBXImplEx();

    [Test]
    procedure Test_IBXImpl_SaveTo();
  end;

{$M-}

implementation

uses
  System.Classes,
  System.SysUtils,
  IBX.IBDatabase,
  IBX.IBCustomDataSet,
  Persistence.CodeGenerator.Abstract,
  Persistence.CodeGenerator.IBX,
  Spring.Persistence.Mapping.CodeGenerator.Abstract;

procedure TTestCodeGeneratorIBX.Test_InterfaceWithIBX;
var
  Actual: ICodeGenerator<TObject>;
begin
  Actual := TCodeGenerator<TObject>.Create;
  Actual.Database := Database;

  Assert.IsNotNull(Actual);
  Assert.IsNotNull(Actual.TablesWithField);
end;

procedure TTestCodeGeneratorIBX.Test_StartingIBXImpl;
var
  Actual: ICodeGenerator<TIBDataBase>;
  Code: string;
begin
  Actual := TCodeGeneratorIBX.Create();
  Actual.Database := Database;

  Actual.Generate;

  Assert.IsNotNull(Actual);
  Assert.IsNotNull(Actual.TablesWithField);
  Assert.AreEqual(10, Actual.TablesWithField.Count);

  Code := Actual.TablesWithField.Items['CUSTOMER'];
  Assert.IsTrue(Code.Length > 0);
  Assert.IsTrue(Code.Contains('[Table(''CUSTOMER'', '''')]'));
  Assert.IsTrue(Code.Contains('TCUSTOMER = class'));
  Assert.IsTrue(Code.Contains('FCUST_NO: INTEGER;'));
  Assert.IsTrue(Code.Contains('[AutoGenerated]'));
  Assert.IsTrue(Code.Contains('[Column(''CUST_NO'',[cpRequired,cpPrimaryKey,cpNotNull])]'));
  Assert.IsTrue(Code.Contains('property CUST_NO: INTEGER read FCUST_NO write FCUST_NO;'));
  Assert.IsTrue(Code.Contains('[Column(''CONTACT_FIRST'',[],15)]'));
  Assert.IsTrue(Code.Contains('property CONTACT_FIRST: VARCHAR read FCONTACT_FIRST write FCONTACT_FIRST;'));
end;

procedure TTestCodeGeneratorIBX.Test_StartingIBXImplEx;
var
  Actual: ICodeGenerator<TIBDataBase>;
begin
  Actual := TCodeGeneratorIBX.Create();
  Assert.WillRaise(
    procedure
    begin
      Actual.Generate;
    end,
    EArgumentNilException);
end;

procedure TTestCodeGeneratorIBX.Test_IBXImpl_SaveTo;
var
  Actual: ICodeGenerator<TIBDataBase>;
begin
  Actual := TCodeGeneratorIBX.Create();
  Actual.Database := Database;
  Actual.Generate;
  Actual.SaveTo(
    procedure(x: string)
    begin
      Assert.IsTrue(x.Contains('[Column('''), x);
      Assert.IsTrue(x.Contains('property '), x);
    end);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestCodeGeneratorIBX);

end.
