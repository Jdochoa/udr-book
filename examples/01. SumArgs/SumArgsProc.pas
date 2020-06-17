{
 *	PROGRAM:	UDR samples.
 *	MODULE:		SumArgsProc.pas
 *	DESCRIPTION:	A sample external procedure.
 *
 *  The contents of this file are subject to the Initial
 *  Developer's Public License Version 1.0 (the "License");
 *  you may not use this file except in compliance with the
 *  License. You may obtain a copy of the License at
 *  http://www.ibphoenix.com/main.nfs?a=ibphoenix&page=ibp_idpl.
 *
 *  Software distributed under the License is distributed AS IS,
 *  WITHOUT WARRANTY OF ANY KIND, either express or implied.
 *  See the License for the specific language governing rights
 *  and limitations under the License.
 *
 *  The Original Code was created by Adriano dos Santos
 *  for the Firebird Open Source RDBMS project.
 *
 *  Copyright (c) 2008 Adriano dos Santos Fernandes <adrianosf@gmail.com>
 *  and all contributors signed below.
 *
 *  All Rights Reserved.
 *  Contributor(s): ______________________________________. 
 *
 *  20.05.2018 Simonov Denis <sim-mail@list.ru> - comments }

unit SumArgsProc;

{$IFDEF FPC}
{$MODE DELPHI}{$H+}
{$ENDIF}

interface

uses
  Firebird;

  { **********************************************************

    create procedure sp_sum_args (
      n1 integer,
      n2 integer,
      n3 integer
    ) returns (result integer)
    external name 'myudr!sum_args_proc'
    engine udr;

    ********************************************************* }
type
  // ��������� �� ������� ����� ���������� ������� ���������
  TSumArgsInMsg = record
    n1: Integer;
    n1Null: WordBool;
    n2: Integer;
    n2Null: WordBool;
    n3: Integer;
    n3Null: WordBool;
  end;
  PSumArgsInMsg = ^TSumArgsInMsg;

  // ��������� �� ������� ����� ���������� �������� ���������
  TSumArgsOutMsg = record
    result: Integer;
    resultNull: WordBool;
  end;
  PSumArgsOutMsg = ^TSumArgsOutMsg;

  // ������� ��� �������� ���������� ������� ��������� TSumArgsProcedure
  TSumArgsProcedureFactory = class(IUdrProcedureFactoryImpl)
    // ���������� ��� ����������� �������
    procedure dispose(); override;

    { ����������� ������ ��� ��� �������� ������� ��������� � ��� ����������

      @param(AStatus ������ ������)
      @param(AContext �������� ���������� ������� ���������)
      @param(AMetadata ���������� ������� ���������)
      @param(AInBuilder ����������� ��������� ��� ������� ����������)
      @param(AOutBuilder ����������� ��������� ��� �������� ����������)
    }
    procedure setup(AStatus: IStatus; AContext: IExternalContext;
      AMetadata: IRoutineMetadata; AInBuilder: IMetadataBuilder;
      AOutBuilder: IMetadataBuilder); override;

    { �������� ������ ���������� ������� ��������� TSumArgsProcedure

      @param(AStatus ������ ������)
      @param(AContext �������� ���������� ������� ���������)
      @param(AMetadata ���������� ������� ���������)
      @returns(��������� ������� ���������)
    }
    function newItem(AStatus: IStatus; AContext: IExternalContext;
      AMetadata: IRoutineMetadata): IExternalProcedure; override;
  end;

  TSumArgsProcedure = class(IExternalProcedureImpl)
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
      @returns(����� ������ ��� ����������� ��������� ���
               nil ��� �������� ����������)
    }
    function open(AStatus: IStatus; AContext: IExternalContext; AInMsg: Pointer;
      AOutMsg: Pointer): IExternalResultSet; override;
  end;

implementation

{ TSumArgsProcedureFactory }

procedure TSumArgsProcedureFactory.dispose;
begin
  Destroy;
end;

function TSumArgsProcedureFactory.newItem(AStatus: IStatus;
  AContext: IExternalContext; AMetadata: IRoutineMetadata): IExternalProcedure;
begin
  Result := TSumArgsProcedure.create;
end;

procedure TSumArgsProcedureFactory.setup(AStatus: IStatus;
  AContext: IExternalContext; AMetadata: IRoutineMetadata; AInBuilder,
  AOutBuilder: IMetadataBuilder);
begin

end;

{ TSumArgsProcedure }

procedure TSumArgsProcedure.dispose;
begin
  Destroy;
end;

procedure TSumArgsProcedure.getCharSet(AStatus: IStatus;
  AContext: IExternalContext; AName: PAnsiChar; ANameSize: Cardinal);
begin

end;

function TSumArgsProcedure.open(AStatus: IStatus; AContext: IExternalContext;
  AInMsg, AOutMsg: Pointer): IExternalResultSet;
var
  xInput: PSumArgsInMsg;
  xOutput: PSumArgsOutMsg;
begin
  Result := nil;
  // ��������������� ��������� �� ���� � ����� � ��������������
  xInput := PSumArgsInMsg(AInMsg);
  xOutput := PSumArgsOutMsg(AOutMsg);
  // ���� ���� �� ���������� NULL ������ � ��������� NULL
  xOutput^.resultNull := xInput^.n1Null or xInput^.n2Null or xInput^.n3Null;
  xOutput^.result := xInput^.n1 + xInput^.n2 + xInput^.n3;
end;

end.
