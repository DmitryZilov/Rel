unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, IdHTTP, IdSSLOpenSSL,
  uLkJSON,//бесплатный парсер, очень хвал€т
  Vcl.ExtCtrls, IniFiles, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxClasses, cxCustomData, cxStyles, cxEdit, dxSkinsCore,
  dxSkinsDefaultPainters, cxCustomPivotGrid, cxDBPivotGrid, dxmdaset,
  cxPivotGridCustomDataSet, cxPivotGridSummaryDataSet, cxFilter, cxData,
  cxDataStorage, cxNavigator, dxDateRanges, cxDBData, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGridCustomView, cxGrid, cxGridLevel,
  cxPropertiesStore, cxFilterControl, cxDBFilterControl, cxGridBandedTableView,
  cxGridDBBandedTableView;

type
  TForm1 = class(TForm)
    FDConnection1: TFDConnection;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    FDQuery1: TFDQuery;
    FDQuery2: TFDQuery;
    main_table: TFDQuery;
    Panel1: TPanel;
    Button2: TButton;
    Button1: TButton;
    Label1: TLabel;
    tmain: TFDTable;
    tmainsymbol: TWideMemoField;
    tmainhigh: TWideMemoField;
    tmainlow: TWideMemoField;
    tmainvolume: TWideMemoField;
    tmainquoteVolume: TWideMemoField;
    tmainpercentChange: TWideMemoField;
    tmainupdatedAt: TWideMemoField;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    cxGrid1DBBandedTableView1: TcxGridDBBandedTableView;
    cxGrid1DBBandedTableView1symbol1: TcxGridDBBandedColumn;
    cxGrid1DBBandedTableView1symbol2: TcxGridDBBandedColumn;
    cxGrid1DBBandedTableView1high: TcxGridDBBandedColumn;
    cxGrid1DBBandedTableView1low: TcxGridDBBandedColumn;
    cxGrid1DBBandedTableView1volume: TcxGridDBBandedColumn;
    cxGrid1DBBandedTableView1quoteVolume: TcxGridDBBandedColumn;
    cxGrid1DBBandedTableView1percentChange: TcxGridDBBandedColumn;
    cxGrid1DBBandedTableView1updatedAt: TcxGridDBBandedColumn;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    key: string;
    fieldstring: string;
    sql_insert, sql_update: tstringlist;
    js: TlkJSONbase; //контейнер json
  public
    { Public declarations }
    procedure ModifyRecords();
    procedure instart();
  end;
  //простой поток с тиками
  TNewThread = class(TThread)
  private
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean);
  end;

var
  Form1: TForm1;
  thr: TNewThread;
  count:integer;

implementation

{$R *.dfm}

function GetPageSource(AURL: string): string;
var
  IdHTTP: TIdHTTP;
  Id_HandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
begin
  IdHTTP := TIdHTTP.Create(Nil);
  Id_HandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(IdHTTP);
  try
    IdHTTP.Request.BasicAuthentication := False;
    //скармливаем шапку
    IdHTTP.Request.UserAgent :=
      'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20100101 Firefox/12.0';
    Id_HandlerSocket.SSLOptions.Mode := sslmClient;
    Id_HandlerSocket.SSLOptions.Method := sslvSSLv23;
    IdHTTP.IOHandler := Id_HandlerSocket;
    try
     Result := IdHTTP.Get(AURL);
    except
     count:=-1;//сбой св€зи, не обновл€емс€
    end;
  Finally
    Id_HandlerSocket.Free;
    IdHTTP.Free;
  end;
end;

procedure TForm1.ModifyRecords;
var
  i: integer;
  loc: string;
  qr1,qr2:TFDQuery;
begin
  qr1:=TFDQuery.Create(self);
  qr2:=TFDQuery.Create(self);
  qr1.Connection:=fdconnection1;
  qr2.Connection:=fdconnection1;
  // запомнить позицию курсора
  loc := main_table.fieldbyname(key).asString;
  //main_table.Active := False;
  //размер всегда одинаковый
  for i := 0 to js.count - 1 do
  begin
  //дл€ нагл€дности
    qr1.Close;
    qr1.SQL.Clear;
    qr1.SQL.Add(sql_insert[i]);
    qr2.Close;
    qr2.SQL.Clear;
    qr2.SQL.Add(sql_update[i]);
    try
      qr1.ExecSQL;
    except
      qr2.ExecSQL;

    end;
  end;
   //main_table.Active := true;
  //так пправильней фетчит
  main_table.Refresh;
  // восстановить позицию курсора

  main_table.Locate(key, loc, []);
  qr1.Free;
  qr2.Free;
end;

