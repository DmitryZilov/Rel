object Form1: TForm1
  Left = 0
  Top = 0
  Caption = #1058#1077#1082#1091#1097#1077#1077' '#1089#1086#1089#1090#1086#1103#1085#1080#1077' '#1041#1044
  ClientHeight = 499
  ClientWidth = 774
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 0
    Top = 41
    Width = 774
    Height = 279
    Align = alClient
    DataSource = DataSource1
    DrawingStyle = gdsClassic
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'symbol'
        Width = 115
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'high'
        Width = 97
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'low'
        Width = 75
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'volume'
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'quoteVolume'
        Width = 108
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'percentChange'
        Width = 90
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'updatedAt'
        Visible = True
      end>
  end
  object ListBox1: TListBox
    Left = 0
    Top = 320
    Width = 774
    Height = 179
    Align = alBottom
    ItemHeight = 13
    TabOrder = 1
    Visible = False
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 774
    Height = 41
    Align = alTop
    TabOrder = 2
    object Label1: TLabel
      Left = 16
      Top = 14
      Width = 75
      Height = 13
      Caption = #1054#1073#1085#1086#1074#1083#1077#1085#1080#1081': 0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Button2: TButton
      Left = 631
      Top = 10
      Width = 129
      Height = 25
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1086#1079#1080#1094#1080#1102
      TabOrder = 0
      OnClick = Button2Click
    end
    object Button1: TButton
      Left = 496
      Top = 10
      Width = 129
      Height = 25
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1087#1086#1079#1080#1094#1080#1102
      TabOrder = 1
      OnClick = Button1Click
    end
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=rel.db'
      'OpenMode=ReadWrite'
      'LockingMode=Normal'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 24
    Top = 336
  end
  object DataSource1: TDataSource
    AutoEdit = False
    DataSet = main_table
    Left = 104
    Top = 336
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Left = 176
    Top = 336
  end
  object FDQuery2: TFDQuery
    Connection = FDConnection1
    Left = 248
    Top = 336
  end
  object main_table: TFDQuery
    IndexFieldNames = 'symbol'
    Connection = FDConnection1
    SQL.Strings = (
      'select cast(symbol as char(50)) as symbol,'
      'cast(high as char(50)) as high,'
      'cast(low as char(50)) as low,'
      'cast(volume as char(50)) as volume,'
      'cast(quoteVolume as char(50)) as quoteVolume,'
      'cast(percentChange as char(50)) as percentChange,'
      'cast(updatedAt as char(50)) as updatedAt'
      ' from main')
    Left = 520
    Top = 336
  end
end
