unit GenRowsProc;

{$IFDEF FPC}
{$MODE DELPHI}{$H+}
{$ENDIF}

interface

uses
  Firebird, SysUtils;

type
  { **********************************************************

    create procedure gen_rows (
      start  integer,
      finish integer
    ) returns (n integer)
    external name 'myudr!gen_rows'
    engine udr;

    ********************************************************* }

  TInput = record
    start: Integer;
    startNull: WordBool;
    finish: Integer;
    finishNull: WordBool;
  end;
  PInput = ^TInput;

  TOutput = record
    n: Integer;
    nNull: WordBool;
  end;
  POutput = ^TOutput;

  // ������� ��� �������� ���������� ������� ��������� TGenRowsProcedure
  TGenRowsFactory = class(IUdrProcedureFactoryImpl)
    // ���������� ��� ����������� �������
    procedure dispose(); override;

    { ����������� ������ ��� ��� �������� ������� ������� � ��� ����������

      @param(AStatus ������ ������)
      @param(AContext �������� ���������� ������� �������)
      @param(AMetadata ���������� ������� �������)
      @param(AInBuilder ����������� ��������� ��� ������� ����������)
      @param(AOutBuilder ����������� ��������� ��� �������� ����������)
    }
    procedure setup(AStatus: IStatus; AContext: IExternalContext;
      AMetadata: IRoutineMetadata; AInBuilder: IMetadataBuilder;
      AOutBuilder: IMetadataBuilder); override;

    { �������� ������ ���������� ������� ��������� TGenRowsProcedure

      @param(AStatus ������ ������)
      @param(AContext �������� ���������� ������� �������)
      @param(AMetadata ���������� ������� �������)
      @returns(��������� ������� �������)
    }
    function newItem(AStatus: IStatus; AContext: IExternalContext;
      AMetadata: IRoutineMetadata): IExternalProcedure; override;
  end;

  // ������� ��������� TGenRowsProcedure.
  TGenRowsProcedure = class(IExternalProcedureImpl)
  public
    // ���������� ��� ����������� ���������� ���������
    procedure dispose(); override;

    { ���� ����� ���������� ��������������� ����� open � ��������
      ���� ��� ����������� ����� �������� ��� ������ ������� ������
      ����� ������. �� ����� ����� ������ �������� ���������� ����� ��������,
      ���������� �� ExternalEngine::getCharSet.

      @param(AStatus ������ ������)
      @param(AContext �������� ���������� ������� �������)
      @param(AName ��� ������ ��������)
      @param(AName ����� ����� ������ ��������)
    }
    procedure getCharSet(AStatus: IStatus; AContext: IExternalContext;
      AName: PAnsiChar; ANameSize: Cardinal); override;

    { ���������� ������� ���������

      @param(AStatus ������ ������)
      @param(AContext �������� ���������� ������� �������)
      @param(AInMsg ��������� �� ������� ���������)
      @param(AOutMsg ��������� �� �������� ���������)
      @returns(����� ������ ��� ����������� ��������� ��� nil ��� �������� ����������)
    }
    function open(AStatus: IStatus; AContext: IExternalContext; AInMsg: Pointer;
      AOutMsg: Pointer): IExternalResultSet; override;
  end;

  // �������� ����� ������ ��� ��������� TGenRowsProcedure
  TGenRowsResultSet = class(IExternalResultSetImpl)
    Input: PInput;
    Output: POutput;

    // ���������� ��� ����������� ���������� ������ ������
    procedure dispose(); override;

    { ���������� ��������� ������ �� ������ ������.
      � ��������� ���� ������ SUSPEND. � ���� ������ ������
      ���������������� ��������� ������ �� ������ ������.

      @param(AStatus ������ ������)
      @returns(True ���� � ������ ������ ���� ������ ��� ����������,
               False ���� ������ �����������)
    }
    function fetch(AStatus: IStatus): Boolean; override;
  end;

implementation

{ TGenRowsFactory }

procedure TGenRowsFactory.dispose;
begin
  Destroy;
end;

function TGenRowsFactory.newItem(AStatus: IStatus; AContext: IExternalContext;
  AMetadata: IRoutineMetadata): IExternalProcedure;
begin
  Result := TGenRowsProcedure.create;
end;

procedure TGenRowsFactory.setup(AStatus: IStatus; AContext: IExternalContext;
  AMetadata: IRoutineMetadata; AInBuilder, AOutBuilder: IMetadataBuilder);
begin

end;

{ TGenRowsProcedure }

procedure TGenRowsProcedure.dispose;
begin
  Destroy;
end;

procedure TGenRowsProcedure.getCharSet(AStatus: IStatus;
  AContext: IExternalContext; AName: PAnsiChar; ANameSize: Cardinal);
begin

end;

function TGenRowsProcedure.open(AStatus: IStatus; AContext: IExternalContext;
  AInMsg, AOutMsg: Pointer): IExternalResultSet;
begin
  // ���� ���� �� ������� ���������� NULL ������ �� ����������
  if PInput(AInMsg).startNull or PInput(AInMsg).finishNull then
  begin
    POutput(AOutMsg).nNull := True;
    Result := nil;
    exit;
  end;
  // ��������
  if PInput(AInMsg).start > PInput(AInMsg).finish then
    raise Exception.Create('First parameter greater then second parameter.');

  Result := TGenRowsResultSet.create;
  with TGenRowsResultSet(Result) do
  begin
    Input := AInMsg;
    Output := AOutMsg;
    // ��������� ��������
    Output.nNull := False;
    Output.n := Input.start - 1;
  end;
end;

{ TGenRowsResultSet }

procedure TGenRowsResultSet.dispose;
begin
  Destroy;
end;

// ���� ���������� True �� ����������� ��������� ������ �� ������ ������.
// ���� ���������� False �� ������ � ������ ������ �����������
// ����� �������� � �������� ������� ����������� ������ ��� ��� ������ ����� ������
function TGenRowsResultSet.fetch(AStatus: IStatus): Boolean;
begin
  Inc(Output.n);
  Result := (Output.n <= Input.finish);
end;

end.
