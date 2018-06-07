unit ORM.Model.COUNTRY;

interface

uses
  Spring.Persistence.Mapping.Attributes;

{$M+}

type
  [Entity]
  [Table('COUNTRY')]
  TCountry = class
  private
    FCountry: string;
    FCurrency: string;
  public
    [UniqueConstraint]
    [Column('COUNTRY', [cpRequired, cpPrimaryKey, cpNotNull], 15)]
    property Country: string read FCountry write FCountry;

    [Column('CURRENCY', [], 10)]
    property Currency: string read FCurrency write FCurrency;
  end;

{$M-}

implementation

end.
