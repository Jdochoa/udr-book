unit Udr;

{$IFDEF FPC}
  {$MODE DELPHI}{$H+}
{$ENDIF}
interface

uses
  Firebird;


type

  // �������� ������� �������
  TUdrFunction = class(IExternalFunctionImpl)
    // ���������� ��� ����������� ���������� �������
    procedure dispose(); override;

    procedure getCharSet(AStatus: IStatus; AContext: IExternalContext;
      AName: PAnsiChar; ANameSize: Cardinal); override;

  end;

  // �������� ������� ���������
  TUdrProcedure = class(IExternalProcedureImpl)
    // ���������� ��� ����������� ���������� ���������
    procedure dispose(); override;

    procedure getCharSet(AStatus: IStatus; AContext: IExternalContext;
      AName: PAnsiChar; ANameSize: Cardinal); override;

  end;

implementation

uses SysUtils, UdrMessages;


{ TUdrFunction }

procedure TUdrFunction.dispose;
begin
  Destroy;
end;


procedure TUdrFunction.getCharSet(AStatus: IStatus;
  AContext: IExternalContext; AName: PAnsiChar; ANameSize: Cardinal);
begin

end;

{ TUdrProcedure }

procedure TUdrProcedure.dispose;
begin
  Destroy;
end;

procedure TUdrProcedure.getCharSet(AStatus: IStatus; AContext: IExternalContext;
  AName: PAnsiChar; ANameSize: Cardinal);
begin

end;

end.
