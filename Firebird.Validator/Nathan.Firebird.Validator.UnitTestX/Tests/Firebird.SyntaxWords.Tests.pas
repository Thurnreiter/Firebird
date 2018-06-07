unit Firebird.SyntaxWords.Tests;

interface

{$M+}

uses
  DUnitX.TestFramework;

const
  {$REGION 'Firebird 2.5 Keywords'}
  Firebird25Keywords: TArray<String> = [
    '!<',
    '^<',
    '^=',
    '^>',
    ',',
    ':=',
    '!=',
    '!>',
    '(',
    ')',
    '<',
    '<=',
    '<>',
    '=',
    '>',
    '>=',
    '||',
    '~<',
    '~=',
    '~>',
    'ABS',
    'ACCENT',
    'ACOS',
    'ACTION',
    'ACTIVE',
    'ADD',
    'ADMIN',
    'AFTER',
    'ALL',
    'ALTER',
    'ALWAYS',
    'AND',
    'ANY',
    'AS',
    'ASC',
    'ASCENDING',
    'ASCII_CHAR',
    'ASCII_VAL',
    'ASIN',
    'AT',
    'ATAN',
    'ATAN2',
    'AUTO',
    'AUTONOMOUS',
    'AVG',
    'BACKUP',
    'BEFORE',
    'BEGIN',
    'BETWEEN',
    'BIGINT',
    'BIN_AND',
    'BIN_NOT',
    'BIN_OR',
    'BIN_SHL',
    'BIN_SHR',
    'BIN_XOR',
    'BIT_LENGTH',
    'BLOB',
    'BLOCK',
    'BOTH',
    'BREAK',
    'BY',
    'CALLER',
    'CASCADE',
    'CASE',
    'CAST',
    'CEIL',
    'CEILING',
    'CHAR',
    'CHAR_LENGTH',
    'CHAR_TO_UUID',
    'CHARACTER',
    'CHARACTER_LENGTH',
    'CHECK',
    'CLOSE',
    'COALESCE',
    'COLLATE',
    'COLLATION',
    'COLUMN',
    'COMMENT',
    'COMMIT',
    'COMMITTED',
    'COMMON',
    'COMPUTED',
    'CONDITIONAL',
    'CONNECT',
    'CONSTRAINT',
    'CONTAINING',
    'COS',
    'COSH',
    'COT',
    'COUNT',
    'CREATE',
    'CROSS',
    'CSTRING',
    'CURRENT',
    'CURRENT_CONNECTION',
    'CURRENT_DATE',
    'CURRENT_ROLE',
    'CURRENT_TIME',
    'CURRENT_TIMESTAMP',
    'CURRENT_TRANSACTION',
    'CURRENT_USER',
    'CURSOR',
    'DATA',
    'DATABASE',
    'DATE',
    'DATEADD',
    'DATEDIFF',
    'DAY',
    'DEC',
    'DECIMAL',
    'DECLARE',
    'DECODE',
    'DEFAULT',
    'DELETE',
    'DELETING',
    'DESC',
    'DESCENDING',
    'DESCRIPTOR',
    'DIFFERENCE',
    'DISCONNECT',
    'DISTINCT',
    'DO',
    'DOMAIN',
    'DOUBLE',
    'DROP',
    'ELSE',
    'END',
    'ENTRY_POINT',
    'ESCAPE',
    'EXCEPTION',
    'EXECUTE',
    'EXISTS',
    'EXIT',
    'EXP',
    'EXTERNAL',
    'EXTRACT',
    'FETCH',
    'FILE',
    'FILTER',
    'FIRST',
    'FIRSTNAME',
    'FLOAT',
    'FLOOR',
    'FOR',
    'FOREIGN',
    'FREE_IT',
    'FROM',
    'FULL',
    'FUNCTION',
    'GDSCODE',
    'GEN_ID',
    'GEN_UUID',
    'GENERATED',
    'GENERATOR',
    'GLOBAL',
    'GRANT',
    'GRANTED',
    'GROUP',
    'HASH',
    'HAVING',
    'HOUR',
    'IF',
    'IGNORE',
    'IIF',
    'IN',
    'INACTIVE',
    'INDEX',
    'INNER',
    'INPUT_TYPE',
    'INSENSITIVE',
    'INSERT',
    'INSERTING',
    'INT',
    'INTEGER',
    'INTO',
    'IS',
    'ISOLATION',
    'JOIN',
    'KEY',
    'LAST',
    'LASTNAME',
    'LEADING',
    'LEAVE',
    'LEFT',
    'LENGTH',
    'LEVEL',
    'LIKE',
    'LIMBO',
    'LIST',
    'LN',
    'LOCK',
    'LOG',
    'LOG10',
    'LONG',
    'LOWER',
    'LPAD',
    'MANUAL',
    'MAPPING',
    'MATCHED',
    'MATCHING',
    'MAX',
    'MAXIMUM_SEGMENT',
    'MAXVALUE',
    'MERGE',
    'MIDDLENAME',
    'MILLISECOND',
    'MIN',
    'MINUTE',
    'MINVALUE',
    'MOD',
    'MODULE_NAME',
    'MONTH',
    'NAMES',
    'NATIONAL',
    'NATURAL',
    'NCHAR',
    'NEXT',
    'NO',
    'NOT',
    'NULL',
    'NULLIF',
    'NULLS',
    'NUMERIC',
    'OCTET_LENGTH',
    'OF',
    'ON',
    'ONLY',
    'OPEN',
    'OPTION',
    'OR',
    'ORDER',
    'OS_NAME',
    'OUTER',
    'OUTPUT_TYPE',
    'OVERFLOW',
    'OVERLAY',
    'PAD',
    'PAGE',
    'PAGE_SIZE',
    'PAGES',
    'PARAMETER',
    'PASSWORD',
    'PI',
    'PLACING',
    'PLAN',
    'POSITION',
    'POST_EVENT',
    'POWER',
    'PRECISION',
    'PRESERVE',
    'PRIMARY',
    'PRIVILEGES',
    'PROCEDURE',
    'PROTECTED',
    'RAND',
    'RDB$DB_KEY',
    'READ',
    'REAL',
    'RECORD_VERSION',
    'RECREATE',
    'RECURSIVE',
    'REFERENCES',
    'RELEASE',
    'REPLACE',
    'REQUESTS',
    'RESERV',
    'RESERVING',
    'RESTART',
    'RESTRICT',
    'RETAIN',
    'RETURNING',
    'RETURNING_VALUES',
    'RETURNS',
    'REVERSE',
    'REVOKE',
    'RIGHT',
    'ROLE',
    'ROLLBACK',
    'ROUND',
    'ROW_COUNT',
    'ROWS',
    'RPAD',
    'SAVEPOINT',
    'SCALAR_ARRAY',
    'SCHEMA',
    'SECOND',
    'SEGMENT',
    'SELECT',
    'SENSITIVE',
    'SEQUENCE',
    'SET',
    'SHADOW',
    'SHARED',
    'SIGN',
    'SIMILAR',
    'SIN',
    'SINGULAR',
    'SINH',
    'SIZE',
    'SKIP',
    'SMALLINT',
    'SNAPSHOT',
    'SOME',
    'SORT',
    'SOURCE',
    'SPACE',
    'SQLCODE',
    'SQLSTATE (2.5.1)',
    'SQRT',
    'STABILITY',
    'START',
    'STARTING',
    'STARTS',
    'STATEMENT',
    'STATISTICS',
    'SUB_TYPE',
    'SUBSTRING',
    'SUM',
    'SUSPEND',
    'TABLE',
    'TAN',
    'TANH',
    'TEMPORARY',
    'THEN',
    'TIME',
    'TIMEOUT',
    'TIMESTAMP',
    'TO',
    'TRAILING',
    'TRANSACTION',
    'TRIGGER',
    'TRIM',
    'TRUNC',
    'TWO_PHASE',
    'TYPE',
    'UNCOMMITTED',
    'UNDO',
    'UNION',
    'UNIQUE',
    'UPDATE',
    'UPDATING',
    'UPPER',
    'USER',
    'USING',
    'UUID_TO_CHAR',
    'VALUE',
    'VALUES',
    'VARCHAR',
    'VARIABLE',
    'VARYING',
    'VIEW',
    'WAIT',
    'WEEK',
    'WEEKDAY',
    'WHEN',
    'WHERE',
    'WHILE',
    'WITH',
    'WORK',
    'WRITE',
    'YEAR',
    'YEARDAY'];
  {$ENDREGION}


