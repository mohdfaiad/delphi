unit UAlteraIten;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mylabel, Mask,  rxToolEdit, rxCurrEdit;

type
  TFAlteraIten = class(TForm)
    GroupBox1: TGroupBox;
    LProduto: TmyLabel3d;                                       
    GroupBox2: TGroupBox;
    myLabel3d1: TmyLabel3d;
    EQtde: TCurrencyEdit;
    EUnitario: TCurrencyEdit;
    myLabel3d2: TmyLabel3d;
    myLabel3d3: TmyLabel3d;
    ETotal: TCurrencyEdit;
    procedure FormShow(Sender: TObject);
    procedure EQtdeExit(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ETotalEnter(Sender: TObject);
    procedure ETotalExit(Sender: TObject);
    procedure EQtdeEnter(Sender: TObject);
    procedure EUnitarioEnter(Sender: TObject);
    procedure EUnitarioExit(Sender: TObject);
    procedure ETotalKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EQtdeKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FAlteraIten: TFAlteraIten;

implementation

uses UBarsa, checkout, UPAF_ECF;

{$R *.dfm}

procedure TFAlteraIten.FormShow(Sender: TObject);
begin
     EQtde.Value:=1;
end;

procedure TFAlteraIten.EQtdeExit(Sender: TObject);
begin
     if (Sender is TCurrencyEdit) then
     TCurrencyEdit(Sender).Color:=clWhite;

     if EQtde.Value <= 0
     then EQtde.Value := 1;
end;

procedure TFAlteraIten.FormKeyPress(Sender: TObject; var Key: Char);
begin
     TabEnter(FAlteraIten,Key);
end;

procedure TFAlteraIten.ETotalEnter(Sender: TObject);
begin
     if (Sender is TCurrencyEdit) then
     TCurrencyEdit(Sender).Color:=$0080FFFF;
     
     ETotal.Value:=EUnitario.Value*EQtde.Value;
end;

procedure TFAlteraIten.ETotalExit(Sender: TObject);
begin
     if (Sender is TCurrencyEdit) then
     TCurrencyEdit(Sender).Color:=clWhite;

     if ETotal.Value <= 0
     then ETotal.Value:=EUnitario.Value*EQtde.Value;
     EUnitario.Value:=ETotal.Value/EQtde.Value;
end;

procedure TFAlteraIten.EQtdeEnter(Sender: TObject);
begin
     if (Sender is TCurrencyEdit) then
     TCurrencyEdit(Sender).Color:=$0080FFFF;
end;

procedure TFAlteraIten.EUnitarioEnter(Sender: TObject);
begin
     if (Sender is TCurrencyEdit) then
     TCurrencyEdit(Sender).Color:=$0080FFFF;
end;

procedure TFAlteraIten.EUnitarioExit(Sender: TObject);
begin
     if (Sender is TCurrencyEdit) then
     TCurrencyEdit(Sender).Color:=clWhite;
end;

procedure TFAlteraIten.ETotalKeyPress(Sender: TObject; var Key: Char);
begin
     if Key=#13
     then begin
          preco_aplicado:=EUnitario.Value;
          frmcheckout.ed_quantidade.Value:=EQtde.Value;
          frmcheckout.editCodigo.SetFocus;
          frmcheckout.editCodigo.Refresh;
          Close;
          end;
end;

procedure TFAlteraIten.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if Key=VK_Escape
     then Close;
end;

procedure TFAlteraIten.EQtdeKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if key=40  // seta para baixo
     then FAlteraIten.Perform(WM_NextDlgCtl,0,0);

     if key=38  // seta para cima
     then FAlteraIten.Perform(WM_NextDlgCtl,1,0);
end;

end.
