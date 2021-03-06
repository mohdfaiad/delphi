unit UProgramaFormaPgto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Mask, RxToolEdit, RxCurrEdit;

type
  TFProgramaFormaPgto = class(TForm)
    GDescricao: TGroupBox;
    EDescricao: TEdit;
    BtOk: TBitBtn;
    BtSair: TBitBtn;
    RGVincular: TRadioGroup;
    RGTipo: TRadioGroup;
    GEstorno: TGroupBox;
    Label1: TLabel;
    EFormaOrigem: TEdit;
    ENovaForma: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    EValorOrigem: TCurrencyEdit;
    procedure BtSairClick(Sender: TObject);
    procedure EDescricaoEnter(Sender: TObject);
    procedure EDescricaoExit(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure BtOkClick(Sender: TObject);
    procedure RGTipoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FProgramaFormaPgto: TFProgramaFormaPgto;

implementation

uses UBarsa, UPAF_ECF;

{$R *.dfm}

procedure TFProgramaFormaPgto.BtSairClick(Sender: TObject);
begin
     Close;
end;

procedure TFProgramaFormaPgto.EDescricaoEnter(Sender: TObject);
begin
     EntraFocu(Sender);
end;

procedure TFProgramaFormaPgto.EDescricaoExit(Sender: TObject);
begin
     FechaFocu(Sender);
end;

procedure TFProgramaFormaPgto.FormKeyPress(Sender: TObject; var Key: Char);
begin
     TabEnter(FProgramaFormaPgto,Key);
end;

procedure TFProgramaFormaPgto.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if key=VK_Escape
     then Close;
end;

procedure TFProgramaFormaPgto.FormShow(Sender: TObject);
begin
     LimpaEdit(FProgramaFormaPgto);
     EDescricao.SetFocus;
end;

procedure TFProgramaFormaPgto.BtOkClick(Sender: TObject);
var
   cFormaPgto           : String;
   cVincula             : String;
   Str_Forma_de_Origem  : String;
   Str_Nova_Forma       : String;
   Str_Valor_Total_Pago : String;
begin
     if Confirma('Tem Certeza que Deseja Programar esta Forma de Pagamento '+EDescricao.Text+' ?')=mrYes
     then begin
           if RGTipo.ItemIndex=0
           then begin
                 if Trim(EDescricao.Text)<>''
                 then begin
                       cFormaPgto:=EDescricao.Text;
                       if RGVincular.ItemIndex=0
                       then cVincula:='1'
                       else cVincula:='0';
                       AC;
                       if s_ImpFiscal = 'ECF Daruma'
                       then begin
                            if RGVincular.ItemIndex=0
                            then Retorno_imp_Fiscal := Daruma_FI_ProgramaVinculados( pchar( cFormaPgto ))
                            else Retorno_imp_Fiscal := Daruma_FI_ProgFormasPagtoSemVincular( pchar( cFormaPgto ));
                            end
                       else if s_ImpFiscal = 'ECF Bematech'
                       then Retorno_imp_Fiscal := Bematech_FI_ProgramaFormaPagamentoMFD( pchar( cFormaPgto ), pchar( cVincula ) )
                       else if s_ImpFiscal = 'ECF Elgin'
                       then Retorno_imp_Fiscal := Elgin_ProgramaFormaPagamentoMFD(pchar ( cFormaPgto ), pchar( cVincula ) )
                       else if s_ImpFiscal = 'ECF Sweda'
                       then Retorno_imp_Fiscal := ECF_ProgramaFormaPagamentoMFD(pchar( cFormaPgto ),pchar( cVincula ));

                       if Retorno_imp_Fiscal = 1
                       then begin
                            Informa('Forma de Pagamento programada com Sucesso! Ela estar� disponiv�l no ECF '+
                                    'ap�s uma Redu��oZ e antes de uma LeituraX ou qualquer outro documento.');
                            end
                       else Informa('N�o foi possiv�l Programar esta Forma de Pagamento!');     

                       Analisa_iRetorno();
                       Retorno_Impressora();
                       DC;
                       end
                 else begin
                      Informa('Informe a Descri��o do Pagamento!');
                      EDescricao.SetFocus;
                      end;
               end
          else begin
               AC;
               Str_Forma_de_Origem:=EFormaOrigem.Text;
               Str_Nova_Forma:=ENovaForma.Text;
               Str_Valor_Total_Pago:=FormatFloat('#####0.00',EValorOrigem.Value);

               if s_ImpFiscal = 'ECF Daruma'
               then Retorno_imp_Fiscal := Daruma_FI_EstornoFormasPagamento( pchar( Str_Forma_de_Origem ), pchar( Str_Nova_Forma ), pchar( Str_Valor_Total_Pago ) )
               else if s_ImpFiscal = 'ECF Bematech'
               then Retorno_imp_Fiscal := Bematech_FI_EstornoFormasPagamento( pchar( Str_Forma_de_Origem ), pchar( Str_Nova_Forma ), pchar( Str_Valor_Total_Pago ) )
               else if s_ImpFiscal = 'ECF Elgin'
               then Retorno_imp_Fiscal := Elgin_EstornoFormasPagamento( pchar( Str_Forma_de_Origem ), pchar( Str_Nova_Forma ), pchar( Str_Valor_Total_Pago ) )
               else if s_ImpFiscal = 'ECF Sweda'
               then Retorno_imp_Fiscal := ECF_EstornoFormasPagamento( pchar( Str_Forma_de_Origem ), pchar( Str_Nova_Forma ), pchar( Str_Valor_Total_Pago ) );

               if Retorno_imp_Fiscal = 1
               then Informa('Estorno da Forma de Pagamento Realizado com Sucesso!')
               else Informa('N�o foi possiv�l estornar a Forma de Pagamento');

               Analisa_iRetorno();
               Retorno_Impressora();
               DC;
              end;
          end;
end;

procedure TFProgramaFormaPgto.RGTipoClick(Sender: TObject);
begin
     if RGTipo.ItemIndex=0
     then GEstorno.Visible:=False
     else begin
          GEstorno.Visible:=True;
          EFormaOrigem.SetFocus;
          end;
end;

end.