type
  /// <summary>
  ///   https://firebirdsql.org/refdocs/langrefupd25-reskeywords-full-keywords.html
  /// </summary>
  TFirebird25Syntax = record
    class function CompareArraysAreTheSame(left, right: TArray<string>): Boolean; static;

    function Find(const value:string): Boolean;

    function IsOperator(const input: string): Boolean;

    procedure Execute();
  end;



  [TestFixture]
  TTestFirebird25Syntax = class
  public
    [Setup]
    procedure SetUp();

    [TearDown]
    procedure TearDown();
  published
    [Test]
    procedure Test_WordsCompare();

    [Test]
    procedure Test_IsOperator();

    [Test]
    [TestCase('Testcase1', 'EXTERNAL,True')]
    [TestCase('Testcase2', 'DECLARE,True')]
    [TestCase('Testcase3', 'Nathan,False')]
    procedure Test_Find(const Value: string; Expected: Boolean);
  end;

{$M-}

implementation

uses
  System.SysUtils,
//  ONPParser,
  System.Generics.Collections,  // Must appear after Classes, so that it can use the correct TCollectionNotification.
  System.Generics.Defaults;

{ TFirebird25Syntax }

class function TFirebird25Syntax.CompareArraysAreTheSame(left, right: TArray<string>): Boolean;
var
  Comparer: IComparer<TArray<string>>;