procedure TForm1.instart();
var
  F, ps, str, str1, wh: string;
  i, j: integer;
  it: TlkJSONbase;
begin
  ps := GetPageSource('https://api.bittrex.com/v3/markets/summaries');
  if count=-1 then exit;        //сразу выходим
  js := TlkJSON.ParseText(ps); // быстрый парсер
  // заполним дл€ запроса
  fieldstring := '(';
  for j := 0 to tmain.FieldDefs.count - 1 do
  begin
    F := tmain.FieldDefs.Items[j].Name;
    fieldstring := fieldstring + F;
    if j < tmain.FieldDefs.count - 1 then
      fieldstring := fieldstring + ','
  end;
  fieldstring := fieldstring + ')';

  sql_insert.Clear;
  sql_update.Clear;


  // структура плоска€, без заходов
  for i := 0 to js.count - 1 do
  begin
    str := '(';
    str1 := '';
    for j := 0 to tmain.FieldDefs.count - 1 do
    begin
      // идентичные названи€, берем отсюда - без разницы
      F := tmain.FieldDefs.Items[j].Name;
      it := js.Child[i].Field[F];
      if assigned(it) then // бывают пропуски полей
      begin
        str := str + '''' + it.Value + '''';
        if j > 0 then // нулевой - ключ
          str1 := str1 + F + '=' + '''' + it.Value + '''';
      end
      else
      begin
        str := str + '''-''';
        if j > 0 then // нулевой - ключ
          str1 := str1 + F + '=' + '''-''';
      end;
      if j < tmain.FieldDefs.count - 1 then
      begin
        str := str + ',';
        if j > 0 then
          str1 := str1 + ',';
      end;
      if j = 0 then
        wh := ' WHERE ' + F + '=' + '''' + it.Value + '''';
    end;
    str := str + ')';
    sql_insert.Add('INSERT INTO main ' + fieldstring + ' VALUES ' + str);
    sql_update.Add('UPDATE main SET ' + str1 + wh)
  end;
  //ModifyRecords(); // вставка, если неудача - то обновление. вынес в процедуру
end;

// сохранить позицию
procedure TForm1.Button1Click(Sender: TObject);
var
  F: TIniFile;
  i: integer;
  loc: string;
begin
//корректно сохран€ет в реестр
  cxGrid1DBBandedTableView1.StoreToRegistry('cxGrid1DBBandedTableView1',true);
//сохранить текущую запись
  F := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'rel.ini');
  loc := main_table.fieldbyname(key).asString;
  F.WriteString('loc', 'key', loc);
  F.WriteInteger('loc', 'RI', cxGrid1DBBandedTableView1.Controller.TopRecordIndex);
  F.Free;
end;

// загрузить позицию
procedure TForm1.Button2Click(Sender: TObject);
var
  F: TIniFile;
  i: integer;
  loc: string;
begin
  cxGrid1DBBandedTableView1.RestoreFromRegistry('cxGrid1DBBandedTableView1');
  F := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'rel.ini');
  loc := F.ReadString('loc', 'key', '');
  //встать на запись
  cxGrid1DBBandedTableView1.Controller.TopRecordIndex:=F.ReadInteger('loc', 'RI', 0);
  cxGrid1DBBandedTableView1.Controller.FocusedRow.Selected:=true;
  main_table.Locate(key, loc, []);
  F.Free;
end;



procedure TForm1.FormCreate(Sender: TObject);
var
  i: integer;

begin
  count:=0;//счетчик обновлений
  FDConnection1.Params.Database:=extractfilepath(application.exename) + 'rel.db';
  FDConnection1.Connected := true;
  main_table.Active := true;
  tmain.Active:=true;
  // ключ таблицы всегда нулевой, потом может изменитьс€
  key := tmain.FieldDefs.Items[0].Name;
  sql_insert := tstringlist.Create;
  sql_update := tstringlist.Create;
  // сразу запускаем
  instart;
  for i := 0 to DBGrid1.Columns.count - 1 do
    DBGrid1.Columns[i].Width := 100;

  thr := TNewThread.Create(False);
end;

{ TNewThread }

constructor TNewThread.Create(CreateSuspended: Boolean);
begin
  inherited;
  Priority := tpNormal;
  FreeOnTerminate := true;
end;

procedure TNewThread.Execute;
begin
  inherited;
  //не очень хорошо, но не критично
  form1.Label1.Caption:='Ќет подключени€';
  while count>-1 do
  begin
    //процедура без VCL
    (Form1.instart);
    Synchronize(Form1.ModifyRecords);
    inc(count);
    form1.Label1.Caption:='ќбновлений: '+ inttostr(count);
    sleep(10000);
  end;
end;

end.
