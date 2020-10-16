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
  uLkJSON,//���������� ������, ����� ������
  Vcl.ExtCtrls, IniFiles;

type
  TForm1 = class(TForm)
    FDConnection1: TFDConnection;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    FDQuery1: TFDQuery;
    ListBox1: TListBox;
    FDQuery2: TFDQuery;
    main_table: TFDQuery;
    Panel1: TPanel;
    Button2: TButton;
    Button1: TButton;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    key: string;
    fieldstring: string;
    sql_insert, sql_update: tstringlist;
    js: TlkJSONbase; //��������� json
  public
    { Public declarations }
    procedure ModifyRecords();
    procedure instart();
  end;
  //������� ����� � ������
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
    //����������� �����
    IdHTTP.Request.UserAgent :=
      'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20100101 Firefox/12.0';
    Id_HandlerSocket.SSLOptions.Mode := sslmClient;
    Id_HandlerSocket.SSLOptions.Method := sslvSSLv23;
    IdHTTP.IOHandler := Id_HandlerSocket;
    try
     Result := IdHTTP.Get(AURL);
    except
     count:=-1;//���� �����, �� �����������
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
begin
  // ��������� ������� �������
  loc := main_table.fieldbyname(key).asString;
  //main_table.Active := False;
  //������ ������ ����������
  for i := 0 to sql_insert.count - 1 do
  begin
  //��� �����������
    FDQuery1.Close;
    FDQuery1.SQL.Clear;
    FDQuery1.SQL.Add(sql_insert[i]);
    FDQuery2.Close;
    FDQuery2.SQL.Clear;
    FDQuery2.SQL.Add(sql_update[i]);
    try
      FDQuery1.ExecSQL;
    except
      FDQuery2.ExecSQL;

    end;
  end;
   //main_table.Active := true;
  //��� ����������� ������
  main_table.Refresh;
  // ������������ ������� �������
  main_table.Locate(key, loc, []);
end;

procedure TForm1.instart();
var
  F, ps, str, str1, wh: string;
  i, j: integer;
  it: TlkJSONbase;
begin
  ps := GetPageSource('https://api.bittrex.com/v3/markets/summaries');
  if count=-1 then exit;        //����� �������
  js := TlkJSON.ParseText(ps); // ������� ������
  // �������� ��� �������
  fieldstring := '(';
  for j := 0 to main_table.FieldDefs.count - 1 do
  begin
    F := main_table.FieldDefs.Items[j].Name;
    fieldstring := fieldstring + F;
    if j < main_table.FieldDefs.count - 1 then
      fieldstring := fieldstring + ','
  end;
  fieldstring := fieldstring + ')';

  sql_insert.Clear;
  sql_update.Clear;

  
  // ��������� �������, ��� �������
  for i := 0 to js.count - 1 do
  begin
    str := '(';
    str1 := '';
    for j := 0 to main_table.FieldDefs.count - 1 do
    begin
      // ���������� ��������, ����� ������ - ��� �������
      F := main_table.FieldDefs.Items[j].Name;
      it := js.Child[i].Field[F];
      if assigned(it) then // ������ �������� �����
      begin
        str := str + '''' + it.Value + '''';
        if j > 0 then // ������� - ����
          str1 := str1 + F + '=' + '''' + it.Value + '''';
      end
      else
      begin
        str := str + '''-''';
        if j > 0 then // ������� - ����
          str1 := str1 + F + '=' + '''-''';
      end;
      if j < main_table.FieldDefs.count - 1 then
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
  ModifyRecords(); // �������, ���� ������� - �� ����������. ����� � ���������
end;

// ��������� �������
procedure TForm1.Button1Click(Sender: TObject);
var
  F: TIniFile;
  i: integer;
  loc: string;
begin
  F := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'rel.ini');
  loc := main_table.fieldbyname(key).asString;
  F.WriteString('loc', 'key', loc);
  for i := 0 to DBGrid1.Columns.count - 1 do
  begin
    F.WriteString('grid', 'Col' + IntTostr(i),
      DBGrid1.Columns[i].Title.Caption);

    F.WriteInteger('grid', 'Width' + IntTostr(i), DBGrid1.Columns[i].Width);
  end;
  F.Free;
end;

// ��������� �������
procedure TForm1.Button2Click(Sender: TObject);
var
  F: TIniFile;
  i: integer;
  loc: string;
begin
  F := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'rel.ini');
  loc := F.ReadString('loc', 'key', '');
  main_table.Locate(key, loc, []);
  for i := 0 to DBGrid1.Columns.count - 1 do
  begin
    DBGrid1.Columns[i].FieldName := F.ReadString('grid', 'Col' + IntTostr(i),
      DBGrid1.Columns[i].FieldName);
    DBGrid1.Columns[i].Width := F.ReadInteger('grid', 'Width' + IntTostr(i),
      DBGrid1.Columns[i].Width)
  end;
  F.Free;
end;



procedure TForm1.FormCreate(Sender: TObject);
var
  ps, F: string;
  it: TlkJSONbase;
  i, j: integer;

begin
  count:=0;//������� ����������
  FDConnection1.Connected := true;
  main_table.Active := true;
  // ���� ������� ������ �������, ����� ����� ����������
  key := main_table.FieldDefs.Items[0].Name;
  sql_insert := tstringlist.Create;
  sql_update := tstringlist.Create;
  // ����� ���������
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
  //�� ����� ������, �� �� ��������
  form1.Label1.Caption:='��� �����������';
  while count>-1 do
  begin
    //��������� ��� VCL
    Form1.instart;
    inc(count);
    form1.Label1.Caption:='����������: '+ inttostr(count);
    sleep(10000);
  end;
end;

end.