begin
  //  TArray.Sort<String>(Arr, TStringComparer.Ordinal);
  Comparer := TComparer<TArray<string>>.Default;
  Result := Comparer.Compare(left, right) = 0;
end;

procedure TFirebird25Syntax.Execute();
begin
//      for I := 0 to length(keyArray)-1 do
//        FCboAdjustmentReason.Properties.Items.AddObject(Referenzen[keyArray[I]].Code + ' ('+ Referenzen[keyArray[I]].CodeDescription+')', Referenzen[keyArray[I]].CopyToObject);
//      FCboAdjustmentReason.ItemIndex := 0;

//  TArray.Sort<TArray<string>>(Firebird25Keywords, TStringComparer.Ordinal.);
//  Firebird25Keywords.
end;

function TFirebird25Syntax.Find(const value: string): Boolean;
var
//  KeyArray: TArray<String>;
  FoundIndex: Integer;
begin
  //  KeyArray := Firebird25Keywords;
  //  TArray.Sort<String>(KeyArray);
  //  Result := TArray.BinarySearch<String>(KeyArray, Value, FoundIndex, TStringComparer.Ordinal);
  Result := TArray.BinarySearch<String>(Firebird25Keywords, Value, FoundIndex, TStringComparer.Ordinal);
end;

function TFirebird25Syntax.IsOperator(const input: string): Boolean;
const
  Ops: TArray<String> = ['-', '+', '*', '/'];
var
  Each: string;
begin
  for Each in Ops do
    if Each.Contains(input) then
      Exit(True);

  Result := False;
end;

{ TTestFirebird25Syntax }

procedure TTestFirebird25Syntax.SetUp();
begin
  //...
end;

procedure TTestFirebird25Syntax.TearDown();
begin
  //...
end;

procedure TTestFirebird25Syntax.Test_Find(const Value: string; Expected: Boolean);
var
  Cut: TFirebird25Syntax;
begin
  Assert.AreEqual(Expected, Cut.Find(Value));
end;

procedure TTestFirebird25Syntax.Test_IsOperator;
var
  Cut: TFirebird25Syntax;
begin
  Assert.IsTrue(Cut.IsOperator('-'));
  Assert.IsTrue(Cut.IsOperator('+'));
  Assert.IsTrue(Cut.IsOperator('*'));
  Assert.IsTrue(Cut.IsOperator('/'));

  Assert.IsFalse(Cut.IsOperator(' '));
  Assert.IsFalse(Cut.IsOperator('A'));
  Assert.IsFalse(Cut.IsOperator(''));
end;

procedure TTestFirebird25Syntax.Test_WordsCompare();
var
  Actual: Boolean;
begin
  //  Arrange...

  //  Act...
  Actual := TFirebird25Syntax.CompareArraysAreTheSame(Firebird25Keywords, Firebird25Keywords);

  //  Assert...
  Assert.IsTrue(Actual);
end;

initialization
  {$IFDEF VER320}TDUnitX.RegisterTestFixture(TTestFirebird25Syntax, 'Words');{$ENDIF}

end.
