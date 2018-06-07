unit ORM.Model.SALARY_HISTORY;

interface

uses
  Spring.Persistence.Mapping.Attributes;

{$M+}

type
  [Entity]
  [Table('SALARY_HISTORY')]
  TSalaryHistory = class
  private
    FId: Integer;
    FChangeDate: TDateTime;
    FUpdaterId: string;
    FOldSalary: Double;
    FPercentChange: Double;
    FNewSalary: Double;
  public
    [UniqueConstraint]
    [Column('EMP_NO', [cpRequired, cpPrimaryKey, cpNotNull])]
    [ForeignJoinColumn('EMP_NO', 'EMPLOYEE', 'EMP_NO', [fsOnDeleteCascade, fsOnUpdateCascade])]
    property Id: Integer read FId write FId;

    [Column('CHANGE_DATE')]
    property ChangeDate: TDateTime read FChangeDate write FChangeDate;

    [Column('UPDATER_ID', [], 20)]
    property UpdaterId: string read FUpdaterId write FUpdaterId;

    [Column('OLD_SALARY', [], 10, 0, 2)]
    property OldSalary: Double read FOldSalary write FOldSalary;

    [Column('PERCENT_CHANGE')]
    property PercentChange: Double read FPercentChange write FPercentChange;

    [Column('NEW_SALARY')]
    property NewSalary: Double read FNewSalary write FNewSalary;
  end;

{$M-}

implementation

end.
